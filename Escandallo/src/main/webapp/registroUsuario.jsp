
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="clases.*"%>
<!-- Esto es para cifrar la contraseña -->
<%@ page import="java.security.MessageDigest"%>
<%@ page import="java.security.NoSuchAlgorithmException"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="css/ingredientes.css">
<title>Registro de usuario</title>
</head>
<body>

	<div class="container">
		<h2>Gestión de Usuarios</h2>

		<div class="añadirEscandallo">
			<h3>Añadir Nuevo Usuario</h3>
			<form id="registrarUsuarioFormulario" method="post"
				action="registroUsuario.jsp">
				<label for="usuario">Usuario:</label> <input type="text"
					id="usuario" name="usuario" required> <br> <label
					for="contrasena">Contraseña:</label> <input type="password"
					id="contrasena" name="contrasena" required> <br> <label
					for="nombre">Nombre:</label> <input type="text" id="nombre"
					name="nombre" required> <br> <label for="apellidos">Apellidos:</label>
				<input type="text" id="apellidos" name="apellidos" required>

				<br>
				<button type="submit">Guardar Usuario</button>

			</form>
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
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;

	// Obtener los parámetros del formulario (suponiendo que los tienes)
	String usuario = request.getParameter("usuario");
	String contrasena = request.getParameter("contrasena");
	String nombre = request.getParameter("nombre");
	String apellidos = request.getParameter("apellidos");

	if (usuario != null && contrasena != null && nombre != null && apellidos != null) {
		try {

			Class.forName("org.sqlite.JDBC"); // DRIVER CORRECTO PARA SQLITE                            
			conn = DriverManager
			.getConnection("jdbc:sqlite:" + application.getRealPath("/bases_de_datos/gestion_costos.db"));

			// Comprobar si el usuario ya existe
			String verificarUsuario = "SELECT COUNT(*) FROM usuarios WHERE usuario = ?";
			pstmt = conn.prepareStatement(verificarUsuario);
			pstmt.setString(1, usuario);
			rs = pstmt.executeQuery();

			if (rs.next() && rs.getInt(1) > 0) {
		out.println("<p>El usuario '" + usuario + "' ya existe. Por favor, elige otro.</p>");
			} else {
				
				String contrasenaCifrada = cifrarSHA256(contrasena);
		
		String sql = "INSERT INTO usuarios (usuario, contrasena, nombre, apellidos) VALUES (?, ?, ?, ?)";
		pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, usuario);
		pstmt.setString(2, contrasenaCifrada);
		pstmt.setString(3, nombre);
		pstmt.setString(4, apellidos);
		pstmt.executeUpdate();

		out.println("<p>usuario añadido con éxito: Usuario: " + usuario + "</p>");
		out.println("<p><a href='home.jsp'>Volver a home</a></p>");
		
			}

		} catch (Exception e) {
			out.println("<p>Error: " + e.getMessage() + "</p>");
		} finally {
			if (pstmt != null)
		try {
			pstmt.close();
		} catch (SQLException ignore) {
		}
			if (conn != null)
		try {
			conn.close();
		} catch (SQLException ignore) {
		}
		}
	}
	%>



</body>
</html>