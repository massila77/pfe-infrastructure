#!/bin/bash
echo "============================================"
echo "  Déploiement de l'infrastructure PFE"
echo "============================================"

# Vérifier que Docker est lancé
if ! docker info > /dev/null 2>&1; then
    echo "ERREUR : Docker n'est pas lancé !"
    exit 1
fi

# Vérifier que le fichier .env existe
if [ ! -f ".env" ]; then
    echo "ERREUR : fichier .env manquant !"
    echo "Copie .env.example en .env et remplis les valeurs."
    exit 1
fi

echo "[1/3] Arrêt des anciens conteneurs..."
cd docker && docker compose down

echo "[2/3] Construction et démarrage des services..."
docker compose --env-file ../.env up -d

echo "[3/3] Vérification des services..."
sleep 5
docker compose ps

echo ""
echo "Déploiement terminé !"
echo "Accès : http://localhost:8080"
