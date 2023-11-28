extends Camera2D

var mouseStartPos
var startPos

var speedFactor = 1000
var speed = speedFactor

var minBounds = Vector2(-1000,-1000)
var maxBounds = Vector2(1000,1000)

func _process(delta):
	if Input.is_action_pressed("shift"):
		speed = speedFactor*2
	else:
		speed = speedFactor

	position += Input.get_vector("left","right","up","down")*speedFactor*delta/zoom.x
	position = position.clamp(minBounds,maxBounds)
	
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
