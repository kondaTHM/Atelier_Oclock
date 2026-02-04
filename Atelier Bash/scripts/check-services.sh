#!/bin/bash

# ==============================================================================
# SCRIPT : check-services.sh
# DESCRIPTION : Surveillance en temps réel des services critiques
# USAGE : ./check-services.sh [--restart] [--watch]
# ==============================================================================

# --- 1. CONFIGURATION ---
CONF_FILE="services.conf"
JSON_REPORT="services_report.json"
RESTART_AUTO=false
WATCH_MODE=false

# Vérification de l'existence du fichier de configuration (5.1)
if [ ! -f "$CONF_FILE" ]; then
    echo "Erreur : Fichier $CONF_FILE introuvable. Veuillez lister vos services dedans."
    exit 1
fi

# Gestion des options (Arguments)
for arg in "$@"; do
    case $arg in
        --restart) RESTART_AUTO=true ;;
        --watch) WATCH_MODE=true ;;
    esac
done

# --- 2. FONCTION DE SURVEILLANCE ---
check_status() {
    local active_count=0
    local inactive_count=0
    local json_output="[\n"
    local first=true

    # Nettoyage de l'écran pour un affichage propre en mode monitoring (5.4)
    [ "$WATCH_MODE" = true ] && clear

    echo "=== RAPPORT DE SURVEILLANCE TECHSECURE ($(date '+%H:%M:%S')) ==="
    echo "---------------------------------------------------------"

    while read -r service || [ -n "$service" ]; do
        # On ignore les lignes vides et les commentaires
        [[ -z "$service" || "$service" =~ ^# ]] && continue

        # Récupération de l'état (Point 5.2)
        status=$(systemctl is-active "$service" 2>/dev/null || echo "unknown")
        # Vérification si activé au démarrage (Point 5.3)
        enabled=$(systemctl is-enabled "$service" 2>/dev/null || echo "unknown")

        if [ "$status" == "active" ]; then
            echo -e "[\e[32m OK \e[0m] $service : Actif (Auto-start: $enabled)"
            ((active_count++))
        else
            echo -e "[\e[31mDOWN\e[0m] $service : INACTIF !"
            ((inactive_count++))
            
            # Alerte simulée (Point 5.3)
            echo ">> ALERTE : Le service critique $service est hors ligne !"

            # Tentative de réparation (Point 5.3)
            if [ "$RESTART_AUTO" = true ]; then
                echo ">> Tentative de redémarrage de $service..."
                sudo systemctl start "$service" 2>/dev/null
            fi
        fi

        # Construction propre du JSON (Point 5.3)
        if [ "$first" = true ]; then first=false; else json_output+=",\n"; fi
        json_output+="  { \"service\": \"$service\", \"status\": \"$status\", \"enabled\": \"$enabled\" }"

    done < "$CONF_FILE"

    # Sauvegarde du rapport JSON
    echo -e "${json_output}\n]" > "$JSON_REPORT"

    echo "---------------------------------------------------------"
    echo -e "RÉSUMÉ : \e[32m$active_count Actifs\e[0m | \e[31m$inactive_count Inactifs\e[0m"
}

# --- 3. LOGIQUE D'EXÉCUTION ---

if [ "$WATCH_MODE" = true ]; then
    # Gestion de la sortie propre avec Ctrl+C (Point 5.4)
    trap "echo -e '\n\nArrêt du monitoring.'; exit" INT
    echo "Monitoring en cours (Rafraîchissement toutes les 30s)..."
    while true; do
        check_status
        sleep 30
    done
else
    # Exécution unique
    check_status
    echo -e "\nRapport JSON généré : $JSON_REPORT"
fi