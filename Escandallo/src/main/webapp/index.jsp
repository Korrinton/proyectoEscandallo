<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="clases.*" %>
<%@ page import="java.security.MessageDigest"%>
<%@ page import="java.security.NoSuchAlgorithmException"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Login</title>
<link rel="stylesheet" href="css/login.css">

</head>
<body>
<video autoplay loop muted playsinline style="position: fixed; top: 0; left: 0; min-width: 100%; min-height: 100%; z-index: -1;">
  <source src="img/cocina.mp4" type="video/mp4">
  <source src="img/cocina.mp4" type="video/webm">
   Tu navegador no soporta la reproducción de video.
</video>
	<div class="login-container">
	
        <div class="logo">
            <img src="img/logo.jpg" alt="Logo de Cocina">
        </div>
        <h2>Acceso</h2>
    <form method="post" action="index.jsp">
        <label for="usuario">Usuario:</label>
        <input type="text" id="usuario" name="usuario" required>
        <br>

        <label for="contrasena">Contraseña:</label>
        <input type="password" id="contrasena" name="contrasena" required>
        <br>

        <button type="submit">Iniciar sesión</button>
        
   	 </form>
   	 <div class="options">
   	 	<a href="registroUsuario.jsp">Crear Nuevo Usuario</a>
   	 </div>
    </div>
    <%!public String cifrarSHA256(String contrasena) {
		try {
			MessageDigest md = MessageDigest.getInstance("SHA-256");
			byte[] hash = md.digest(contrasena.getBytes("UTF-8"));
			StringBuilder hexString = new StringBuilder();
			for (byte b : hash) {
				String hex = Integer.toHexString(0xff & b);
				if (hex.length() == 1)
					hexString.append('0');
				hexString.append(hex);
			}
			return hexString.toString();
		} catch (Exception e) {
			return null;
		}
	}%>
    <%
    String usuario = request.getParameter("usuario");
    String contrasena = request.getParameter("contrasena");

    if (usuario != null && contrasena != null) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        // Cifrar contraseña ingresada
       

        try {
        	Class.forName("org.sqlite.JDBC");
        	//indicación para ver donde está buscando la base de datos
        	String dbPath = application.getRealPath("/bases_de_datos/escandallo.db");
        	
        	out.println("<p>Ruta de la base de datos: " + dbPath + "</p>");
        	String dbURL = "jdbc:sqlite:" + dbPath;
        	out.println("<p>URL de conexión: " + dbURL + "</p>");
        	
        	conn = DriverManager.getConnection(dbURL);
        	
			String contrasenaCifrada = cifrarSHA256(contrasena);

            String sql = "SELECT * FROM usuarios WHERE usuario = ? AND contrasena = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, usuario);
            pstmt.setString(2, contrasenaCifrada);
            rs = pstmt.executeQuery();
			
            if (rs.next()) {
            	
            	 session.setAttribute("usuario", usuario);
            	 response.sendRedirect("home.jsp");
                //out.println("<p style='color:green;'>Inicio de sesión exitoso. Bienvenido, " + rs.getString("nombre") + ".</p>");
            } else {
                out.println("<p style='color:red;'>Usuario o contraseña incorrectos.</p>");
            }
        } catch (Exception e) {
            out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException ignore) {}
            if (pstmt != null) try { pstmt.close(); } catch (SQLException ignore) {}
            if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
        }
    }
%>
<jsp:include page="pie.jsp" flush="true" />
</body>
</html>