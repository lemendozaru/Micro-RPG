extends Node2D

# Creamos nuestra clase Character
class_name Character

# Señal de daño
signal OnTakeDamage (health : int)
# Señal de curación
signal OnHeal (health : int)

# Variable lógica que indica si el caracter es el jugador
@export var is_player : bool
# Muestra la salud actual del caracter
@export var cur_health : int
# Guarda la vida máxima del caracter
@export var max_health : int
# Muestra la escala hacia la cual va el caracter. Muestra el turno del jugador
var target_scale : float = 1.0
# Referencia al AudioStreamPlayer
@onready var audio : AudioStreamPlayer = $AudioStreamPlayer
# Precarga el audio de daño
var take_damage_sfx : AudioStream = preload("res://assets/Audio/take_damage.wav")
# Precarga el audio de sanación
var heal_sfx : AudioStream = preload("res://assets/Audio/heal.wav")

# Arreglo de movimientos
@export var combat_actions : Array[CombatAction]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
# Llamada cuando comience el turno del caracter
func begin_turn ():
	# Mayor a 1: turno del caracter
	target_scale = 1.1
	
# Llamada cuando finalice el turno
func end_turn ():
	# Menor a 1: fin del turno
	target_scale = 0.9

# Recibir daño
func take_damage (amount : int):
	pass  
	
# Sanación
func heal (amount : int):
	pass
	
# Realizar un movimiento
func cast_combat_action(action: CombatAction, opponent: Character):
	pass
	
# Reproducri el sonido correspondiente
func _play_audio (stream : AudioStream):
	pass
