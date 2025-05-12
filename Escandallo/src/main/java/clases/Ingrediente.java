package clases;

public class Ingrediente {
    private String nombre;
    private String unidadMedida;
    private double costoPorUnidad;

    // Constructor
    public Ingrediente(String nombre, String unidadMedida, double costoPorUnidad) {

        this.nombre = nombre;
        this.unidadMedida = unidadMedida;
        this.costoPorUnidad = costoPorUnidad;
    }

    // Getters y Setters
    
    public String getNombre() {
        return nombre;
    }

    public String getUnidadMedida() {
        return unidadMedida;
    }

    public double getCostoPorUnidad() {
        return costoPorUnidad;
    }

    @Override
	public String toString() {
		return "Ingrediente [ nombre=" + nombre + ", unidadMedida=" + unidadMedida + ", costoPorUnidad="
				+ costoPorUnidad + "]";
	}
}