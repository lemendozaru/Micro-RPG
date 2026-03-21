extends ProgressBar

# Referencia al texto de la barra
@onready var health_text : Label = $HealthText

func _ready():
	# Referenciamos al nodo padre (Character)
	var chara = get_parent()
	# Definimos su vida máxima con el valor máximo permitido
	max_value = chara.max_health
	# Actualizamos su vida actual
	_update_value(chara.cur_health)
	# Conectamos la señal de daño a la función que actualiza
	# la vida actual
	chara.OnTakeDamage.connect(_update_value)
	# También conectamos la señal de curación
	chara.OnHeal.connect(_update_value)
	
# Función que actualizará los valores actuales de la vida
func _update_value (health : int):
	# Manda el valor de vida actual
	value = health
	# Manda el valor a la etiqueta
	health_text.text = str(health) + " / " + str(int(max_value))
