extends KinematicBody2D
class_name Actor
# Main entity variable
export var speed: = Vector2(300.0,750.0)
export var gra: = 1500.0
onready var Globals = get_node("/root/Globals")

# Main velocity
var vel: = Vector2.ZERO
