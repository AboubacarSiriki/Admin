from flask import Flask, render_template, url_for, request, redirect, session,jsonify,flash,send_from_directory
import pyodbc
from werkzeug.security import generate_password_hash, check_password_hash

app = Flask(__name__)


app.secret_key = "votre_clé_secrète"

app.config['IMAGE_FOLDER'] = r'C:\Users\HPC\OneDrive\Documents\GitHub\MV'
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
        cursor.execute("SELECT * FROM Administrateur WHERE Email = ?", (Email,))
        user = cursor.fetchone()

        if user and check_password_hash(user.Mot_de_pass, password):  # Accès au mot de passe directement par le nom de colonne
            session['IdAdministrateur'] = user.IdAdministrateur
            session['user'] = user.Email
            return redirect(url_for('index'))
        else:
            flash('Mauvaise adresse e-mail ou mot de passe.')
            
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



@app.route('/api/data')
def get_data():
    analysis_type = request.args.get('type')
    
    conn = pyodbc.connect(app.config['SQL_SERVER_CONNECTION_STRING'])
    cursor = conn.cursor()
    result = []

    if analysis_type == 'utilisateurs_par_ville':
        query = '''
            SELECT Adresse, COUNT(*) AS Nombre_utilisateurs
            FROM [MV].[dbo].[Utilisateur]
            WHERE Adresse IS NOT NULL
            GROUP BY Adresse
        '''
        cursor.execute(query)
        data = cursor.fetchall()
        result = [{'Adresse': row[0], 'Nombre_utilisateurs': row[1]} for row in data]



    elif analysis_type == 'frequence_actions':
        query = '''
            SELECT IdUtilisateur, COUNT(*) AS Nombre_actions
            FROM [MV].[dbo].[user_like]
            WHERE IdUtilisateur IS NOT NULL
            GROUP BY IdUtilisateur
        '''
        cursor.execute(query)
        data = cursor.fetchall()
        result = [{'IdUtilisateur': row[0], 'Nombre_actions': row[1]} for row in data]
    
    elif analysis_type == 'types_actions':
        query = '''
            SELECT type_action, COUNT(*) AS Nombre_actions
            FROM [MV].[dbo].[user_like]
            WHERE type_action IS NOT NULL
            GROUP BY type_action
        '''
        cursor.execute(query)
        data = cursor.fetchall()
        result = [{'type_action': row[0], 'Nombre_actions': row[1]} for row in data]

    elif analysis_type == 'maisons_populaires':
        query = '''
            SELECT IdMaison, COUNT(*) AS Nombre_likes
            FROM [MV].[dbo].[user_like]
            WHERE IdMaison IS NOT NULL
            GROUP BY IdMaison
        '''
        cursor.execute(query)
        data = cursor.fetchall()
        result = [{'IdMaison': row[0], 'Nombre_likes': row[1]} for row in data]

    elif analysis_type == 'location_populaires':
        query = '''
            SELECT IdLocations, COUNT(*) AS Nombre_likes
            FROM [MV].[dbo].[user_like]
            WHERE IdLocations IS NOT NULL
            GROUP BY IdLocations
        '''
        cursor.execute(query)
        data = cursor.fetchall()
        result = [{'IdLocations': row[0], 'Nombre_likes': row[1]} for row in data]

    if analysis_type == 'demande_services_par_type':
        query = '''
            SELECT Type_de_services, COUNT(*) AS Nombre_demandes
            FROM [MV].[dbo].[Services_demande]
            WHERE Type_de_services IS NOT NULL
            GROUP BY Type_de_services
        '''
        cursor.execute(query)
        data = cursor.fetchall()
        result = [{'Type_de_services': row[0], 'Nombre_demandes': row[1]} for row in data]



    elif analysis_type == 'statut_services_demandes':
        query = '''
            SELECT Statut_services, COUNT(*) AS Nombre_services
            FROM [MV].[dbo].[Services_demande]
            WHERE Statut_services IS NOT NULL
            GROUP BY Statut_services
        '''
        cursor.execute(query)
        data = cursor.fetchall()
        result = [{'Statut_services': row[0], 'Nombre_services': row[1]} for row in data]

    elif analysis_type == 'repartition_proprietes':
        # query = '''
        #     SELECT Ville, Commune, COUNT(*) AS Nombre_proprietes
        #     FROM (
        #         SELECT Ville, Commune FROM [MV].[dbo].[Maison]
        #         UNION ALL
        #         SELECT Ville, Commune FROM [MV].[dbo].[Locations]
        #     ) AS Proprietes
        #     WHERE Ville IS NOT NULL AND Commune IS NOT NULL
        #     GROUP BY Ville, Commune
        # '''
        query = '''
            SELECT Ville, Commune, COUNT(*) AS Nombre_proprietes, GPS
            FROM (
                SELECT Ville, Commune, GPS
                FROM [MV].[dbo].[Maison]
                UNION ALL
                SELECT Ville, Commune, GPS
                FROM [MV].[dbo].[Locations]
            ) AS Proprietes
            GROUP BY Ville, Commune, GPS
        '''
        cursor.execute(query)
        data = cursor.fetchall()
        # result = [{'Ville': row[0], 'Commune': row[1], 'Nombre_proprietes': row[2]} for row in data]
        result = [{'Ville': row[0], 'Commune': row[1], 'Nombre_proprietes': row[2], 'GPS': row[3]} for row in data]

    elif analysis_type == 'popularite_proprietes':
        query = '''
            SELECT 'Maison' AS Type_propriete, IdMaison AS IdPropriete, COUNT(*) AS Nombre_likes
            FROM [MV].[dbo].[user_like]
            WHERE IdMaison IS NOT NULL
            GROUP BY IdMaison
            UNION ALL
            SELECT 'Location' AS Type_propriete, IdLocations AS IdPropriete, COUNT(*) AS Nombre_likes
            FROM [MV].[dbo].[user_like]
            WHERE IdLocations IS NOT NULL
            GROUP BY IdLocations
        '''
        cursor.execute(query)
        data = cursor.fetchall()
        result = [{'Type_propriete': row[0], 'IdPropriete': row[1], 'Nombre_likes': row[2]} for row in data]

    elif analysis_type == 'analyse_prix_maison':
        query = '''
            SELECT 'Maison' AS Type_propriete, Prix_unitaire AS Prix
            FROM [MV].[dbo].[Maison]
            WHERE Prix_unitaire IS NOT NULL
        '''
        cursor.execute(query)
        data = cursor.fetchall()
        result = [{'Type_propriete': row[0], 'Prix': row[1]} for row in data]

    elif analysis_type == 'analyse_prix_location':
        query = '''
            SELECT 'Location' AS Type_propriete, Prix_mensuel AS Prix
            FROM [MV].[dbo].[Locations]
            WHERE Prix_mensuel IS NOT NULL
        '''
        cursor.execute(query)
        data = cursor.fetchall()
        result = [{'Type_propriete': row[0], 'Prix': row[1]} for row in data]

    elif analysis_type == 'popularite_services':
        query = '''
            SELECT lieu_debitation, COUNT(*) AS Nombre_interesses
            FROM [MV].[dbo].[interesse]
            WHERE lieu_debitation IS NOT NULL
            GROUP BY lieu_debitation
        '''
        cursor.execute(query)
        data = cursor.fetchall()
        result = [{'lieu_debitation': row[0], 'Nombre_interesses': row[1]} for row in data]

    elif analysis_type == 'profil_interesses':
        query = '''
            SELECT nom, prenom, COUNT(*) AS Nombre_interesses
            FROM [MV].[dbo].[interesse]
            WHERE nom IS NOT NULL AND prenom IS NOT NULL
            GROUP BY nom, prenom
        '''
        cursor.execute(query)
        data = cursor.fetchall()
        result = [{'nom': row[0], 'prenom': row[1], 'Nombre_interesses': row[2]} for row in data]

    conn.close()

    return jsonify(result)



