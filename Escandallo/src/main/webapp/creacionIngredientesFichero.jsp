<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.io.*, java.sql.*" %>

<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="css/ingredientes.css">
    <title>Añadir Ingredientes</title>
</head>

  
<body>
<a href="ingredientes.jsp">Volver al listado</a>

<%
String rutaEntrada = application.getRealPath("/ficheros/ingredientes.txt");
String rutaSalida = application.getRealPath("/ficheros/resultado.txt");

File archivoEntrada = new File(rutaEntrada);
File archivoSalida = new File(rutaSalida);

BufferedReader br = null;
BufferedWriter bw = null;

Connection conn = null;
PreparedStatement pstmtVerificar = null;
PreparedStatement pstmtInsertar = null;


try {
    Class.forName("org.sqlite.JDBC");
    conn = DriverManager.getConnection("jdbc:sqlite:" + application.getRealPath("/bases_de_datos/escandallo.db"));

    br = new BufferedReader(new FileReader(archivoEntrada));
    bw = new BufferedWriter(new FileWriter(archivoSalida));

    String linea;
    while ((linea = br.readLine()) != null) {
        String[] partes = linea.split(";"); //decido poner ";" identico al fichero
        if (partes.length == 3) {
            String nombre = partes[0].trim();
            String unidad = partes[1].trim();
            String costoStr = partes[2].trim();
            double costo;

            try {
                costo = Double.parseDouble(costoStr);
                
                // Verificar si ya existe
                String sqlVerificar = "SELECT COUNT(*) FROM ingredientes WHERE nombre = ?";
                pstmtVerificar = conn.prepareStatement(sqlVerificar);
                pstmtVerificar.setString(1, nombre);
                ResultSet rs = pstmtVerificar.executeQuery();
                boolean existe = false;
                if(rs.next() && rs.getInt(1) > 0){
                	existe=true;
                }
                rs.close();
                pstmtVerificar.close();

                if (!existe) {
                    String sqlInsertar = "INSERT INTO ingredientes (nombre, unidad_medida, costo_por_unidad) VALUES (?, ?, ?)";
                    pstmtInsertar = conn.prepareStatement(sqlInsertar);
                    pstmtInsertar.setString(1, nombre);
                    pstmtInsertar.setString(2, unidad);
                    pstmtInsertar.setDouble(3, costo);
                    pstmtInsertar.executeUpdate();
                    pstmtInsertar.close();

                    bw.write("Añadido: " + nombre + "\n");
                } else {
                    bw.write("Ya existe: " + nombre + "\n");
                }
            } catch (NumberFormatException e) {
                bw.write("Error numérico en: " + linea + "\n");
            }
        } else {
            bw.write("Formato incorrecto: " + linea + "\n");
        }
    }

    out.println("<p>proceso de registros finalizados. Verifica los resultados en: ficheros/resultado.txt</p>");

} catch (Exception e) {
    out.println("<p>Error durante el proceso de registro: " + e.getMessage() + "</p>");
} finally {
    if (br != null) try { br.close(); } catch (IOException ignore) {}
    if (bw != null) try { bw.close(); } catch (IOException ignore) {}
    if (pstmtVerificar != null) try { pstmtVerificar.close(); } catch (SQLException ignore) {}
    if (pstmtInsertar != null) try { pstmtInsertar.close(); } catch (SQLException ignore) {}
    if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
}
%>
    <p><a href="ficheros/resultado.txt" download>Descargar resultado.txt</a></p>
 </body>
</html>