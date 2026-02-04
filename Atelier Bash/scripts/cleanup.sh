#!/bin/bash

# ==============================================================================
# SCRIPT : cleanup.sh
# DESCRIPTION : Nettoyage intelligent du système (tmp, logs, cache, corbeille)
# USAGE : sudo ./cleanup.sh [--force | -f] [jours_tmp] [jours_logs]
# ==============================================================================

# --- 1. CONFIGURATION & ARGUMENTS ---
LOG_FILE="/var/log/cleanup.log"
FORCE=false
DAYS_TMP=${2:-7}    # Valeur par défaut : 7 jours
DAYS_LOGS=${3:-30}  # Valeur par défaut : 30 jours

# Vérification de l'option --force ou -f
if [[ "$1" == "--force" ]] || [[ "$1" == "-f" ]]; then
    FORCE=true
fi

# --- RÉSUMÉ DES OPTIONS AU DÉMARRAGE ---
echo "=============================================================================="
echo " SCRIPT : cleanup.sh"
echo " DESCRIPTION : Nettoyage intelligent du système"
echo "------------------------------------------------------------------------------"
echo " PARAMÈTRES ACTUELS :"
echo "  - Mode d'exécution : $([ "$FORCE" = true ] && echo "RÉEL (FORCE)" || echo "SIMULATION (DRY-RUN)")"
echo "  - Âge fichiers /tmp  : $DAYS_TMP jours"
echo "  - Âge logs (.gz)     : $DAYS_LOGS jours"
echo "=============================================================================="
sleep 1

# --- 2. VÉRIFICATIONS DE SÉCURITÉ ---

# Vérification des droits root
if [ "$EUID" -ne 0 ]; then
    echo -e "\n\033[31mErreur : Ce script doit être exécuté avec sudo.\033[0m"
    exit 1
fi

# Demande de confirmation en mode FORCE (Point 4.2)
if [ "$FORCE" = true ]; then
    echo -e "\n\033[33mATTENTION : Le mode FORCE va supprimer des fichiers définitivement.\033[0m"
    read -p "Confirmez-vous le lancement du nettoyage ? (y/n) : " confirm < /dev/tty
    if [[ ! "$confirm" =~ ^[yY]$ ]]; then
        echo "Opération annulée par l'utilisateur."
        exit 0
    fi
fi

# --- 3. MESURE INITIALE ---
# On récupère l'espace utilisé sur la partition racine /
BEFORE=$(df / | awk 'NR==2 {print $3}')

# --- 4. FONCTION DE NETTOYAGE (Point 4.3) ---
clean_category() {
    local label=$1
    local find_cmd=$2
    local is_apt=$3

    echo -e "\n--- [ Catégorie : $label ] ---"
    
    if [ "$is_apt" = "true" ]; then
        if [ "$FORCE" = true ]; then
            apt-get clean
            echo "Succès : Cache APT vidé."
        else
            echo "[SIMULATION] La commande 'apt-get clean' serait lancée."
        fi
    else
        # Compter les fichiers concernés
        local count=$(eval "$find_cmd" | wc -l)
        echo "Fichiers trouvés : $count"

        if [ "$FORCE" = true ]; then
            eval "$find_cmd -delete"
            echo "Succès : $count fichiers supprimés."
        else
            echo "[SIMULATION] Liste des 5 premiers fichiers qui seraient supprimés :"
            eval "$find_cmd" | head -n 5
            [ "$count" -gt 5 ] && echo "... et $((count-5)) autres fichiers."
        fi
    fi
}

# --- 5. EXÉCUTION DU NETTOYAGE ---

echo -e "\n🚀 Lancement du nettoyage ($(date))"
echo "-------------------------------------------"
echo "Espace libre initial : $(df -h / | awk 'NR==2 {print $4}')"

# A. Nettoyage /tmp (Point 4.1)
clean_category "Temporaires /tmp (> $DAYS_TMP jours)" "find /tmp -type f -mtime +$DAYS_TMP"

# B. Nettoyage Logs compressés (Point 4.1)
clean_category "Logs compressés (> $DAYS_LOGS jours)" "find /var/log -name '*.gz' -mtime +$DAYS_LOGS"

# C. Vidage des corbeilles (Point 4.1)
clean_category "Corbeilles utilisateurs" "find /home/*/.local/share/Trash/files -type f"

# D. Cache APT (Point 4.1)
clean_category "Cache des paquets APT" "" "true"

# --- 6. BILAN ET LOGS (Point 4.3) ---

AFTER=$(df / | awk 'NR==2 {print $3}')
RECOVERED=$(( BEFORE - AFTER ))
RECOVERED_MB=$(( RECOVERED / 1024 ))

echo -e "\n==========================================="
echo "NETTOYAGE TERMINÉ"

if [ "$FORCE" = true ]; then
    echo "Espace total récupéré : $RECOVERED_MB Mo"
    # Enregistrement dans le log
    echo "$(date '+%Y-%m-%d %H:%M') | FORCE: $FORCE | Récupéré: ${RECOVERED_MB}Mo" >> "$LOG_FILE"
else
    echo "RÉSULTAT : Mode simulation terminé (aucun fichier supprimé)."
fi
echo "==========================================="