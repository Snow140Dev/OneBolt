extends Node2D

@onready var lightningScene = preload("res://objects/lightning_bolt.tscn")
@onready var explosionScene = preload("res://objects/explosion.tscn")

func destroy(tilemap, coords):
	tilemap.set_cell(1, coords, 0)
	
	var bolt = lightningScene.instantiate()
	var exp = explosionScene.instantiate()
	bolt.get_node("Line2D").points = PackedVector2Array([Vector2(get_global_mouse_position().x,-20*get_global_mouse_position().y), Vector2(get_global_mouse_position().x,get_global_mouse_position().y)])
	exp.global_position = get_global_mouse_position()
	get_parent().get_parent().add_child(bolt)
	get_parent().get_parent().add_child(exp)
	
	$explode.play()
	
func replace(tilemap, coords):
	tilemap.set_cell(1, coords, 0, Vector2(3,0), 0)
	
	var bolt = lightningScene.instantiate()
	var exp = explosionScene.instantiate()
	bolt.get_node("Line2D").points = PackedVector2Array([Vector2(get_global_mouse_position().x,-20*get_global_mouse_position().y), Vector2(get_global_mouse_position().x,get_global_mouse_position().y)])
	exp.global_position = get_global_mouse_position()
	get_parent().get_parent().add_child(bolt)
	get_parent().get_parent().add_child(exp)
	
	$explode.play()
	
func replace2(tilemap, coords):
	tilemap.set_cell(1, coords, 0, Vector2(2,0), 0)
