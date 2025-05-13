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