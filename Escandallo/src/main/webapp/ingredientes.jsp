
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

<% 
    String nombre = request.getParameter("nombre");
    String unidadMedida = request.getParameter("unidadMedida");
    String costoPorUnidad = request.getParameter("costeUnidad");

    if (nombre != null && unidadMedida != null && costoPorUnidad != null) {
        double costo = Double.parseDouble(costoPorUnidad);
        Ingrediente ingrediente = new Ingrediente(nombre, unidadMedida, costo);
        

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver"); // Cambiar la base de datos
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/tu_base_de_datos", "usuario", "contraseña");

            String sql = "INSERT INTO ingredientes (nombre, unidad_medida, costo_por_unidad) VALUES (?, ?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, ingrediente.getNombre());
            pstmt.setString(2, ingrediente.getUnidadMedida());
            pstmt.setDouble(3, ingrediente.getCostoPorUnidad());
            pstmt.executeUpdate();

            out.println("<p>Ingrediente añadido con éxito: " + ingrediente.toString() + "</p>");

        } catch (Exception e) {
            out.println("<p>Error: " + e.getMessage() + "</p>");
        } finally {
            if (pstmt != null) try { pstmt.close(); } catch (SQLException ignore) {}
            if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
        }
    }
%>

<form action="ingredientes.jsp" class="formulario" method="post">
    <label for="nombre">Nombre:</label>
    <input type="text" id="name" name="name" required>
    
    <label for="unidadMedida">Unidad de Medida:</label>
    <input type="text" id="unit_of_measure" name="unit_of_measure" required>
    
    <label for="costeUnidad">Costo por Unidad:</label>
    <input type="number" id="cost_per_unit" name="cost_per_unit" step="0.01" required>
    
    <button type="submit">Guardar Ingrediente</button>
</form>

</body>
<jsp:include page="pie.jsp" flush="true" />
</html>