extends KinematicBody2D

onready var parent = get_parent()
onready var col = $CollisionShape2D

onready var ray = $RayCast2D

var gravity = .06
var air_friction = .975
var ground_friction = .8
var dir = Vector2(0, 0)

var hook_strength = Vector2(.15, .25)
var hook_range = 70

var movement_dir = Vector2(0, 0)
var jump_pressed = 0
var jump_buffer = 8
var air_timer = 0
var hsp = .08
var vsp = -1.4

var mouse_pressed = false
var target_pos = Vector2(0, 0)
var old_target_pos

var grounded = true

var cell_size

var player_spawn = Vector2(180, 20)

var should_time = false
var timer = 0
var all_times = []

func _ready():
	cell_size = parent.cell_size

func _process(delta):
	if should_time:
		timer += delta
	
	if Input.is_action_just_pressed("click"):
		ray.cast_to = (get_global_mouse_position() - position).normalized() * hook_range
		ray.force_raycast_update()
		
		if ray.is_colliding():
			mouse_pressed = true
			old_target_pos = ray.get_collision_point()
			parent.hook.target_pos = old_target_pos
			air_timer = jump_buffer
		else:
			parent.hook.target_pos = position + (get_global_mouse_position() - position).normalized() * hook_range
			parent.hook.display_range = 10
		
	if Input.is_action_just_released("click"):
		mouse_pressed = false
		parent.hook.clear()
	
	movement_dir = Vector2(0, 0)
	
	if Input.is_action_pressed("ui_left"):
		movement_dir.x -= hsp
	if Input.is_action_pressed("ui_right"):
		movement_dir.x += hsp
	
	if Input.is_action_just_pressed("ui_accept"):
		jump_pressed = jump_buffer
	elif jump_pressed > 0:
		jump_pressed -= 1
	
	if grounded:
		if Input.is_action_pressed("ui_left"):
			movement_dir.x -= hsp*2
			movement_dir.y = .1
		if Input.is_action_pressed("ui_right"):
			movement_dir.x += hsp*2
			movement_dir.y = .1
		
		if jump_pressed > 0:
			movement_dir.y = vsp
			jump_pressed = 0
		air_timer = 0
	else:
		should_time = true
		if air_timer < jump_buffer:
			if jump_pressed > 0:
				movement_dir.y = vsp
				jump_pressed = 0
		air_timer += 1

func _physics_process(delta):
	if mouse_pressed:
		target_pos = old_target_pos - position
		dir += (target_pos).normalized() * hook_strength
	
	dir += movement_dir
	
	if !grounded:
		dir.y += gravity
		dir.x *= air_friction
	else:
		dir.x *= ground_friction
	
	var moved = move_and_slide(dir * 60)
	
	if moved.y == 0:
		if dir.y > 0:
			grounded = true
			dir.y = 0
		elif dir.y < 0:
			dir.y = 0
	elif grounded:
		grounded = false
	
	if moved.x == 0:
		dir.x = 0
	
	var old_pos = position
	var collision = move_and_collide(dir)
	position = old_pos
	if collision != null:
		var new_vec = (collision.position + (dir))/cell_size
		
		match parent.level.get_cell(floor(new_vec.x), floor(new_vec.y)):
			0:
				pass
			1:
				mouse_pressed = false
				grounded = false
				parent.hook.clear()
				position = player_spawn
				dir = Vector2(0, 0)
			2:
				all_times.append(timer)
				timer = 0
				
				mouse_pressed = false
				grounded = false
				dir = Vector2(0, 0)
				parent.level.level += 1
				if parent.level.level > 9:
					parent.level.world += 1
					parent.level.level = 0
					col.shape.radius = 3.5
					
					var full_time = 0
					for time in len(all_times):
						print('level: ', time+1, ' time: ', all_times[time])
						full_time += all_times[time]
					
					print('total time: ', full_time)
					
				parent.level.next_level()
				parent.hook.clear()
				
				
