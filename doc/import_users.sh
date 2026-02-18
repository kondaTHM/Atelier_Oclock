#!/bin/bash
# Nettoyage du fichier au cas ou
sed -i 's/\r//' utilisateurs.csv

while IFS=, read -r user_id display_name email password groups quota; do
    [ "$user_id" = "user_id" ] && continue
    
    echo "Import : $user_id"
    
    # ÉTAPE CRUCIALE : On met le mot de passe dans la variable attendue
    export OC_PASS="$password"
    
    # Création de l'utilisateur avec la variable exportée
    sudo -E nextcloud.occ user:add --password-from-env --display-name="$display_name" "$user_id"
    
    # Ajout au groupe
    sudo nextcloud.occ group:add "$groups"
    sudo nextcloud.occ group:adduser "$groups" "$user_id"
    
    # Réglage du quota
    sudo nextcloud.occ user:setting "$user_id" files quota "$quota"
    
    # On vide la variable par sécurité
    unset OC_PASS
    
done < utilisateurs.csv