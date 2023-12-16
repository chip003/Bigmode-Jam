extends Button

func _process(delta):
	if get_node("/root/MainLevel/BuildPreview").active:
		disabled = true
	else:
		disabled = false
