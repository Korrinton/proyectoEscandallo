<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.nio.charset.StandardCharsets" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    Connection connection = null;
    Statement statement = null;
    ResultSet resultSet = null;
    String message = null;
    String filePath = application.getRealPath("/WEB-INF/ingredientes.txt");
    boolean fileSavedSuccessfully = false;

    try {
        Class.forName("org.sqlite.JDBC");
        String dbPath = application.getRealPath("/bases_de_datos/escandallo.db");
        String url = "jdbc:sqlite:" + dbPath;
        connection = DriverManager.getConnection(url);
        statement = connection.createStatement();
        String sql = "SELECT nombre, unidad_medida, costo_por_unidad FROM ingredientes";
        resultSet = statement.executeQuery(sql);

        StringBuilder ingredientsText = new StringBuilder();
        while (resultSet.next()) {
            String nombre = resultSet.getString("nombre");
            String medida = resultSet.getString("unidad_medida");
            int costo = resultSet.getInt("costo_por_unidad");
            ingredientsText.append("Nombre: ").append(nombre)
                           .append(", Medida: ").append(medida)
                           .append(", Costo por unidad: ").append(costo)
                           .append(System.lineSeparator());
        }

        // Crear y escribir el archivo usando BufferedWriter
        if (!ingredientsText.isEmpty()) {
            try (BufferedWriter writer = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(filePath), StandardCharsets.UTF_8))) {
                writer.write(ingredientsText.toString());
                fileSavedSuccessfully = true;
                message = "<p class='success'>Archivo ingredientes.txt creado exitosamente en WEB-INF.</p>";
            } catch (IOException e) {
                message = "<p class='error'>Error al escribir en el archivo: " + e.getMessage() + "</p>";
                e.printStackTrace();
            }
        } else {
            message = "<p class='warning'>No hay datos de ingredientes para guardar.</p>";
        }

        // Descargar el archivo si se creó correctamente
        
        if (fileSavedSuccessfully) {
            File downloadFile = new File(filePath);
            if (downloadFile.exists()) {
                response.setContentType("application/octet-stream");
                response.setHeader("Content-Disposition", "attachment; filename=ingredientes.txt");
                response.setContentLength((int) downloadFile.length());
                try (FileInputStream inStream = new FileInputStream(downloadFile);
                     OutputStream outStream = response.getOutputStream()) {
                    byte[] buffer = new byte[4096];
                    int bytesRead = -1;
                    while ((bytesRead = inStream.read(buffer)) != -1) {
                        outStream.write(buffer, 0, bytesRead);
                    }
                    // No es necesario el flush ni el close, los try-with-resources lo hacen automáticamente.
                } catch (IOException e) {
                    message = "<p class='error'>Error durante la descarga: " + e.getMessage() + "</p>";
                    e.printStackTrace(); // Importante para ver el error en el log del servidor
                }
            } else {
                message = "<p class='error'>Error: El archivo ingredientes.txt no se encuentra.</p>";
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

