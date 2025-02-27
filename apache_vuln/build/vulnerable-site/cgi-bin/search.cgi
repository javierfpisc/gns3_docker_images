#!/bin/bash
echo "Content-type: text/html"
echo ""

echo "<html><head><title>Resultados de Búsqueda</title></head><body>"
echo "<h1>Resultados para: $QUERY_STRING</h1>"

# Vulnerabilidad XSS Reflejado
QUERY=$(echo "$QUERY_STRING" | sed 's/q=//')
echo "<p>${QUERY//%/\\x}</p>"  # Descodificación insegura

# Vulnerabilidad Command Injection (probando con ;whoami)
echo "<pre>"
grep -ri "$QUERY" /var/www/html/vulnerable-site/
echo "</pre>"

echo "</body></html>"