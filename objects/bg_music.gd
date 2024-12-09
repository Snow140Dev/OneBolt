extends AudioStreamPlayer

func _ready() -> void:
	stream = load("res://assets/7 - Mild Risk Ahead.mp3")
	autoplay = true
	volume_db = 5
	process_mode = Node.PROCESS_MODE_ALWAYS
	play()
