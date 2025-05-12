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

	 <div class="contenedor">
        <h2>Bienvenido</h2>
        <p>Esta aplicación te permite gestionar los ingredientes, recetas y costos de tus productos finales.</p>
        <p>Utiliza los enlaces de navegación para acceder a las diferentes secciones.</p>
    </div>

    <jsp:include page="pie.jsp" flush="true" />

</body>
</html>