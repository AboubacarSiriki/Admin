from flask import Flask, render_template, url_for, request, redirect, session
import pyodbc
from werkzeug.security import generate_password_hash, check_password_hash
from flask_paginate import Pagination, get_page_parameter


app = Flask(__name__)

app.secret_key = "votre_clé_secrète"
# Configuration de la connexion à SQL Server
app.config["SQL_SERVER_CONNECTION_STRING"] = """
    Driver={SQL Server};
    Server=DESKTOP-JK6D8G9\SQLEXPRESS;
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
        cursor.execute("SELECT * FROM Utilisateur WHERE Email = ?", (Email,))
        user = cursor.fetchone()

        if user and check_password_hash(user.Mot_de_pass, password):  # Accès au mot de passe directement par le nom de colonne
            session['IdUtilisateur'] = user.IdUtilisateur
            print(session['IdUtilisateur'])
            session['user'] = user.Email
            print(session['IdUtilisateur'])
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
        cursor.execute("INSERT INTO Utilisateur (Nom_et_prenoms, Email, Mot_de_pass, Adresse, Telephone) VALUES (?, ?, ?, ?, ?)", (Nom_et_prenoms, Email, hashed_password, Adresse, Telephone))
        connection.commit()

        # Récupérer l'ID de l'utilisateur après l'insertion
        cursor.execute("SELECT IdUtilisateur FROM Utilisateur WHERE Email=?", (Email,))
        IdUtilisateur = cursor.fetchone()[0]

        session['IdUtilisateur'] = IdUtilisateur
        session['user'] = Email

        cursor.close()
        connection.close()

        return redirect(url_for('index'))

    return render_template("/auth/register.html")

@app.route('/deconnection')
def deconnection():
    session.pop('user', None)
    return redirect(url_for('index'))


################################################################

@app.route("/")
def index():
    return render_template("index.html")

@app.route("/")
def locotion():
    return render_template("index.html")

@app.route("/")
def maison_en_vente():
    return render_template("index.html")

@app.route("/")
def liste_serviece():
    return render_template("index.html")

@app.route("/")
def add_serviece():
    return render_template("index.html")

@app.route("/")
def modifier_serviece():
    return render_template("index.html")

@app.route("/")
def supprimer_serviece():
    return render_template("index.html")

if __name__ == "__main__":
    app.run(debug=True)