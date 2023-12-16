class_name Turret extends Buildable

@export var shootSpeed = 3.0
@export var shootRange = 128
@export var damage = 2.5
@export var rotationOffset = 0
@export var projectileSprite = ""
@export var projectileSpeed = 500
@export var shootSound = "res://Sounds/cannon_shoot.wav"
@export var shootVolume = -10
@export var followTarget = true
@export var usesProjectile = true
@export var cooldownWhileInRange = true

var timer = 0

func _process(delta):
	var enemies = get_tree().get_nodes_in_group("Enemies")
	
	var dist = 9999
	var target = null
	
	for enemy in enemies:
		if position.distance_to(enemy.position) < dist:
			target = enemy
			dist = position.distance_to(enemy.position)
	
	if !cooldownWhileInRange:
		if timer > 0:
			timer -= 1*delta
	
	if target != null:
		if position.distance_to(target.position) < shootRange:
			var targetRotation = get_angle_to(target.position)+deg_to_rad(90+rotationOffset)
			
			if followTarget:
				$Top.rotation = lerp_angle($Top.rotation, targetRotation, 4*delta)
			
			if timer > 0:
				if cooldownWhileInRange:
					timer -= 1*delta
			else:
				if !get_parent().gameOver:
				#shoot enemy
				#target.take_damage(damage)
					timer = shootSpeed
					
					var sound = load("res://Scenes/audio_player.tscn").instantiate()
					sound.stream = load(shootSound)
					sound.position = position
					sound.volume_db = shootVolume
					sound.pitch_scale = randf_range(0.75,1.25)
					get_parent().add_child(sound)
					
					_on_shoot(target)
					
					if usesProjectile:	
						var projectile = load("res://Scenes/projectile.tscn").instantiate()
						projectile.speed = position.direction_to(target.position)*projectileSpeed
						projectile.damage = damage
						projectile.spritePath = projectileSprite
						projectile.position = position
						projectile.spriteRotation = targetRotation
							
						get_parent().add_child(projectile)

func _on_shoot(target):
	pass					
