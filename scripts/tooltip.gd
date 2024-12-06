extends Control

var boltDesc = "Destroys one block."
var strmDesc = "Stroys all blocks in a \nsix-block radius"

func ItemPopup(x, y, item):
	if x <= get_viewport_rect().size.x/2:
		x = x
	else:
		x = x-255-64
	%ItemPopup.popup(Rect2i(Vector2i(x,y),Vector2i(255,120)))
	
	if item == "bolt":
		$UI/ItemPopup/VBoxContainer/Name.text = "Bolt"
		$UI/ItemPopup/VBoxContainer/Desc.text = boltDesc
	if item == "strm":
		$UI/ItemPopup/VBoxContainer/Name.text = "Storm"
		$UI/ItemPopup/VBoxContainer/Desc.text = strmDesc
	
func HideItemPopup():
	%ItemPopup.hide()
	
func BlockPopup(block, contents, x, y):
	%BlockPopup.popup()
	
func HideBlockPopup():
	%BlockPopup.hide()
