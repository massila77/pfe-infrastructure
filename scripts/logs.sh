#!/bin/bash
echo "============================================"
echo "  Journalisation de l'infrastructure PFE"
echo "============================================"

echo ""
echo ">>> LOGS NGINX (dernières 20 lignes)"
echo "--------------------------------------------"
docker logs pfe-nginx --tail=20

echo ""
echo ">>> LOGS WORDPRESS (dernières 20 lignes)"
echo "--------------------------------------------"
docker logs pfe-wordpress --tail=20

echo ""
echo ">>> LOGS MYSQL (dernières 20 lignes)"
echo "--------------------------------------------"
docker logs pfe-mysql --tail=20

echo ""
echo ">>> STATUT DE TOUS LES CONTENEURS"
echo "--------------------------------------------"
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

echo ""
echo ">>> UTILISATION DES RESSOURCES"
echo "--------------------------------------------"
docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}"

echo ""
echo "Journalisation terminée !"