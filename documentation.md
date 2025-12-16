# Documentation technique — Barbarian Game (iOS)

## 1. Architecture générale de l’application

L’application a été développée en SwiftUI pour iOS, en s’appuyant sur une architecture de type MVVM (Model – View – ViewModel).  
Ce choix permet de séparer clairement l’interface utilisateur, la logique applicative et la gestion des données, tout en restant cohérent avec les recommandations actuelles de SwiftUI.

Les Models représentent uniquement les données telles qu’elles sont renvoyées par l’API (Barbarian, Fight, Avatar, etc.).  
Aucune logique métier n’est implémentée côté client : l’ensemble des calculs liés aux combats est réalisé par le serveur, conformément aux contraintes du sujet.

Les ViewModels jouent un rôle central dans l’application. Ils sont responsables :
- des appels à l’API via les repositories,
- de la gestion de l’état de l’application (chargement, erreurs),
- de l’exposition des données aux vues SwiftUI.

Chaque vue principale possède son ViewModel dédié (par exemple `BarbarianViewModel`, `FightViewModel`, `AuthViewModel`), ce qui permet d’éviter des ViewModels trop complexes et facilite la maintenance du code.

---

## 2. Gestion de l’authentification et du token

L’authentification repose sur l’utilisation d’un token Bearer fourni par l’API après la connexion de l’utilisateur.  
Ce token est stocké localement et automatiquement ajouté aux en-têtes HTTP de toutes les requêtes suivantes.

La logique d’authentification est centralisée dans le `AuthViewModel`, qui expose un état `isAuthenticated` utilisé par le reste de l’application pour adapter l’interface.

Lors de la déconnexion, le token est supprimé et l’utilisateur est redirigé vers l’écran de connexion.  
Cette approche garantit que l’application ne tente jamais d’accéder à des ressources protégées sans être authentifiée.

---

## 3. Rôle de RootView et gestion des routes principales

`RootView` constitue le point d’entrée principal de l’application.  
Son rôle est de déterminer quelle vue afficher en fonction de l’état global de l’utilisateur.

Plutôt que de gérer la navigation de manière dispersée dans chaque vue, la logique est centralisée dans cette vue afin de simplifier le flux utilisateur et d’éviter les incohérences.

Trois cas principaux sont gérés :
- utilisateur non connecté : affichage de la vue de connexion ;
- utilisateur connecté sans barbare existant : affichage de la création du barbare ;
- utilisateur connecté avec un barbare : accès au menu principal.

Le chargement initial des données (avatars et barbare) est déclenché lors d’un changement de l’état d’authentification.  
Un indicateur de chargement est affiché afin d’éviter l’apparition de vues incomplètes.

---

## 4. Communication avec l’API

La communication avec le backend repose sur un client HTTP centralisé (APIClient).  
Ce composant est responsable de :
- l’envoi des requêtes HTTP,
- l’encodage des paramètres,
- le décodage des réponses JSON,
- la gestion des erreurs réseau.

Les appels à l’API sont regroupés dans des repositories (par exemple `BarbarianRepository`, `FightRepository`), afin de séparer la logique réseau des ViewModels.

---

## 5. Gestion des combats, de l’historique et des événements

Les combats étant entièrement simulés côté serveur, l’application se limite à déclencher un combat et à afficher les données renvoyées par l’API.

Un point important concerne l’historique des combats : un joueur peut être impliqué dans un combat sans en être à l’origine, lorsqu’il est sélectionné comme adversaire par le serveur.  
Pour cette raison, l’application recharge l’historique lorsque celle-ci est visible afin de détecter l’apparition de nouveaux combats.

Lorsqu’un nouveau combat est détecté dans l’historique, une notification visuelle simple est affichée dans l’interface pour informer l’utilisateur.  
Aucune notification système n’a été mise en place, le sujet ne l’imposant pas.

---

## 6. Navigation et cycle de vie SwiftUI

La navigation repose sur `NavigationStack` et est principalement pilotée par l’état de l’application.  
Les transitions entre vues sont déclenchées par des changements d’état plutôt que par une navigation impérative.

Le chargement des données est effectué via des modificateurs `.task`, et les traitements en cours sont arrêtés lorsque les vues disparaissent, afin d’éviter des appels réseau inutiles.

---

## 7. Organisation du projet

Le projet est organisé de manière à séparer clairement les différentes responsabilités :

- `Views` : interfaces SwiftUI
- `ViewModels` : logique applicative et état
- `Models` : structures de données
- `Repositories` : communication avec l’API
- `Network` : client HTTP et gestion du token

Cette organisation permet à un nouveau développeur de comprendre rapidement la structure du projet et de localiser facilement les parties importantes du code.

---

## 8. Limites et améliorations possibles

Certaines améliorations pourraient être envisagées :
- ajouter des tests unitaires sur les ViewModels ;
- améliorer la gestion des erreurs réseau côté interface ;
- ajouter des animations plus avancées lors des combats.

Ces points n’ont pas été implémentés par manque de temps, mais la structure actuelle du projet permettrait de les ajouter facilement.

---

## 9. Conclusion

Ce projet a permis de mettre en pratique le développement d’un client mobile consommant une API REST, tout en respectant des contraintes fortes liées à la logique serveur.  
L’architecture mise en place permet une évolution progressive de l’application et une reprise du projet facilitée par un autre développeur.

