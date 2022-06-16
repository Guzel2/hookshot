extends Node2D

onready var player = $player
onready var player_display = $player_display
onready var hook = $hook
onready var level = $level

var cell_size = 8

func _ready():
	hook.ready()
	player_display.ready()
