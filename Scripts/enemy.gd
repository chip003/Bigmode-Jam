class_name Enemy extends CharacterBody2D

var dir = Vector2(0,-1) #xy vector to store direction
@export var stopDistance = 16
@export var acceleration = 100
@export var maxSpeed = 80
@export var damage = 1
@export var hp = 10
@export var attackTime = 1.0
@export var goldAmount = 1

@export var attackSound = "res://Sounds/lightattack.wav"
@export var deathSound = "res://Sounds/death.wav"

@onready var currentAttackTime = attackTime

var shake = 0

func _ready():
	modulate.a = 0

func on_death():
	get_parent().totalSpawnCount -= 1
	get_parent().gold += goldAmount
	var part = load("res://Scenes/effect_dust.tscn").instantiate()
	part.position = position
	get_parent().add_child(part)
		
	var sound = load("res://Scenes/audio_player.tscn").instantiate()
	sound.pitch_scale = randf_range(0.75,1.25)
	sound.stream = load(deathSound)
	sound.volume_db = -10
	sound.position = position
	get_parent().add_child(sound)
		
	queue_free()


func take_damage(takenDamage):
	hp -= takenDamage
	
	$Sprite/Damage.modulate.a = 1
	shake = 4
	
	var sound = load("res://Scenes/audio_player.tscn").instantiate()
	sound.stream = load("res://Sounds/onhit.wav")
	sound.volume_db = -20
	sound.pitch_scale = randf_range(0.5,1.5)
	sound.position = position
	get_parent().add_child(sound)

func _process(delta):
	if hp <= 0:
		on_death()
	
	$Sprite.offset = Vector2(randf_range(-shake,shake), randf_range(-shake,shake))
	
	$Sprite/Damage.modulate.a = lerpf($Sprite/Damage.modulate.a, 0, 4*delta)
	shake = lerpf(shake, 0, 4*delta)
		
	if modulate.a < 1:
		modulate.a += 1*delta
	
	var map = get_node("../TileMap")
	var tile = map.get_cell_tile_data(0,map.local_to_map(position))
	var inWater = tile.get_custom_data("water")
	
	if inWater != null:
		if inWater:
			$Sprite/WaterOverlay.visible = true
			$Sprite.offset.y = 6
		else:
			$Sprite/WaterOverlay.visible = false
			$Sprite.offset.y = 0
	
	if (!is_on_wall() && !is_on_ceiling() && !is_on_floor()):
		if velocity.length() < maxSpeed:
			velocity += dir*delta*acceleration
			$Sprite.play("walk_" + str(dir.x) + str(dir.y))
	else: #enemy has reached destination
		$Sprite.stop()
		velocity = velocity.lerp(Vector2(0,0),1-pow(0.01,delta))
		currentAttackTime -= 1*delta
		
		if currentAttackTime <= 0:
			if !get_parent().gameOver:
				currentAttackTime = attackTime
				get_parent().attack(damage)
				
				var sound = load("res://Scenes/audio_player.tscn").instantiate()
				sound.pitch_scale = randf_range(0.75,1.25)
				sound.stream = load(attackSound)
				get_parent().add_child(sound)

				var part = load("res://Scenes/effect_attack.tscn").instantiate()
				part.position = position
				get_parent().add_child(part)
				
				_on_attack()
		
	move_and_slide()
	
func _on_attack():
	pass
