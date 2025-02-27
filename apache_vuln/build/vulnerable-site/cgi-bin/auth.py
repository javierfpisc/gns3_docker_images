#!/usr/bin/env python3
import cgi
import cgitb
cgitb.enable()

print("Content-type: text/html\n\n")
print("<html><body>")

# Simulación de autenticación vulnerable
form = cgi.FieldStorage()
user = form.getvalue('user', '')
password = form.getvalue('pass', '')

# "Validación" insegura
if user == "admin" and password == "supersecret":
    print("<h1>Acceso concedido!</h1>")
    print("<p>Bienvenido administrador</p>")
else:
    print("<h1>Credenciales inválidas!</h1>")
    print(f"<p>Intento de login con: {user}:{password}</p>")  # XSS almacenado

print("</body></html>")