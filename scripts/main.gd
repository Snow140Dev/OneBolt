extends Node2D

## Game Nodes ##

@onready var hover = $Levels/Level1/MouseHover
@onready var hotbar = $IGUI/Hotbar

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
			
			#if int(coord.x) % 13 != 0 or int(coord.y) % 13 != 0:
			#	print(coord)
	
	#print(hoveredTool)
	
	if Input.is_action_just_pressed("rClick"):

		if level < 8:
			level += 1
		else:
			level = 1
			
		loadLevel()
		
	elif Input.is_action_just_pressed("click"):
		getBlockHit()
		if hoveredTool != []:
			#if selectedTool == "bolt":
			#	print(selectedTool)
			#	print(hotbar.items.size())
			#	var addStr = selectedTool[0] + str(hotbar.items.size())
			#	hotbar.items.append(addStr)
			selectedTool = hoveredTool[0]
			print(selectedTool)
			
			for i in hotbar.items:
				if i.begins_with(selectedTool):
					print("ERASE!")
					hoveredTool = []
					hotbar.items.erase(i)
					hotbar.loadItems()
					hotbar.changeSelected(selectedTool)
					break
	
	#print(hotbar.items)		
		

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
						#if level < 8:
						#	level += 1
						#elif level == 8:
						#	print("WIN")
						#	level = 1
						$UI.next_lvl_popup()
				if hover.hovered[1].get_custom_data("type") == "Return" and selectedTool == "mine":
					hover.hovered[1].set_terrain(7)
					blockBreak.replace(levelNode.get_node("tileMap"), hover.hovered[2])
					selectedTool = ""
					hotbar.changeSelected(selectedTool)
					onLevelLoad()
					cratesDestroyed += 1
					if cratesDestroyed >= cratesInLevel[level-1]:
						cratesDestroyed = 0
						#if level < 8:
						#	level += 1
						#elif level == 8:
						#	print("WIN")
						#	level = 1
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
					for hoverCopy in strmHovers:
						#print(">:(")
						#print(hoverCopy.hovered)
						#if hoverCopy.hovered:
					#		print("DESTORY-")
				#			if hoverCopy.hovered.size() > 1:
				#				print("DESTROY!")
				#				if hoverCopy.hovered[1]:
				#					print("DESTROY")
						#print(tilemap)
						#print(hoverCopy.global_position)
						#print(tilemap.get_cell_tile_data(1,tilemap.local_to_map(hoverCopy.global_position)))
						tilemap.get_cell_tile_data(1,tilemap.local_to_map(hoverCopy.global_position)).set_terrain(0)
						blockBreak.destroy(levelNode.get_node("tileMap"), hoverCopy.hoveredCell)
						#print("DESTROY")
						hoverCopy.queue_free()
					selectedTool = ""
					hotbar.changeSelected(selectedTool)
					onLevelLoad()
					if blocks[crates] == []:
						if level < 8:
							level += 1
						elif level == 8:
							print("WIN")
							level = 1
						loadLevel()
