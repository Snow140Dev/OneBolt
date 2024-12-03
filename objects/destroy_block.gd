extends Node2D

@onready var lightningScene = preload("res://objects/lightning_bolt.tscn")

func destroy(tilemap, coords):
	tilemap.set_cell(1, coords, 0)
	
	var bolt = lightningScene.instantiate()
	bolt.get_node("Line2D").points = PackedVector2Array([Vector2(get_global_mouse_position().x,-16*get_global_mouse_position().y), Vector2(get_global_mouse_position().x,get_global_mouse_position().y)])
	get_parent().get_parent().add_child(bolt)
