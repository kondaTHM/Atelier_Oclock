#!/bin/bash

# ==============================================================================
# SCRIPT      : sysadmin-tools.sh
# VERSION     : 1.0
# AUTEUR      : konda (TechSecure Admin)
# DESCRIPTION : Menu interactif regroupant tous les outils d'administration
# ==============================================================================

# --- 1. CONFIGURATION ---
LOG_FILE="/var/log/sysadmin-tools.log"
VERSION="1.0"
AUTHOR="konda"

# Liste des scripts requis et leurs chemins
declare -A SCRIPTS=(
    ["1"]="backup.sh"
    ["2"]="monitor.sh"
    ["3"]="create-users.sh"
    ["4"]="cleanup.sh"
    ["5"]="check-services.sh"
)

# --- 2. VÉRIFICATIONS (Point 6.3) ---

# Vérifier si l'utilisateur est root (nécessaire pour la plupart des outils)
if [ "$EUID" -ne 0 ]; then
    echo "ERREUR : Veuillez lancer ce menu avec sudo."
    exit 1
fi

# Vérifier que tous les scripts existent avant de commencer
for script in "${SCRIPTS[@]}"; do
    if [ ! -f "./$script" ]; then
        echo "ERREUR : Le script '$script' est manquant dans le répertoire actuel."
        exit 1
    fi
    chmod +x "./$script" # S'assurer qu'ils sont exécutables
done

# --- 3. FONCTIONS ---

log_action() {
    echo "$(date '+%Y-%m-%d %H:%M') | Utilisateur: $USER | Action: $1" >> "$LOG_FILE"
}

show_help() {
    clear
    echo "===================================================="
    echo "            DOCUMENTATION DES OUTILS"
    echo "===================================================="
    echo "1. Sauvegarde : Archive et compresse un dossier."
    echo "2. Monitoring : Affiche l'état CPU, RAM et Disque."
    echo "3. Utilisateurs : Création/Suppression via fichier CSV."
    echo "4. Nettoyage : Supprime les fichiers temporaires et logs."
    echo "5. Services : Surveille l'état de SSH, Apache, etc."
    echo "===================================================="
    read -p "Appuyez sur [Entrée] pour revenir au menu..."
}

# --- 4. MENU INTERACTIF (Point 6.1 & 6.2) ---

while true; do
    clear
    echo "===================================================="
    echo "       OUTILS D'ADMINISTRATION - v$VERSION"
    echo "       Auteur : $AUTHOR"
    echo "===================================================="
    echo " 1. Sauvegarde de répertoire"
    echo " 2. Monitoring système"
    echo " 3. Créer/Gérer des utilisateurs (CSV)"
    echo " 4. Nettoyage système"
    echo " 5. Vérifier les services"
    echo " 6. Aide (Documentation)"
    echo " 7. Quitter"
    echo "===================================================="
    read -p "Votre choix : " choix

    case $choix in
        1)
            read -p "Répertoire à sauvegarder : " dir
            ./backup.sh "$dir"
            log_action "Sauvegarde de $dir"
            ;;
        2)
            ./monitor.sh
            log_action "Consultation Monitoring"
            ;;
        3)
            read -p "Fichier CSV : " csv
            read -p "Mode suppression ? (y pour oui, Entrée pour création) : " mode
            if [ "$mode" == "y" ]; then
                ./create-users.sh "$csv" -d
                log_action "Suppression utilisateurs via $csv"
            else
                ./create-users.sh "$csv"
                log_action "Création utilisateurs via $csv"
            fi
            ;;
        4)
            read -p "Exécuter réellement le nettoyage ? (y/n) : " confirm
            if [ "$confirm" == "y" ]; then
                ./cleanup.sh --force
                log_action "Nettoyage système (FORCE)"
            else
                ./cleanup.sh
                log_action "Nettoyage système (Simulation)"
            fi
            ;;
        5)
            read -p "Mode monitoring en boucle (30s) ? (y/n) : " watch
            if [ "$watch" == "y" ]; then
                ./check-services.sh --watch
                log_action "Monitoring services (Watch)"
            else
                ./check-services.sh
                log_action "Vérification services (Unique)"
            fi
            ;;
        6)
            show_help
            ;;
        7)
            echo "Au revoir !"
            log_action "Fermeture du menu"
            exit 0
            ;;
        *)
            echo -e "\e[31mChoix invalide. Veuillez saisir un nombre entre 1 et 7.\e[0m"
            sleep 2
            ;;
    esac

    echo -e "\n-------------------------------------------"
    read -p "Travail terminé. Appuyez sur [Entrée] pour revenir au menu..."
done