#!/bin/bash
echo "============================================"
echo "  Déploiement de l'infrastructure PFE"
echo "============================================"

if ! docker info > /dev/null 2>&1; then
    echo "ERREUR : Docker n'est pas lancé !"
    exit 1
fi

if [ ! -f ".env" ]; then
    echo "ERREUR : fichier .env manquant !"
    exit 1
fi

echo "[1/3] Arrêt des anciens conteneurs..."
cd docker && docker compose down

echo "[2/3] Démarrage des services..."
docker compose --env-file ../.env up -d

echo "[3/3] Vérification..."
sleep 5
docker compose ps

echo "Déploiement terminé ! Accès : http://localhost:8080"
