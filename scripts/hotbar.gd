extends Node2D


var items = ["bolt1"]

@onready var selectedItemsVeiw = [$selectedVeiw/bolt, $selectedVeiw/strm,$selectedVeiw/mine,$selectedVeiw/sctr]

@onready var itemsNode = $Items

@onready var prevItems = [get_node("Item")]

@onready var itemScene = preload("res://objects/item.tscn")

func _ready() -> void:
	loadItems()

func changeSelected(tool):
	for hideTool in selectedItemsVeiw:
		hideTool.visible = false
	if tool == "bolt": selectedItemsVeiw[0].visible = true
	elif tool == "strm": selectedItemsVeiw[1].visible = true
	elif tool == "mine": selectedItemsVeiw[2].visible = true
	elif tool == "sctr": selectedItemsVeiw[3].visible = true
	else:
		selectedItemsVeiw[1].visible = false
		selectedItemsVeiw[0].visible = false
		selectedItemsVeiw[2].visible = false
		selectedItemsVeiw[3].visible = false
	
func loadItems():
	for prev in prevItems:
		if prev:
			prev.visible = false
			prev.queue_free()
			prevItems.erase(prev)
	for item in items:
		prevItems = []
		var newItem = itemScene.instantiate()
		var pos = items.bsearch(item, false)
		newItem.name = "Item" + str(pos)
		newItem.type = item.erase(4, 10)
		newItem.position.y = 31
		newItem.position.x = 25 + 40*(pos - 1)
		add_child(newItem)
		prevItems.append(get_node(str(newItem.name)))
	print(prevItems)
		
