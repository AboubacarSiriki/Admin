DROP DATABASE IF EXISTS MV
CREATE DATABASE MV


DROP TABLE IF EXISTS Administrateur
CREATE TABLE Administrateur (
IdAdministrateur  INT NOT NULL PRIMARY KEY IDENTITY(1,1),
Nom_et_prenoms VARCHAR(500),
Email VARCHAR(500),
Mot_de_pass VARCHAR(200),
Adresse VARCHAR(200),
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




--

DROP DATABASE IF EXISTS MV
CREATE DATABASE MV


CREATE TABLE Administrateur (
IdAdministrateur  INT NOT NULL PRIMARY KEY IDENTITY(1,1),
Nom_et_prenoms VARCHAR(500),
Email VARCHAR(500),
Mot_de_pass VARCHAR(200),
Adresse VARCHAR(200),
Telephone VARCHAR(200)
)



CREATE TABLE Utilisateur (
IdUtilisateur INT NOT NULL PRIMARY KEY IDENTITY(1,1),
Nom_et_prenoms VARCHAR(500),
Email VARCHAR(500),
Mot_de_pass VARCHAR(200),
Adresse VARCHAR(200),
Telephone VARCHAR(200),
condition_aprouve VARCHAR(200)
)


CREATE TABLE Maison (
IdMaison INT NOT NULL PRIMARY KEY IDENTITY(1,1),
Ville VARCHAR(200),
Commune VARCHAR(200),
Quartier VARCHAR(200),
Nombre_de_pieces INT,
Nombre_de_chambres INT,
Nombre_de_salles_de_bain INT,
metre_carre VARCHAR(200),
Prix_unitaire FLOAT,
Descriptions VARCHAR(MAX),
Type_de_maison VARCHAR(200),
Statut_maison VARCHAR(200),
GPS VARCHAR(200),
Image1 VARCHAR(MAX),
Likes INT,
Nombre_de_vue INT,
IdUtilisateur INT NOT NULL,
FOREIGN KEY (IdUtilisateur) REFERENCES Utilisateur (IdUtilisateur),
)



CREATE TABLE Locations (
IdLocations INT NOT NULL PRIMARY KEY IDENTITY(1,1),
Ville VARCHAR(200),
Commune VARCHAR(200),
Quartier VARCHAR(200),
Nombre_de_pieces INT,
Nombre_de_chambres INT,
Nombre_de_salles_de_bain INT,
metre_carre VARCHAR(200),
Prix_mensuel FLOAT,
Caution FLOAT,
Avance FLOAT,
Descriptions VARCHAR(MAX),
Type_de_maison VARCHAR(200),
Statut_maison VARCHAR(200),
GPS VARCHAR(200),
Image1 VARCHAR(MAX),
Likes INT,
Nombre_de_vue INT,
IdUtilisateur INT NOT NULL,
FOREIGN KEY (IdUtilisateur) REFERENCES Utilisateur (IdUtilisateur),
)


CREATE TABLE user_like (
    Id INT NOT NULL PRIMARY KEY IDENTITY(1,1),
    IdLocations INT,
    IdMaison INT,
    IdUtilisateur INT,
    type_action VARCHAR(50),
    FOREIGN KEY (IdLocations) REFERENCES Locations(IdLocations),
    FOREIGN KEY (IdMaison) REFERENCES Maison(IdMaison),
    FOREIGN KEY (IdUtilisateur) REFERENCES Utilisateur(IdUtilisateur)
);


CREATE TABLE interesse (
    IdServices_demande INT NOT NULL PRIMARY KEY IDENTITY(1,1),
    nom VARCHAR(200),
    prenom VARCHAR(200),
    Email VARCHAR(200),
    telephonne VARCHAR(200),
    Descriptions VARCHAR(200),
    IdLocations INT,
	IdMaison INT,
    FOREIGN KEY (IdLocations) REFERENCES Locations (IdLocations),
	FOREIGN KEY (IdMaison) REFERENCES Maison (IdMaison),
);


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

CREATE TABLE contacte (
idcontacte INT NOT NULL PRIMARY KEY IDENTITY(1,1),
nom VARCHAR(200),
prenom VARCHAR(200),
Email VARCHAR(200),
telephonne VARCHAR(200),
Descriptions VARCHAR(200)
);

-- 

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


SELECT TOP (1000) [IdServices_demande]
      ,[nom]
      ,[prenom]
      ,[Email]
      ,[telephonne]
      ,[Descriptions]
      ,[IdLocations]
      ,[IdMaison]
  FROM [MV].[dbo].[interesse]

  SELECT TOP (1000) [IdLocations]
      ,[Ville]
      ,[Commune]
      ,[Nombre_de_pieces]
      ,[Prix_mensuel]
      ,[Caution]
      ,[Avance]
      ,[Descriptions]
      ,[Type_de_maison]
      ,[Statut_maison]
      ,[GPS]
      ,[Image1]
      ,[IdUtilisateur]
      ,[Likes]
  FROM [MV].[dbo].[Locations]


DROP TABLE IF EXISTS Locations
CREATE TABLE Locations (
IdLocations INT NOT NULL PRIMARY KEY IDENTITY(1,1),
Ville VARCHAR(200),
Commune VARCHAR(200),
Nombre_de_pieces INT,
dimantion INT,
Prix_mensuel FLOAT,
Caution FLOAT,
Avance FLOAT,
Descriptions VARCHAR(MAX),
Type_de_maison VARCHAR(200),
Statut_maison VARCHAR(200),
GPS VARCHAR(200),
Image1 VARCHAR(MAX),
IdUtilisateur INT NOT NULL,
Likes VARCHAR(100)
FOREIGN KEY (IdUtilisateur) REFERENCES Utilisateur (IdUtilisateur),
)

  SELECT TOP (1000) [IdMaison]
      ,[Ville]
      ,[Commune]
      ,[Nombre_de_pieces]
      ,[Prix_unitaire]
      ,[Descriptions]
      ,[Type_de_maison]
      ,[Statut_maison]
      ,[GPS]
      ,[Image1]
      ,[IdUtilisateur]
      ,[Likes]
  FROM [MV].[dbo].[Maison]



CREATE TABLE Maison (
IdMaison INT NOT NULL PRIMARY KEY IDENTITY(1,1),
Ville VARCHAR(200),
Commune VARCHAR(200),
Nombre_de_pieces INT,
nombre_chanbre INT,
nombre_salle_bains INT,
dimantion INT,
Prix_unitaire FLOAT,
Descriptions VARCHAR(MAX),
Type_de_maison VARCHAR(200),
Statut_maison VARCHAR(200),
GPS VARCHAR(200),
Image1 VARCHAR(MAX),
IdUtilisateur INT NOT NULL,
Likes VARCHAR(100)
FOREIGN KEY (IdUtilisateur) REFERENCES Utilisateur (IdUtilisateur),
)

  SELECT TOP (1000) [Id]
      ,[IdLocations]
      ,[IdMaison]
      ,[IdUtilisateur]
      ,[type_action]
  FROM [MV].[dbo].[user_like]

  SELECT TOP (1000) [IdServices_demande]
      ,[nom_et_prenom]
      ,[Type_de_services]
      ,[lieu_debitation]
      ,[telephonne]
      ,[Descriptions]
      ,[Dates]
      ,[Statut_services]
  FROM [MV].[dbo].[Services_demande]

-- 


-- Maisons
INSERT INTO [MV].[dbo].[Maison] ([Ville], [Commune], [Nombre_de_pieces], [Prix_unitaire], [Descriptions], [Type_de_maison], [Statut_maison], [GPS], [IdUtilisateur], [Likes])
VALUES
('Abidjan', 'Cocody', 4, 120000000, 'Maison moderne avec piscine', 'Villa', 'Disponible', '5.3454, -4.0243', 1, 20),
('Abidjan', 'Marcory', 3, 90000000, 'Appartement lumineux proche des commerces', 'Appartement', 'Disponible', '5.3036, -3.9783', 2, 15),
('Bouaké', 'Belleville', 5, 80000000, 'Grande maison familiale avec jardin', 'Maison', 'Loué', '7.6898, -5.0333', 3, 10),
('Yamoussoukro', 'Quartier Présidentiel', 6, 150000000, 'Résidence de luxe avec piscine et garage', 'Villa', 'Disponible', '6.8224, -5.2760', 4, 25),
('San-Pédro', 'Bardot', 3, 70000000, 'Maison proche de la plage', 'Maison', 'Loué', '4.7477, -6.6356', 5, 8),
('Daloa', 'Kennedy', 4, 65000000, 'Maison spacieuse dans un quartier calme', 'Maison', 'Disponible', '6.8770, -6.4502', 6, 12),
('Korhogo', 'Soba', 2, 45000000, 'Petit appartement pour jeune couple', 'Appartement', 'Loué', '9.4580, -5.6295', 7, 5),
('Abidjan', 'Plateau', 3, 110000000, 'Appartement moderne avec vue sur la lagune', 'Appartement', 'Disponible', '5.3248, -4.0270', 1, 30),
('Man', 'Centre-ville', 5, 75000000, 'Grande maison avec vue sur les montagnes', 'Maison', 'Loué', '7.4139, -7.5537', 2, 7),
('Gagnoa', 'Libreville', 4, 60000000, 'Maison familiale avec grand jardin', 'Maison', 'Disponible', '6.1319, -5.9494', 3, 13),
('Abidjan', 'Yopougon', 2, 50000000, 'Studio rénové idéal pour étudiants', 'Studio', 'Disponible', '5.3365, -4.0701', 4, 22),
('Abengourou', 'Amanikro', 3, 55000000, 'Maison avec jardin et garage', 'Maison', 'Loué', '6.7297, -3.4919', 5, 10),
('Aboisso', 'Koumassi', 4, 48000000, 'Maison de ville avec terrasse', 'Maison', 'Disponible', '5.4725, -3.2062', 6, 9),
('Divo', 'Grah', 3, 50000000, 'Maison agréable avec cour', 'Maison', 'Loué', '5.8371, -5.3581', 7, 6),
('Soubré', 'Orly', 2, 40000000, 'Petit appartement en centre-ville', 'Appartement', 'Disponible', '5.7877, -6.6031', 1, 11),
('Abidjan', 'Adjame', 3, 75000000, 'Appartement spacieux dans un quartier animé', 'Appartement', 'En vente', '5.3482, -4.0384', 1, 18),
('San-Pédro', 'Sewe', 4, 85000000, 'Maison avec vue sur la mer', 'Maison', 'Vendu', '4.7478, -6.6365', 2, 22),
('Bouaké', 'Koko', 5, 90000000, 'Grande maison avec piscine', 'Villa', 'En vente', '7.6889, -5.0323', 3, 17),
('Yamoussoukro', 'Morofé', 3, 70000000, 'Appartement moderne en centre-ville', 'Appartement', 'Vendu', '6.8225, -5.2771', 4, 14),
('Man', 'Camp Militaire', 4, 80000000, 'Maison avec grand jardin', 'Maison', 'En vente', '7.4140, -7.5538', 5, 16),
('Gagnoa', 'Gagnoa Ville', 3, 60000000, 'Maison familiale proche des écoles', 'Maison', 'En vente', '6.1320, -5.9505', 6, 10),
('Daloa', 'Orly', 2, 50000000, 'Appartement rénové', 'Appartement', 'Vendu', '6.8780, -6.4513', 7, 9),
('Korhogo', 'Haute Ville', 4, 75000000, 'Maison moderne avec terrasse', 'Maison', 'En vente', '9.4581, -5.6306', 1, 11),
('Abidjan', 'Treichville', 3, 65000000, 'Appartement proche des commodités', 'Appartement', 'Vendu', '5.3156, -4.0123', 2, 20),
('San-Pédro', 'San Pedro Ville', 4, 90000000, 'Maison avec piscine et jardin', 'Villa', 'En vente', '4.7480, -6.6367', 3, 15),
('Bouaké', 'Zone industrielle', 3, 60000000, 'Maison avec grand garage', 'Maison', 'En vente', '7.6891, -5.0325', 4, 12),
('Yamoussoukro', 'Dioulakro', 2, 55000000, 'Studio moderne pour célibataire', 'Studio', 'Vendu', '6.8226, -5.2772', 5, 8),
('Man', 'Grand Gbapleu', 5, 95000000, 'Villa avec vue sur les montagnes', 'Villa', 'En vente', '7.4141, -7.5539', 6, 19),
('Gagnoa', 'Sogefiha', 4, 65000000, 'Maison familiale avec cour', 'Maison', 'Vendu', '6.1321, -5.9506', 7, 13),
('Daloa', 'Gboguhé', 3, 60000000, 'Appartement dans un quartier calme', 'Appartement', 'En vente', '6.8781, -6.4514', 1, 14),
('Korhogo', 'Péléforo', 3, 70000000, 'Maison avec garage', 'Maison', 'Vendu', '9.4582, -5.6307', 2, 16),
('Abidjan', 'Koumassi', 4, 75000000, 'Maison avec jardin et piscine', 'Maison', 'En vente', '5.3396, -4.0251', 3, 18),
('Abengourou', 'Belleville', 3, 50000000, 'Appartement lumineux en centre-ville', 'Appartement', 'Vendu', '6.7307, -3.4920', 4, 11),
('Aboisso', 'Aboisso Ville', 4, 65000000, 'Maison moderne avec terrasse', 'Maison', 'En vente', '5.4726, -3.2073', 5, 12),
('Divo', 'Bada', 3, 55000000, 'Maison proche du marché', 'Maison', 'Vendu', '5.8381, -5.3592', 6, 10),
('Abidjan', 'Port-Bouet', 3, 70000000, 'Appartement moderne proche de aéroport', 'Appartement', 'En vente', '5.2610, -3.9272', 1, 23),
('San-Pédro', 'Balmer', 4, 80000000, 'Maison avec jardin et vue sur la mer', 'Maison', 'Vendu', '4.7512, -6.6340', 2, 19),
('Bouaké', 'Ahougnassou', 5, 95000000, 'Grande maison avec piscine et garage', 'Villa', 'En vente', '7.6932, -5.0298', 3, 27),
('Yamoussoukro', 'Habitat', 3, 75000000, 'Appartement lumineux et spacieux', 'Appartement', 'Vendu', '6.8231, -5.2801', 4, 14),
('Man', 'Libreville', 4, 85000000, 'Maison familiale avec vue sur les montagnes', 'Maison', 'En vente', '7.4165, -7.5567', 5, 12),
('Gagnoa', 'Garahio', 3, 60000000, 'Maison proche des écoles et des commerces', 'Maison', 'En vente', '6.1372, -5.9512', 6, 11),
('Daloa', 'Abattoir', 2, 55000000, 'Appartement rénové en centre-ville', 'Appartement', 'Vendu', '6.8802, -6.4540', 7, 9),
('Korhogo', 'Tafire', 4, 75000000, 'Maison moderne avec terrasse', 'Maison', 'En vente', '9.4642, -5.6299', 1, 20),
('Abidjan', 'Cocody', 5, 120000000, 'Villa de luxe avec piscine et jardin', 'Villa', 'Vendu', '5.3470, -4.0245', 2, 30),
('San-Pédro', 'Sewe', 3, 70000000, 'Maison avec vue sur la mer', 'Maison', 'En vente', '4.7500, -6.6350', 3, 18),
('Bouaké', 'Koko', 3, 60000000, 'Maison avec grand jardin', 'Maison', 'Vendu', '7.6900, -5.0320', 4, 15),
('Yamoussoukro', 'Sopim', 4, 85000000, 'Maison spacieuse avec garage', 'Maison', 'En vente', '6.8250, -5.2780', 5, 22),
('Man', 'Toho', 3, 65000000, 'Appartement moderne avec vue sur les montagnes', 'Appartement', 'Vendu', '7.4145, -7.5560', 6, 10),
('Gagnoa', 'Barouhio', 2, 50000000, 'Studio moderne en centre-ville', 'Studio', 'En vente', '6.1300, -5.9515', 7, 8),
('Daloa', 'Zagloba', 3, 60000000, 'Maison familiale dans un quartier calme', 'Maison', 'Vendu', '6.8790, -6.4520', 1, 13);


-- Locations
INSERT INTO [MV].[dbo].[Locations] ([Ville], [Commune], [Nombre_de_pieces], [Prix_mensuel], [Caution], [Avance], [Descriptions], [Type_de_maison], [Statut_maison], [GPS], [Image1], [IdUtilisateur], [Likes])
VALUES
('Abidjan', 'Cocody', 3, 350000, 2, 1, 'Appartement moderne proche des écoles', 'Appartement', 'Libre', '5.3454, -4.0243', 1, 20),
('Abidjan', 'Marcory', 2, 250000, 1, 1, 'Petit appartement lumineux', 'Appartement', 'Occupée', '5.3036, -3.9783', 2, 15),
('Bouaké', 'Belleville', 4, 300000, 2, 2, 'Maison familiale avec grand jardin', 'Maison', 'Libre', '7.6898, -5.0333', 3, 10),
('Yamoussoukro', 'Quartier Présidentiel', 5, 450000, 3, 2, 'Grande villa avec piscine et garage', 'Villa', 'Libre', '6.8224, -5.2760', 4, 25),
('San-Pédro', 'Bardot', 2, 200000, 1, 1, 'Maison proche de la plage', 'Maison', 'Occupée', '4.7477, -6.6356', 5, 8),
('Daloa', 'Kennedy', 3, 250000, 1, 1, 'Maison spacieuse dans un quartier calme', 'Maison', 'Libre', '6.8770, -6.4502', 6, 12),
('Korhogo', 'Soba', 2, 150000, 1, 1, 'Petit appartement pour jeune couple', 'Appartement', 'Occupée', '9.4580, -5.6295', 7, 5),
('Abidjan', 'Plateau', 3, 400000, 2, 2, 'Appartement moderne avec vue sur la lagune', 'Appartement', 'Libre', '5.3248, -4.0270', 1, 30),
('Man', 'Centre-ville', 4, 300000, 2, 2, 'Grande maison avec vue sur les montagnes', 'Maison', 'Occupée', '7.4139, -7.5537', 2, 7),
('Gagnoa', 'Libreville', 3, 250000, 1, 1, 'Maison familiale avec grand jardin', 'Maison', 'Libre', '6.1319, -5.9494', 3, 13),
('Abidjan', 'Yopougon', 2, 200000, 1, 1, 'Studio rénové idéal pour étudiants', 'Studio', 'Libre', '5.3365, -4.0701', 4, 22),
('Abengourou', 'Amanikro', 3, 220000, 1, 1, 'Maison avec jardin et garage', 'Maison', 'Occupée', '6.7297, -3.4919', 5, 10),
('Aboisso', 'Koumassi', 3, 240000, 1, 1, 'Maison de ville avec terrasse', 'Maison', 'Libre', '5.4725, -3.2062', 6, 9),
('Divo', 'Grah', 2, 180000, 1, 1, 'Maison agréable avec cour', 'Maison', 'Occupée', '5.8371, -5.3581', 7, 6),
('Soubré', 'Orly', 2, 150000, 1, 1, 'Petit appartement en centre-ville', 'Appartement', 'Libre', '5.7877, -6.6031', 1, 11),
('Abidjan', 'Cocody', 4, 400000, 2, 2, 'Villa moderne avec piscine', 'Villa', 'Libre', '5.3480, -4.0260', 1, 35),
('Abidjan', 'Treichville', 3, 280000, 1, 1, 'Appartement lumineux', 'Appartement', 'Occupée', '5.3056, -4.0118', 2, 19),
('Bouaké', 'Dar-Es-Salam', 3, 250000, 1, 1, 'Maison avec jardin', 'Maison', 'Libre', '7.6911, -5.0332', 3, 12),
('Yamoussoukro', 'Kokrenou', 4, 350000, 2, 2, 'Grande villa avec jardin', 'Villa', 'Occupée', '6.8204, -5.2750', 4, 28),
('San-Pédro', 'Cité', 3, 270000, 1, 1, 'Maison familiale proche de la plage', 'Maison', 'Libre', '4.7500, -6.6360', 5, 15),
('Daloa', 'Gbatta', 2, 200000, 1, 1, 'Petit appartement confortable', 'Appartement', 'Occupée', '6.8771, -6.4515', 6, 11),
('Korhogo', 'Soba', 3, 220000, 1, 1, 'Maison moderne avec terrasse', 'Maison', 'Libre', '9.4580, -5.6296', 7, 17),
('Abidjan', 'Adjame', 2, 250000, 1, 1, 'Appartement proche des commodités', 'Appartement', 'Occupée', '5.3470, -4.0370', 1, 22),
('Bouaké', 'Zone 4', 4, 300000, 2, 2, 'Maison spacieuse avec garage', 'Maison', 'Libre', '7.6880, -5.0310', 2, 20),
('Yamoussoukro', 'Attiégouakro', 3, 280000, 1, 1, 'Appartement moderne', 'Appartement', 'Occupée', '6.8250, -5.2781', 3, 14),
('San-Pédro', 'Sewe', 2, 180000, 1, 1, 'Appartement confortable', 'Appartement', 'Libre', '4.7480, -6.6355', 4, 13),
('Daloa', 'Grandes Terres', 3, 230000, 1, 1, 'Maison avec vue sur les montagnes', 'Maison', 'Occupée', '6.8785, -6.4525', 5, 12),
('Korhogo', 'Pelengana', 4, 350000, 2, 2, 'Villa moderne avec jardin', 'Villa', 'Libre', '9.4570, -5.6300', 6, 18),
('Abidjan', 'Marcory', 3, 300000, 1, 1, 'Appartement lumineux avec balcon', 'Appartement', 'Occupée', '5.3100, -3.9730', 7, 25),
('Man', 'Libreville', 2, 200000, 1, 1, 'Petit appartement avec vue sur la montagne', 'Appartement', 'Libre', '7.4160, -7.5561', 1, 14),
('Gagnoa', 'Sogefiha', 3, 250000, 1, 1, 'Maison familiale avec cour', 'Maison', 'Occupée', '6.1319, -5.9500', 2, 16),
('Abidjan', 'Cocody', 4, 350000, 2, 2, 'Villa spacieuse avec piscine', 'Villa', 'Libre', '5.3482, -4.0250', 3, 26),
('San-Pédro', 'Bardot', 3, 270000, 1, 1, 'Maison avec vue sur la mer', 'Maison', 'Occupée', '4.7482, -6.6360', 4, 21),
('Bouaké', 'Belleville', 2, 200000, 1, 1, 'Appartement en centre-ville', 'Appartement', 'Libre', '7.6895, -5.0335', 5, 10),
('Yamoussoukro', 'Quartier résidentiel', 3, 320000, 1, 1, 'Maison moderne avec jardin', 'Maison', 'Occupée', '6.8244, -5.2772', 6, 29),
('Daloa', 'Zagloba', 2, 180000, 1, 1, 'Petit studio confortable', 'Studio', 'Libre', '6.8775, -6.4519', 7, 9),
('Korhogo', 'Koko', 3, 260000, 1, 1, 'Maison moderne avec terrasse', 'Maison', 'Occupée', '9.4578, -5.6292', 1, 13),
('Abengourou', 'Bellevue', 2, 200000, 1, 1, 'Appartement rénové en centre-ville', 'Appartement', 'Libre', '6.7305, -3.4915', 2, 11),
('Aboisso', 'Aboisso Ville', 3, 240000, 1, 1, 'Maison moderne avec terrasse', 'Maison', 'Occupée', '5.4725, -3.2063', 3, 15),
('Divo', 'Bada', 2, 180000, 1, 1, 'Maison proche du marché', 'Maison', 'Libre', '5.8375, -5.3580', 4, 7),
('Abidjan', 'Yopougon', 3, 300000, 1, 1, 'Appartement moderne avec balcon', 'Appartement', 'Libre', '5.3364, -4.0732', 1, 18),
('San-Pédro', 'Sewe', 2, 220000, 1, 1, 'Petit appartement confortable', 'Appartement', 'Occupée', '4.7501, -6.6364', 2, 12),
('Bouaké', 'Ahougnansou', 3, 250000, 1, 1, 'Maison avec petit jardin', 'Maison', 'Libre', '7.6908, -5.0326', 3, 16),
('Yamoussoukro', 'Attiégouakro', 4, 350000, 2, 2, 'Grande villa avec garage et piscine', 'Villa', 'Occupée', '6.8201, -5.2768', 4, 21),
('Daloa', 'Gboguhé', 2, 200000, 1, 1, 'Appartement rénové', 'Appartement', 'Libre', '6.8782, -6.4527', 5, 14),
('Man', 'Camp Militaire', 3, 280000, 1, 1, 'Maison familiale avec cour', 'Maison', 'Occupée', '7.4142, -7.5535', 6, 17),
('Gagnoa', 'Garahio', 2, 220000, 1, 1, 'Petit appartement lumineux', 'Appartement', 'Libre', '6.1321, -5.9509', 7, 11),
('Abidjan', 'Adjame', 4, 370000, 2, 2, 'Villa spacieuse avec jardin', 'Villa', 'Occupée', '5.3483, -4.0372', 1, 25),
('Korhogo', 'Haute Ville', 3, 240000, 1, 1, 'Maison avec terrasse', 'Maison', 'Libre', '9.4579, -5.6293', 2, 15),
('San-Pédro', 'Cité', 2, 200000, 1, 1, 'Studio confortable proche de la plage', 'Studio', 'Occupée', '4.7502, -6.6368', 3, 13);


-- DECLARE @i INT = 1;
-- WHILE @i <= 1000
-- BEGIN
--     INSERT INTO [MV].[dbo].[user_like] ([IdLocations], [IdMaison], [IdUtilisateur], [type_action])
--     VALUES (
--         CASE WHEN RAND() > 0.5 THEN FLOOR(RAND() * 50) + 1 ELSE NULL END,
--         CASE WHEN RAND() <= 0.5 THEN FLOOR(RAND() * 50) + 1 ELSE NULL END,
--         FLOOR(RAND() * 7) + 1,
--         'like'
--     );
--     SET @i = @i + 1;
-- END;




-- Créer une table temporaire pour stocker les likes des Locations
SELECT IdLocations, Likes
INTO #TempLocations
FROM Locations;

-- Créer une table temporaire pour stocker les likes des Maison
SELECT IdMaison, Likes
INTO #TempMaison
FROM Maison;

-- Insérer les likes pour les Locations
DECLARE @i INT, @j INT, @IdLocations INT, @Likes INT;

DECLARE cursor_Locations CURSOR FOR
SELECT IdLocations, Likes FROM #TempLocations;

OPEN cursor_Locations;
FETCH NEXT FROM cursor_Locations INTO @IdLocations, @Likes;

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @j = 1;
    WHILE @j <= @Likes
    BEGIN
        INSERT INTO [MV].[dbo].[user_like] ([IdLocations], [IdMaison], [IdUtilisateur], [type_action])
        VALUES (
            @IdLocations,
            NULL,
            CASE 
                WHEN RAND() < 0.5 THEN FLOOR(RAND() * 7) + 1 
                ELSE FLOOR(RAND() * 993) + 8 
            END,
            'like'
        );
        SET @j = @j + 1;
    END
    FETCH NEXT FROM cursor_Locations INTO @IdLocations, @Likes;
END

CLOSE cursor_Locations;
DEALLOCATE cursor_Locations;

-- Insérer les likes pour les Maison
DECLARE @IdMaison INT;

DECLARE cursor_Maison CURSOR FOR
SELECT IdMaison, Likes FROM #TempMaison;

OPEN cursor_Maison;
FETCH NEXT FROM cursor_Maison INTO @IdMaison, @Likes;

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @j = 1;
    WHILE @j <= @Likes
    BEGIN
        INSERT INTO [MV].[dbo].[user_like] ([IdLocations], [IdMaison], [IdUtilisateur], [type_action])
        VALUES (
            NULL,
            @IdMaison,
            CASE 
                WHEN RAND() < 0.5 THEN FLOOR(RAND() * 7) + 1 
                ELSE FLOOR(RAND() * 993) + 8 
            END,
            'like'
        );
        SET @j = @j + 1;
    END
    FETCH NEXT FROM cursor_Maison INTO @IdMaison, @Likes;
END

CLOSE cursor_Maison;
DEALLOCATE cursor_Maison;

-- Nettoyer les tables temporaires
DROP TABLE #TempLocations;
DROP TABLE #TempMaison;




