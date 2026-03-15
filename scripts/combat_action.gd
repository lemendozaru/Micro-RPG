# Definimos la clase
class_name CombatAction

# Cambiamos el tipo de herencia a Recurso
extends Resource

# Declaramos variables
# Nombre del movimiento
@export var display_name : String
# Lo que hace el movimiento
@export var description : String
# Daño a melée
@export var melee_damage : int = 0
# Cantidad de sanación
@export var heal_amount : int = 0
# Ponderación o atractivo para la IA, más alto, más deseable
@export var base_weight : int = 100
