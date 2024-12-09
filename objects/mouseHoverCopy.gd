extends Node2D

var hovered
var finalCoords

func _process(delta: float) -> void:
	var tileNode = get_parent().get_parent().tilemap
	var hovered_cell = tileNode.local_to_map( global_position )
	
	# Make sure we are snapped to isometric map

	
	# Checks if hovering on tilemap
	
	var hide = true
	$coll.global_position = get_global_mouse_position()

	for obj in $coll.get_overlapping_bodies():
		hide = false
	hide = false
	# Resets Hover
	
	#hovered = []
	
	if hide: visible = false
	else: 
		visible = true
		
		# Get Hovered Tiles
		
		hovered = [tileNode.get_cell_tile_data(0,hovered_cell),tileNode.get_cell_tile_data(1,hovered_cell),hovered_cell]
		if hovered[1]:
			finalCoords = hovered_cell
		else:
			hovered[1] = tileNode.get_cell_tile_data(1, hovered_cell + Vector2i(-1,0))
			finalCoords = hovered_cell + Vector2i(-1,0)
			if not hovered[1]:
				hovered[1] = tileNode.get_cell_tile_data(1, hovered_cell + Vector2i(0,-1))
				finalCoords = hovered_cell + Vector2i(0,-1)
				
		#print(hovered)
