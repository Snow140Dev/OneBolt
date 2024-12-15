extends Node2D

## Game Nodes ##

@onready var hover = $Levels/Level1/MouseHover
@onready var hotbar = $IGUI/Hotbar

@onready var lvl1 = preload("res://objects/levels/level_1.tscn")
@onready var lvl2 = preload("res://objects/levels/level_2.tscn")
@onready var lvl3 = preload("res://objects/levels/level_3.tscn")
@onready var lvl4 = preload("res://objects/levels/level_4.tscn")
@onready var lvl5 = preload("res://objects/levels/level_5.tscn")
@onready var lvl6 = preload("res://objects/levels/level_6.tscn")
@onready var lvl7 = preload("res://objects/levels/level_7.tscn")
@onready var lvl8 = preload("res://objects/levels/level_8.tscn")

var tilemap

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

var strmCoords = [
				Vector2(78,39),
				Vector2(52,26),
				Vector2(26,13),
				Vector2(-26,-13),
				Vector2(-52,-26),
				Vector2(-78,-39),
				Vector2(78,-39),
				Vector2(52,-26),
				Vector2(26,-13),
				Vector2(-26,13),
				Vector2(-52,26),
				Vector2(-78,39),
				Vector2(78,13),
				Vector2(78,-13),
				Vector2(52,0),
				Vector2(26,-39),
				Vector2(0,-26),
				Vector2(-26,-39),
				Vector2(-52,0),
				Vector2(-78,-13),
				Vector2(-78,13),
				Vector2(0,26),
				Vector2(-26,39),
				Vector2(26,39)]
var strmHovers = []
var strmDestroys = [
	Vector2i(-1,0),
	Vector2i(-2,0),
	Vector2i(-3,0),
	Vector2i(1,0),
	Vector2i(2,0),
	Vector2i(3,0),
	Vector2i(0,-1),
	Vector2i(0,-2),
	Vector2i(0,-3),
	Vector2i(0,1),
	Vector2i(0,2),
	Vector2i(0,3),
	Vector2i(-1,1),
	Vector2i(-1,2),
	Vector2i(-2,1),
	Vector2i(-1,-1),
	Vector2i(-1,-2),
	Vector2i(-2,-1),
	Vector2i(-1,1),
	Vector2i(-1,2),
	Vector2i(1,1),
	Vector2i(1,2),
	Vector2i(2,1),
	Vector2i(1,-1),
	Vector2i(1,-2),
	Vector2i(2,-1), ]

var sctrCoords = [
	Vector2(26,0),
	Vector2(26,13),
	Vector2(26,-13),
	Vector2(26*2,0),
	Vector2(26*2,13),
	Vector2(26*2,-13),
	Vector2(26*2,26),
	Vector2(26*2,-26),
	Vector2(26*3,0),
	Vector2(26*3,13),
	Vector2(26*3,-13),
	Vector2(26*3,-26),
	Vector2(26*4,0),
	Vector2(26*4,-13), ]
var sctrHovers = []
var sctrDestroys = [
	Vector2i(-2,0),
	Vector2i(-4,0),
	Vector2i(-1,1),
	Vector2i(-3,1),
	Vector2i(-5,1),
	Vector2i(0,2),
	Vector2i(-2,2),
	Vector2i(-4,2),
	Vector2i(-1,3),
	Vector2i(-3,3),
	Vector2i(-5,3),
	Vector2i(0,4),
	Vector2i(-2,4),
	Vector2i(-4,4), ]

var cratesInLevel = [ 1,2,32,4,4,15,1,1 ]
var cratesDestroyed = 0
## Game Vars ##

var level = 1
var levelNode

var newCopy : Node2D

var hoveredTool = []
var selectedTool = ""

@onready var copyHover = preload('res://objects/mouse_hover_copy.tscn')

@onready var blockBreak = $Systems/DestroyBlock

## Built-in Functions ##

func _ready() -> void:
	$Levels.visible = false
	$IGUI.visible = false
	
	$UI.gameStarted.connect(start)
	
	get_tree().paused = true
	
func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	elif Input.is_action_just_pressed("restart"):
		restart()
		
