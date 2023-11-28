extends Camera2D

var mouseStartPos
var startPos

var speedFactor = 1000

func _process(delta):
	if Input.is_action_pressed("shift"):
		position += Input.get_vector("left","right","up","down")*(speedFactor*2)*delta/zoom.x
	else:
		position += Input.get_vector("left","right","up","down")*speedFactor*delta/zoom.x
	
	if Input.is_action_just_pressed("zoomin"):
		if zoom.x < 5:
			zoom *= 1.1
		
	if Input.is_action_just_pressed("zoomout"):
		if zoom.x > 0.5:
			zoom /= 1.1
		
	if Input.is_action_just_pressed("drag"):
		mouseStartPos = get_local_mouse_position()
		startPos = position
		
	if Input.is_action_pressed("drag"):
		position = startPos + (mouseStartPos-get_local_mouse_position())
