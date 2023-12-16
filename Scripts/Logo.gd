extends TextureRect


func _process(delta):
	if get_node("/root/MainMenu").logoMove:
		pivot_offset.y = lerpf(pivot_offset.y,0,1*delta)