func restart():
	var lvl
	var lvlNode
	if level == 1: lvl = lvl1
	if level == 2: lvl = lvl2
	if level == 3: lvl = lvl3
	if level == 4: lvl = lvl4
	if level == 5: lvl = lvl5
	if level == 6: lvl = lvl6
	if level == 7: lvl = lvl7
	if level == 8: lvl = lvl8
	
	levelNode.queue_free()
	lvlNode = lvl.instantiate()
	lvlNode.name = "Level" + str(level)
	get_node("Levels").add_child(lvlNode)
	var dict = {}
	if level == 1: dict = {1: $Levels/Level1}
	if level == 2: dict = {2: $Levels/Level2}
	if level == 3: dict = {3: $Levels/Level3}
	if level == 4: dict = {4: $Levels/Level4}
	if level == 5: dict = {5: $Levels/Level5}
	if level == 6: dict = {6: $Levels/Level6}
	if level == 7: dict = {7: $Levels/Level7}
	if level == 8: dict = {8: $Levels/Level8}
	
	levels.merge(dict)
	
	onLevelLoad()
	
	
func start():
	
	get_tree().paused = false
	
	$Levels.visible = true
	$IGUI.visible = true
	
	newCopy = Node2D.new()
	newCopy.name = 'CopyHovers'
	add_child(newCopy)
	
	loadLevel()

func _process(delta: float) -> void:
	if get_tree().paused:
		$Levels.visible = false
	else:
		$Levels.visible = true
		getBlockHover()
	
	if selectedTool == 'strm':
		strmHovers = []
		newCopy.queue_free()
		newCopy = Node2D.new()
		newCopy.name = 'CopyHovers'
		add_child(newCopy)
		for coord in strmCoords:
			var newHover = copyHover.instantiate()
			newHover.global_position = hover.global_position - coord
			newHover.scale = Vector2(2,2)
			newHover.z_index = 10
			newCopy.add_child(newHover)
			#var script = load('res://objects/mouseHoverCopy.gd')
			#newCopy.set_script(script)
			strmHovers.append(newHover)
			
	if selectedTool == 'sctr':
		sctrHovers = []
		newCopy.queue_free()
		newCopy = Node2D.new()
		newCopy.name = 'CopyHovers'
		add_child(newCopy)
		for coord in sctrCoords:
			var newHover = copyHover.instantiate()
			newHover.global_position = hover.global_position - coord*Vector2(2,2)
			newHover.scale = Vector2(2,2)
			newHover.z_index = 10
			newCopy.add_child(newHover)
			#var script = load('res://objects/mouseHoverCopy.gd')
			#newCopy.set_script(script)
			sctrHovers.append(newHover)
			
	
	if Input.is_action_just_pressed("rClick"):

		if level < 8:
			level += 1
		else:
			level = 1
			
		loadLevel()
		
	elif Input.is_action_just_pressed("click"):
		getBlockHit()
		if hoveredTool != []:
			selectedTool = hoveredTool[0]
			
			for i in hotbar.items:
				if i.begins_with(selectedTool):
					hoveredTool = []
					hotbar.items.erase(i)
					hotbar.loadItems()
					hotbar.changeSelected(selectedTool)
					break
	
	
		

func loadLevel():
	hotbar.items = ["bolt1"]
	hotbar.loadItems()
	for lvl in levels:
		levels[lvl].visible = false
	levels[level].visible = true
	
	onLevelLoad()
	
## Levels ##
	
func onLevelLoad():
	
	
	levelNode = levels[level]
	hover = levelNode.get_node("MouseHover")
	tilemap = levelNode.get_node("tileMap")
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


func getBlockHover():
	if hover.hovered.size() > 1:
		if hover.hovered[0]:
			if hover.hovered[0].get_custom_data("type") == "Lava":
				if not hover.hovered[1]:
					Input.warp_mouse(Vector2(50,50))
		if hover.hovered[1]:
			if hover.hovered[1].get_custom_data("type") == "Crate":
				Tooltip.BlockPopup("Crate", null, 
					10, 
					get_viewport_rect().size.y - 150)
				print(tilemap.local_to_map(get_global_mouse_position()))
			elif hover.hovered[1].get_custom_data("type") == "Return":
				var contents = Tooltip.returns[[level, hover.finalCoords.x, hover.finalCoords.y]]
				Tooltip.BlockPopup("Return", contents, 
					10, 
					get_viewport_rect().size.y - 150)
			elif hover.hovered[1].get_custom_data("type") == "Scatter":
				Tooltip.BlockPopup("Scatter", null, 
					10, 
					get_viewport_rect().size.y - 150)
			elif hover.hovered[1].get_custom_data("type") == "Door":
				Tooltip.BlockPopup("Door", null, 
					10, 
					get_viewport_rect().size.y - 150)
			elif hover.hovered[1].get_custom_data("type") == "Key":
				Tooltip.BlockPopup("Key", null, 
					10, 
					get_viewport_rect().size.y - 150)
			elif hover.hovered[1].get_custom_data("type") == "PORTAL2":
				Tooltip.BlockPopup("Portal", null, 
					10, 
					get_viewport_rect().size.y - 150)
				Input.warp_mouse(Vector2(1152/2-32, 648/2-13))
		else:
			Tooltip.HideBlockPopup()

