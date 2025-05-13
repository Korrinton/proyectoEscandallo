package clases;

import java.sql.*;
import java.util.ArrayList;

/**
 * Clase que representa un escandallo de un producto
 */
public class Escandallo {
    private int id;
    private String nombre;
    private double numeroPorciones;
    private String imagenPath;
    private ArrayList<Ingrediente> ingredientes;
    private Double costeTotal;
    
    /**
     * Constructor por defecto
     */
    public Escandallo() {
        this.id = 0;
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
        this.id = 0;
        this.nombre = nombre;
        this.numeroPorciones = numeroPorciones;
        this.imagenPath = "";
        this.ingredientes = new ArrayList<>();
    }
    
    // Getters y setters
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
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
        this.costeTotal=costeTotal+(costeTotal*.21)/this.numeroPorciones;     
    }

    public void removeIngrediente(int index) {
        if (index >= 0 && index < this.ingredientes.size()) {
            this.ingredientes.remove(index);
        }
        setCosteTotal();
    }
    
    //guardar el escandallo en la base de datos
    public boolean guardar() {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        boolean resultado = false;
        
        try {
            Class.forName("org.sqlite.JDBC");
            String dbURL = "jdbc:sqlite:escandallo.db";
            conn = DriverManager.getConnection(dbURL);
            conn.setAutoCommit(false);
            
            // Insertar en tabla escandallos
            String sql = "INSERT INTO escandallos (nombre, numero_porciones, imagen_path) VALUES (?, ?, ?)";
            pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            pstmt.setString(1, this.nombre);
            pstmt.setDouble(2, this.numeroPorciones);
            pstmt.setString(3, this.imagenPath);
            pstmt.executeUpdate();
            
            // Obtener el ID generado
            rs = pstmt.getGeneratedKeys();
            if (rs.next()) {
                this.id = rs.getInt(1);
            } else {
                throw new SQLException("No se pudo obtener el ID del escandallo");
            }
            
            // Insertar ingredientes
            sql = "INSERT INTO escandallo_ingredientes (ingrediente_nombre, cantidad, unidad,precio) VALUES (?, ?, ?, ?)";
            pstmt = conn.prepareStatement(sql);
            
            for (Ingrediente ingrediente : this.ingredientes) {
                pstmt.setString(1, ingrediente.getNombre());
                pstmt.setDouble(2, ingrediente.getCantidad());
                pstmt.setString(3, ingrediente.getUnidad());
                pstmt.setDouble(4, ingrediente.getPrecio());
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
    public static Escandallo cargar(int id) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        Escandallo escandallo = null;
        
        try {
            Class.forName("org.sqlite.JDBC");
            String dbURL = "jdbc:sqlite:escandallo.db";
            conn = DriverManager.getConnection(dbURL);
            
            // Cargar datos del escandallo
            String sql = "SELECT * FROM escandallos";
            pstmt = conn.prepareStatement(sql);
            
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                escandallo = new Escandallo();
                escandallo.setNombre(rs.getString("nombre"));
                escandallo.setNumeroPorciones(rs.getDouble("numero_porciones"));
                escandallo.setImagenPath(rs.getString("imagen_path"));
                
                // Cargar ingredientes
                pstmt.close();
                rs.close();
                
                sql = "SELECT * FROM escandallo_ingredientes WHERE nombre = ?";
                pstmt = conn.prepareStatement(sql);
               
                rs = pstmt.executeQuery();
                
                while (rs.next()) {
                    Ingrediente ingrediente = new Ingrediente();
                    ingrediente.setNombre(rs.getString("ingrediente_nombre"));
                    ingrediente.setCantidad(rs.getDouble("cantidad"));
                    ingrediente.setUnidad(rs.getString("unidad"));
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
    public static ArrayList<Escandallo> obtenerTodos() {
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        ArrayList<Escandallo> escandallos = new ArrayList<>();
        
        try {
            Class.forName("org.sqlite.JDBC");
            String dbURL = "jdbc:sqlite:escandallo.db";
            conn = DriverManager.getConnection(dbURL);
            
            // Obtener todos los escandallos
            String sql = "SELECT * FROM escandallos";
            stmt = conn.createStatement();
            rs = stmt.executeQuery(sql);
            
            while (rs.next()) {
                Escandallo escandallo = new Escandallo();
                escandallo.setId(rs.getInt("id"));
                escandallo.setNombre(rs.getString("nombre"));
                escandallo.setNumeroPorciones(rs.getDouble("numero_porciones"));
                escandallo.setImagenPath(rs.getString("imagen_path"));
                escandallos.add(escandallo);
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