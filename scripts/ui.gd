extends CanvasLayer

signal gameStarted

@onready var buttons = [
	$MainMenu/levelSelectButton,
	$MainMenu/playButton,
	$LevelSelect/Level1,
	$LevelSelect/Level2,
	$LevelSelect/Level3,
	$LevelSelect/Level4,
	$LevelSelect/Level5,
	$LevelSelect/Level6,
	$LevelSelect/Level7,
	$LevelSelect/Level8,
	$LevelSelect/Back
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for btn in buttons:
		btn_hovered(btn)
		
func btn_hovered(button):
	if button.is_hovered():
		button.get_node("Sprite2D").self_modulate = Color8(230, 255, 0)
	else:
		button.get_node("Sprite2D").self_modulate = Color8(255, 255, 255)

func play_pressed():
	$MainMenu.visible = false
	
	emit_signal("gameStarted")
	
func level_select_pressed():
	$MainMenu.visible = false
	$LevelSelect.visible = true
	
func back_pressed():
	$MainMenu.visible = true
	$LevelSelect.visible = false
	

func level_pressed(lvl: int) -> void:
	$MainMenu.visible = false
	$LevelSelect.visible = false
	
	get_parent().level = lvl
	
	emit_signal("gameStarted")
