extends CenterContainer

var curText = 1
var index = 0

var speed = 0.05
var curTime = 0

var startSound = true

func _ready():
	if !Global.intro:
		get_parent().modulate.a = 0
		curText = 8
		startSound = false

func _process(delta):
	if curText < 8:
		var currentNode = get_node(str(curText))
		
		if currentNode != null:
			currentNode.visible = true
			currentNode.visible_characters = index
			
			if index < currentNode.text.length()-16:
				if curTime > 0:
					curTime -= 1*delta
				else:
					curTime = speed
					index += 1
					$AudioStreamPlayer.play()
					
			if Input.is_action_just_pressed("leftclick"):
				index = 0
				curTime = 0
				currentNode.visible = false
				curText += 1
	else:
		if startSound:
			startSound = false
			$Opening.play()
			
		get_parent().modulate.a -= 1*delta
		
		if get_parent().modulate.a < 0.5:
			get_parent().mouse_filter = Control.MOUSE_FILTER_IGNORE
			get_node("/root/MainMenu").logoMove = true

		get_node("/root/ambience").volume_db = -35
