extends TextureRect

# velocidad del movimiento
@export var speed : float = 200
# Extensión
@export var extents : float = 1024
# Posición inicial
@onready var start_pos : Vector2 = position
# Cambio de color
@export var color_lerp : Gradient

func _process(delta):
	position.x += speed * delta
	# Si la posición actual en X menos la original supera la extensión:
	if position.x - start_pos.x >= extents:
		# reiniciamos la posición
		position = start_pos
	
	# Obtenemos el tiempo del sistema
	var time = sin(Time.get_unix_time_from_system())
	time = (time + 1) / 2
	# Aplicamos un filtro de color basados en el tiempo
	modulate = color_lerp.sample(time)
	
