extends Panel

# Referencia a la etiqueta
@onready var header_text : Label = $HeaderText

# Actualiza el texto en la etiqueta
func set_header_text(text_to_display : String):
	header_text.text = text_to_display


func _on_play_again_button_pressed() -> void:
	# Recarga la escena actual
	get_tree().reload_current_scene()
