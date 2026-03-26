extends Node2D

# Creamos nuestra clase Character
class_name Character

# Booleana que hace girar a la izquierda
@export var facing_left : bool = false

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
# Muestra la escala hacia la cual va el caracter. 
# Muestra el turno del jugador
var target_scale : float = 1.0
# Referencia al AudioStreamPlayer
@onready var audio : AudioStreamPlayer = $AudioStreamPlayer
# Precarga el audio de daño
var take_damage_sfx : AudioStream = preload("res://assets/Audio/take_damage.wav")
# Precarga el audio de sanación
var heal_sfx : AudioStream = preload("res://assets/Audio/heal.wav")

# Arreglo de movimientos
@export var combat_actions : Array[CombatAction]

# Referencia al sprite del caracter
@onready var sprite : Sprite2D = $Sprite2D

# Variable para cargar diferentes texturas
@export var display_texture : Texture2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Tomamos el valor de la variable lógica correspondiente
	sprite.flip_h = facing_left
	sprite.texture = display_texture


# Llamada cuando comience el turno del caracter
func begin_turn():
	# Mayor a 1: turno del caracter
	target_scale = 1.1
	
# Llamada cuando finalice el turno
func end_turn ():
	# Menor a 1: fin del turno
	target_scale = 0.9

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	# Escala en X
	scale.x = lerp(scale.x, target_scale, delta * 10)
	# Escala en Y
	scale.y = lerp(scale.y, target_scale, delta * 10)

# Recibir daño
func take_damage (amount : int):
	# Restamos el daño
	cur_health -= amount
	# Emitimos la señal
	OnTakeDamage.emit(cur_health)
	# Reproducimos el sonido de daño
	_play_audio(take_damage_sfx)
	
# Sanación
func heal (amount : int):
	# Suma la cantidad de salud a la vida
	cur_health += amount
	# Limita la curación a la vida máxima
	cur_health = clamp(cur_health, 0, max_health)
	# Emite la señal de curación
	OnHeal.emit(cur_health)
	# Reproduce el sonido adecuado
	_play_audio(heal_sfx)
	
# Realizar un movimiento
func cast_combat_action(action: CombatAction, opponent: Character):
	# Si no hay acción:
	if action == null:
		# retorna
		return
	# Si la acción tiene daño a melee:
	if action.melee_damage > 0:
		# el oponente recibirá el daño de la acción
		opponent.take_damage(action.melee_damage)
	# Si la acción cura:
	if action.heal_amount > 0:
		# el caracter se cura lo que indique la acción
		heal(action.heal_amount)
	
# Reproducri el sonido correspondiente
func _play_audio (stream : AudioStream):
	audio.stream = stream
	audio.play()
