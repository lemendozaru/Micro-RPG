extends Panel

@onready var buttons_container = $ButtonsContainer
var ca_buttons : Array[CombatActionButton]

@onready var description_text : RichTextLabel = $Description
@onready var game_manager = $"../.."

func _ready():
	# buscamos los botones
	for child in buttons_container.get_children():
		# Si el botón no es una acción de combate
		if child is not CombatActionButton:
			# sigue de largo
			continue
		# agrega el botón al arreglo
		ca_buttons.append(child)
		# Conectamos la señal de botón presionado al botón
		child.pressed.connect(_button_pressed.bind(child))
		# Conectamos la señal de cursor entrando al botón
		child.mouse_entered.connect(_button_entered.bind(child))
		# Conectamos la señal de cursor saliendo al botón
		child.mouse_exited.connect(_button_exited.bind(child))
		

func set_combat_actions(actions: Array[CombatAction]):
	# Recorre los botones
	for i in len(ca_buttons):
		# Si son más botones que acciones:
		if i >= len(actions):
			# deshabilitarlos
			ca_buttons[i].visible = false
			# Continuar
			continue
		
		# Los botones son visibles
		ca_buttons[i].visible = true
		# Se asigna la acción al botón
		ca_buttons[i].set_combat_action(actions[i])
		
# Función de presionar el botón
func _button_pressed(button : CombatActionButton):
	# Llamamos al game manager pidiendo el movimiento asociado
	game_manager.player_cast_combat_action(button.combat_action)
	
# Función de cursor entrando al botón
func _button_entered(button : CombatActionButton):
	# Actualizamos la descripción del movimiento
	var ca = button.combat_action
	description_text.text = "[b]" + ca.display_name + "[/b]\n" + ca.description
	
func _button_exited(_button : CombatActionButton):
	# Reiniciamos el texto de la descripción
	description_text.text = ""


func _on_pass_turn_button_pressed() -> void:
	game_manager.next_turn()
