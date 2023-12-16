extends Turret

func _ready():
	$Progress.max_value = shootSpeed
	

func _process(delta):
	super._process(delta)
	
	$Top.rotation -= 0.5*delta
	$Progress.value = timer
	
	if timer <= 0:
		$Progress.visible = false
	else:
		$Progress.visible = true
		
func _on_shoot(target):
	target.take_damage(damage)
