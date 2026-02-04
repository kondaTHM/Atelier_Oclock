#!/bin/bash

echo "=============================================================================="
echo "SCRIPT : create-users.sh"
echo " DESCRIPTION : Gestion complète des utilisateurs (Création et Suppression)"
echo " USAGE pour la création : sudo ./create-users.sh <fichier.csv> "
echo " USAGE pour la suppression : sudo ./create-users.sh <fichier.csv> [-d]"
echo "=============================================================================="

# --- 1. CONFIGURATION ---
CSV_FILE=$1
ACTION=$2
LOG_FILE="/var/log/user-creation.log"
RECAP_FILE="users_created.txt"

# --- 2. VÉRIFICATIONS DE SÉCURITÉ ---

if [ "$EUID" -ne 0 ]; then
    echo "ERREUR : Vous devez être root pour gérer les utilisateurs (utilisez sudo)."
    exit 1
fi

if [ -z "$CSV_FILE" ] || [ ! -f "$CSV_FILE" ]; then
    echo "ERREUR : Fichier CSV introuvable."
    echo "Usage : sudo $0 <fichier.csv> [-d]"
    exit 1
fi

# --- 3. LES FONCTIONS ---

# A. Fonction de CRÉATION
create_user() {
    local prenom=$1
    local nom=$2
    local dept=$3

    local login=$(echo "${prenom:0:1}${nom}" | tr '[:upper:]' '[:lower:]' | tr -d ' ')

    if id "$login" &>/dev/null; then
        echo "[!] L'utilisateur $login existe déjà. Ignoré."
        return
    fi

    if ! getent group "$dept" > /dev/null; then
        groupadd "$dept"
        echo "[+] Groupe $dept créé." >> "$LOG_FILE"
    fi

    local password=$(openssl rand -base64 12)

    if useradd -m -g "$dept" -c "$prenom $nom" "$login" &>/dev/null; then
        echo "$login:$password" | chpasswd
        
        # Optionnel : Forcer le changement de mot de passe à la première connexion
        # passwd -e "$login"

        echo "Date: $(date +%D) | Login: $login | Pass: $password | Dept: $dept" >> "$RECAP_FILE"
        echo "$(date '+%Y-%m-%d %H:%M') : SUCCÈS - Création de $login" >> "$LOG_FILE"
        echo "[OK] Utilisateur $login créé."
    else
        echo "[ERREUR] Échec de la création pour $login." >> "$LOG_FILE"
    fi
}

# B. Fonction de SUPPRESSION (Correction du bug de lecture clavier)
delete_user() {
    local prenom=$1
    local nom=$2
    local login=$(echo "${prenom:0:1}${nom}" | tr '[:upper:]' '[:lower:]' | tr -d ' ')

    if id "$login" &>/dev/null; then
        # On utilise < /dev/tty pour que le 'read' écoute le clavier et non le fichier CSV
        echo -n "Voulez-vous vraiment supprimer l'utilisateur $login ? (y/n) : "
        read confirm < /dev/tty
        
        if [ "$confirm" == "y" ] || [ "$confirm" == "Y" ]; then
            userdel -r "$login"
            echo "$(date '+%Y-%m-%d %H:%M') : SUPPRESSION - $login" >> "$LOG_FILE"
            echo "[-] Utilisateur $login supprimé."
        else
            echo "[#] Suppression annulée pour $login."
        fi
    else
        echo "[?] L'utilisateur $login n'existe pas."
    fi
}

# --- 4. LE MOTEUR DU SCRIPT ---

echo "--- Début du traitement du fichier $CSV_FILE ---"

tail -n +2 "$CSV_FILE" | while IFS="," read -r prenom nom dept fonction
do
    # Nettoyage des caractères Windows (\r)
    prenom=$(echo "$prenom" | tr -d '\r')
    nom=$(echo "$nom" | tr -d '\r')
    dept=$(echo "$dept" | tr -d '\r')

    if [ "$ACTION" == "-d" ]; then
        delete_user "$prenom" "$nom"
    else
        create_user "$prenom" "$nom" "$dept"
    fi
done

echo "Le fichier avec le recap ici : ./users_created.txt"
echo "Log des créations et suppressions : /var/log/user-creation.log"
echo "--- Opération terminée ---"