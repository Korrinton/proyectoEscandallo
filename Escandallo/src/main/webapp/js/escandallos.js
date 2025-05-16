function actualizarPrecioFila(selectIngrediente) {
    var precioSpan = selectIngrediente.parentNode.parentNode.querySelector('.precio-ingrediente');
    var precioInputHidden = selectIngrediente.parentNode.parentNode.querySelector('.precio-escondido');
    var unidadSelect = selectIngrediente.parentNode.nextElementSibling.querySelector('select[name="ingredienteUnidad"]');
    var selectedOption = selectIngrediente.options[selectIngrediente.selectedIndex];
    var precio = selectedOption.getAttribute('data-precio');
    var unidad = selectedOption.getAttribute('data-unidad');

    if (precioSpan) {
        precioSpan.textContent = parseFloat(precio).toFixed(2);
    }
    if (precioInputHidden) {
        precioInputHidden.value = precio;
    }
    if (unidadSelect && unidad) {
        for (var i = 0; i < unidadSelect.options.length; i++) {
            if (unidadSelect.options[i].value === unidad) {
                unidadSelect.selectedIndex = i;
                break;
            }
        }
    } else if (unidadSelect) {
        unidadSelect.selectedIndex = 0; // O podrías establecer un valor por defecto si no se encuentra la unidad
    }
}

function agregarFila() {
    var tabla = document.getElementById("tablaIngredientes").getElementsByTagName('tbody')[0];
    var primeraFila = tabla.rows[0];
    var nuevaFila = primeraFila.cloneNode(true);

    // Limpiar los valores
    var selects = nuevaFila.getElementsByTagName('select');
    var inputs = nuevaFila.getElementsByTagName('input');
    var precioSpan = nuevaFila.querySelector('.precio-ingrediente');
    var precioInputHidden = nuevaFila.querySelector('.precio-escondido');
    var unidadSelect = nuevaFila.querySelector('select[name="ingredienteUnidad"]');

    for (var i = 0; i < selects.length; i++) {
        selects[i].selectedIndex = 0;
        selects[i].onchange = actualizarPrecioFila; // Asegurar que el evento onchange se copie
    }

    for (var i = 0; i < inputs.length; i++) {
        inputs[i].value = '';
    }

    if (precioSpan) {
        precioSpan.textContent = '0.00';
    }
    if (precioInputHidden) {
        precioInputHidden.value = '0.00';
    }
    if (unidadSelect) {
        unidadSelect.selectedIndex = 0; // Restablecer la unidad en las nuevas filas
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
        var precioSpan = fila.querySelector('.precio-ingrediente');
        var precioInputHidden = fila.querySelector('.precio-escondido');
        var unidadSelect = fila.querySelector('select[name="ingredienteUnidad"]');

        for (var i = 0; i < selects.length; i++) {
            selects[i].selectedIndex = 0;
        }

        for (var i = 0; i < inputs.length; i++) {
            inputs[i].value = '';
        }

        if (precioSpan) {
            precioSpan.textContent = '0.00';
        }
        if (precioInputHidden) {
            precioInputHidden.value = '0.00';
        }
        if (unidadSelect) {
            unidadSelect.selectedIndex = 0;
        }
    }
}