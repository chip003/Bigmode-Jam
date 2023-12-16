class_name SideButton extends Button

@export var price = 100
@export var demolish = false
@onready var par = get_node("/root/MainLevel")

func _ready():
	if !demolish:
		$MarginContainer/HBoxContainer/Label.text = str(price)

func _process(delta):
	if par.gold >= price:
		if !demolish:
			$MarginContainer/HBoxContainer/Label.modulate = Color(1,1,1,1)
		if par.buildMode && !par.get_node("BuildPreview").active:
			disabled = false
		else:
			disabled = true
	else:
		disabled = true
		if !demolish:
			$MarginContainer/HBoxContainer/Label.modulate = Color(1,0,0,1)

func update_price(newPrice):
	price = newPrice
	if !demolish:
		$MarginContainer/HBoxContainer/Label.text = str(price)
