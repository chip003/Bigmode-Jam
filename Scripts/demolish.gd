extends Area2D

var timer = 1

func _physics_process(delta):
	var bodies = get_overlapping_bodies()
	
	if bodies.size() > 0:
		for b in bodies:
			if b is Buildable:
				bodies[0].queue_free()
				
				for i in range(4):
					var part = load("res://Scenes/effect_water.tscn").instantiate()
					part.position = global_position + Vector2(randf_range(-16, 16), randf_range(-16, 16))
					get_parent().add_child(part)
				
				var player = get_node("../BuildPreview/AudioStreamPlayer")
							
				player.pitch_scale = randf_range(0.75,1.25)
				player.stream = load("res://Sounds/splash" + Global.choose(["1.wav","2.wav","3.wav"]))
				player.play()
				
				queue_free()
	
	if timer <= 0:
		queue_free()
	else:
		timer -= 1
