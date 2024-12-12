class Nodo
  attr_reader :id, :log, :estado_actual, :vecinos
  
  def initialize(id)
    @id = id
    @log = []
    @estado_actual = nil
    @vecinos = []
    @activo = true
    @votos = Hash.new { |hash, key| hash[key] = [] }
    @consenso_alcanzado = false
  end
  
  def agregar_vecino(nodo)
    @vecinos << nodo
    calcular_umbral_consenso
  end
  
  def calcular_umbral_consenso
    @umbral_consenso = ((@vecinos.size + 1) / 2.0).ceil
  end
  
  def proponer_estado(estado)
    return false unless @activo
  
    # Solo proponer si el nuevo estado es más reciente
    if @estado_actual.nil? || estado > @estado_actual
      registrar_evento("Proponiendo estado: #{estado}")
      @estado_actual = estado
      difundir_propuesta(estado)
    end
  
    true
  end
  
  def recibir_mensaje(mensaje)
    return false unless @activo
  
    registrar_evento("Mensaje recibido: #{mensaje}")
    
    case mensaje[:tipo]
    when :propuesta
      manejar_propuesta(mensaje)
    when :voto
      manejar_voto(mensaje)
    end
  
    true
  end
  
  def manejar_propuesta(mensaje)
    propuesta = mensaje[:estado]
    
    if @estado_actual.nil? || propuesta > @estado_actual
      @estado_actual = propuesta
      enviar_voto(mensaje[:de], propuesta)
    end
  end
  
  def manejar_voto(mensaje)
    estado_votado = mensaje[:estado]
    
    # Agregar voto solo si no existe
    @votos[estado_votado] << mensaje[:de] unless @votos[estado_votado].include?(mensaje[:de])
  
    verificar_consenso(estado_votado)
  end
  
  def verificar_consenso(estado)
    if @votos[estado].size >= @umbral_consenso && !@consenso_alcanzado
      @consenso_alcanzado = true
      @estado_actual = estado
      registrar_evento("Consenso alcanzado para estado: #{estado}")
    end
  end
  
  def enviar_voto(id_destino, estado)
    destino = @vecinos.find { |nodo| nodo.id == id_destino }
    destino&.recibir_mensaje(
      tipo: :voto, 
      estado: estado, 
      de: @id
    )
  end
  
  def difundir_propuesta(estado)
    @vecinos.each do |vecino|
      vecino.recibir_mensaje(
        tipo: :propuesta, 
        estado: estado, 
        de: @id
      )
    end
  end
  
  def simular_particion(nodos_excluidos)
    @vecinos.reject! { |vecino| nodos_excluidos.include?(vecino) }
    calcular_umbral_consenso
    registrar_evento("Partición de red. Vecinos restantes: #{@vecinos.size}")
  end
  
  def simular_fallo
    @activo = false
    registrar_evento("Nodo ha fallado")
  end
  
  def obtener_log
    @log
  end
  
  def estado_consenso
    @estado_actual
  end
  
  private
  
  def registrar_evento(mensaje)
    @log << "Nodo #{@id}: #{mensaje}"
  end
end

# Escenario de prueba con simulación de fallo
def demostrar_consenso
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

  # Simular fallo de nodo
  puts "\n--- Simulación de Fallo ---"
  nodos[1].simular_fallo

  # Propuesta adicional después de partición y fallo
  puts "\n--- Post Partición y Fallo ---"
  nodos[2].proponer_estado(3)

  # Imprimir logs y estados finales
  nodos.each_with_index do |nodo, index|
    puts "\n--- Log del Nodo #{index + 1} ---"
    puts nodo.obtener_log

    puts "\n--- Estado de Consenso del Nodo #{index + 1} ---"
    puts nodo.estado_consenso
  end
end

# Ejecutar demostración
demostrar_consenso