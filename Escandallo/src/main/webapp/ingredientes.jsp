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

<h3>Listado de Ingredientes</h3> 
<a href="registrarIngrediente.jsp">Crear nuevo ingrediente</a> 
<a href="creacionIngredientesFichero.jsp">Crear ingredientes por fichero</a> 

<% 
Connection conn = null; 
PreparedStatement pstmt = null; 
ResultSet rs = null; 

try { 
    Class.forName("org.sqlite.JDBC"); 
    conn = DriverManager.getConnection("jdbc:sqlite:" + application.getRealPath("/bases_de_datos/escandallo.db")); 

    String sql = "SELECT nombre, unidad_medida, costo_por_unidad FROM ingredientes"; 
    pstmt = conn.prepareStatement(sql); 
    rs = pstmt.executeQuery(); 

    boolean hayDatos = false; 

    out.println("<div>"); 
    out.println("<table>");
	//columnas
    out.println("<tr><th>Nombre</th><th>Unidad de Medida</th><th>Costo por Unidad</th><th>Eliminar</th></tr>"); 

    while (rs.next()) { 
        hayDatos = true; 
        out.println("<tr>"); 
        out.println("<td>" + rs.getString("nombre") + "</td>"); 
        out.println("<td>" + rs.getString("unidad_medida") + "</td>"); 
        out.println("<td>" + rs.getDouble("costo_por_unidad") + "</td>"); 
        out.println("<td>");
        
     	// Formulario para eliminar
        out.println("<form action='eliminarIngrediente.jsp' method='post'>"); 
        out.println("<input type='hidden' name='nombre' value='" + rs.getString("nombre") + "'>"); // Envía el nombre del ingrediente
        out.println("<input type='submit' value='Eliminar'>");
        out.println("</form>");
        out.println("</td>");
        out.println("</tr>"); 
    } 

    out.println("</table>"); 
    out.println("</div>"); 

    if (!hayDatos) { 
        out.println("<p>No hay ingredientes disponibles en la base de datos.</p>"); 
    } 

} catch (Exception e) { 
    out.println("<p>Error al listar ingredientes: " + e.getMessage() + "</p>"); 
} finally { 
    if (rs != null) try { rs.close(); } catch (SQLException ignore) {} 
    if (pstmt != null) try { pstmt.close(); } catch (SQLException ignore) {} 
    if (conn != null) try { conn.close(); } catch (SQLException ignore) {} 
} 
%> 

</body> 
<jsp:include page="pie.jsp" flush="true" />
</html>