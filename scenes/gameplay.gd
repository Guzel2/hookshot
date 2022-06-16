extends Node2D

onready var player = $player
onready var player_display = $player_display
onready var hook = $hook
onready var level = $level

var cell_size = 8

var paused = false

var block = 0

func _ready():
	hook.ready()
	player_display.ready()
	level.ready()

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		paused = !paused
		if paused:
			player.set_process(false)
			player.set_physics_process(false)
		else:
			player.set_process(true)
			player.set_physics_process(true)
			print('test')
			level.print_level()
	
	if paused:
		if Input.is_action_pressed("click"):
			var pos = get_global_mouse_position()
			level.set_cell(floor(pos.x/cell_size), floor(pos.y/cell_size), block)
		if Input.is_action_pressed("right_click"):
			var pos = get_global_mouse_position()
			level.set_cell(floor(pos.x/cell_size), floor(pos.y/cell_size), -1)
		
		if Input.is_action_just_pressed("ui_accept"):
			block += 1
			block %= 3
