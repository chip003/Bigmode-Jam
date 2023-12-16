extends Node2D

var moatRadius = Vector2(16,12)
var gold = 300
var goldPerDay = 100
var day = 1
var moatSizeMultiply = 0

var maxHP = 20
var maxRep = 20

var hp = maxHP
var rep = maxRep

var moatLength = 0
var buildMode = true

var bridges
var spawners

var totalSpawnCount = 1
var spawnCount = 1
var lastSpawnCount = 1

var spawnerCooldown = 3
var spawnerTimer = 0

var gameOver = false

var startNewRound = true 
var fade = false

var farmValue = 30
var regen = 0

var enemyList = ["res://Scenes/enemyMeleeBasic.tscn"]

func _ready():
	bridges = get_tree().get_nodes_in_group("Bridges")
	spawners = get_tree().get_nodes_in_group("Spawners")

func _process(delta):
	
	if fade:
		if $Canvas/Screen.modulate.a > 0:
			$Canvas/Screen.modulate.a -= 4*delta
	else:
		if $Canvas/Screen.modulate.a < 1:
			$Canvas/Screen.modulate.a += 4*delta
		
	goldPerDay = 100 + get_tree().get_nodes_in_group("Farms").size()*farmValue
	
	if hp <= 0 && !gameOver:
		$GameOver.play()
		gameOver = true
		$Canvas/Screen/GameOver.visible = true
	
	$Canvas/Screen/UI/RightVBox/CastleHealth/MarginContainer/Label.text = str(hp) + "/" + str(maxHP) + " "
	$Canvas/Screen/UI/RightVBox/Reputation/MarginContainer/Label.text = "" + str(rep) + "/" + str(maxRep)
	
	$Canvas/Screen/UI/RightVBox/CastleHealth.max_value = maxHP
	$Canvas/Screen/UI/RightVBox/CastleHealth.value = hp
	if regen > 0:
		$Canvas/Screen/UI/RightVBox/CastleHealth/MarginContainer/HBoxContainer/PerTurn.text = "+" + str(regen)
	else:
		$Canvas/Screen/UI/RightVBox/CastleHealth/MarginContainer/HBoxContainer/PerTurn.text = ""
	#$Canvas/Screen/UI/RightVBox/Reputation.max_value = maxRep
	#$Canvas/Screen/UI/RightVBox/Reputation.value = rep
	
	$Canvas/Screen/UI/LeftVBox/MarginContainer/MarginContainer/VBoxContainer/Gold/Label.text = str(gold)
	$Canvas/Screen/UI/LeftVBox/MarginContainer/MarginContainer/VBoxContainer/Gold/PerTurn.text = str(goldPerDay)
	$Canvas/Screen/UI/LeftVBox/Days/MarginContainer/Label.text = "DAY " + str(day)
	
	if buildMode:
		moatLength = lerpf(moatLength, 192+(32*moatSizeMultiply), 1*delta)
		$Canvas/Screen/UI/Bottom/MarginContainer/VBoxContainer/Label.text = "BUILD MODE"
		$Canvas/Screen/UI/Bottom/MarginContainer/VBoxContainer/Button.visible = true
	else:
		moatLength = lerpf(moatLength, 0, 1*delta)
		$Canvas/Screen/UI/Bottom/MarginContainer/VBoxContainer/Label.text = "BATTLE MODE\n" + str(totalSpawnCount) + " ENEMIES REMAIN"
		$Canvas/Screen/UI/Bottom/MarginContainer/VBoxContainer/Button.visible = false
		
	for bridge in bridges:
		bridge.size.y = moatLength
		
	if !buildMode:
		if startNewRound:
			#ran on start of round
			if Global.roundHorns:
				$RoundStart.play()
			startNewRound = false
			
		if spawnCount > 0:
			spawnerTimer -= 1*delta
			
			if spawnerTimer <= 0:
				#spawn enemies
				spawnerTimer = spawnerCooldown
				spawnCount -= 1
				
				var num = randi_range(0,spawners.size()-1)
				var selectedSpawner = spawners[num]
				
				var enemy = load(enemyList[randi_range(0,enemyList.size()-1)]).instantiate()
				
				var rand = 24
				
				enemy.position = selectedSpawner.position + Vector2(randf_range(-rand,rand),randf_range(-rand,rand))
				enemy.dir = selectedSpawner.dir
				add_child(enemy)
			
			
		if totalSpawnCount <= 0 && !gameOver:
			#round is over
			
			get_tree().call_group("Farms", "round_end")
			
			hp += regen
			
			if Global.roundHorns:
				$RoundEnd.play()
				
			buildMode = true
			startNewRound = true
			day += 1
			gold += goldPerDay
			spawnCount = lastSpawnCount + max(1, randi_range(int(day/8),int(day/4)))
			lastSpawnCount = spawnCount
			totalSpawnCount = spawnCount
			spawnerCooldown = 3.0/(spawnCount/3.0)
			
			if day == 10:
				enemyList.push_back("res://Scenes/enemyMeleeSpecial.tscn")
			if day == 20:
				enemyList.push_back("res://Scenes/enemyMeleeHeavy.tscn")
			if day == 30:
				enemyList.push_back("res://Scenes/enemyBomber.tscn")
			if day == 35:
				enemyList.remove_at(0)
			if day == 40:
				enemyList.push_back("res://Scenes/enemyMeleeHeavySpecial.tscn")
			if day == 45:
				enemyList.remove_at(0)
			if day == 50:
				enemyList.push_back("res://Scenes/enemyOgre.tscn")

