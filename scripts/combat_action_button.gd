extends Button

# clase nueva
class_name CombatActionButton

# variable de tipo CombatAction
var combat_action : CombatAction

# función que actualiza el texto en el botón
func set_combat_action(ca : CombatAction):
	combat_action = ca
	text = ca.display_name

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
