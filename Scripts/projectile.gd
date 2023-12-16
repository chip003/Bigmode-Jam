extends Area2D

var damage
var spritePath
var speed
var spriteRotation

var lifespan = 2

func _process(delta):
	if lifespan > 0:
		lifespan -= 1*delta
	else:
		queue_free()
		
	position += speed*delta

func _ready():
	$Sprite.texture = load(spritePath)
	$Sprite.rotation = spriteRotation

func _on_body_entered(body):
	if body is Enemy:
		body.take_damage(damage)
		queue_free()
