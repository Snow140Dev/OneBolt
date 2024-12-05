extends GPUParticles2D

func _ready():
	one_shot = true

func on_Timer_Timeout():
	queue_free()
