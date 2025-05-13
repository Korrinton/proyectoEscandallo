
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
 <%@page import="clases.*"%>
 
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="css/ingredientes.css">
    <title>Añadir Ingrediente</title>
</head>

  <jsp:include page="cabecera.jsp" flush="true" />
<body>

<form action="ingredientes.jsp" class="formulario" method="post">
    <label for="nombre">Nombre:</label>
    <input type="text" id="nombre" name="nombre" required>
    
    <label for="unidad_medida">Seleccionar unidad</label>
    <select id="unidad_medida" name="unidad_medida" required>
        <option value="kg">Kilogramos (kg)</option>
        <option value="L">Litros (L)</option>
    </select>
    
    <label for="costo_por_unidad">Costo por Unidad:</label>
    <input type="number" id="costo_por_unidad" name="costo_por_unidad" step="0.01" required>
    
    <button type="submit">Guardar Ingrediente</button>
</form>

<%
    // Obtener los parámetros del formulario (suponiendo que los tienes)
    String nombre = request.getParameter("nombre");
    String unidadMedida = request.getParameter("unidad_medida");
    String costoStr = request.getParameter("costo_por_unidad");

    if (nombre != null && unidadMedida != null && costoStr != null && !nombre.isEmpty() && !unidadMedida.isEmpty() && !costoStr.isEmpty()) {
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {

            // URL de conexión para SQLite
            String url = "jdbc:sqlite:bases_de_datos/escandallo.db";

            // Establecer la conexión
            conn = DriverManager.getConnection(url);
			
            String sql = "INSERT INTO ingredientes (nombre, unidad_medida, costo_por_unidad) VALUES (?, ?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, nombre);
            pstmt.setString(2, unidadMedida);
            pstmt.setDouble(3, Double.parseDouble(costoStr));
            pstmt.executeUpdate();

            out.println("<p>Ingrediente añadido con éxito: Nombre: " + nombre + ", Unidad: " + unidadMedida + ", Costo: " + costoStr + "</p>");

        } catch (SQLException e) {
            out.println("<p>Error de SQL: " + e.getMessage() + "</p>");
        } catch (NumberFormatException e) {
            out.println("<p>Error de formato numérico al convertir el costo.</p>");
        } catch (Exception e) {
            out.println("<p>Error general: " + e.getMessage() + "</p>");
        } finally {
            if (pstmt != null) try { pstmt.close(); } catch (SQLException ignore) {}
            if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
        }
    } else if (request.getMethod().equalsIgnoreCase("POST")) {
        out.println("<p>Por favor, completa todos los campos del formulario.</p>");
    }
%>

</body>
<jsp:include page="pie.jsp" flush="true" />
</html>