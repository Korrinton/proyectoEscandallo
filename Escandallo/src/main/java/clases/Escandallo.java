package clases;

import java.sql.*;
import java.util.ArrayList;
import jakarta.servlet.ServletContext;

/**
 * Clase que representa un escandallo de un producto
 */

public class Escandallo {
    private String nombre;
    private double numeroPorciones;
    private String imagenPath;
    private ArrayList<Ingrediente> ingredientes;
    private Double costeTotal;
    private ServletContext servletContext;
    private Double costePorPorciones;
    
    /**
     * Constructor por defecto
     */
    public Escandallo() {
        this.nombre = "";
        this.numeroPorciones = 0.0;
        this.imagenPath = "";
        this.ingredientes = new ArrayList<>();
    }

    /**
     * Constructor con parámetros
     * @param nombre Nombre del producto
     * @param numeroPorciones Número de porciones
     */
    public Escandallo(String nombre, double numeroPorciones) {
        this.nombre = nombre;
        this.numeroPorciones = numeroPorciones;
        this.imagenPath = "";
        this.ingredientes = new ArrayList<>();
    }

    // Getters y setters

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public double getNumeroPorciones() {
        return numeroPorciones;
    }

    public void setNumeroPorciones(double numeroPorciones) {
        this.numeroPorciones = numeroPorciones;
    }

    public String getImagenPath() {
        return imagenPath;
    }

    public void setImagenPath(String imagenPath) {
        this.imagenPath = imagenPath;
    }

    public ArrayList<Ingrediente> getIngredientes() {
        return ingredientes;
    }

    public void setIngredientes(ArrayList<Ingrediente> ingredientes) {
        this.ingredientes = ingredientes;
        setCosteTotal();
    }
    
    
    public Double getCostePorPorciones() {
    	costePorPorciones=this.costeTotal/this.numeroPorciones;

    	return costePorPorciones;
	}
    //formato para verlo en forma de euros
    public String getCostePorPorcionesFormateado() {
    	costePorPorciones=this.costeTotal/this.numeroPorciones;
    	String formateado = String.format("%.2f", costePorPorciones);
    	return formateado;
	}
    public String getCosteTotalFormateado() {
    	String formateado = String.format("%.2f", this.costeTotal);
    	return formateado;
	}
	public void addIngrediente(Ingrediente ingrediente) {
        this.ingredientes.add(ingrediente);
        setCosteTotal();
    }
    //cada vez que se modifique el
    public void setCosteTotal() {
        Double costeTotal=0.0;
        for(Ingrediente ingrediente:this.ingredientes) {

            costeTotal+=ingrediente.getCantidad()*ingrediente.getPrecio();
        }
        this.costeTotal=costeTotal+(costeTotal*.21); // Coste total con IVA (sin dividir por porciones aquí)
    }

    public Double getCosteTotal() {
        
    	return costeTotal;
    }

    public void removeIngrediente(int index) {
        if (index >= 0 && index < this.ingredientes.size()) {
            this.ingredientes.remove(index);
        }
        setCosteTotal();
    }

    public void setServletContext(ServletContext servletContext) {
        this.servletContext = servletContext;
    }

