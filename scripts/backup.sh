#!/bin/bash
echo "============================================"
echo "  Sauvegarde de l'infrastructure PFE"
echo "============================================"

# Créer le dossier de sauvegarde
BACKUP_DIR="../backups"
DATE=$(date +%Y%m%d_%H%M%S)
mkdir -p $BACKUP_DIR

echo "[1/3] Sauvegarde de la base de données MySQL..."
docker exec pfe-mysql mysqldump \
  -u root \
  -pRootPass123! \
  appdb > $BACKUP_DIR/mysql_backup_$DATE.sql

if [ $? -eq 0 ]; then
    echo "OK : Sauvegarde MySQL créée : mysql_backup_$DATE.sql"
else
    echo "ERREUR : Sauvegarde MySQL échouée"
fi

echo "[2/3] Sauvegarde de la configuration..."
cp ../docker/docker-compose.yml $BACKUP_DIR/docker-compose_$DATE.yml
cp ../config/nginx.conf $BACKUP_DIR/nginx_$DATE.conf
echo "OK : Fichiers de configuration sauvegardés"

echo "[3/3] Liste des sauvegardes disponibles..."
ls -lh $BACKUP_DIR/

echo ""
echo "Sauvegarde terminée ! Dossier : $BACKUP_DIR"