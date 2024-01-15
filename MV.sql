DROP DATABASE IF EXISTS MV
CREATE DATABASE MV


DROP TABLE IF EXISTS Administrateur
CREATE TABLE Administrateur (
IdAdministrateur  INT NOT NULL PRIMARY KEY IDENTITY(1,1),
Nom_et_prenoms VARCHAR(500),
Email VARCHAR(500),
Mot_de_pass VARCHAR(200),
Telephone VARCHAR(200)
)

DROP TABLE IF EXISTS Utilisateur
CREATE TABLE Utilisateur (
IdUtilisateur INT NOT NULL PRIMARY KEY IDENTITY(1,1),
Nom_et_prenoms VARCHAR(500),
Email VARCHAR(500),
Mot_de_pass VARCHAR(200),
Adresse VARCHAR(200),
Telephone VARCHAR(200)
)

DROP TABLE IF EXISTS Maison
CREATE TABLE Maison (
IdMaison INT NOT NULL PRIMARY KEY IDENTITY(1,1),
Ville VARCHAR(200),
Commune VARCHAR(200),
Nombre_de_pieces INT,
Prix_unitaire FLOAT,
Descriptions VARCHAR(MAX),
Type_de_maison VARCHAR(200),
Statut_maison VARCHAR(200),
GPS VARCHAR(200),
Image1 VARCHAR(MAX),
IdUtilisateur INT NOT NULL,
FOREIGN KEY (IdUtilisateur) REFERENCES Utilisateur (IdUtilisateur),
)


DROP TABLE IF EXISTS Locations
CREATE TABLE Locations (
IdLocations INT NOT NULL PRIMARY KEY IDENTITY(1,1),
Ville VARCHAR(200),
Commune VARCHAR(200),
Nombre_de_pieces INT,
Prix_mensuel FLOAT,
Caution FLOAT,
Avance FLOAT,
Descriptions VARCHAR(MAX),
Type_de_maison VARCHAR(200),
Statut_maison VARCHAR(200),
GPS VARCHAR(200),
Image1 VARCHAR(MAX),
IdUtilisateur INT NOT NULL,
FOREIGN KEY (IdUtilisateur) REFERENCES Utilisateur (IdUtilisateur),
)


DROP TABLE IF EXISTS Services_demande;
CREATE TABLE Services_demande (
    IdServices_demande INT NOT NULL PRIMARY KEY IDENTITY(1,1),
    nom_et_prenom VARCHAR(200),
    Type_de_services VARCHAR(200),
    lieu_debitation VARCHAR(200),
    telephonne VARCHAR(200),
    Descriptions VARCHAR(200),
    Dates DATETIME,
    Statut_services VARCHAR(200),
);

DROP TABLE IF EXISTS interesse;
CREATE TABLE interesse (
    IdServices_demande INT NOT NULL PRIMARY KEY IDENTITY(1,1),
    nom VARCHAR(200),
    prenom VARCHAR(200),
    Email VARCHAR(200),
    telephonne VARCHAR(200),
    Descriptions VARCHAR(200),
    IdLocations INT NOT NULL,
    FOREIGN KEY (IdLocations) REFERENCES Locations (IdLocations),
);

DROP TABLE IF EXISTS Vendu
CREATE TABLE Vendu (
IdVendu INT NOT NULL PRIMARY KEY IDENTITY(1,1),
IdMaison INT NOT NULL,
IdUtilisateur INT NOT NULL,
FOREIGN KEY (IdMaison) REFERENCES Maison (IdMaison),
FOREIGN KEY (IdUtilisateur) REFERENCES Utilisateur (IdUtilisateur),
)

DROP TABLE IF EXISTS Loué
CREATE TABLE Loué (
IdLoué INT NOT NULL PRIMARY KEY IDENTITY(1,1),
IdMaison INT NOT NULL,
IdUtilisateur INT NOT NULL,
FOREIGN KEY (IdMaison) REFERENCES Maison (IdMaison),
FOREIGN KEY (IdUtilisateur) REFERENCES Utilisateur (IdUtilisateur),
)

DROP TABLE IF EXISTS Historique_servives
CREATE TABLE Historique_servives (
IdHist_servives INT NOT NULL PRIMARY KEY IDENTITY(1,1),
IdUtilisateur INT NOT NULL,
FOREIGN KEY (IdUtilisateur) REFERENCES Utilisateur (IdUtilisateur),
)


