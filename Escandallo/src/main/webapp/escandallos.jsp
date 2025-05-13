<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="clases.*" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="css/ingredientes.css">
    <title>Escandallo de Ingredientes/Producto Final</title>
</head>
<body>

    <jsp:include page="cabecera.jsp" flush="true" />

    <div class="container">
        <h2>Gestión de Escandallos</h2>
       
        <div class="añadirEscandallo">
            <h3>Añadir Nuevo Escandallo</h3>
            <form id="añadirEscandalloFormulario" method="post" action="escandallo.jsp">
                <label for="producto">Nombre del Producto:</label>
                <input type="text" id="producto" name="producto" required>
				<br>
                <label for="numeroPorciones">Numero de porciones:</label>
                <input type="number" id="numeroPorciones" name="numeroPorciones" step="0.01" required>
				
				<br>
                <label for="ingredientes">Seleccionar Ingredientes:</label>
                <select id="ingredientes" name="ingredientes" multiple>
                
                
                <label for="imagen">Selecciona una imagen:</label>            
				<input type="file" id="imagen" name="imagen" accept="image/*">
                    <%
                        Connection conn = null;
                        Statement stmt = null;

                        try {
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/tu_base_de_datos", "usuario", "contraseña");
                            stmt = conn.createStatement();
                            String sql = "SELECT * FROM ingredientes";
                            ResultSet rs = stmt.executeQuery(sql);

                            while (rs.next()) {
                                int id = rs.getInt("id");
                                String nombre = rs.getString("nombre");
                                out.println("<option value='" + id + "'>" + nombre + "</option>");
                            }
                            rs.close();
                        } catch (Exception e) {
                            out.println("<p>Error: " + e.getMessage() + "</p>");
                        } finally {
                            if (stmt != null) try { stmt.close(); } catch (SQLException ignore) {}
                            if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
                        }
                    %>
                </select>
				<br>
                <button type="submit">Guardar Escandallo</button>
              
            </form>
              </div>
        </div>


    <jsp:include page="pie.jsp" flush="true" />

</body>
</html>