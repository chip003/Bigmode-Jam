extends Control

func toggle_pause():
	if get_tree().paused:
		get_tree().paused = false
		visible = false
	else:
		get_tree().paused = true
		visible = true

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		toggle_pause()


func _on_resume_pressed():
	get_node("/root/clicker").play()
	toggle_pause()


func _on_main_menu_pressed():
	get_node("/root/clicker").play()
	toggle_pause()
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")


func _on_options_pressed():
	get_node("/root/clicker").play()
	$Options.visible = true
	$MarginContainer.visible = false
	
