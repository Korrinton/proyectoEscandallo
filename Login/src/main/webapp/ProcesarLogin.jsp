<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>

<%
    String usuario = request.getParameter("usuario");
    String password = request.getParameter("password");

    String error = null;

    // Conexión a la base de datos (reemplaza con tus credenciales)
    String url = "jdbc:mysql://localhost:3306/usuarios";
    String dbUsuario = "webapp";
    String dbPassword = "admin123";
    Connection connection = null;
    PreparedStatement preparedStatement = null;
    ResultSet resultSet = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver"); // Driver de MySQL
        connection = DriverManager.getConnection(url, dbUsuario, dbPassword);

        String sql = "SELECT * FROM usuarios WHERE Nombre = ?";
        preparedStatement = connection.prepareStatement(sql);
        preparedStatement.setString(1, usuario);
        resultSet = preparedStatement.executeQuery();

        if (resultSet.next()) {
            String storedPassword = resultSet.getString("Contrasena"); // Asume que tienes una columna 'password_hash'

            // ¡IMPORTANTE! Debes usar una función segura para verificar la contraseña hasheada
            // Aquí solo se muestra una comparación directa (INSEGURA).
            if (password != null && password.equals(storedPassword)) {
                // Inicio de sesión exitoso
                session.setAttribute("usuario", usuario);
                response.sendRedirect("Main.jsp"); // Redirige a la página principal
            } else {
                error = "Contraseña incorrecta.";
            }
        } else {
            error = "Usuario no encontrado.";
        }

    } catch (ClassNotFoundException e) {
        error = "Error al cargar el driver de MySQL.";
        e.printStackTrace();
    } catch (SQLException e) {
        error = "Error al conectar o consultar la base de datos.";
        e.printStackTrace();
    } finally {
        try { if (resultSet != null) resultSet.close(); } catch (SQLException e) {}
        try { if (preparedStatement != null) preparedStatement.close(); } catch (SQLException e) {}
        try { if (connection != null) connection.close(); } catch (SQLException e) {}
    }

    if (error != null) {
        request.setAttribute("error", error);
        request.getRequestDispatcher("Index.jsp").forward(request, response);
    }
%>