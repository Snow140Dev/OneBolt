extends Node2D

var type = ""

@onready var hover = $hover

func _ready() -> void:
	if type == "bolt":
		$sprite.texture = load("res://assets/bolt.png")
	if type == "strm":
		$sprite.texture = load("res://assets/storm.png")
	
		
func enlarge():
	$sprite.scale = Vector2(1.2, 1.2)
	if not get_parent().get_parent().get_parent().hoveredTool.has(self.type):
		get_parent().get_parent().get_parent().hoveredTool.append(self.type)
	
func shrink():
	print("EXIT")
	$sprite.scale = Vector2(1, 1)
	get_parent().get_parent().get_parent().hoveredTool.erase(self.type)
