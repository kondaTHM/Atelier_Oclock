#!/bin/bash

# --- CONFIGURATION ET COULEURS ---
VERT='\e[32m'
JAUNE='\e[33m'
ROUGE='\e[31m'
RESET='\e[0m'

# --- COLLECTE DES DONNÉES ---
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d. -f1)
MEM_TOTAL=$(free -m | grep "Mem:" | awk '{print $2}')
MEM_USED=$(free -m | grep "Mem:" | awk '{print $3}')
MEM_PCT=$(( MEM_USED * 100 / MEM_TOTAL ))
DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')
NB_PROC=$(ps -e --no-headers | wc -l)
DATE_FULL=$(date '+%d/%m/%Y %H:%M:%S')

# --- FONCTIONS ---

# 1. État coloré pour l'affichage écran
get_status() {
    local val=$1
    if [ "$val" -ge 85 ]; then echo -e "${ROUGE}$val% [ALERTE]${RESET}"
    elif [ "$val" -ge 70 ]; then echo -e "${JAUNE}$val% [ATTENTION]${RESET}"
    else echo -e "${VERT}$val% [OK]${RESET}"
    fi
}

# 2. Génération des données brutes (pour le rapport)
generate_raw_data() {
    echo "=== RAPPORT TECHSECURE - $(hostname) ==="
    echo "DATE    : $DATE_FULL"
    echo "UPTIME  : $(uptime -p)"
    echo "-------------------------------------------"
    echo "CPU     : $CPU_USAGE%"
    echo "MÉMOIRE : $MEM_PCT% ($MEM_USED Mo / $MEM_TOTAL Mo)"
    echo "DISQUE  : $DISK_USAGE%"
    echo "PROCESSUS : $NB_PROC"
    echo "-------------------------------------------"
    echo -e "\nTOP 5 PROCESSUS (CPU) :"
    ps -eo pcpu,pmem,comm --sort=-pcpu | head -n 6
    echo -e "\nTOP 5 PROCESSUS (MÉMOIRE) :"
    ps -eo pmem,pcpu,comm --sort=-pmem | head -n 6
}

# --- LOGIQUE D'EXÉCUTION ---

if [ "$1" == "-r" ]; then
    # Mode Rapport : On écrit dans /var/log
    FILE="/var/log/monitor_$(date +%Y%m%d).txt"
    # On utilise { } pour grouper et rediriger vers le fichier
    generate_raw_data | sudo tee "$FILE" > /dev/null
    echo -e "${VERT}Succès : Rapport généré dans $FILE${RESET}"
else
    # Mode Affichage : On utilise les couleurs
    clear
    echo -e "=== MONITORING TECHSECURE - ${JAUNE}$(hostname)${RESET} ==="
    echo -e "DATE    : $DATE_FULL"
    echo -e "UPTIME  : $(uptime -p)"
    echo -e "-------------------------------------------"
    echo -e "CPU     : $(get_status "$CPU_USAGE")"
    echo -e "MÉMOIRE : $(get_status "$MEM_PCT")"
    echo -e "DISQUE  : $(get_status "$DISK_USAGE")"
    echo -e "PROC    : $NB_PROC en cours"
    echo -e "-------------------------------------------"
    
    echo -e "\nTOP 5 PROCESSUS (CPU) :"
    ps -eo pcpu,pmem,comm --sort=-pcpu | head -n 6
    
    echo -e "\n[Info] Utilisez './monitor.sh -r' pour créer un rapport log."
fi