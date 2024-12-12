# Distributed System Simulation


## Simulación de Consenso en una Red de Nodos

Este proyecto implementa una simulación básica de un algoritmo de consenso en una red de nodos. Los nodos pueden proponer estados, comunicarse entre sí, y alcanzar consenso mediante el intercambio de mensajes. Además, permite simular fallos y particiones en la red para observar cómo afecta la dinámica del consenso.

Características
- Propuesta de Estados: Los nodos pueden proponer un estado y compartirlo con sus vecinos.
- Consenso Distribuido: Los nodos votan por los estados propuestos y alcanzan consenso cuando la mayoría lo acepta.
- Simulación de Fallos: Un nodo puede ser desactivado para simular un fallo.
- Simulación de Particiones: Se pueden eliminar conexiones entre nodos para simular particiones de red.
- Registro de Actividades: Cada nodo mantiene un log de sus actividades y mensajes recibidos.

Uso

1. Crea instancias de nodos con Nodo.new(id).
2. Conecta los nodos entre sí usando agregar_vecino.
3. Propón estados utilizando proponer_estado.
4. Simula particiones de red con simular_particion.
5. Revisa los logs de cada nodo con obtener_log.

```ruby
  # Crear nodos
  nodos = (1..3).map { |id| Nodo.new(id) }

  # Establecer conexiones de red
  nodos[0].agregar_vecino(nodos[1])
  nodos[0].agregar_vecino(nodos[2])

  nodos[1].agregar_vecino(nodos[0])
  nodos[1].agregar_vecino(nodos[2])
  
  nodos[2].agregar_vecino(nodos[0])
  nodos[2].agregar_vecino(nodos[1])

  # Simular propuestas
  puts "--- Propuestas Iniciales ---"
  nodos[0].proponer_estado(1)
  nodos[1].proponer_estado(2)

  # Simular partición de red
  puts "\n--- Partición de Red ---"
  nodos[2].simular_particion([nodos[0]])

  # Propuesta adicional después de partición
  puts "\n--- Post Partición de Red ---"
  nodos[1].proponer_estado(3)

  # Imprimir logs y estados finales
  nodos.each_with_index do |nodo, index|
    puts "\n--- Log del Nodo #{index + 1} ---"
    puts nodo.obtener_log

    puts "\n--- Estado de Consenso del Nodo #{index + 1} ---"
    puts nodo.estado_consenso
  end
  ```

```bash

OUTPUT: 

--- Propuestas Iniciales ---

--- Partición de Red ---

--- Simulación de Fallo ---

--- Post Partición y Fallo ---

--- Log del Nodo 1 ---
Nodo 1: Proponiendo estado: 1
Nodo 1: Mensaje recibido: {:tipo=>:voto, :estado=>1, :de=>2}
Nodo 1: Mensaje recibido: {:tipo=>:voto, :estado=>1, :de=>3}
Nodo 1: Consenso alcanzado para estado: 1
Nodo 1: Mensaje recibido: {:tipo=>:propuesta, :estado=>2, :de=>2}

--- Estado de Consenso del Nodo 1 ---
2

--- Log del Nodo 2 ---
Nodo 2: Mensaje recibido: {:tipo=>:propuesta, :estado=>1, :de=>1}
Nodo 2: Proponiendo estado: 2
Nodo 2: Mensaje recibido: {:tipo=>:voto, :estado=>2, :de=>1}
Nodo 2: Mensaje recibido: {:tipo=>:voto, :estado=>2, :de=>3}
Nodo 2: Consenso alcanzado para estado: 2
Nodo 2: Nodo ha fallado

--- Estado de Consenso del Nodo 2 ---
2

--- Log del Nodo 3 ---
Nodo 3: Mensaje recibido: {:tipo=>:propuesta, :estado=>1, :de=>1}
Nodo 3: Mensaje recibido: {:tipo=>:propuesta, :estado=>2, :de=>2}
Nodo 3: Partición de red. Vecinos restantes: 1
Nodo 3: Proponiendo estado: 3

--- Estado de Consenso del Nodo 3 ---
3

```


Requisitos
- Tener ruby instalado 

Instalación
1. Clona el repositorio.
2. Ejecuta el archivo con el siguiente comando:
 
```bash
ruby simulation.rb
```
