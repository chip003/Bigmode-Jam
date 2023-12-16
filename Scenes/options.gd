extends MarginContainer

func _ready():
	$MarginContainer/VBoxContainer/Horns.button_pressed = Global.roundHorns

func _on_back_pressed():
	visible = false
	get_tree().call_group("MainUI","reappear")
	get_node("/root/clicker").play()

func _on_horns_toggled(toggled_on):
	Global.roundHorns = toggled_on
