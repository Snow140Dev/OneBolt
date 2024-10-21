extends Node2D

var hovered = []

func is_even(integer):
	return integer % 2 == 0

func _process(delta: float) -> void:
	var tileNode = get_parent().get_node("Level1/tileMap")
	var mouse_cell_pos = tileNode.local_to_map( get_global_mouse_position() )
	print(mouse_cell_pos)
	
	hovered = [tileNode.get_cell_tile_data(0,mouse_cell_pos,true)]
	
	
	if is_even(mouse_cell_pos.x):
		mouse_cell_pos.x -= 1
	if not is_even(mouse_cell_pos.y):
		mouse_cell_pos.y -= 1
		
	self.global_position = tileNode.map_to_local(mouse_cell_pos) - Vector2(26,13)
	
	var hide = true
	$coll.global_position = get_global_mouse_position()
	
	for obj in $coll.get_overlapping_bodies():
		hide = false
		
	if hide: visible = false
	else: visible = true
