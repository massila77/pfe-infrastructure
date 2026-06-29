#!/bin/bash
echo "============================================"
echo "  Validation de l'infrastructure PFE"
echo "============================================"

ERRORS=0

# Vérifier chaque conteneur
for service in pfe-mysql pfe-wordpress pfe-nginx; do
    STATUS=$(docker inspect -f '{{.State.Running}}' $service 2>/dev/null)
    if [ "$STATUS" = "true" ]; then
        echo "OK : $service est en cours d'exécution"
    else
        echo "ERREUR : $service n'est pas lancé"
        ERRORS=$((ERRORS+1))
    fi
done

# Vérifier que le site répond
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8080)
if [ "$HTTP_CODE" = "200" ] || [ "$HTTP_CODE" = "302" ]; then
    echo "OK : Le site répond (HTTP $HTTP_CODE)"
else
    echo "ERREUR : Le site ne répond pas (HTTP $HTTP_CODE)"
    ERRORS=$((ERRORS+1))
fi

echo ""
if [ $ERRORS -eq 0 ]; then
    echo "Tous les services sont opérationnels !"
else
    echo "$ERRORS erreur(s) détectée(s)"
fi
