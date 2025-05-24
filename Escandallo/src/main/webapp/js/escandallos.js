function actualizarPrecioFila(selectElement) {
    const selectedOption = selectElement.options[selectElement.selectedIndex];

    // Obtener el precio  de los atributos data-
    // Usamos '|| 0' o '|| ''' para asegurar un valor por defecto si el atributo no existe o es inválido.
    const precioUnitario = parseFloat(selectedOption.getAttribute('data-precio')) || 0;
    const unidad = selectedOption.getAttribute('data-unidad') || '';

    // Encontrar la fila (<tr>) que contiene el select
    const row = selectElement.closest('tr');

    // Elementos a actualizar en la fila
    const precioSpan = row.querySelector('.precio-ingrediente');
    const hiddenPrecioInput = row.querySelector('input[name="ingredientePrecio"]');
    const unidadSpan = row.querySelector('.unidad-ingrediente');
    const hiddenUnidadInput = row.querySelector('input[name="ingredienteUnidad"]');

    // 1. Actualizar el SPAN visible del precio
    if (precioSpan) {
        precioSpan.textContent = precioUnitario.toFixed(2); // Formatear a 2 decimales 
    }

    // 2. Actualizar el INPUT OCULTO del precio (CRÍTICO para el envío al servidor)
    if (hiddenPrecioInput) {
        hiddenPrecioInput.value = precioUnitario.toFixed(2); // Guardar también con 2 decimales
    } else {
        console.error("Error: No se encontró el input oculto 'ingredientePrecio' en la fila.");
    }

    // 3. Actualizar el SPAN visible de la unidad
    if (unidadSpan) {
        unidadSpan.textContent = unidad;
    }

    // 4. Actualizar el INPUT OCULTO de la unidad
    if (hiddenUnidadInput) {
        hiddenUnidadInput.value = unidad;
    } else {
        console.error("Error: No se encontró el input oculto 'ingredienteUnidad' en la fila.");
    }
}

function agregarFila() {
    const tabla = document.getElementById("tablaIngredientes").getElementsByTagName('tbody')[0];
    const primeraFila = tabla.rows[0];
    // Clonar la primera fila profundamente (con todos sus descendientes)
    const nuevaFila = primeraFila.cloneNode(true);

    // Limpiar los valores de los elementos en la nueva fila
    const select = nuevaFila.querySelector('select[name="ingredienteNombre"]');
    const cantidadInput = nuevaFila.querySelector('input[name="ingredienteCantidad"]');
    const precioSpan = nuevaFila.querySelector('.precio-ingrediente');
    const hiddenPrecioInput = nuevaFila.querySelector('input[name="ingredientePrecio"]');
    const unidadSpan = nuevaFila.querySelector('.unidad-ingrediente');
    const hiddenUnidadInput = nuevaFila.querySelector('input[name="unidad"]');

    // Resetear el select a la primera opción y reasignar el evento onchange
    if (select) {
        select.selectedIndex = 0; // Selecciona la opción "-- Seleccione un ingrediente --"
        select.onchange = function() { // Reasignar el evento para la nueva fila
            actualizarPrecioFila(this);
        };
    }

    // Limpiar el campo de cantidad
    if (cantidadInput) {
        cantidadInput.value = '';
    }

    // Limpiar el span y el input oculto del precio
    if (precioSpan) {
        precioSpan.textContent = '0.00';
    }
    if (hiddenPrecioInput) {
        hiddenPrecioInput.value = '0.00';
    }

    // Limpiar el span y el input oculto de la unidad
    if (unidadSpan) {
        unidadSpan.textContent = '';
    }
    if (hiddenUnidadInput) {
        hiddenUnidadInput.value = '';
    }

    // Añadir la nueva fila a la tabla
    tabla.appendChild(nuevaFila);
}

function eliminarFila(boton) {
    const fila = boton.closest('tr'); // Encuentra la fila más cercana
    const tablaBody = fila.parentNode; // El <tbody> que contiene la fila

    // No eliminar si es la única fila en la tabla
    if (tablaBody.rows.length > 1) {
        tablaBody.removeChild(fila);
    } else {
        // Si es la única fila, solo limpiar sus valores
        const select = fila.querySelector('select[name="ingredienteNombre"]');
        const cantidadInput = fila.querySelector('input[name="ingredienteCantidad"]');
        const precioSpan = fila.querySelector('.precio-ingrediente');
        const hiddenPrecioInput = fila.querySelector('input[name="ingredientePrecio"]');
        const unidadSpan = fila.querySelector('.unidad-ingrediente');
        const hiddenUnidadInput = fila.querySelector('input[name="ingredienteUnidad"]');

        if (select) {
            select.selectedIndex = 0;
        }
        if (cantidadInput) {
            cantidadInput.value = '';
        }
        if (precioSpan) {
            precioSpan.textContent = '0.00';
        }
        if (hiddenPrecioInput) {
            hiddenPrecioInput.value = '0.00';
        }
        if (unidadSpan) {
            unidadSpan.textContent = '';
        }
        if (hiddenUnidadInput) {
            hiddenUnidadInput.value = '';
        }
    }
}



/**
 * Se ejecuta cuando el DOM está completamente cargado.
 * Asegura que los precios y unidades se actualicen para las filas existentes
 * si ya hay una opción seleccionada al cargar la página.
 */
document.addEventListener('DOMContentLoaded', function() {
    // Para todas las filas que contienen un selector de ingredientes
    document.querySelectorAll('select[name="ingredienteNombre"]').forEach(select => {
        // Solo si hay una opción seleccionada (y no es la opción por defecto vacía)
        if (select.value) {
            actualizarPrecioFila(select);
        }
    });
});