extends Node2D

var moatRadius = Vector2(16,12)
var gold = 100
var day = 1

func _process(delta):
	$Canvas/UI/LeftVBox/MarginContainer/MarginContainer/VBoxContainer/Gold/Label.text = str(gold)
	$Canvas/UI/LeftVBox/Days/MarginContainer/Label.text = "DAY " + str(day)

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
				#$TileMap.set_cells_terrain_path(0,[Vector2i(currentX,currentY)],0,1)
			currentY += 1
			
		currentX += 1
		currentY = -moatRadius.y
		
	$TileMap.set_cells_terrain_connect(0,cells,0,1)
		
	moatRadius.x += 1
	moatRadius.y += 1

func _on_button_pressed():
	expand_moat()