# Route pour la recherche asynchrone
@app.route('/search', methods=['POST'])
def search():
    keyword = request.form['keyword']
    results = search_in_database(keyword)
    return jsonify(results)

# Fonction de recherche dans la base de données
def search_in_database(mot):
    connection = pyodbc.connect(app.config['SQL_SERVER_CONNECTION_STRING'])
    cursor = connection.cursor()
    query = f"select idLocations,nom_et_prenoms,ville,commune,Type_de_maison,Descriptions from Locations join  Utilisateur on Locations.IdLocations=Utilisateur.IdUtilisateur WHERE commune LIKE ?"
    result = cursor.execute(query, ('%' + mot + '%',)).fetchall()
    return result

@app.route("/recherche_location", methods=['GET', 'POST'])
def recherche_location():
    connection = pyodbc.connect(app.config['SQL_SERVER_CONNECTION_STRING'])
    cursor = connection.cursor()
    cursor.execute("SELECT COUNT(*) from Locations")
    resultat1 = cursor.fetchone()
    cursor.close()
    results = None
    if request.method == 'POST':
        keyword = request.form['keyword']
        results = search_in_database(keyword)
    return render_template("recherche_location.html",resultat1=resultat1,results=results)

def search_in_database_user(mot):
    connection = pyodbc.connect(app.config['SQL_SERVER_CONNECTION_STRING'])
    cursor = connection.cursor()
    query = f"SELECT * from Utilisateur WHERE nom_et_prenoms LIKE ?"
    result = cursor.execute(query, ('%' + mot + '%',)).fetchall()
    return result
