extends Node2D

## Game Nodes ##

@onready var hover = $Levels/Level1/MouseHover

## Lists ##

@onready var levels = {
	1: $Levels/Level1, }
var blocks = {
	grass: [],
	crates : [],
	returns: [],
	scatters: [],
	keys: [],
	doors: [],
	lava: [],
	portals: [] }
enum {
	grass, 
	crates, 
	returns, 
	scatters, 
	keys, 
	doors, 
	lava, 
	portals }

## Game Vars ##

var level = 1
var levelNode

## Built-in Functions ##

func _ready() -> void:
	onLevelLoad()

func _process(delta: float) -> void:
	getBlockHit()
## Levels ##
	
func onLevelLoad():
	levelNode = levels[level]
	hover = levelNode.get_node("MouseHover")
	var tilemap = levelNode.get_node("tileMap")
	for i in [0,1]:
		for c in tilemap.get_used_cells(i):
			var tile = tilemap.get_cell_tile_data(i,c)
			if tile.get_custom_data("type") == "Grass": blocks[grass].append(c)
			elif tile.get_custom_data("type") == "Crate": blocks[crates].append(c)
			elif tile.get_custom_data("type") == "Return": blocks[returns].append(c)
			elif tile.get_custom_data("type") == "Scatter": blocks[scatters].append(c)
			elif tile.get_custom_data("type") == "Key": blocks[keys].append(c)
			elif tile.get_custom_data("type") == "Door": blocks[doors].append(c)
			elif tile.get_custom_data("type") == "Lava": blocks[lava].append(c)
			elif tile.get_custom_data("type") == "Portal": blocks[portals].append(c)

## Puzzle System ##

func getBlockHit():
	if Input.is_action_just_pressed("click"):
		if hover: 
			if hover.hovered.size() > 1:
				if hover.hovered[1]:
					if hover.hovered[1].get_custom_data("type") == "Crate":
						print("Hit!")
