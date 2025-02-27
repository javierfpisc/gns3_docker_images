#!/bin/bash
echo "Content-type: text/html"
echo ""

echo "<html><body>"
echo "<h1>Información del Sistema</h1>"

# Vulnerabilidad grave de command injection
if [[ "$QUERY_STRING" =~ "cmd=" ]]; then
    CMD=$(echo "$QUERY_STRING" | cut -d= -f2)
    echo "<pre>$(eval $CMD)</pre>"
fi

echo "<form method='GET'>"
echo "Comando a ejecutar: <input type='text' name='cmd'>"
echo "<input type='submit' value='Ejecutar'>"
echo "</form>"
echo "</body></html>"