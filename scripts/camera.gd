extends Camera2D

@export var minZoom = 0.1
@export var maxZoom = 10

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	Zoom()
	Pan()
	ClickAndDrag()
	
func Zoom():
	if Input.is_action_just_pressed("camera_zoom_in"):
		zoom = zoom * 1.1
	elif Input.is_action_just_pressed("camera_zoom_out"):
		zoom = zoom * 0.9
	zoom.x = clamp(zoom.x, minZoom, maxZoom)
	zoom.y = clamp(zoom.y, minZoom, maxZoom)
	
func Pan():
	if Input.is_action_pressed("camera_move_left"):
		position += Vector2(-5,0)
	if Input.is_action_pressed("camera_move_right"):
		position += Vector2(5,0)
	if Input.is_action_pressed("camera_move_down"):
		position += Vector2(0,5)
	if Input.is_action_pressed("camera_move_up"):
		position += Vector2(0,-5)
	
func ClickAndDrag():
	pass