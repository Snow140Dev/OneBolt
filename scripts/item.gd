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
	sprite.scale = Vector2(1.2, 1.2)
	if not get_parent().get_parent().get_parent().hoveredTool.has(self.type):
		get_parent().get_parent().get_parent().hoveredTool.append(self.type)
		Tooltip.ItemPopup(self.global_position.x+32, self.global_position.y+32, type)
	
func shrink():
	sprite.scale = Vector2(1, 1)
	get_parent().get_parent().get_parent().hoveredTool.erase(self.type)
	Tooltip.HideItemPopup()
