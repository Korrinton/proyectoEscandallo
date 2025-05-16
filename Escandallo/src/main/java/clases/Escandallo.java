package clases;


import java.util.List;


public class Escandallo {
    private String NombreEscandallo;
    private double costoTotal;
    private List<Ingrediente> ingredientes; 
    private int porciones;
    private double costePorPorciones;
    private String usuario;

    
    

	public Escandallo(String producto, double costoTotal,int porciones, List<Ingrediente> ingredientes) {

        this.NombreEscandallo = producto;
        this.costoTotal = costoTotal;
        this.ingredientes = ingredientes;
        this.porciones=porciones;
        calcularCoste();
    }

    // Getters y Setters
   
    public String getProducto() {
        return NombreEscandallo;
    }

    public void setProducto(String producto) {
        this.NombreEscandallo = producto;
    }

    public double getCostoTotal() {
        return costoTotal;
    }

    public void setCostoTotal(double costoTotal) {
        this.costoTotal = costoTotal;
    }

    public List<Ingrediente> getIngredientes() {
        return ingredientes;
    }

    public void setIngredientes(List<Ingrediente> ingredientes) {
        this.ingredientes = ingredientes;
    }
    
    public double getCostePorPorciones() {
		return costePorPorciones;
	}

	public void setCostePorPorciones(double costePorPorciones) {
		this.costePorPorciones = costePorPorciones;
	}
	
	
	
	public String getUsuario() {
		return usuario;
	}

	public void setUsuario(String usuario) {
		this.usuario = usuario;
	}

	//método para calcular el coste
    public void calcularCoste() {
    	double calculoTotal=0;
    	for(Ingrediente ingrediente:ingredientes) {
    		calculoTotal+=ingrediente.getCostoPorUnidad();
    	}
    	this.costePorPorciones=calculoTotal/this.porciones;
    	 
    }

	@Override
	public String toString() {
		return "Escandallo [NombreEscandallo=" + NombreEscandallo + ", costoTotal=" + costoTotal + ", ingredientes="
				+ ingredientes + ", porciones=" + porciones + ", costePorPorciones=" + costePorPorciones + "]";
	}
    
}