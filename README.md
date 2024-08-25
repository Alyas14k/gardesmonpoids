#GardeMonPoids

GardeMonPoids est une application mobile développée en Flutter pour aider les utilisateurs à suivre et analyser leur poids corporel au quotidien. L'application permet de renseigner, visualiser et analyser les variations de poids, de calculer l'IMC (Indice de Masse Corporelle), et d'afficher des graphiques de suivi.

Fonctionnalités
  
  Journalisation du poids : Les utilisateurs peuvent enregistrer leur poids quotidiennement avec la date associée.
  
  Analyse du poids : Affichage du poids actuel et des précédents, avec un historique en fonction des dates.
  
  Calcul de l'IMC : Calcul automatique de l'IMC en fonction du poids et de la taille, avec une évaluation de la catégorie (poids insuffisant, normal,   surpoids, etc.).
 
  Graphiques de suivi : Visualisation des tendances de poids sous forme de courbes.
  
  Sécurité des données : Authentification sécurisée pour protéger les données personnelles.
  
  Navigation intuitive : Menu de navigation pour accéder facilement aux différentes pages de l'application.

Installation

Prérequis
Flutter SDK: Installation Guide
Android Studio ou un autre IDE compatible avec Flutter
Un émulateur Android ou un appareil physique pour tester l'application

Étapes d'installation
Clonez le repository sur votre machine locale :
bash
Copier le code
git clone https://github.com/votre-utilisateur/gardemonpoids.git
Accédez au dossier du projet :
bash
Copier le code
cd gardemonpoids
Installez les dépendances du projet :
bash
Copier le code
flutter pub get
Exécutez l'application sur un émulateur ou un appareil connecté :
bash
Copier le code
flutter run

Structure du Projet

Le projet est organisé comme suit :

  lib/ : Contient tout le code source de l'application.
  auth/ : Gestion de l'authentification (connexion, inscription, déconnexion).
  pages/ : Les différentes pages de l'application (accueil, suivi, graphique, calcul IMC, etc.).
  models/ : Modèles de données pour les utilisateurs, les enregistrements de poids, etc.
  utils/ : Fonctions utilitaires pour l'application.
  main.dart : Point d'entrée principal de l'application.

#Usage

Enregistrement du poids : Depuis la page d'accueil, cliquez sur "Renseigner poids" pour ajouter une nouvelle entrée de poids.
Calcul de l'IMC : Accédez à la page "Calcul IMC" depuis le menu pour calculer votre IMC en renseignant votre poids et votre taille.
Visualisation des graphiques : Cliquez sur "Graphique" pour afficher les tendances de votre poids au fil du temps.
Sécurité : Les données sont protégées par une authentification avec mot de passe.

#Contribution

Les contributions sont les bienvenues ! Si vous souhaitez contribuer, veuillez suivre les étapes suivantes :
  -Forkez le projet
  -Créez une branche pour votre fonctionnalité (git checkout -b feature/nom-de-la-fonctionnalité)
  -Effectuez vos modifications (git commit -am 'Ajout d'une nouvelle fonctionnalité')
  -Poussez la branche (git push origin feature/nom-de-la-fonctionnalité)
  -Ouvrez une Pull Request
