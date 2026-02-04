#!/bin/bash

# --- 1. CONFIGURATION ---
SOURCE_DIR=$1
DEST_DIR="/backup"
LOG_FILE="/var/log/backup.log"
DATE_FORMAT=$(date "+%Y-%m-%d %H:%M:%S")
FILE_SUFFIX=$(date +%Y%m%d_%H%M%S)
BACKUP_NAME="backup_$FILE_SUFFIX.tar.gz"

# --- 2. SÉCURISATION ---
# Vérifier si l'utilisateur a passé un argument
if [ -z "$SOURCE_DIR" ]; then
    echo "Usage: $0 /chemin/du/dossier"
    exit 1
fi

# Vérifier si le dossier source existe
if [ ! -d "$SOURCE_DIR" ]; then
    echo "Erreur : Le dossier '$SOURCE_DIR' n'existe pas." | sudo tee -a $LOG_FILE
    exit 1
fi

# Créer le dossier de destination s'il n'existe pas
sudo mkdir -p $DEST_DIR

# --- 3. EXÉCUTION DE LA SAUVEGARDE ---
echo "--- Début de la sauvegarde [$DATE_FORMAT] ---"

sudo tar -czf "$DEST_DIR/$BACKUP_NAME" "$SOURCE_DIR" 2>/dev/null

# Vérifier si la commande précédente (tar) a réussi
if [ $? -eq 0 ]; then
    SIZE=$(du -h "$DEST_DIR/$BACKUP_NAME" | cut -f1)
    echo "[$DATE_FORMAT] SUCCÈS : $BACKUP_NAME créé ($SIZE)." | sudo tee -a $LOG_FILE
else
    echo "[$DATE_FORMAT] ÉCHEC : Erreur lors de la compression." | sudo tee -a $LOG_FILE
    exit 1
fi

# --- 4. ROTATION (Garder les 7 derniers) ---
echo "Nettoyage des anciennes sauvegardes..."
# On liste, on saute les 7 plus récents, on supprime le reste
OLD_BACKUPS=$(ls -1t $DEST_DIR/backup_*.tar.gz | tail -n +8)

if [ -n "$OLD_BACKUPS" ]; then
    echo "$OLD_BACKUPS" | xargs sudo rm -f
    COUNT=$(echo "$OLD_BACKUPS" | wc -l)
    echo "[$DATE_FORMAT] ROTATION : $COUNT ancienne(s) sauvegarde(s) supprimée(s)." | sudo tee -a $LOG_FILE
else
    echo "Aucune ancienne sauvegarde à supprimer."
fi

echo "--- Fin du script ---"