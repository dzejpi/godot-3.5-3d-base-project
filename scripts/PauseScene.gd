extends Node2D


var is_game_paused = false


func _ready():
	update_pause_state()


func _process(delta):
	if Input.is_action_just_pressed("game_pause"):
		if is_game_paused:
			is_game_paused = false
			update_pause_state()
		else:
			is_game_paused = true
			update_pause_state()


func update_pause_state():
	if is_game_paused:
		visible = true
	else:
		visible = false
