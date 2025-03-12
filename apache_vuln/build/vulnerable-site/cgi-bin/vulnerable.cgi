#!/bin/bash

# Vulnerabilidad: No validar contenido ni codificar salida
echo "Content-type: text/html"
echo ""

# Vulnerabilidad XSS: Reflejar parámetros sin saneamiento
cat << EOF
<html>
<head><title>Comandos Bash Peligroso</title></head>
<body>
<h1>Ejecutor de Comandos Inseguro</h1>
<form>
<input type="text" name="cmd">
<input type="submit" value="Ejecutar">
</form>
EOF

# Vulnerabilidad Command Injection: Ejecución directa en shell
if [ -n "$QUERY_STRING" ]; then
    # Parseo básico e inseguro de parámetros
    cmd=$(echo "$QUERY_STRING" | sed -n 's/.*cmd=\([^&]*\).*/\1/p' | sed 's/+/ /g' | sed 's/%\(..\)/\\x\1/g' | xargs -0 printf "%b")
    
    # Vulnerabilidad XSS: Mostrar entrada no saneada
    echo "<p>Comando recibido: $cmd</p>"
    echo "<h3>Resultado:</h3><pre>"
    
    # Vulnerabilidad crítica de inyección de comandos
    eval "$cmd 2>&1"
    
    echo "</pre>"
fi

echo "</body></html>"