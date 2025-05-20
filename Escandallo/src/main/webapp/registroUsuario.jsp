
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
<link rel="stylesheet" href="css/login.css">
<title>Registro de usuario</title>
</head>
<body>

	<div class="caja">
		<h2>Gestión de Usuarios</h2>

		<div class="añadirEscandallo">
			<h3>Añadir Nuevo Usuario</h3>
			<form id="registrarUsuarioFormulario" method="post" action="registroUsuario.jsp">
				<label for="usuario">Usuario:</label> 
				<input type="text"id="usuario" name="usuario" required>
				<br> 
				<label for="contrasena">Contraseña:</label> 
				<input type="password" id="contrasena" name="contrasena" required>
				<br>
				<label for="nombre">Nombre:</label>
				<input type="text" id="nombre" name="nombre" required>
				<br> 
				<label for="apellidos">Apellidos:</label>
				<input type="text" id="apellidos" name="apellidos" required>
				<br>
				<button type="submit">Guardar Usuario</button>
				
			</form>		
		</div>
		<div class="options">
			<a href="index.jsp">Volver a login</a>
			<br>
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
	//Aqui se crean 3 variables, para guardar la conexión, la consulta y para guardar resultados de la consulta
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;

	// Recoger datos del formulario escritos por el usuario
	String usuario = request.getParameter("usuario");
	String contrasena = request.getParameter("contrasena");
	String nombre = request.getParameter("nombre");
	String apellidos = request.getParameter("apellidos");

	//Compruebo que no hay campos nulos
	if (usuario != null && contrasena != null && nombre != null && apellidos != null) {
		try {
			//Intento la conexion a la bbdd
			Class.forName("org.sqlite.JDBC");// DRIVER CORRECTO PARA SQLITE                            
			conn = DriverManager
			.getConnection("jdbc:sqlite:" + application.getRealPath("/bases_de_datos/escandallo.db"));

			// Comprobar si el usuario ya existe, ejecuto y guardo resultado
			String verificarUsuario = "SELECT COUNT(*) FROM usuarios WHERE usuario = ?";
			pstmt = conn.prepareStatement(verificarUsuario);
			pstmt.setString(1, usuario);
			rs = pstmt.executeQuery();

			//Si el resultado es > 0 = usuario existe y lo notifico
			if (rs.next() && rs.getInt(1) > 0) {
		out.println("<p class='mensaje error'>El usuario '" + usuario + "' ya existe. Por favor, elige otro.</p>");
			//Si no existe, cifro y guardo al usuario nuevo
			} else {
				
				String contrasenaCifrada = cifrarSHA256(contrasena);
		//Preparo la consulta para guardar al nuevo usuario
		String sql = "INSERT INTO usuarios (usuario, contrasena, nombre, apellidos) VALUES (?, ?, ?, ?)";
		pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, usuario);
		pstmt.setString(2, contrasenaCifrada);
		pstmt.setString(3, nombre);
		pstmt.setString(4, apellidos);
		pstmt.executeUpdate();
	
		//muestro un mensaje de usuario añadido con éxito 
		out.println("<p class='mensaje exito'>usuario añadido con éxito: Usuario: " + usuario + "</p>");
		
			}
		//Si ocurre algún error lo muestro
		} catch (Exception e) {
			out.println("<p>Error: " + e.getMessage() + "</p>");
		//Cierro conexion y consulta
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

<jsp:include page="pie.jsp" flush="false" />

</body>
</html>