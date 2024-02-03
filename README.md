# ASPG : AI Sport Program Generator

ASPG est un projet mobile développé en Flutter par [ZoEnXI](https://github.com/ZoEnXI) et moi-même. 

## Objectif du projet
L'objectif de l'application est de permettre à l'utilisateur de créer un programme sportif entièrement personnalisé et sur-mesure grâce à l'intelligence artificielle (OpenAI). En effet, le sportif indique ses informations (âge, poids, fréquence de sport, possession de matériel...) et l'IA va lui retourner des séances de sports, des exercices à réaliser selon les informations et les envies de l’utilisateur. 

## Architecture logicielle
Concernant l’architecture, nous utilisons trois API différentes : 
- X – Twitter : Authentification 
- Supabase : base de données 
- OpenAI : pour le retour des données 

Pour l’authentification, nous avons utilisé le package [“supabase_auth_ui”](https://pub.dev/packages/supabase_auth_ui). Grâce à dernier, nous pouvons nous connecter avec le nom d’utilisateur le mot de passe utilisé pour X. De plus, nous pouvons également récupérer des informations telles que l’adresse mail ou l’image du profil. 

![Architecture](https://github.com/maelgllt/ASPG/blob/main/assets/architecture.png)

### Supabase
Dans notre base de données, nous avons utilisé 2 tables : Utilisateur et Programme. De plus, Supabase nous permet de créer des fonctions personnalisées que l'on peut réutiliser dans le code. Ainsi, nous avons crée une fonction “getLastProgrammeTitle” qui nous permet donc de récupérer le dernier programme de l'utilisateur.

## Interfaces utilisées
- Account.dart : il permet de gérer toute la partie compte, affiche les informations de l’utilisateur comme l’image du profil de X, son nom d’utilisateur et son email. De plus, il contient un lien qui redirige vers la page de modification de profil.
- Auth.dart : ce fichier permet de faire la liaison à l’API supabase, l’initialisation pour la connexion et la création de la session. Il permet également de faire la redirection sur la page d’accueil une fois la session créée.
- CreateProgram.dart : il contient différents inputs pour que l’utilisateur entre ses informations et un bouton pour pouvoir les soumettre. Ensuite, un appel à l’IA permet d’avoir le programme personnalisé en retour.
- FirstPage.dart : c’est la page d’accueil de notre application, c’est la page qui est lancée après la connexion effectuée. On affiche un message de bienvenue et divers boutons pour aider l’utilisateur à naviguer sur l’application comme “Créer un programme”, “Détail Programme”... Il y a aussi le titre du dernier programme de l’utilisateur.
- Home.dart : c’est la première page qui s’affiche lors du lancement de notre application. C’est la page de connexion qui contient un bouton pour s’authentifier.
- Main.dart : fichier principale de notre projet, il permet de lancer le fichier Home.dart
- MenuBurger.dart : correspond au menu déroulant situé sur le côté gauche de l’application. Il contient différents liens pour naviguer sur l’application.
- ModifProfilPage.dart : c’est la page qui permet de modifier les informations du profil. Elle contient donc des inputs pour pouvoir entrer des informations.
- Program.dart : ce fichier affiche la liste des différents programmes de l’utilisateur. Il contient le détail de chacun d’entre eux. 
