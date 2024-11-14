extends Node2D

var type = ""

@onready var hover = $hover

func _ready() -> void:
	if type == "bolt":
		$sprite.texture = load("res://assets/bolt.png")
	elif type == "strm":
		$sprite.texture = load("res://assets/storm.png")
		
	hover.connect("mouse_entered", enlarge)
	hover.connect("mouse_exited", shrink)
		
func enlarge():
	$sprite.scale = Vector2(1.2, 1.2)
	print("big!")
	
func shrink():
	$sprite.scale = Vector2(1, 1)
