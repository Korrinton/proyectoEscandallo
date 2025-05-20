<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.nio.charset.StandardCharsets" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lista y Guardar Ingredientes</title>
    
</head>
<body>

    <h1>Lista de Ingredientes</h1>
    <div>
        <%
            Connection connection = null;
            Statement statement = null;
            ResultSet resultSet = null;
            StringBuilder ingredientsText = new StringBuilder();
            String message = null; // Para mostrar mensajes de éxito/error

            try {
                Class.forName("org.sqlite.JDBC");
                String dbPath = application.getRealPath("/bases_de_datos/escandallo.db");
                String url = "jdbc:sqlite:" + dbPath;
                connection = DriverManager.getConnection(url);
                statement = connection.createStatement();
                String sql = "SELECT nombre, unidad_medida, costo_por_unidad FROM ingredientes";
                resultSet = statement.executeQuery(sql);

                while (resultSet.next()) {
                    String nombre = resultSet.getString("nombre");
                    String medida = resultSet.getString("unidad_medida");
                    int cantidad = resultSet.getInt("costo_por_unidad");
        %>
        <%
                    ingredientsText.append("Nombre: ").append(nombre)
                                   .append(", Medida: ").append(medida)
                                   .append(", costo: ").append(cantidad)
                                   .append(System.lineSeparator());
                }

                // Procesar la acción de guardar si se envió el formulario
                if (request.getMethod().equalsIgnoreCase("POST")) {
                    String ingredientesData = ingredientsText.toString();
                    if (!ingredientesData.isEmpty()) {
                        String filePath = application.getRealPath("/WEB-INF/ingredientes.txt");
                        try (BufferedWriter writer = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(filePath), StandardCharsets.UTF_8))) {
                            writer.write(ingredientesData);
                            message = "<p class='success'>Los datos de los ingredientes se han guardado en el archivo: " + filePath + "</p>";
                        } catch (IOException e) {
                            message = "<p class='error'>Error al escribir en el archivo: " + e.getMessage() + "</p>";
                            e.printStackTrace();
                        }
                    } else {
                        message = "<p class='warning'>No hay datos de ingredientes para guardar.</p>";
                    }
                }

            } catch (ClassNotFoundException e) {
                out.println("<p class='error'>Error: No se encontró el driver JDBC de SQLite. Asegúrate de que el JAR esté en WEB-INF/lib.<br>" + e.getMessage() + "</p>");
                e.printStackTrace();
            } catch (SQLException e) {
                out.println("<p class='error'>Error de SQL: " + e.getMessage() + "</p>");
                e.printStackTrace();
            } finally {
                try { if (resultSet != null) resultSet.close(); } catch (SQLException e) { e.printStackTrace(); }
                try { if (statement != null) statement.close(); } catch (SQLException e) { e.printStackTrace(); }
                try { if (connection != null) connection.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
        %>
    </div>

    <form method="post" action="<%= request.getRequestURI() %>">
        <button type="submit">Guardar Ingredientes en Archivo</button>
    </form>

    <% if (message != null) { %>
        <%= message %>
    <% } %>

</body>
</html>