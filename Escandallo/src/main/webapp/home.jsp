<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="css/home.css">
    <script src="js/home.js"></script>
    <title>Home</title>
</head>
<body>

    <jsp:include page="cabecera.jsp" flush="true" />

        <video autoplay loop muted playsinline style="position: fixed; top: 0; left: 0; min-width: 100%; min-height: 100%; z-index: -1;">
  			<source src="img/loginCocina.mp4" type="video/mp4">
  			<source src="img/loginCocina.mp4" type="video/webm">
  			
			</video>
	<div class="caja">
	<%
    String nombreUsuario = null;

    // Verificar si la sesión existe y si el atributo "usuario" está presente.
    if (session != null && session.getAttribute("usuario") != null) {
        // Obtener el valor del atributo "usuario" (asumiendo que así lo guardaste).
        nombreUsuario = (String) session.getAttribute("usuario");
    }
%>        
        <% if (nombreUsuario != null) { %>
           <h2>Bienvenido <%= nombreUsuario %></h2>
        <% } %>
        
        <p>Esta aplicación te permite gestionar los ingredientes, recetas y costos de tus productos finales.</p>
        <p>Utiliza los enlaces de navegación para acceder a las diferentes secciones.</p>
    </div>

    <jsp:include page="pie.jsp" flush="true" />

</body>
</html>