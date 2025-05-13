package clases;

import java.sql.*;
import java.util.ArrayList;

/**
 * Clase que representa un ingrediente en un escandallo
 */
public class Ingrediente {
    private String nombre;
    private double cantidad;
    private String unidad;
    

    public Ingrediente() {
        this.nombre = "";
        this.cantidad = 0.0;
        this.unidad = "";
    }
    

    public Ingrediente(String nombre, double cantidad, String unidad) {
        this.nombre = nombre;
        this.cantidad = cantidad;
        this.unidad = unidad;
    }
    
    // Getters y setters
    public String getNombre() {
        return nombre;
    }
    
    public void setNombre(String nombre) {
        this.nombre = nombre;
    }
    
    public double getCantidad() {
        return cantidad;
    }
    
    public void setCantidad(double cantidad) {
        this.cantidad = cantidad;
    }
    
    public String getUnidad() {
        return unidad;
    }
    
    public void setUnidad(String unidad) {
        this.unidad = unidad;
    }
    
    @Override
    public String toString() {
        return nombre + " - " + cantidad + " " + unidad;
    }
}