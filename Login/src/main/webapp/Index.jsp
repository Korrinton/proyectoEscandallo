<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Iniciar Sesión</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-image: url('img/tt.jpg'); /* Reemplaza con tu imagen de fondo */
            background-size: cover;
            background-position: center;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
        }

        .login-container {
            background-color: rgba(255, 255, 255, 0.9);
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
            width: 350px;
            text-align: center;
        }

        .logo {
            margin-bottom: 30px;
        }

        .logo img {
            max-width: 120px;
            height: auto;
        }

        h2 {
            color: #e44d26; /* Naranja/rojizo cocina */
            margin-bottom: 25px;
            font-size: 2.2em;
            font-weight: bold;
        }

        .form-group {
            margin-bottom: 20px;
            text-align: left;
        }

        label {
            display: block;
            margin-bottom: 8px;
            color: #555;
            font-size: 1em;
            font-weight: bold;
        }

        input[type="text"],
        input[type="password"] {
            width: calc(100% - 16px);
            padding: 12px;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 1.1em;
            box-sizing: border-box;
        }

        button {
            background-color: #28a745; /* Verde ingredientes frescos */
            color: #fff;
            padding: 14px 18px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 1.1em;
            font-weight: bold;
            transition: background-color 0.3s ease;
            margin-top: 20px;
            width: 100%;
        }

        button:hover {
            background-color: #1e7e34;
        }

        .error-message {
            margin-top: 20px;
            color: red;
            font-size: 0.9em;
        }

        .options {
            margin-top: 25px;
            font-size: 0.9em;
            color: #777;
        }

        .options a {
            color: #007bff;
            text-decoration: none;
            margin: 0 8px;
        }

        .options a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <div class="logo">
            <img src="img/logo.webp" alt="Logo de Cocina">
        </div>
        <h2>Acceso</h2>
        <form action="ProcesarLogin.jsp" method="post">
            <div class="form-group">
                <label for="usuario">Usuario:</label>
                <input type="text" id="usuario" name="usuario" required>
            </div>
            <div class="form-group">
                <label for="password">Contraseña:</label>
                <input type="password" id="password" name="password" required>
            </div>
            <button type="submit">Entrar a la Cocina</button>
        </form>
        <div class="error-message">
            <% if (request.getAttribute("error") != null) { %>
                <p><%= request.getAttribute("error") %></p>
            <% } %>
        </div>
        <div class="options">
            <a href="#">¿Olvidaste tu contraseña?</a>
            <span>|</span>
            <a href="#">Crear cuenta de chef</a>
        </div>
    </div>
</body>
</html>