extends Area2D

var active = false
var data = null

func set_new_object(newData):
	active = true
	data = newData
	$Sprite.texture = load(data.Sprite)
	$CollisionShape2D.shape.size = data.Size-Vector2(1,1)

func _process(delta):
	if active:
		if !visible:
			visible = true
			
		if Input.is_action_just_pressed("rightclick"):
			active = false
	else:
		visible = false
		
func _physics_process(delta):
	if active:
		if data != null:
			
			if get_parent().gold < data.Price:
				active = false
			
			var bodies = get_overlapping_bodies()
			
			if bodies.size() == 0 || data.Name == "Demolish":
				if data.Name == "Demolish":
					modulate = Color(1,1,1,1)
				else:
					modulate = Color(0.25,1,0.25,0.5)
				if Input.is_action_just_pressed("leftclick"):
					var object = load(data.Path).instantiate()
					object.position = global_position
					get_parent().add_child(object)
					get_parent().gold -= data.Price
					
					if data.Name != "Demolish":
						for i in range((data.Size.x/32)*2):
							var part = load("res://Scenes/effect_water.tscn").instantiate()
							part.position = global_position + Vector2(randf_range(-data.Size.x/2, data.Size.x/2), randf_range(-data.Size.x/2, data.Size.x/2))
							get_parent().add_child(part)
							

						$AudioStreamPlayer.pitch_scale = randf_range(0.75,1.25)
						$AudioStreamPlayer.stream = load("res://Sounds/splash" + Global.choose(["1.wav","2.wav","3.wav"]))
						$AudioStreamPlayer.play()
			else:
				modulate = Color(1,0.25,0.25,0.5)
				
			if int(data.Size.x)/32 % 2 == 0:
				global_position = get_global_mouse_position().snapped(Vector2(32,32))
			else:
				global_position = (get_global_mouse_position()+Vector2(16,16)).snapped(Vector2(32,32))-Vector2(16,16)
