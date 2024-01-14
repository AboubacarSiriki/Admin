from flask import Flask, render_template, url_for, request, redirect, session
import pyodbc
from werkzeug.security import generate_password_hash, check_password_hash
from flask_paginate import Pagination, get_page_parameter


app = Flask(__name__)

app.secret_key = "votre_clé_secrète"
# Configuration de la connexion à SQL Server
app.config["SQL_SERVER_CONNECTION_STRING"] = """
    Driver={SQL Server};
    Server=DESKTOP-5I6GQ70\SQLEXPRESS;
    Database=MV;
    Trusted_Connection=yes;"""

@app.template_filter('add_line_breaks')
def add_line_breaks(s, width):

    """
    Ajoutez des sauts de ligne à une chaîne après une largeur spécifiée.

    Parameters:
    - s (str): Input string.
    - width (int): Maximum width before line break.

    Returns:
    - str: String with line breaks added.
    """
    return '\n'.join([s[i:i+width] for i in range(0, len(s), width)])



######## connexion / inscription  ###########


@app.route("/connexion", methods=["GET", "POST"])
def connexion():
    if request.method == 'POST':

        Email = request.form['Email']
        password = request.form['Mot_de_pass']

        connection = pyodbc.connect(app.config['SQL_SERVER_CONNECTION_STRING'])
        cursor = connection.cursor()
        cursor.execute("SELECT * FROM Administrateur WHERE Email = ?", (Email,))
        user = cursor.fetchone()

        if user and check_password_hash(user.Mot_de_pass, password):  # Accès au mot de passe directement par le nom de colonne
            session['IdAdministrateur'] = user.IdAdministrateur
            print(session['IdAdministrateur'])
            session['user'] = user.Email
            print(session['IdAdministrateur'])
            return redirect(url_for('index'))
        else:
            print('Mauvaise adresse e-mail ou mot de passe.')
            
    return render_template("/auth/login.html")


@app.route("/register", methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        Nom_et_prenoms = request.form['Nom_et_prenoms']
        Email = request.form['Email']
        Mot_de_pass = request.form['Mot_de_pass']
        Adresse = request.form['Adresse']
        Telephone = request.form['Telephone']

        # Hacher le mot de passe
        hashed_password = generate_password_hash(Mot_de_pass)

        connection = pyodbc.connect(app.config['SQL_SERVER_CONNECTION_STRING'])
        cursor = connection.cursor()
        cursor.execute("INSERT INTO Administrateur (Nom_et_prenoms, Email, Mot_de_pass, Adresse, Telephone) VALUES (?, ?, ?, ?, ?)", (Nom_et_prenoms, Email, hashed_password, Adresse, Telephone))
        connection.commit()

        # Récupérer l'ID de l'utilisateur après l'insertion
        cursor.execute("SELECT IdAdministrateur FROM Administrateur WHERE Email=?", (Email,))
        IdUtilisateur = cursor.fetchone()[0]

        session['IdAdministrateur'] = IdUtilisateur
        session['user'] = Email

        cursor.close()
        connection.close()

        return redirect(url_for('index'))

    return render_template("/auth/register.html")

@app.route('/deconnection/')
def deconnection():
    session.pop('user', None)
    return redirect(url_for('index'))


################################################################

@app.route("/")
def accueil():
    return render_template("/auth/login.html")

@app.route("/base/")
def base():
    return render_template("base.html")

@app.route("/index/")
def index():
    connection = pyodbc.connect(app.config['SQL_SERVER_CONNECTION_STRING'])
    cursor = connection.cursor()
    cursor.execute("SELECT * from Utilisateur")
    resultat = cursor.fetchall()
    cursor.close()
    cursor = connection.cursor()
    cursor.execute("SELECT COUNT(*) from Utilisateur")
    resultat1 = cursor.fetchone()
    cursor.close()
    cursor = connection.cursor()
    cursor.execute(
        "select idLocations,nom_et_prenoms,ville,commune,Type_de_maison,Descriptions from Locations join  Utilisateur on Locations.IdLocations=Utilisateur.IdUtilisateur")
    resultat2 = cursor.fetchall()
    cursor.close()
    cursor = connection.cursor()
    cursor.execute("SELECT COUNT(*) from Locations")
    resultat3 = cursor.fetchone()
    cursor.close()
    cursor = connection.cursor()
    cursor.execute("SELECT COUNT(*) from Maison")
    resultat4 = cursor.fetchone()
    cursor.close()
    return render_template("index.html",resultat=resultat, resultat1=resultat1,resultat2=resultat2,resultat3=resultat3,resultat4=resultat4)

@app.route("/location/")
def location():
    connection = pyodbc.connect(app.config['SQL_SERVER_CONNECTION_STRING'])
    cursor = connection.cursor()
    cursor.execute("select idLocations,nom_et_prenoms,ville,commune,Type_de_maison,Descriptions from Locations join  Utilisateur on Locations.IdLocations=Utilisateur.IdUtilisateur")
    resultat = cursor.fetchall()
    cursor.close()
    cursor = connection.cursor()
    cursor.execute("SELECT COUNT(*) from Locations")
    resultat1 = cursor.fetchone()
    cursor.close()
    return render_template("location.html",resultat=resultat, resultat1=resultat1)

@app.route("/vente/")
def maison_en_vente():
    connection = pyodbc.connect(app.config['SQL_SERVER_CONNECTION_STRING'])
    cursor = connection.cursor()
    cursor.execute(
        "select IdMaison, nom_et_prenoms,ville,commune,Type_de_maison,Descriptions from Maison join  Utilisateur on Maison.IdMaison=Utilisateur.IdUtilisateur")
    resultat = cursor.fetchall()
    cursor.close()
    cursor = connection.cursor()
    cursor.execute("SELECT COUNT(*) from Maison")
    resultat1 = cursor.fetchone()
    cursor.close()
    return render_template("vente.html", resultat=resultat, resultat1=resultat1)

@app.route("/service/")
def liste_service():
    return render_template("service.html")

@app.route("/utilisateur/")
def utilisateur():
    connection = pyodbc.connect(app.config['SQL_SERVER_CONNECTION_STRING'])
    cursor = connection.cursor()
    cursor.execute("SELECT * from Utilisateur")
    resultat = cursor.fetchall()
    cursor.close()
    cursor = connection.cursor()
    cursor.execute("SELECT COUNT(*) from Utilisateur")
    resultat1 = cursor.fetchone()
    cursor.close()
    return render_template("utilisateur.html", resultat=resultat, resultat1=resultat1)

@app.route("/supprimer_utisateur/")
def supprimer_utisateur():
    return render_template("index.html")

@app.route("/supprimer_service/")
def supprimer_service():
    return render_template("index.html")

@app.route("/recherche", methods=['GET', 'POST'])
def recherche():

    return render_template("index.html")

if __name__ == "__main__":
    app.run(debug=True)