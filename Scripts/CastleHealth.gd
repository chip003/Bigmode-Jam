extends ProgressBar

func _process(delta):
	custom_minimum_size.y = lerpf(custom_minimum_size.y,32,2*delta)

func expand():
	custom_minimum_size.y = 64

func _on_value_changed(_value):
	expand()
