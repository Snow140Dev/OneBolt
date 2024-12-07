extends Node2D

## Game Nodes ##

@onready var hover = $Levels/Level1/MouseHover
@onready var hotbar = $UI/Hotbar

## Lists ##

@onready var levels = {
	1: $Levels/Level1,
	2: $Levels/Level2,
	3: $Levels/Level3,
	4: $Levels/Level4,
	5: $Levels/Level5,
	6: $Levels/Level6,
	7: $Levels/Level7,
	8: $Levels/Level8 }
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

var hoveredTool = []
var selectedTool

@onready var blockBreak = $Systems/DestroyBlock

## Built-in Functions ##

func _ready() -> void:
	loadLevel()

func _process(delta: float) -> void:
	getBlockHit()
	hoverLava()
	
	#print(hoveredTool)
	
	if Input.is_action_just_pressed("rClick"):

		if level < 8:
			level += 1
		else:
			level = 1
			
		loadLevel()
		
	elif Input.is_action_just_pressed("click"):
		if hoveredTool != []:
			#if selectedTool == "bolt":
			#	print(selectedTool)
			#	print(hotbar.items.size())
			#	var addStr = selectedTool[0] + str(hotbar.items.size())
			#	hotbar.items.append(addStr)
			selectedTool = hoveredTool[0]
			
			for i in hotbar.items:
				if i.begins_with(selectedTool):
					print("ERASE!")
					hotbar.items.erase(i)
					hotbar.loadItems()
					break
					
			hotbar.changeSelected(selectedTool)
		

func loadLevel():
	for lvl in levels:
		levels[lvl].visible = false
	levels[level].visible = true
	
	onLevelLoad()
	

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

func hoverLava():
	if hover.hovered.size() > 1:
		if hover.hovered[0]:
			if hover.hovered[0].get_custom_data("type") == "Lava":
				if not hover.hovered[1]:
					Input.warp_mouse(Vector2(50,50))
func getBlockHit():
	if Input.is_action_just_pressed("click"):
		if hoveredTool != null:
			selectedTool = hoveredTool
		if hover: 
			if hover.hovered.size() > 1:
				if hover.hovered[1]:
					if hover.hovered[1].get_custom_data("type") == "Crate":
						blockBreak.destroy(levelNode.get_node("tileMap"), hover.hovered[2])
						hover.hovered[1].set_terrain(0)
						onLevelLoad()
						if blocks[crates] == []:
							if level < 8:
								level += 1
							elif level == 8:
								print("WIN")
								level = 1
							loadLevel()
