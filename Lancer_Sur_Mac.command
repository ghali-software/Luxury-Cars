#!/bin/bash
set -u
cd "$(dirname "$0")"

HOST="opurent.localhost"
PORT=5678
MAX_PORT=5800

while lsof -tiTCP:"$PORT" -sTCP:LISTEN >/dev/null 2>&1; do
  PORT=$((PORT + 1))
  if [ "$PORT" -gt "$MAX_PORT" ]; then
    echo "Aucun port libre entre 5678 et $MAX_PORT."
    read -r -p "Appuyez sur Entree pour quitter..."
    exit 1
  fi
done

echo "------------------------------------------------"
echo "   DEMARRAGE DU SERVEUR LOCAL"
echo "------------------------------------------------"
echo "Port local choisi: $PORT"

(sleep 1 && open "http://$HOST:$PORT") >/dev/null 2>&1 &

if command -v python3 >/dev/null 2>&1; then
  python3 -m http.server "$PORT"
elif command -v python >/dev/null 2>&1; then
  python -m http.server "$PORT"
elif command -v php >/dev/null 2>&1; then
  php -S 0.0.0.0:"$PORT"
else
  echo
  echo "Erreur: Python ou PHP est requis pour lancer le serveur local."
  read -r -p "Appuyez sur Entree pour quitter..."
fi
