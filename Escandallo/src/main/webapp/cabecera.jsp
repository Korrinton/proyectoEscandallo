<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%
    String usuario = (String) session.getAttribute("usuario");
%>
    <link rel="stylesheet" href="css/cabecera.css">
 <header>
        <h1>Escandallo de Ingredientes/Producto Final</h1>
        <p>Gestión de Costos y Rentabilidad de Productos</p>
    </header>
    <div class="links">
        <ul>
             <% if (usuario != null) { %>
                         <li><a href="home.jsp">Home</a></li>
             
            <li><a href="ingredientes.jsp">Ingredientes</a></li>
            <li><a href="listaEscandallos">Escandallos</a></li>
<!--             <li><a href="escandallos.jsp">Crear nuevo escandallo</a></li> -->
            <li><a href="logout.jsp">Cerrar sesión</a></li>
        <% } else { %>
            <li><a href="login.jsp">Iniciar sesión</a></li>
            <li><a href="registroUsuario.jsp">Registrar Usuario</a></li>
        <% } %>        </ul>
    </div>
    