func expand_moat():

	var width = moatRadius.x*2
	var height = moatRadius.y*2
	
	var currentX = -moatRadius.x
	var currentY = -moatRadius.y
	
	var cells = []
	
	for x in range(width):
		for y in range(height):
			if (x == 0 || x == width-1) || (y == 0 || y == height-1):
				$TileMap.set_cell(0,Vector2i(currentX,currentY), 0, Vector2i(4,1))
				cells.push_back(Vector2i(currentX,currentY))
				
				#var part = load("res://Scenes/effect_water.tscn").instantiate()
				#part.global_position = Vector2(currentX,currentY)*32
				#add_child(part)
				
				#$TileMap.set_cells_terrain_path(0,[Vector2i(currentX,currentY)],0,1)
			currentY += 1
			
		currentX += 1
		currentY = -moatRadius.y
		
	$TileMap.set_cells_terrain_connect(0,cells,0,1)
		
	moatRadius.x += 1
	moatRadius.y += 1
	moatSizeMultiply += 1
	
	for s in spawners:
		s.position -= s.dir*32

func attack(damage):
	hp -= damage
	$Camera2D.shake = clamp($Camera2D.shake+damage,0,5)

func _on_moat_button_pressed():
	get_node("/root/clicker").play()
	var button = $Canvas/Screen/UI/LeftVBox/MarginContainer/MarginContainer/VBoxContainer/Moat/MoatButton
	gold -= button.price
	$Canvas/Screen/UI/LeftVBox/MarginContainer/MarginContainer/VBoxContainer/Moat/MoatButton.update_price($Canvas/Screen/UI/LeftVBox/MarginContainer/MarginContainer/VBoxContainer/Moat/MoatButton.price*2)
	expand_moat()
	$BigSplash.play()


func change_health(newMax):
	maxHP = newMax
	if hp > maxHP:
		hp = maxHP


func _on_button_pressed():
	get_node("/root/clicker").play()
	if buildMode:
		buildMode = false


func _on_main_menu_pressed():
	get_node("/root/clicker").play()
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")


func _on_replay_pressed():
	get_node("/root/clicker").play()
	get_tree().reload_current_scene()


func _on_max_health_button_pressed():
	get_node("/root/clicker").play()
	var button = $Canvas/Screen/UI/LeftVBox/MarginContainer/MarginContainer/VBoxContainer/MaxHealth/MaxHealthButton
	gold -= button.price
	change_health(maxHP + 20)
	$Canvas/Screen/UI/RightVBox/CastleHealth.expand()


func _on_regen_button_pressed():
	get_node("/root/clicker").play()
	var button = $Canvas/Screen/UI/LeftVBox/MarginContainer/MarginContainer/VBoxContainer/Regen/RegenButton
	gold -= button.price
	regen += 1
	button.update_price(button.price*2)
	$Canvas/Screen/UI/RightVBox/CastleHealth.expand()
