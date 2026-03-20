extends Node2D

# Definen al caracter actual
@export var player_character : Character
@export var ia_character : Character
# Almacena cuál caracter es el actual
var current_character : Character

# Referencia al panel de movimientos
@onready var player_ui = $CanvasLayer/CombatActionsUI

# Verifica si el juego ha terminado
var game_over : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	next_turn()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Gestión del cambio de turnos
func next_turn():
	# Si el juego ha terminado:
	if game_over:
		# Retorna
		return
	
	if current_character != null:
		current_character.end_turn()
	if current_character == ia_character or current_character == null:
		current_character = player_character
	else:
		current_character = ia_character
		current_character.begin_turn()
	if current_character.is_player:
		player_ui.visible = true
		player_ui.set_combat_actions(player_character.combat_actions)
	else:
		player_ui.visible = false
		var wait_time = randf_range(0.5, 1.5)
		await get_tree().create_timer(wait_time).timeout
		var action_to_cast = ia_decide_combat_action()
		ia_character.cast_combat_action(action_to_cast, player_character)
		await get_tree().create_timer(0.5).timeout
		next_turn()

	
	# Si el caracter no es nulo:
	#if current_character != null:
		# Termina el turno para ese caracter
	#	current_character.end_turn()
		
	# Si el caracter actual es la IA o es nulo:
	#if current_character == ia_character or current_character == null:
		# Cede el turno al jugador
		current_character = player_character
	# Si no:
	#else:
		# Cede el turno a la IA
	#	current_character = ia_character
	
	# Comienza el turno para el caracter actual
	#current_character.begin_turn()
	
	
	# Si es turno del jugador:
	if current_character.is_player:
		# Habilita la IU 
		pass # Por mientras
	# Si no
	else:
		# Deshabilita la IU si aún está activa
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
	return null
