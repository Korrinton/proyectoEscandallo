
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
 <%@page import="clases.*"%>
 
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="css/ingredientes.css">
    <title> Ingrediente</title>
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
    conn = DriverManager.getConnection("jdbc:sqlite:" + application.getRealPath("/bases_de_datos/gestion_costos.db"));

    String sql = "SELECT nombre_ingrediente, unidad_medida, costo_unidad FROM ingredientes";
    pstmt = conn.prepareStatement(sql);
    rs = pstmt.executeQuery();

    boolean hayDatos = false;

    out.println("<div style='max-height: 400px; overflow: auto; border: 1px solid #ccc;'>");
    out.println("<table border='1' style='width: 100%; border-collapse: collapse;'>");
    out.println("<tr><th>Nombre</th><th>Unidad de Medida</th><th>Costo por Unidad</th></tr>");

    while (rs.next()) {
        hayDatos = true;
        out.println("<tr>");
        out.println("<td>" + rs.getString("nombre_ingrediente") + "</td>");
        out.println("<td>" + rs.getString("unidad_medida") + "</td>");
        out.println("<td>" + rs.getDouble("costo_unidad") + "</td>");
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