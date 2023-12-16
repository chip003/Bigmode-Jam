extends Button

func _on_pressed():
	get_parent().get_parent().get_parent().visible = false
	get_tree().call_group("MainUI","reappear")
	get_node("/root/clicker").play()
