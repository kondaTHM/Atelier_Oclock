# Rapport d'Installation et Configuration : Serveur Nextcloud sur Proxmox

## 1. Préparation de l'Infrastructure (Proxmox)
La solution est hébergée sur une machine virtuelle Ubuntu 24.04 LTS configurée avec les ressources suivantes :

* **OS :** Ubuntu 24.04 LTS
* **RAM :** 8 GB
* **CPU :** 4 vCPU
* **Disque :** 100 GB

![Configuration VM Proxmox](images/image-130.png)

### Configuration Réseau
L'adresse IP statique a été définie lors de l'installation du système :
* **Nom d'hôte :** `vmrb3`
* **Adresse IP :** `172.16.0.15/24`

![Configuration IP Statique](images/image-131.png)

---

## 2. Installation et Profil Serveur
Création du profil utilisateur système pour la gestion du serveur :
* **Utilisateur :** `XXXXXXXXXX`

![Création Profil](images/image-132.png)

### Initialisation de Nextcloud
L'interface de configuration est accessible via l'URL : `http://172.16.0.15`

![Page de connexion](images/image-133.png)

**Paramètres de la base de données :**
* **Utilisateur Admin Nextcloud :** `admin`
* **Utilisateur BDD :** `NexcloudAbd`
* **Mot de passe BDD :** `XXXXXXXXXX`

> **Statut :** Installation terminée avec succès.
> ![Fin d'installation](images/image-134.png)

---

## 3. Gestion des Applications et Services

### Tableau des applications vérifiées

| Application | Rôle | Catégorie | Installation |
| :--- | :--- | :--- | :--- |
| **Nextcloud Talk** | Chat + Visioconférence | Communication | Par défaut |
| **Calendar** | Calendriers partagés | Organisation | Par défaut |
| **Contacts** | Carnet d'adresses | Organisation | Par défaut |
| **Deck** | Tableaux Kanban | Organisation | Réalisé |
| **OnlyOffice** | Suite bureautique collaborative | Bureautique | Réalisé |
| **Tasks** | Gestion de tâches | Organisation | Réalisé |
| **Community Document Server** | Gestion de documents | Bureautique | Réalisé |

**Vérification de ONLYOFFICE :** Le service est pleinement fonctionnel.
![Vérification OnlyOffice](images/image-135.png)

---

## 4. Gestion des Utilisateurs et Groupes

### Automatisation de la création
Création des groupes et de **15 utilisateurs** (Mot de passe : `rocknroll26!`).

* **Groupes :** ![Groupes](images/image-136.png)
* **Script d'importation :** Utilisation d'un fichier CSV et d'un script Bash.
    * [Fichier CSV des utilisateurs](doc/utilisateurs.csv)
    * [Script d'importation Shell](doc/import_users.sh)

![Exécution du script](images/image-151.png)

**Rendu final de l'annuaire :**
![Liste utilisateurs](images/image-139.png)


---

## 5. Collaboration et Fonctionnalités

### Arborescence et Partages
Mise en place des dossiers partagés par services.
![Arborescence](images/image-140.png)

### Communication (Talk)
Configuration des salons de discussion pour les équipes.
![Configuration Talk](images/image-141.png)

### Calendriers Partagés
Création d'événements tests récurrents :
* **Daily Standup Dev :** Lun-Ven, 9h30–9h45.
* **Rétrospective Sprint :** Vendredi (toutes les 2 semaines), 16h–17h.

![Calendrier](images/image-142.png)
![Détails événements](images/image-143.png)

### Gestion de projet (Deck)
Création du board Kanban pour le suivi de projet.
![Board Deck](images/image-144.png)

---

## 6. Sécurisation et Validation

### Sécurisation (Bonnes Pratiques)
* **Politique de mots de passe :** Renforcement de la sécurité des comptes. ![Sécurité](images/image-145.png)
* **Partages externes :** Configuration des accès sécurisés. ![Partage externe](images/image-146.png)

### Tests de Validation
1.  **Connexion Utilisateur :** Test réussi avec le compte `HANNAH PROOF`. ![Test Hannah](images/image-147.png)
2.  **Co-édition :** Test d'édition simultanée (Bob et Alice) sur ONLYOFFICE. ![Co-édition](images/image-148.png)
3.  **Visioconférence :** Validation du flux vidéo/audio via Talk. ![Visioconférence](images/image-149.png)

---

## 7. Récapitulatif des Identifiants

| Élément | Valeur |
| :--- | :--- |
| **IP de la VM** | `172.16.0.15` |
| **URL Nextcloud** | `http://172.16.0.15/` |
| **Admin Nextcloud** | `admin` |
| **Utilisateur BDD** | `NexcloudAbd` |
| **Nom de la BDD** | `nextcloud` |

## 8. Rendu Final

![alt text](images/image-150.png)