@app.route("/recherche_utilisateur", methods=['GET', 'POST'])
def recherche_utilisateur():
    connection = pyodbc.connect(app.config['SQL_SERVER_CONNECTION_STRING'])
    cursor = connection.cursor()
    cursor.execute("SELECT COUNT(*) from Utilisateur")
    resultat1 = cursor.fetchone()
    cursor.close()
    results = None
    if request.method == 'POST':
        mot = request.form['mot']
        results = search_in_database_user(mot)
    return render_template("recherche_utilisateur.html",resultat1=resultat1,results=results)

@app.route("/location", methods=['GET', 'POST'])
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
def service():
    connection = pyodbc.connect(app.config['SQL_SERVER_CONNECTION_STRING'])
    cursor = connection.cursor()
    cursor.execute("SELECT * from Services_demande")
    resultat = cursor.fetchall()
    cursor.close()
    cursor = connection.cursor()
    # Requête pour obtenir le nombre de services
    cursor.execute("SELECT COUNT(*) from Services_demande")
    resultat1 = cursor.fetchone()[0]
    # Requête pour obtenir le nombre de services ayant le statut "en_cours"
    cursor.execute("SELECT COUNT(*) FROM Services_demande WHERE Statut_services = 'en_cours'")
    resultat2 = cursor.fetchone()[0]
    # Requête pour obtenir le nombre de services ayant le statut "effectuer"
    cursor.execute("SELECT COUNT(*) FROM Services_demande WHERE Statut_services = 'effectuer'")
    resultat3 = cursor.fetchone()[0]
    cursor.close()
    return render_template("service.html", resultat=resultat, resultat1=resultat1, resultat2=resultat2,resultat3=resultat3)

@app.route("/Statut_services/<string:id_data>", methods=["GET", "POST"])
def Statut_services(id_data):
    connection = pyodbc.connect(app.config['SQL_SERVER_CONNECTION_STRING'])
    cursor = connection.cursor()
    
    # Exécution de la requête pour obtenir les informations de l'utilisateur
    cursor.execute("SELECT * FROM Services_demande WHERE IdServices_demande=?", (id_data,))
    Services_demande_info = cursor.fetchone()
    cursor.close()

    if Services_demande_info:
        if Services_demande_info[7] == 'en_cours':
            statut_services = "effectuer"
            flash("Le statut du service a été mis à jour avec succès!")
        else:
            statut_services = "en_cours"
            flash("Le statut du service a été mis à jour avec succès!")

        # Connexion à la base de données et mise à jour
        connection = pyodbc.connect(app.config['SQL_SERVER_CONNECTION_STRING'])
        cursor = connection.cursor()
        cursor.execute(
            """
            UPDATE Services_demande SET Statut_services=? WHERE IdServices_demande=?
            """,
            (statut_services, id_data)
        )
        connection.commit()
        cursor.close()
        connection.close()

    return redirect(url_for("service"))

@app.route("/utilisateur", methods=['GET', 'POST'])
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

@app.route("/interesse/")
def interesse():
    connection = pyodbc.connect(app.config['SQL_SERVER_CONNECTION_STRING'])
    cursor = connection.cursor()
    cursor.execute("SELECT * from interesse")
    resultat = cursor.fetchall()
    cursor.execute("SELECT COUNT(*) from interesse")
    resultat1 = cursor.fetchone()
    cursor.execute("SELECT COUNT(*) FROM interesse WHERE IdLocations IS NOT NULL")
    resultat2 = cursor.fetchone()
    cursor.execute("SELECT COUNT(*) FROM interesse WHERE IdMaison IS NOT NULL")
    resultat3 = cursor.fetchone()
    cursor.close()
    return render_template("interesse.html", resultat=resultat, resultat1=resultat1, resultat2=resultat2, resultat3=resultat3)

@app.route('/details/<typea>/<id>')
def show_details(typea, id):
    conn = pyodbc.connect(app.config['SQL_SERVER_CONNECTION_STRING'])
    cursor = conn.cursor()

    if typea == 'location':
        cursor.execute("SELECT * FROM Locations WHERE IdLocations = ?", id)
        row = cursor.fetchone()
        images = row.Image1.split(",") if row and row.Image1 else []
    elif typea == 'maison':
        cursor.execute("SELECT * FROM Maison WHERE IdMaison = ?", id)
        row = cursor.fetchone()
        images = row.Image1.split(",") if row and row.Image1 else []
    else:
        return "Type invalide", 400

    # Si aucun résultat n'est trouvé, retourner une page d'erreur ou un message
    if not row:
        return "Détails non trouvés", 404

    # Fermer la connexion
    cursor.close()
    conn.close()

    # Rendre le modèle avec les détails récupérés
    return render_template('profile.html', row=row, typea=typea, images=images)

@app.route('/images/<path:filename>')
def get_image(filename):
    return send_from_directory(app.config['IMAGE_FOLDER'], filename)

@app.route("/supprimer_service/")
def supprimer_service():
    return render_template("index.html")

if __name__ == "__main__":
    app.run(debug=True)