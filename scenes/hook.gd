extends TileMap

onready var parent = get_parent()

var player
var target_pos = Vector2(0, 0)

var display_range = 0

func ready():
	player = parent.player

func _process(delta):
	if player.mouse_pressed:
		if display_range > 0:
			display_range = 0
		clear()
		
		var length = floor((target_pos-player.position).length())
		var dir = (target_pos-player.position).normalized()
		
		var x = player.position.x
		var y = player.position.y
		
		var old_x = floor(x)
		var old_y = floor(y)
		
		var old_distance = 120
		
		var tiles_to_check = []
		
		while length > 0:
			
			if old_x == floor(x) and old_y == floor(y):
				x += dir.x
				y += dir.y
			else:
				var x_floor = floor(x)
				var y_floor = floor(y)
				
				set_cell(x_floor, y_floor, 0)
				old_x = x_floor
				old_y = y_floor
				
				tiles_to_check.append(Vector2(x_floor, y_floor))
				
				length -= 1
			
			if Vector2(x, y).distance_to(target_pos) > old_distance:
				length = 0
			else:
				old_distance = Vector2(x, y).distance_to(target_pos)
		
		#removes additional tiles, does not work properly5
		#var tiles_to_remove = []
		
		#for tile in tiles_to_check:
		#	var adjacent = 0
		#	
		#	if get_cell(tile.x, tile.y-1) == 0:
		#		adjacent += 1
		#	if get_cell(tile.x, tile.y+1) == 0:
		#		adjacent += 1
		#	if get_cell(tile.x-1, tile.y) == 0:
		#		adjacent += 1
		#	if get_cell(tile.x+1, tile.y) == 0:
		#		adjacent += 1
		#	
		#	if adjacent > 1:
		#		set_cell(tile.x, tile.y, -1)
		pass
	
	if display_range:
		clear()
		
		var length = floor((target_pos-player.position).length())
		var dir = (target_pos-player.position).normalized()
		
		var x = player.position.x
		var y = player.position.y
		
		var old_x = floor(x)
		var old_y = floor(y)
		
		var old_distance = 120
		
		var tiles_to_check = []
		
		while length > 0:
			
			if old_x == floor(x) and old_y == floor(y):
				x += dir.x
				y += dir.y
			else:
				var x_floor = floor(x)
				var y_floor = floor(y)
				
				set_cell(x_floor, y_floor, 1)
				old_x = x_floor
				old_y = y_floor
				
				tiles_to_check.append(Vector2(x_floor, y_floor))
				
				length -= 1
			
			if Vector2(x, y).distance_to(target_pos) > old_distance:
				length = 0
			else:
				old_distance = Vector2(x, y).distance_to(target_pos)
		
		display_range -= delta*60
		if display_range <= 0:
			display_range = 0
			clear()
