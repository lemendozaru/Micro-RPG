extends Sprite2D

# Variable que aplica el desfase
@onready var base_offset: Vector2 = offset
# Intensidad de la sacudida
var shake_intensity: float = 0.0
var shake_damping: float = 10.0

# Intensidad del movimiento
var bob_amount : float = 0.02
# Velocidad del movimiento
var bob_speed : float = 15.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Obtenemos el nodo padre
	var character = get_parent()
	# Conectamos a la señal de recibir daño
	character.OnTakeDamage.connect(_damage_visual)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Tomamos el tiempo desde el sistema
	var t = Time.get_unix_time_from_system()
	# Usamos la función seno
	var y_scale = 1 + (sin(t * bob_speed) * bob_amount)
	# Escalamos en y basados en el seno
	scale.y = y_scale
	
	# Si la intensidad es mayor a cero:
	if shake_intensity > 0:
		# Interpola la vibración gradualmente
		shake_intensity = lerpf(shake_intensity, 0, shake_damping * delta)
		# Desfase aleatorio
		offset = base_offset + _random_offset()

# Desfase aleatorio para la sacudida del sprite
func _random_offset() -> Vector2:
	var x = randf_range(-shake_intensity, shake_intensity)
	var y = randf_range(-shake_intensity, shake_intensity)
	return Vector2(x, y)
	
func _damage_visual(health: int):
	# Aplicamos un filtro rojo
	modulate = Color.RED
	# Intensidad de sacudida
	shake_intensity = 10.0
	# Hacemos que dure 0.05 s
	await get_tree().create_timer(0.05).timeout
	# quitamos el filtro rojo
	modulate = Color.WHITE
	
