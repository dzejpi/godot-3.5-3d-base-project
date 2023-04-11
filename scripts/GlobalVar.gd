extends Node


onready var sfx_node = $SfxPlayer
onready var music_node = $MusicPlayer

var is_game_over = false


func _ready():
	initialise_variables()


func initialise_variables():
	pass
