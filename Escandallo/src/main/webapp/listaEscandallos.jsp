<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="clases.*" %>
<%@ page import="java.util.ArrayList" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="css/escandallos.css">
    <title>Lista de Escandallos</title>
</head>
<body>

    <jsp:include page="cabecera.jsp" flush="true" />

    <div class="container">
        <h2>Lista de Escandallos</h2>
        <table id="escandallosTable">
            <thead>
                <tr>
                    <th>Producto</th>
                    <th>Costo Total</th>
                    <th>Ingredientes</th>
                </tr>
            </thead>
            <tbody>
                <%
                    Connection conn = null;
                    Statement stmt = null;

                    try {
                    	Class.forName("org.sqlite.JDBC");
                        
                        String dbURL = "jdbc:sqlite:escandallo.db"; 
                        conn = DriverManager.getConnection(dbURL);
                        
                        stmt = conn.createStatement();
                        
                        String sql = "SELECT * FROM escandallos";
                        ResultSet rs = stmt.executeQuery(sql);

                        while (rs.next()) {
                            String producto = rs.getString("producto");
                            double costoTotal = rs.getDouble("costo_total");
                            String ingredientesStr = rs.getString("ingredientes"); // Nombres de los ingredientes

                            out.println("<tr>");
                            out.println("<td>" + producto + "</td>");
                            out.println("<td>" + costoTotal + "</td>");
                            out.println("<td>" + ingredientesStr + "</td>");
                            out.println("</tr>");
                        }
                        rs.close();
                    } catch (Exception e) {
                        out.println("<p>Error: " + e.getMessage() + "</p>");
                    } finally {
                        if (stmt != null) try { stmt.close(); } catch (SQLException ignore) {}
                        if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
                    }
                %>
            </tbody>
        </table>
    </div>

    <jsp:include page="pie.jsp" flush="true" />

</body>
</html>