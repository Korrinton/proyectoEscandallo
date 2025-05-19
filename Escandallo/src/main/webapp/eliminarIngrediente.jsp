<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
Connection conn = null;
PreparedStatement pstmt = null;

try {
    Class.forName("org.sqlite.JDBC");
    conn = DriverManager.getConnection("jdbc:sqlite:" + application.getRealPath("/bases_de_datos/escandallo.db"));

    // Obtener el nombre del ingrediente a eliminar
    String nombre = request.getParameter("nombre");

    // Preparar la consulta SQL para eliminar el ingrediente
    String sql = "DELETE FROM ingredientes WHERE nombre = ?";
    pstmt = conn.prepareStatement(sql);
    pstmt.setString(1, nombre);

    // Ejecutar la consulta
    int filasEliminadas = pstmt.executeUpdate();

    if (filasEliminadas > 0) {
        out.println("<p>Ingrediente eliminado correctamente.</p>");
    } else {
        out.println("<p>No se pudo eliminar el ingrediente.  Verifique el nombre del ingrediente.</p>");
    }

} catch (Exception e) {
    out.println("<p>Error al eliminar el ingrediente: " + e.getMessage() + "</p>");
} finally {
    if (pstmt != null) {
        try {
            pstmt.close();
        } catch (SQLException ignore) {
        }
    }
    if (conn != null) {
        try {
            conn.close();
        } catch (SQLException ignore) {
        }
    }
    // Redirigir de vuelta a la página principal después de la eliminación
    response.setHeader("Refresh", "1; URL=ingredientes.jsp"); // Redirige después de 1 segundo
    // O mejor: response.sendRedirect("ingredientes.jsp");
}
%>
