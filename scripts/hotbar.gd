extends Node2D


var items = ["bolt1", "strm2"]

@onready var prevItems = [get_node("Item")]

@onready var itemScene = preload("res://objects/item.tscn")

func _ready() -> void:
	loadItems()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	loadItems()
	
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
		
