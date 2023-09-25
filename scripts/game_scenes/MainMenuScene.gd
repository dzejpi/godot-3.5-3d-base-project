extends Node2D


var time_out = 0
onready var transition_overlay_sprite = transition_overlay.get_node("TransitionSprite")


func _process(delta):
	if time_out < 1:
		time_out += (2 * delta)
		transition_overlay_sprite.modulate.a = (1 - time_out)
