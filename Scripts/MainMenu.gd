extends Node2D

var logoMove = false
var fade = false

func _process(delta):
	if fade:
		if $Canvas/Screen.modulate.a > 0:
			$Canvas/Screen.modulate.a -= 4*delta
		else:
			get_tree().change_scene_to_file("res://Scenes/MainLevel.tscn")
	else:
		if $Canvas/Screen.modulate.a < 1:
			$Canvas/Screen.modulate.a += 4*delta
			
			
func _ready():
	if !Global.streamsMade:
		Global.streamsMade = true
		var player = AudioStreamPlayer.new()
		player.name = "ambience"
		player.stream = load("res://Sounds/ambience.mp3")
		player.autoplay = true
		player.volume_db = -80
		player.bus = "Effects"
		player.process_mode = Node.PROCESS_MODE_ALWAYS
		add_sibling.call_deferred(player)
		
		var player2 = AudioStreamPlayer.new()
		player2.name = "clicker"
		player2.stream = load("res://Sounds/buttonclick.wav")
		player2.volume_db = -10
		player2.bus = "Effects"
		player2.process_mode = Node.PROCESS_MODE_ALWAYS
		add_sibling.call_deferred(player2)
	else:
		logoMove = true

func _on_play_pressed():
	Global.intro = false
	fade = true
	get_node("/root/clicker").play()
	
	
func _on_options_pressed():
	get_node("/root/clicker").play()
	$Canvas/Screen/Main/MarginContainer.visible = false
	$Canvas/Screen/Main/Options.visible = true


func _on_quit_pressed():
	get_node("/root/clicker").play()
	get_tree().quit()


func _on_credits_pressed():
	get_node("/root/clicker").play()
	$Canvas/Screen/Main/MarginContainer.visible = false
	$Canvas/Screen/Main/Credits.visible = true
