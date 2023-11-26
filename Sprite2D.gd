extends CharacterBody2D

func _ready():
	velocity = Vector2(1000,1000)

func _process(delta):
	if position.y < 0 || position.y > 648:
		velocity.y *= -1
	
	if position.x < 0 || position.x > 1152:
		velocity.x *= -1
		
	move_and_slide()
