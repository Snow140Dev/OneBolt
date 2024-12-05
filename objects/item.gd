extends Node2D

var type = ""

@onready var boltSpr = $bolt
@onready var strmSpr = $strm

var sprite

@onready var hover = $hover

func _ready() -> void:
	if type == "bolt":
		sprite = boltSpr
	if type == "strm":
		sprite = strmSpr
	sprite.visible = true
	
		
func enlarge():
	print("ENTER")
	sprite.scale = Vector2(1.2, 1.2)
	get_parent().get_parent().get_parent().showItemPopup(null, null, null)
	if not get_parent().get_parent().get_parent().hoveredTool.has(self.type):
		get_parent().get_parent().get_parent().hoveredTool.append(self.type)
		get_parent().get_parent().get_parent().hoveredToolPos.append([self.global_position.x,self.global_position.y])
		
	
func shrink():
	print("EXIT")
	sprite.scale = Vector2(1, 1)
	get_parent().get_parent().get_parent().hoveredTool.erase(self.type)
	get_parent().get_parent().get_parent().hoveredToolPos.erase([self.global_position.x,self.global_position.y])
	
	get_parent().get_parent().get_parent().hideItemPopup()
