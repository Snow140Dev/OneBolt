extends Control

const boltDesc = "Destroys one block."
const strmDesc = "Destroys all blocks in a \nsix-block radius."
const sctrDesc = "Destroys every other block in a\nsix-block square"
const thndDesc = "Destroys one block, \nthen destroys four bocks in a plus shape\nafter hit by a bolt."

const crateDesc = "These are your target.\nDestroy all to move to the next level."
const returnDesc = "Returns spells when destroyed. \nSpells:"
const scatterDesc = "Spreads spell put in it two \nblocks in the four directions."
const keyDesc = "Placing a mine on this block will\nunlock a door."
const doorDesc = "Keys will open this block,\nrevealing what's beneath it."
const portalDesc = "Any item placed on this block\nwill be teleported to the corresponding portal."

const _duration = 1.0
const _delay0 = 0.5
const _delay1 = 1.5
const _delay2 = 0.8

var returns = {
	[2,0,0]: ["bolt","bolt"],
	[3,-1,3]: ["strm"],
	[4,3,2]: ["bolt"],
	[4,-1,2]: ["mine"],
	[5,-1,2]: ["mine", "bolt"],
	[5,7,2]: ["bolt"],
	[6,1,2]: ["sctr"],
	[7,1,3]: ["strm"]
}

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
	if item == "sctr":
		$UI/ItemPopup/VBoxContainer/Name.text = "Scatter"
		$UI/ItemPopup/VBoxContainer/Desc.text = sctrDesc
	if item == "mine":
		$UI/ItemPopup/VBoxContainer/Name.text = "Thunder"
		$UI/ItemPopup/VBoxContainer/Desc.text = thndDesc
	
func HideItemPopup():
	%ItemPopup.hide()
	
func BlockPopup(block, contents, x, y):
	
	if block == "Crate":
		$UI/BlockPopup/VBoxContainer/Name.text = "Crate"
		$UI/BlockPopup/VBoxContainer/Desc.text = crateDesc
	elif block == "Return":
		$UI/BlockPopup/VBoxContainer/Name.text = "Return"
		$UI/BlockPopup/VBoxContainer/Desc.text = returnDesc
	elif block == "Scatter":
		$UI/BlockPopup/VBoxContainer/Name.text = "Scatter"
		$UI/BlockPopup/VBoxContainer/Desc.text = scatterDesc
	elif block == "Key":
		$UI/BlockPopup/VBoxContainer/Name.text = "Key"
		$UI/BlockPopup/VBoxContainer/Desc.text = keyDesc
	elif block == "Door":
		$UI/BlockPopup/VBoxContainer/Name.text = "Door"
		$UI/BlockPopup/VBoxContainer/Desc.text = doorDesc
	elif block == "Portal":
		$UI/BlockPopup/VBoxContainer/Name.text = "Portal"
		$UI/BlockPopup/VBoxContainer/Desc.text = portalDesc
	
	if contents:
		var contText : String
		var numItems = [0,0,0,0]
		for cont in contents:
			if cont == 'bolt':
				numItems[0] += 1
			elif cont == 'strm':
				numItems[1] += 1
			elif cont == 'mine':
				numItems[2] += 1
			elif cont == 'sctr':
				numItems[3] += 1
		if numItems[0] != 0:
			contText += 'x' + str(numItems[0]) + ' bolt '
		if numItems[1] != 0:
			print('x' + str(numItems[1]) + 'strm')
			contText += 'x' + str(numItems[1]) + ' storm '
		if numItems[2] != 0:
			contText += 'x' + str(numItems[2]) + ' thunder '
		if numItems[3] != 0:
			contText += 'x' + str(numItems[3]) + ' scatter '
		$UI/BlockPopup/VBoxContainer/Label.text = contText
	else:
		$UI/BlockPopup/VBoxContainer/Label.text = ''	
		
	%BlockPopup.popup(Rect2i(Vector2i(x,y),Vector2i(255,120)))
	
func HideBlockPopup():
	%BlockPopup.hide()