func getBlockHit():
	if hover: 
		if hover.hovered.size() > 1:
			if hover.hovered[1]:
				if hover.hovered[1].get_custom_data("type") == "Crate" and selectedTool == "bolt":
					hover.hovered[1].set_terrain(0)
					blockBreak.destroy(levelNode.get_node("tileMap"), hover.hovered[2])
					selectedTool = ""
					hotbar.changeSelected(selectedTool)
					onLevelLoad()
					cratesDestroyed += 1
					if cratesDestroyed >= cratesInLevel[level-1]:
						cratesDestroyed = 0
						$UI.next_lvl_popup()
				elif hover.hovered[1].get_custom_data("type") == "Return" and selectedTool == "mine":
					#hover.hovered[1].set_terrain(7)
					var contents = Tooltip.returns[[level, hover.finalCoords.x, hover.finalCoords.y]]
					hotbar.items = contents
					hotbar.loadItems()
					blockBreak.replace(levelNode.get_node("tileMap"), hover.hovered[2])
					selectedTool = ""
					hotbar.changeSelected(selectedTool)
					onLevelLoad()
					#cratesDestroyed += 1
					if cratesDestroyed >= cratesInLevel[level-1]:
						cratesDestroyed = 0
						$UI.next_lvl_popup()
				elif hover.hovered[1].get_custom_data("type") == "Key" and selectedTool == "mine":
					blockBreak.replace2(levelNode.get_node("tileMap"), Vector2i(7,2))
					blockBreak.replace(levelNode.get_node("tileMap"), hover.hovered[2])
					selectedTool = ""
					hotbar.changeSelected(selectedTool)
					onLevelLoad()
					#cratesDestroyed += 1
					if cratesDestroyed >= cratesInLevel[level-1]:
						cratesDestroyed = 0
						$UI.next_lvl_popup()
				elif hover.hovered[1].get_custom_data("type") == "Scatter" and selectedTool == "bolt":
					#hover.hovered[1].set_terrain(7)
					blockBreak.destroy(levelNode.get_node("tileMap"), hover.hovered[2]-Vector2i(2,0))
					blockBreak.destroy(levelNode.get_node("tileMap"), hover.hovered[2]-Vector2i(0,2))
					blockBreak.destroy(levelNode.get_node("tileMap"), hover.hovered[2]+Vector2i(2,0))
					blockBreak.destroy(levelNode.get_node("tileMap"), hover.hovered[2]+Vector2i(0,2))
					selectedTool = ""
					hotbar.changeSelected(selectedTool)
					onLevelLoad()
					cratesDestroyed += 4
					if cratesDestroyed >= cratesInLevel[level-1]:
						cratesDestroyed = 0
						$UI.next_lvl_popup()
				elif hover.hovered[1].get_custom_data("type") == "Return" and selectedTool == "bolt":
					var contents = Tooltip.returns[[level, hover.finalCoords.x, hover.finalCoords.y]]
					hotbar.items = contents
					hotbar.loadItems()
					hover.hovered[1].set_terrain(0)
					blockBreak.destroy(levelNode.get_node("tileMap"), hover.hovered[2])
					selectedTool = ""
					hotbar.changeSelected(selectedTool)
					onLevelLoad()
				elif hover.hovered[1].get_custom_data("type") == "Crate" and selectedTool == "strm":
					for destroy in strmDestroys:
						blockBreak.destroy(levelNode.get_node("tileMap"), hover.hovered[2]+destroy)
						cratesDestroyed += 1
					blockBreak.destroy(levelNode.get_node("tileMap"), hover.hovered[2])
					for hoverCopy in strmHovers:
						hoverCopy.queue_free()
					selectedTool = ""
					hotbar.changeSelected(selectedTool)
					onLevelLoad()
					cratesDestroyed = 0
					$UI.next_lvl_popup()
				elif hover.hovered[1].get_custom_data("type") == "Crate" and selectedTool == "sctr":
					for destroy in sctrDestroys:
						blockBreak.destroy(levelNode.get_node("tileMap"), hover.hovered[2]+destroy)
						print(hover.hovered[2]+destroy , " | " , destroy)
						cratesDestroyed += 1
					blockBreak.destroy(levelNode.get_node("tileMap"), hover.hovered[2])
					for hoverCopy in sctrHovers:
						hoverCopy.queue_free()
					selectedTool = ""
					hotbar.changeSelected(selectedTool)
					onLevelLoad()
					cratesDestroyed = 0
					$UI.next_lvl_popup()
					
					#9,10
					#13,10
