extends Node

func destroy(tilemap, coords):
	tilemap.set_cell(1, coords, 0)
	
