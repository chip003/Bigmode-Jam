extends CPUParticles2D

func _ready():
	restart()

func _on_finished():
	queue_free()
