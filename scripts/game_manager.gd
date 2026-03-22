extends Node2D

# Definen al caracter actual
@export var player_character : Character
@export var ia_character : Character
# Almacena cuál caracter es el actual
var current_character : Character

# Referencia al panel de movimientos
@onready var player_ui = $CanvasLayer/CombatActionsUI

# Referencia al panel
@onready var end_screen = $CanvasLayer/EndScreen

# Verifica si el juego ha terminado
var game_over : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	# Conexión de señal de daño al jugador
	player_character.OnTakeDamage.connect(_on_player_take_damage)
	# Conexión de señal de daño a la IA
	ia_character.OnTakeDamage.connect(_on_ia_take_damage)
	
	# Ocultamos la pantalla final por defecto
	end_screen.visible = false
	
	# Siguiente turno
	next_turn()

# Revisa la salud del jugador
func _on_player_take_damage (health : int):
	# Si la vida llega a 0:
	if health <= 0:
		# termina el juego y vence la IA
		end_game(ia_character)

# Revisa la salud de la IA
func _on_ia_take_damage (health : int):
	# Si la vida llega a 0:
	if health <= 0:
		# termina el juego y gana el jugador
		end_game(player_character)

# Define quién gana y muestra la pantalla final
func end_game (winner : Character):
	# Vuelve verdadera la variable 
	game_over = true
	# Vuelve visible la pantalla final
	end_screen.visible = true
	# Si el jugador gana:
	if winner == player_character:
		# la etiqueta muestra el texto adecuado.
		end_screen.set_header_text("¡Ganaste!")
	# Si no:
	else:
		# la etiqueta muestra el mensaje contrario.
		end_screen.set_header_text("¡Has perdido!")

# Gestión del cambio de turnos
func next_turn():
	# Si el juego ha terminado:
	if game_over:
		# Retorna
		return
	
	# Si el caracter no es nulo:
	if current_character != null:
		# Termina el turno para ese caracter
		current_character.end_turn()
	
	# Si el caracter actual es la IA o es nulo:
	if current_character == ia_character or current_character == null:
		# Cede el turno al jugador
		current_character = player_character
	# Si no:
	else:
		# Cede el turno a la IA
		current_character = ia_character
		# Comienza el turno para el caracter actual
		current_character.begin_turn()
	# Si es turno del jugador:
	if current_character.is_player:
		# Habilita la IU 
		player_ui.visible = true
		player_ui.set_combat_actions(player_character.combat_actions)
	# Si no
	else:
		# Deshabilita la IU si aún está activa
		player_ui.visible = false
		# Genera un tiempo de espera entre 0.5 y 1.5 segundos
		var wait_time = randf_range(0.5, 1.5)
		await get_tree().create_timer(wait_time).timeout
		# Permitimos a la IA decidir qué hacer
		var action_to_cast = ia_decide_combat_action()
		# Ejecuta el movimiento
		ia_character.cast_combat_action(action_to_cast, player_character)
		await get_tree().create_timer(0.5).timeout
		# La función se manda a llamar a sí misma 
		next_turn()	
	
			
# Gestión de los movimientos del jugador
func player_cast_combat_action(action: CombatAction):
	# Si el caracter no es el jugador:
	if player_character != current_character:
		# Retorna
		return
	# Eljugador ejecuta un movimiento contra la IA
	player_character.cast_combat_action(action, ia_character)
	# Deshabilita la IU y espera medio segundo
	player_ui.visible = false
	await get_tree().create_timer(0.5).timeout
	# Llama al siguiente turno
	next_turn()
	
# Gestión de las decisiones de la IA
func ia_decide_combat_action() -> CombatAction:
	# Si la IA no es el jugador actual:
	if ia_character != current_character:
		# no regresa nada
		return null
	
	# Alias para las variables
	var ia = ia_character
	var player = player_character
	var actions = ia.combat_actions
	
	# Variables para rastrear las ponderaciones
	var weights: Array[int] = []
	var total_weight = 0
	
	# Calculamos el porcentaje de salud de la IA
	var ia_health_perc = float(ia.cur_health) / float(ia.max_health)
	# Calculamos el porcentaje del jugador
	var player_health_perc = float(player.cur_health) / float(player.max_health)
	
	# Para cada acción dentro de las acciones
	for action in actions:
		# Variable que toma el peso base de la acción
		var weight : int = action.base_weight
		# Si la salud actual del jugador es menor o igual que el daño 
		# del movimiento:
		if player.cur_health <= action.melee_damage:
			# multiplica el peso base por 3
			weight *= 3
		
		# Si es movimiento de curación:
		if action.heal_amount > 0:
			# aumenta su peso mientras menos vida tenga la IA
			weight *= 1 + (1 - ia_health_perc)
			
		# Añadimos el peso calculado al arreglo de pesos
		weights.append(weight)
		# y lo sumamos a la variable de peso total
		total_weight += weight
		
	# Variable para el peso acumulado
	var cumulative_weight = 0
	# Variable aleatoria entre 0 y el peso total
	var rand_weight = randi_range(0,total_weight)
	
	# Para cada peso en el arreglo de pesos:
	for i in len(actions):
		# agregamos el peso actual al acumulado
		cumulative_weight += weights[i]
		
		# Si el peso random es menor al acumulado:
		if rand_weight < cumulative_weight:
			# devuelve la actual acción del ciclo
			return actions[i]
	
	return null
