# E06 - Atelier AD

## 1. GPO : Activation du Pavé Numérique (NumLock)
> Configuration via le Registre Windows pour forcer l'activation du pavé numérique dès l'écran de connexion (niveau Ordinateur).


## 2. Stratégie de Mot de Passe (Password Policy)
> Mise en place et vérification des exigences de complexité de mot de passe pour les étudiants.



> *Validation en vérifiant la mise en place de la polique de sécurité sur l'utilisateur B. Delphin.*

## 3. Déploiement de Fonds d'Écran par Promotion
> Configuration de GPO ciblées (Item-Level Targeting) pour appliquer un arrière-plan spécifique à chaque groupe de sécurité (Promo).

## 4. Restriction des Horaires de Connexion
> **Objectif :** Interdire l'accès aux promotions Zinc et Basilic de 17h00 à 08h00.
> **Mise en œuvre :** Configuration des plages horaires dans l'AD et GPO de déconnexion forcée en fin de plage.
> *Test de validation effectué sur le compte R. Beldent.*

## 5. Architecture de Partage et Permissions NTFS
> Création de l'arborescence et sécurisation des dossiers : suppression de l'accès "Tout le monde" et attribution des ACLs (droits) uniquement aux Groupes de Sécurité concernés.

## 6. Mappage Automatique de Lecteurs Réseau (GPO Drive Maps)
> Déploiement automatique des lecteurs partagés via GPO à la racine du domaine pour l'ensemble des promotions.

## 7. Gestion des Quotas de Stockage (FSRM)
> Mise en place de quotas stricts (30 Go) par dossier de promotion via le Gestionnaire de ressources du serveur de fichiers.

## 8. Filtrage de Fichiers (File Screening)
> Configuration d'un filtre FSRM pour bloquer l'enregistrement de fichiers vidéos (ex: .divx, .avi) sur le serveur.

## 9. Bonus : Déploiement Logiciel via GPO (Firefox)
> Installation silencieuse de Mozilla Firefox (MSI) via une GPO Ordinateur.
> *Point d'attention : Utilisation impérative du chemin réseau UNC (\\Server\Share) pour la source.*

## 10. Bonus Expert : Profils Itinérants & VSCode
> **Itinérance :** Configuration du partage de profils et GPO pour permettre l'accès administrateur aux dossiers utilisateurs.
> **Validation :** Test de la synchronisation des données (dossier Images) entre le poste client et le serveur.