    private String getDatabasePath() {
        String dbPath = "";
        if (servletContext != null) {
            dbPath = servletContext.getRealPath("/bases_de_datos/escandallo.db");
        } else {
            dbPath = "escandallo.db";
        }
        System.out.println("Ruta de la base de datos: " + dbPath);
        return dbPath;
    }
    //guardar el escandallo en la base de datos
    public boolean guardar() {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        boolean resultado = false;

        try {
            Class.forName("org.sqlite.JDBC");
            String dbPath = getDatabasePath();
            String dbURL = "jdbc:sqlite:" + dbPath;
            
            
            conn = DriverManager.getConnection(dbURL);
            conn.setAutoCommit(false);

            // Insertar en tabla escandallos
            String sql = "INSERT INTO escandallos (nombre_escandallo, numero_porciones, costo_total, coste_porciones, imagen_path) VALUES (?, ?, ?, ?, ?)";
            pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            pstmt.setString(1, this.nombre);
            pstmt.setDouble(2, this.numeroPorciones);
            pstmt.setDouble(3, this.costeTotal);
            pstmt.setDouble(4, this.costeTotal / this.numeroPorciones);
            pstmt.setString(5, this.imagenPath);
            pstmt.executeUpdate();
            
            // Insertar ingredientes
            sql = "INSERT INTO escandallo_ingredientes (nombre_escandallo, nombre_ingrediente, cantidad, unidad_medida, precio) VALUES (?, ?, ?, ?, ?)";
            pstmt = conn.prepareStatement(sql);

            for (Ingrediente ingrediente : this.ingredientes) {
                pstmt.setString(1, this.nombre); // Usar el nombre del escandallo como clave foránea
                pstmt.setString(2, ingrediente.getNombre());
                pstmt.setDouble(3, ingrediente.getCantidad());
                pstmt.setString(4, ingrediente.getUnidad());
                pstmt.setDouble(5, ingrediente.getPrecio());
                pstmt.executeUpdate();
            }
            
            conn.commit();
            resultado = true;
        } catch (Exception e) {
            try {
                if (conn != null) {
                    conn.rollback();
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        return resultado;
    }

    //mostrar el escandallo
    public static Escandallo cargar(String nombreEscandallo, ServletContext servletContext) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        Escandallo escandallo = null;

        try {
            Class.forName("org.sqlite.JDBC");
            String dbPath = (servletContext != null) ? servletContext.getRealPath("/bases_de_datos/escandallo.db") : "ruta/por/defecto/escandallo.db";
            String dbURL = "jdbc:sqlite:" + dbPath;
            conn = DriverManager.getConnection(dbURL);

            // Cargar datos del escandallo
            String sql = "SELECT nombre_escandallo, numero_porciones, costo_total, imagen_path FROM escandallos WHERE nombre_escandallo = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, nombreEscandallo);

            rs = pstmt.executeQuery();

            if (rs.next()) {
                escandallo = new Escandallo(rs.getString("nombre_escandallo"), rs.getDouble("numero_porciones"));
                escandallo.setImagenPath(rs.getString("imagen_path"));
                escandallo.costeTotal = rs.getDouble("costo_total");

                // Cargar ingredientes
                pstmt.close();
                rs.close();

                sql = "SELECT ei.nombre_ingrediente, ei.cantidad, ei.unidad_medida, ei.precio " +
                      "FROM escandallo_ingredientes ei " +
                      "WHERE ei.nombre_escandallo = ?";
                
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, escandallo.getNombre());
                rs = pstmt.executeQuery();

                while (rs.next()) {
                    Ingrediente ingrediente = new Ingrediente(
                            rs.getString("nombre_ingrediente"),
                            rs.getDouble("cantidad"),
                            rs.getString("unidad_medida"),
                            rs.getDouble("precio")
                    );
                    escandallo.addIngrediente(ingrediente);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        return escandallo;
    }

    //para ver todos los escandallos
    public static ArrayList<Escandallo> obtenerTodos(ServletContext servletContext) {
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        ArrayList<Escandallo> escandallos = new ArrayList<>();

        try {
            Class.forName("org.sqlite.JDBC");
            String dbPath = (servletContext != null) ? servletContext.getRealPath("/bases_de_datos/escandallo.db") : "bases_de_datos/escandallo.db";
            String dbURL = "jdbc:sqlite:" + dbPath;
            conn = DriverManager.getConnection(dbURL);

            // Obtener todos los nombres de los escandallos
            String sql = "SELECT nombre_escandallo FROM escandallos";
            stmt = conn.createStatement();
            rs = stmt.executeQuery(sql);

            while (rs.next()) {
                String nombreEscandallo = rs.getString("nombre_escandallo");
                // Cargar la información completa del escandallo, incluyendo los ingredientes
                Escandallo escandallo = cargar(nombreEscandallo, servletContext);
                if (escandallo != null) {
                    escandallos.add(escandallo);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        return escandallos;
    }
}