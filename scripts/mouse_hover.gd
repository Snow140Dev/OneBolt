extends Node2D

var hovered = []

func is_even(integer):
	return integer % 2 == 0

func _process(delta: float) -> void:
	getHover()
	
func getHover():
	
	# Gets Tiles and Mouse Position
	
	var tileNode = get_parent().get_node("tileMap")
	var mouse_cell_pos = tileNode.local_to_map( get_global_mouse_position() )
	var hovered_cell = tileNode.local_to_map( get_parent().get_local_mouse_position() )
	
	# Make sure we are snapped to isometric map
	
	if is_even(mouse_cell_pos.x):
		mouse_cell_pos.x -= 1
	if not is_even(mouse_cell_pos.y):
		mouse_cell_pos.y -= 1
		
	self.global_position = tileNode.map_to_local(mouse_cell_pos) - Vector2(26,13)
	
	# Checks if hovering on tilemap
	
	var hide = true
	$coll.global_position = get_global_mouse_position()

	for obj in $coll.get_overlapping_bodies():
		hide = false
		
	# Resets Hover
	
	hovered = []
	
	if hide: visible = false
	else: 
		visible = true
		
		# Get Hovered Tiles
		
		hovered = [tileNode.get_cell_tile_data(0,hovered_cell),tileNode.get_cell_tile_data(1,hovered_cell)]
		if hovered[1]:
			pass
		else:
			hovered[1] = tileNode.get_cell_tile_data(1, hovered_cell + Vector2i(-1,0))
			if not hovered[1]:
				hovered[1] = tileNode.get_cell_tile_data(1, hovered_cell + Vector2i(0,-1))
