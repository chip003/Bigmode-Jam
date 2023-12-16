extends Label

func _process(delta):
	text = "you survived until day " + str(get_node("/root/MainLevel").day)
