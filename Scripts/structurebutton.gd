extends SideButton

@export var path : String
@export var objectName : String
@export var objectSize : Vector2
@export var sprite : String

var data = null

func _ready():
	super._ready()
	data = {
		"Path": path,
		"Name": objectName,
		"Size": objectSize,
		"Price": price,
		"Sprite": sprite
	}

func _on_pressed():
	var preview = get_node("/root/MainLevel/BuildPreview")
	preview.set_new_object(data)
	get_node("/root/clicker").play()
