# E06 - Atelier AD

![alt text](images/image-49.png)

## 1. GPO : Activation du Pavé Numérique (NumLock)
> Configuration via le Registre Windows pour forcer l'activation du pavé numérique dès l'écran de connexion (niveau Ordinateur).

![alt text](images/image-50.png)

## 2. Stratégie de Mot de Passe (Password Policy)
> Mise en place et vérification des exigences de complexité de mot de passe pour les étudiants.

![alt text](images/image-51.png)


> *Validation en vérifiant la mise en place de la polique de sécurité sur l'utilisateur B. Delphin.*

![alt text](images/image-52.png)

## 3. Déploiement de Fonds d'Écran par Promotion
> Configuration de GPO ciblées pour définir un fond d’écran spécifique pour chaque promotion (Aldebaran,Andromède, Zinc, Basilic)

![alt text](images/image-53.png)

> Vérification sur les profils users sur le poste client :

![alt text](images/image-54.png)
![alt text](images/image-55.png)
![alt text](images/image-58.png)
![alt text](images/image-57.png)

## 4. Restriction des Horaires de Connexion
> **Objectif :** Interdire l'accès aux promotions Zinc et Basilic de 17h00 à 08h00.
> **Mise en œuvre :** Configuration des plages horaires dans l'AD

![alt text](images/image-59.png)
![alt text](images/image-60.png)

> *Test de validation effectué sur le compte R. Beldent.*

![alt text](images/image-61.png)

## 5. Architecture de Partage et Permissions NTFS
> Création de l'arborescence et sécurisation des dossiers : suppression de l'accès "Tout le monde" et attribution des ACLs uniquement aux Groupes de Sécurité concernés.

![alt text](images/image-62.png)
![alt text](images/image-63.png)


## 6. Mappage Automatique de Lecteurs Réseau (GPO Drive Maps)
> Déploiement automatique des lecteurs partagés via GPO à la racine du domaine pour l'ensemble des promotions.

![alt text](images/image-64.png)

> *Test de validation effectué sur le compte B.Delphin.*

![alt text](images/image-65.png)

## 7. Gestion des Quotas de Stockage (FSRM)
> Mise en place de quotas stricts (30 Go) par dossier de promotion via le Gestionnaire de ressources du serveur de fichiers.

![alt text](images/image-66.png)

> *Test de validation effectué sur le compte B.Delphin.*

![alt text](images/image-68.png)

## 8. Filtrage de Fichiers 
> Configuration d'un filtre FSRM pour bloquer les fichiers .divx uniquement

![alt text](images/image-69.png)

> *Test de validation effectué sur le compte B.Delphin.*

![alt text](images/image-70.png)


> *Vérification des logs.*

![alt text](images/image-71.png)


## 9. Bonus : Déploiement Logiciel via GPO (Firefox)
> Installation silencieuse de Mozilla Firefox (MSI) via une GPO Ordinateur.
> *Point d'attention : Utilisation impérative du chemin réseau UNC 

> création d'un partage application et téléchargement du fichier firefox.msi

![alt text](images/image-72.png)

> Création de la GPO 

![alt text](images/image-73.png)

> *Test de validation effectué sur le compte C.Seignant.*

![alt text](images/image-74.png)

## 10. Bonus Expert : Profils Itinérants & VSCode
> **Itinérance :** Configuration du partage de profils et GPO pour permettre l'accès administrateur aux dossiers utilisateurs.

> création d'un share profil itinéarant pour b.delphin

![alt text](images/image-75.png)

> **Validation :** Test de la synchronisation des données (dossier Images) entre le poste client et le serveur.

> le profil est bien présent sur le poste client 

![alt text](images/image-76.png)

>Enregistrement de fichier test dans le dossier images sur le pc en local 


![alt text](images/image-78.png)

>Les modifications apportées en local sont bien reportées sur le réseau et sauvegardés 

![alt text](images/image-77.png)

