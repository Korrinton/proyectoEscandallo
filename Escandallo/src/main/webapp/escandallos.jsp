<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="clases.*" %>
<%@ page import="java.io.File" %>
<%@ page import="java.nio.file.Paths" %>

<%
// Crear el directorio de imágenes si no existe
String uploadPath = application.getRealPath("/imagenes");
File uploadDir = new File(uploadPath);
if (!uploadDir.exists()) {
    uploadDir.mkdir();
}


// Procesar el formulario si se envió
if ("POST".equalsIgnoreCase(request.getMethod())) {
    try {
        // Datos básicos del escandallo
        String nombreProducto = request.getParameter("producto");
        double numeroPorciones = Double.parseDouble(request.getParameter("numeroPorciones"));
		
        // Crear nuevo escandallo
        Escandallo nuevoEscandallo = new Escandallo(nombreProducto, numeroPorciones);
        nuevoEscandallo.setServletContext(application);

        // Procesar imagen si se ha subido
        try {
            jakarta.servlet.http.Part imagenPart = request.getPart("imagen");
            if (imagenPart != null && imagenPart.getSize() > 0) {
                String fileName = Paths.get(imagenPart.getSubmittedFileName()).getFileName().toString();

                // Generar un nombre único para evitar colisiones
                String uniqueFileName = System.currentTimeMillis() + "_" + fileName;
                String filePath = uploadPath + File.separator + uniqueFileName;

                // Guardar el archivo físicamente
                imagenPart.write(filePath);

                // Guardar la ruta relativa en el escandallo
                nuevoEscandallo.setImagenPath("/imagenes/" + uniqueFileName);
            }
        } catch (Exception e) {
            // Si hay un error con la imagen, continuamos sin ella
            out.println("<div class='mensaje-error'>Error al procesar la imagen: " + e.getMessage() + "</div>");
        }
		
        // Procesar ingredientes
        String[] ingredientesNombres = request.getParameterValues("ingredienteNombre");
        String[] ingredientesCantidades = request.getParameterValues("ingredienteCantidad");
        String[] ingredientesPrecio = request.getParameterValues("ingredientePrecio");

        if (ingredientesNombres != null) {
            for (int i = 0; i < ingredientesNombres.length; i++) {
                if (ingredientesNombres[i] != null && !ingredientesNombres[i].trim().isEmpty()) {
                    String nombre = ingredientesNombres[i];
                    double cantidad = Double.parseDouble(ingredientesCantidades[i]);
                    double precio = Double.parseDouble(ingredientesPrecio[i]);

                    String unidad = "";
                    String[] parts = request.getParameterValues("ingredienteNombre")[i].split("'data-unidad='");
                    if (parts.length > 1) {
                        String[] unidadParts = parts[1].split("'");
                        if (unidadParts.length > 0) {
                            unidad = unidadParts[0];
                        }
                    }

                    Ingrediente ingrediente = new Ingrediente(nombre, cantidad, unidad, precio);
                    nuevoEscandallo.addIngrediente(ingrediente);
                }
            }
        }
	
        // Guardar en la base de datos
        boolean guardado = nuevoEscandallo.guardar();

        if (guardado) {
            out.println("<div class='mensaje-exito'>Escandallo guardado correctamente</div>");
        } else {
        	
            out.println("<div class='mensaje-error'>Error al guardar el escandallo </div>");
        }
    } catch (Exception e) {
        out.println("<div class='mensaje-error'>Error: " + e.getMessage() + "</div>");
        e.printStackTrace();
    }
}
%>

<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="css/ingredientes.css">
<title>Escandallo de Ingredientes/Producto Final</title>
<script src="js/escandallos.js"></script>
</head>
<body>

<jsp:include page="cabecera.jsp" flush="true" />

<div class="container">
    <h2>Gestión de Escandallos</h2>

    <div class="añadirEscandallo">
        <h3>Añadir Nuevo Escandallo</h3>
        <form id="añadirEscandalloFormulario" method="post" action="escandallos.jsp" enctype="multipart/form-data">
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
                            <th>Precio</th>
                            <th>Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>
                                <select name="ingredienteNombre" required onchange="actualizarPrecioFila(this)">
                                    <option value="" data-precio="0" data-unidad="">-- Seleccione un ingrediente --</option>
                                    <%
                                    Class.forName("org.sqlite.JDBC");
                                    
                                    String dbPath = application.getRealPath("/bases_de_datos/escandallo.db");
                                    String dbURL = "jdbc:sqlite:" + dbPath;
                                    Connection conn = DriverManager.getConnection(dbURL);                                  
                                    Statement stmt= conn.createStatement();
                               
                                    try { 
 
 										String sql = "SELECT nombre, unidad_medida, costo_por_unidad FROM ingredientes";
										ResultSet rs = stmt.executeQuery(sql);

                                        while (rs.next()) {
                                  			String nombreIngrediente = rs.getString("nombre");
                                            String unidadMedidaIngrediente = rs.getString("unidad_medida");
                                            double precioIngrediente = rs.getDouble("costo_por_unidad");
                                            out.println("<option value='" + nombreIngrediente + "' data-precio='" + precioIngrediente + "' data-unidad='" + unidadMedidaIngrediente + "'>" + nombreIngrediente + "</option>");
                                        }
                                        rs.close();
                                    } catch (Exception e) {
                                        out.println("<option value='' data-precio='0' data-unidad=''>Error: " + e.getMessage() + "</option>");
                                    } finally {
                                        if (stmt != null) try { stmt.close(); } catch (SQLException ignore) {}
                                        if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
                                    }
                                    %>
                                </select>
                            </td>
                            <td>
                                <input type="number" name="ingredienteCantidad" step="0.01" min="0" required>
                                <span class="unidad-ingrediente"></span>
                            </td>
                            <td>
                                <span class="precio-ingrediente">0.00</span>
                                <input type="hidden" name="ingredientePrecio" class="precio-escondido" value="0.00">
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

</body>
</html>