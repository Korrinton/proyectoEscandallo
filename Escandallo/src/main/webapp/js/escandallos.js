function actualizarPrecioFila(selectElement) {
    const selectedOption = selectElement.options[selectElement.selectedIndex];
    // Asegúrate de que esto devuelve el precio correcto del atributo data-precio
    const precioUnitario = parseFloat(selectedOption.getAttribute('data-precio')) || 0;
    const unidad = selectedOption.getAttribute('data-unidad') || '';

    const row = selectElement.closest('tr');

    const precioSpan = row.querySelector('.precio-ingrediente');
    // Asegúrate de que seleccionas el input oculto correcto por su 'name' o clase única
    const hiddenPrecioInput = row.querySelector('input[name="ingredientePrecio"]');

    const unidadSpan = row.querySelector('.unidad-ingrediente');
    const hiddenUnidadInput = row.querySelector('input[name="ingredienteUnidad"]');

    // Actualizar el span visible para el usuario
    precioSpan.textContent = precioUnitario.toFixed(2);

    // *** ESTO ES CLAVE: ACTUALIZAR EL VALOR DEL INPUT OCULTO ***
    if (hiddenPrecioInput) { // Siempre es buena práctica verificar si el elemento existe
        hiddenPrecioInput.value = precioUnitario.toFixed(2);
    } else {
        console.error("No se encontró el input oculto 'ingredientePrecio' en la fila.");
    }


    // Actualizar el span visible para la unidad
    unidadSpan.textContent = unidad;

    // *** ESTO ES CLAVE: ACTUALIZAR EL VALOR DEL INPUT OCULTO DE LA UNIDAD ***
    if (hiddenUnidadInput) { // Verificar si el elemento existe
        hiddenUnidadInput.value = unidad;
    } else {
        console.error("No se encontró el input oculto 'ingredienteUnidad' en la fila.");
    }
}

// Asegurarse de que esta función se ejecuta cuando la página se carga
document.addEventListener('DOMContentLoaded', function() {
    // Para todas las filas existentes que tienen un selector de ingredientes
    document.querySelectorAll('select[name="ingredienteNombre"]').forEach(select => {
        // Solo si hay una opción seleccionada (no la primera por defecto)
        if (select.value) { // Verifica si el valor del select no está vacío
            actualizarPrecioFila(select);
        }
    });
});

function agregarFila() {
    var tabla = document.getElementById("tablaIngredientes").getElementsByTagName('tbody')[0];
    var primeraFila = tabla.rows[0];
    var nuevaFila = primeraFila.cloneNode(true);

    // Limpiar los valores
    var selects = nuevaFila.getElementsByTagName('select');
    var inputs = nuevaFila.getElementsByTagName('input'); // This gets ALL inputs in the row
    var precioSpan = nuevaFila.querySelector('.precio-ingrediente');
    var precioInputHidden = nuevaFila.querySelector('input[name="ingredientePrecio"]'); // Select specifically by name
    var unidadSpan = nuevaFila.querySelector('.unidad-ingrediente'); // For the displayed unit
    var unidadInputHidden = nuevaFila.querySelector('input[name="ingredienteUnidad"]'); // NUEVO: Select specifically by name for hidden unit

    for (var i = 0; i < selects.length; i++) {
        selects[i].selectedIndex = 0;
        selects[i].onchange = actualizarPrecioFila; // Asegurar que el evento onchange se copie
    }

    // Iterate through inputs to clear their values.
    // Be careful with this loop if you have other input types you don't want cleared.
    for (var i = 0; i < inputs.length; i++) {
        // Only clear text/number inputs, not hidden ones directly here
        if (inputs[i].type === 'text' || inputs[i].type === 'number') {
            inputs[i].value = '';
        }
    }

    if (precioSpan) {
        precioSpan.textContent = '0.00';
    }
    if (precioInputHidden) {
        precioInputHidden.value = '0.00'; // Clear hidden price
    }
    if (unidadSpan) {
        unidadSpan.textContent = ''; // Clear displayed unit
    }
    if (unidadInputHidden) { // NUEVO: Clear hidden unit input
        unidadInputHidden.value = '';
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

        if (unidadSelect) {
            unidadSelect.selectedIndex = 0;
        }
    }
}