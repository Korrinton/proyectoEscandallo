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
<a href="ingredientes.jsp">Volver al listado</a>

<form action="registrarIngrediente.jsp" class="formulario" method="post">
    <label for="nombre_ingrediente">Nombre:</label>
    <input type="text" id="nombre_ingrediente" name="nombre_ingrediente" required>
    
    <label for="unidad_medida">Seleccionar unidad</label>
    <select id="unidad_medida" name="unidad_medida" required>
        <option value="kg">Kilogramos (kg)</option>
        <option value="L">Litros (L)</option>
    </select>
    
    <label for="costo_unidad">Costo por Unidad:</label>
    <input type="number" id="costo_unidad" name="costo_unidad" step="0.01" required>
    
    <button type="submit">Guardar Ingrediente</button>
</form>

<%
    // Obtener los parámetros del formulario (suponiendo que los tienes)
    String nombreIngrediente = request.getParameter("nombre_ingrediente");
    String unidadMedida = request.getParameter("unidad_medida");
    String costoUnidad = request.getParameter("costo_unidad");

    if (nombreIngrediente != null && unidadMedida != null && costoUnidad != null && !nombreIngrediente.isEmpty() && !unidadMedida.isEmpty() && !costoUnidad.isEmpty()) {
        Connection conn = null;
        PreparedStatement pstmt = null;
    	ResultSet rs = null;

        try {

        	Class.forName("org.sqlite.JDBC"); // DRIVER CORRECTO PARA SQLITE                            
			conn = DriverManager
			.getConnection("jdbc:sqlite:" + application.getRealPath("/bases_de_datos/escandallo.db"));

			// Comprobar si el ingrediente ya existe
			String verificarIngrediente= "SELECT COUNT(*) FROM ingredientes WHERE nombre = ?";
			pstmt = conn.prepareStatement(verificarIngrediente);
			pstmt.setString(1, nombreIngrediente);
			rs = pstmt.executeQuery();
			
			
			if (rs.next() && rs.getInt(1) > 0) {
				out.println("<p>El ingrediente '" + nombreIngrediente + "' ya existe. Por favor, elige otro.</p>");
					} else {
						 String sql = "INSERT INTO ingredientes (nombre, unidad_medida, costo_por_unidad) VALUES (?, ?, ?)";
				            pstmt = conn.prepareStatement(sql);
				            pstmt.setString(1, nombreIngrediente);
				            pstmt.setString(2, unidadMedida);
				            pstmt.setDouble(3, Double.parseDouble(costoUnidad));
				            pstmt.executeUpdate();

				            out.println("<p>Ingrediente añadido con éxito: " + nombreIngrediente + "</p>");

					}
           
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