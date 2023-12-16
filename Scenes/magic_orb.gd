extends Turret

var sinOffset = 0
	
func _process(delta):
	super._process(delta)
	sinOffset += 1*delta
	$Top.offset.y = sin(sinOffset)*4
	
