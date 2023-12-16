extends Node

var intro = true
var streamsMade = false
var roundHorns = true

func choose(arr):
	return arr[randi_range(0,arr.size()-1)]

func _process(delta):
	if Input.is_action_just_pressed("f11"):
		if DisplayServer.window_get_mode(0) == DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
