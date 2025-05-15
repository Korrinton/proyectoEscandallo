<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="clases.Escandallo" %>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Lista de Escandallos</title>
    <link rel="stylesheet" href="css/estilos_listar.css"> </head>
<body>

    <jsp:include page="cabecera.jsp" flush="true" />

    <div class="container">
        <h2>Lista de Escandallos</h2>

        <%
            // Obtener la lista de todos los escandallos desde la base de datos
            ArrayList<Escandallo> listaDeEscandallos = Escandallo.obtenerTodos(application);

            // Verificar si hay escandallos para mostrar
            if (listaDeEscandallos != null && !listaDeEscandallos.isEmpty()) {
        %>
                <table class="tabla-escandallos">
                    <thead>
                        <tr>
                            <th>Nombre del Producto</th>
                            <th>Número de Porciones</th>
                            <th>Imagen</th>
                            <th>Acciones</th> </tr>
                    </thead>
                    <tbody>
                        <%
                            // Iterar sobre la lista de escandallos y mostrar cada uno en una fila de la tabla
                            for (Escandallo escandallo : listaDeEscandallos) {
                        %>
                                <tr>
                                    <td><%= escandallo.getNombre() %></td>
                                    <td><%= escandallo.getNumeroPorciones() %></td>
                                    <td>
                                        <% if (escandallo.getImagenPath() != null && !escandallo.getImagenPath().isEmpty()) { %>
                                            <img src="<%= request.getContextPath() + escandallo.getImagenPath() %>" alt="Imagen de <%= escandallo.getNombre() %>" width="50">
                                        <% } else { %>
                                            Sin imagen
                                        <% } %>
                                    </td>
                                    <td>
                                        <a href="#">Ver Detalles</a>
                                        </td>
                                </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
        <%
            } else {
        %>
                <p>No se han encontrado escandallos.</p>
        <%
            }
        %>

    </div>

    <jsp:include page="pie.jsp" flush="true" />

</body>
</html>