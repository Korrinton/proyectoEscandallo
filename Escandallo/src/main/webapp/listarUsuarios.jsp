<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="clases.*" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Listado de Usuarios</title>
</head>
<body>
	<h2>Usuarios Registrados</h2>
    <table border="1">
        <tr>
            <th>Usuario</th>
            <th>Contraseña</th>
            <th>Nombre</th>
            <th>Apellidos</th>
        </tr>
        <%
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;

            try {
            	Class.forName("org.sqlite.JDBC");  // DRIVER CORRECTO PARA SQLITE                            
            	conn = DriverManager.getConnection("jdbc:sqlite:" + application.getRealPath("/bases_de_datos/gestion_costos.db"));

                String sql = "SELECT usuario, contrasena, nombre, apellidos FROM usuarios";
                pstmt = conn.prepareStatement(sql);
                rs = pstmt.executeQuery();

                while (rs.next()) {
        %>
        <tr>
            <td><%= rs.getString("usuario") %></td>
            <td><%= rs.getString("contrasena") %></td>
            <td><%= rs.getString("nombre") %></td>
            <td><%= rs.getString("apellidos") %></td>
        </tr>
        <%
                }
            } catch (Exception e) {
                out.println("<p>Error: " + e.getMessage() + "</p>");
            } finally {
                if (rs != null) try { rs.close(); } catch (SQLException ignore) {}
                if (pstmt != null) try { pstmt.close(); } catch (SQLException ignore) {}
                if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
            }
        %>
    </table>

</body>
</html>