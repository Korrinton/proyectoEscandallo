<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="clases.*" %>

<%
// Procesar el formulario si se envió
if ("POST".equalsIgnoreCase(request.getMethod())) {
    String nombreProducto = request.getParameter("producto");
    String numPorcionesStr = request.getParameter("numeroPorciones");
    String[] ingredientesNombres = request.getParameterValues("ingredienteNombre");
    String[] ingredientesCantidades = request.getParameterValues("ingredienteCantidad");
    String[] ingredientesUnidades = request.getParameterValues("ingredienteUnidad");
    String[] ingredientesPrecio =request.getParameterValues("ingredientesPrecio");
    
    
    if (nombreProducto != null && numPorcionesStr != null && 
        ingredientesNombres != null && ingredientesCantidades != null && ingredientesUnidades != null) {
        
        try {
            double numeroPorciones = Double.parseDouble(numPorcionesStr);
            
            // Crear un nuevo escandallo
            Escandallo nuevoEscandallo = new Escandallo();
            nuevoEscandallo.setNombre(nombreProducto);
            nuevoEscandallo.setNumeroPorciones(numeroPorciones);
            
            // Añadir ingredientes al escandallo
            for (int i = 0; i < ingredientesNombres.length; i++) {
                if (ingredientesNombres[i] != null && !ingredientesNombres[i].trim().isEmpty()) {
                    String nombre = ingredientesNombres[i];
                    double cantidad = Double.parseDouble(ingredientesCantidades[i]);
                    String unidad = ingredientesUnidades[i];
                    double precio = Double.parseDouble(ingredientesPrecio[i]);
                    
                    Ingrediente ingrediente = new Ingrediente(nombre, cantidad, unidad,precio);
                    
                    nuevoEscandallo.addIngrediente(ingrediente);
                }
            }
            
            // Guardar el escandallo en la base de datos
            boolean guardado = nuevoEscandallo.guardar();
            
            if (guardado) {
                out.println("<div class='mensaje-exito'>Escandallo guardado correctamente</div>");
            } else {
                out.println("<div class='mensaje-error'>Error al guardar el escandallo</div>");
            }
        } catch (Exception e) {
            out.println("<div class='mensaje-error'>Error: " + e.getMessage() + "</div>");
        }
    }
}
%>

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
        <form id="añadirEscandalloFormulario" method="post" action="escandallo.jsp" enctype="multipart/form-data">
            <label for="producto">Nombre del Producto:</label>
            <input type="text" id="producto" name="producto" required>
            <br>
            <label for="numeroPorciones">Numero de porciones:</label>
            <input type="number" id="numeroPorciones" name="numeroPorciones" step="0.01" required>
            <br>
            
            <div class="ingredientes-container">
                <h4>Ingredientes del Escandallo</h4>
                <table class="tabla-ingredientes" id="tablaIngredientes">
                    <thead>
                        <tr>
                            <th>Ingrediente</th>
                            <th>Cantidad</th>
                            <th>Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>
                                <select name="ingredienteNombre" required>
                                    <option value="">-- Seleccione un ingrediente --</option>
                                    <%
                                    Connection conn = null;
                                    Statement stmt = null;

                                    try {
                                        Class.forName("org.sqlite.JDBC");

                                        String dbPath = application.getRealPath("/bases_de_datos/escandallo.db");
                                    	String dbURL = "jdbc:sqlite:" + dbPath;
                                        conn = DriverManager.getConnection(dbURL);

                                        stmt = conn.createStatement();

                                        String sql = "SELECT * FROM ingredientes";
                                        ResultSet rs = stmt.executeQuery(sql);

                                        while (rs.next()) {
                                            String nombre = rs.getString("nombre");
                                            out.println("<option value='" + nombre + "'>" + nombre + "</option>");
                                        }
                                        rs.close();
                                    } catch (Exception e) {
                                        out.println("<option value=''>Error: " + e.getMessage() + "</option>");
                                    } finally {
                                        if (stmt != null) try { stmt.close(); } catch (SQLException ignore) {}
                                        if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
                                    }
                                    %>
                                </select>
                            </td>
                            <td>
                                <input type="number" name="ingredienteCantidad" step="0.01" min="0" required>
                            </td>
                            <td>
                                <button type="button" class="btn-eliminar" onclick="eliminarFila(this)">Eliminar</button>
                            </td>
                        </tr>
                    </tbody>
                </table>
                
                <button type="button" class="btn-agregar" onclick="agregarFila()">Añadir otro ingrediente</button>
            </div>
            
            <br>
            <label for="imagen">Selecciona una imagen:</label>
            <input type="file" id="imagen" name="imagen" accept="image/*">
            <br>
            <button type="submit" class="btn-guardar">Guardar Escandallo</button>
        </form>
    </div>
</div>

<jsp:include page="pie.jsp" flush="true" />

<script>
function agregarFila() {
    var tabla = document.getElementById("tablaIngredientes").getElementsByTagName('tbody')[0];
    var primeraFila = tabla.rows[0];
    var nuevaFila = primeraFila.cloneNode(true);
    
    // Limpiar los valores
    var selects = nuevaFila.getElementsByTagName('select');
    var inputs = nuevaFila.getElementsByTagName('input');
    
    for (var i = 0; i < selects.length; i++) {
        selects[i].selectedIndex = 0;
    }
    
    for (var i = 0; i < inputs.length; i++) {
        inputs[i].value = '';
    }
    
    tabla.appendChild(nuevaFila);
}

function eliminarFila(boton) {
    var fila = boton.parentNode.parentNode;
    var tabla = fila.parentNode;
    
    // No eliminar si es la única fila
    if (tabla.rows.length > 1) {
        tabla.removeChild(fila);
    } else {
        // Si es la única fila, solo limpiar los valores
        var selects = fila.getElementsByTagName('select');
        var inputs = fila.getElementsByTagName('input');
        
        for (var i = 0; i < selects.length; i++) {
            selects[i].selectedIndex = 0;
        }
        
        for (var i = 0; i < inputs.length; i++) {
            inputs[i].value = '';
        }
    }
}
</script>

</body>
</html>