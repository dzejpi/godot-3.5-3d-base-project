extends Node2D


var is_game_paused = false


func _ready():
	update_pause_state()


func _process(_delta):
	if Input.is_action_just_pressed("game_pause"):
		if is_game_paused:
			GlobalVar.is_game_paused = false
			update_pause_state()
		else:
			GlobalVar.is_game_paused = true
			update_pause_state()


func update_pause_state():
	is_game_paused = GlobalVar.is_game_paused
	
	if is_game_paused:
		visible = true
	else:
		visible = false
