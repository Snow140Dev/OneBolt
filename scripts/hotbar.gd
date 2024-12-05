extends Node2D


var items = ["bolt1", "strm2"]

@onready var selectedItemsVeiw = [$selectedVeiw/bolt, $selectedVeiw/strm]


@onready var prevItems = [get_node("Item")]

@onready var itemScene = preload("res://objects/item.tscn")

func _ready() -> void:
	loadItems()

func changeSelected(tool):
	for hideTool in selectedItemsVeiw:
		hideTool.visible = false
	if tool == "bolt": selectedItemsVeiw[0].visible = true
	if tool == "strm": selectedItemsVeiw[1].visible = true
	
func loadItems():
	for prev in prevItems:
		if prev:
			prev.queue_free()
	for item in items:
		prevItems = []
		var newItem = itemScene.instantiate()
		var pos = items.bsearch(item, false)
		newItem.name = "Item" + str(pos)
		newItem.type = item.erase(4, 10)
		newItem.position.y = 31
		newItem.position.x = 25 + 30*(pos - 1)
		add_child(newItem)
		prevItems.append(get_node(str(newItem.name)))
		
