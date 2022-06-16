extends TileMap

onready var parent = get_parent()
var player

var player_pos = []

var number_of_frames = 10

var pixel_amount = 0

func ready():
	player = parent.player

func _process(_delta):
	clear()
	player_pos.push_front(player.position)
	
	while len(player_pos) > number_of_frames:
		player_pos.pop_back()
	
	draw_tail()

func draw_tail():
	var pos = len(player_pos)-1
	
	var speed = player.dir.length()
	
	if speed < 1.8:
		while pos >= 0:
			var floor_x = floor(player_pos[pos].x)
			var floor_y = floor(player_pos[pos].y)
			
			match pos:
				0:  #current pos
					draw_pixel_circle(floor_x, floor_y, 4, 2)
				1:
					draw_pixel_circle(floor_x, floor_y, 4, 3)
				2:
					draw_pixel_circle(floor_x, floor_y, 3, 1)
				3:
					draw_pixel_circle(floor_x, floor_y, 3, 3)
				4:
					draw_pixel_circle(floor_x, floor_y, 2, 1)
				5:
					draw_pixel_circle(floor_x, floor_y, 2, 2)
				6:
					draw_pixel_circle(floor_x, floor_y, 2, 2)
				7:
					draw_pixel_circle(floor_x, floor_y, 1, 1)
				8:
					draw_pixel_circle(floor_x, floor_y, 1, 1)
				9: # last pos
					set_cell(floor_x, floor_y, 0)
			pos -= 1
	
	elif speed < 2.75:
		while pos >= 0:
			var floor_x = floor(player_pos[pos].x)
			var floor_y = floor(player_pos[pos].y)
			
			match pos:
				0:  #current pos
					draw_pixel_circle(floor_x, floor_y, 4, 3)
				1:
					draw_pixel_circle(floor_x, floor_y, 3, 1)
				2:
					draw_pixel_circle(floor_x, floor_y, 3, 3)
				3:
					draw_pixel_circle(floor_x, floor_y, 2, 1)
				4:
					draw_pixel_circle(floor_x, floor_y, 2, 2)
				5:
					draw_pixel_circle(floor_x, floor_y, 1, 0)
				6:
					draw_pixel_circle(floor_x, floor_y, 1, 1)
				7:
					draw_pixel_circle(floor_x, floor_y, 1, 1)
				8:
					draw_pixel_circle(floor_x, floor_y, 1, 1)
				9: # last pos
					set_cell(floor_x, floor_y, 0)
			pos -= 1
	
	else:
		while pos >= 0:
			var floor_x = floor(player_pos[pos].x)
			var floor_y = floor(player_pos[pos].y)
			
			match pos:
				0:  #current pos
					draw_pixel_circle(floor_x, floor_y, 3, 1)
				1:
					draw_pixel_circle(floor_x, floor_y, 3, 3)
				2:
					draw_pixel_circle(floor_x, floor_y, 2, 1)
				3:
					draw_pixel_circle(floor_x, floor_y, 2, 2)
				4:
					draw_pixel_circle(floor_x, floor_y, 1, 0)
				5:
					draw_pixel_circle(floor_x, floor_y, 1, 1)
				6:
					draw_pixel_circle(floor_x, floor_y, 1, 1)
				7:
					draw_pixel_circle(floor_x, floor_y, 1, 1)
				8:
					draw_pixel_circle(floor_x, floor_y, 0, 0)
				9: # last pos
					set_cell(floor_x, floor_y, 0)
			pos -= 1

func draw_pixel_circle(floor_x, floor_y, _range, corner_size):
	for x in range(-_range, _range+1):
		for y in range(-_range, _range+1):
			if abs(x) + abs(y) <= _range*2-corner_size:
				set_cell(floor_x+x, floor_y+y, 0)

func draw_same_pixel_amount():
	var pixel_amount = 100
	
	var pos = len(player_pos) -1
	
	while pos >= 0:
		var floor_x = floor(player_pos[pos].x)
		var floor_y = floor(player_pos[pos].y)
		
		var pixel_amounts = [25, 40, 55, 65, 75, 80, 85, 90, 95, 99]
		
		if get_cell(floor_x, floor_y) == -1:
			set_cell(floor_x, floor_y, 0)
			pixel_amount -= 1
		
		while pixel_amount > pixel_amounts[pos]:
			var dir = (float(randi() % 360)) / 180*PI
			var x = float(floor_x)
			var y = float(floor_y)
			var vec = Vector2(cos(dir), sin(dir)).normalized()
			
			while get_cell(floor(x), floor(y)) == 0:
				x += vec.x
				y += vec.y
			
			set_cell(floor(x), floor(y), 0)
			
			pixel_amount -= 1
		
		pos -= 1

func draw_elipse_tail():
	
	#var dir = (get_global_mouse_position() - player.position).normalized()
	var dir = player.dir.normalized()
	
	if dir == Vector2(0, 0):
		dir = Vector2(1, 0)
	
	var degree = .9
	
	var pos = len(player_pos) -1
	while pos >= 0:
		var floor_x = floor(player_pos[pos].x)
		var floor_y = floor(player_pos[pos].y)
			
		match pos:
			0:
				draw_pixel_elipse(floor_x, floor_y, 5, degree, dir)
			1, 2, 3:
				draw_pixel_elipse(floor_x, floor_y, 4, degree, dir)
			4, 5:
				draw_pixel_elipse(floor_x, floor_y, 3, degree, dir)
			6, 7:
				draw_pixel_elipse(floor_x, floor_y, 2, degree, dir)
			8, 9:
				set_cell(floor_x, floor_y, 0)
		pos -=  1

func draw_pixel_elipse(floor_x, floor_y, _range, degree, dir):
	var corner_size = 3
	for x in range(-_range, _range+1):
		for y in range(-_range, _range+1):
			if abs(x*y) < _range * (_range - corner_size):
				var vector = Vector2(x, y).normalized()
				
				var dot = vector.dot(dir)
				
				if dot > degree or dot < -degree:
					set_cell(floor_x+x, floor_y+y, 0)
	
	draw_pixel_circle(floor_x, floor_y, _range-1, _range-2)

func draw_pixel_line(floor_x, floor_y, dir, length):
	var x = 0
	var y = 0
	
	var pixel_to_place = length
	
	var placed = []
	
	while pixel_to_place > 0:
		if !(Vector2(floor_x + floor(x), floor_y + floor(y)) in placed):
			set_cell(floor_x + floor(x), floor_y + floor(y), 0)
			pixel_to_place -= 1
			placed.append(Vector2(floor_x + floor(x), floor_y + floor(y)))
		else:
			x += dir.x
			y += dir.y
