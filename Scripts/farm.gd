extends Buildable

func _ready():
	$Box/Label.text = "+" + str(get_parent().farmValue)

func round_end():
	$Box.modulate.a = 1
	$Box.position = Vector2(-44, -20)
	
func _process(delta):
	if $Box.modulate.a > 0:
		$Box.modulate.a -= 0.5*delta
		$Box.position.y -= 20*delta
