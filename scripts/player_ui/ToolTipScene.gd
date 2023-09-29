extends Node2D


onready var tooltip_node = $TooltipNode
onready var label = $TooltipNode/TooltipLabel

var is_tooltip_visible = false
var is_flashing_up = false
var action_required = "move_jump"

var flashing_speed = 1


func _ready():
	# Set to default values to be double sure
	is_tooltip_visible = false
	is_flashing_up = true
	tooltip_node.modulate.a = 0


func _process(delta):
	if is_tooltip_visible:
		# Switch only if necessary
		if !tooltip_node.is_visible():
			tooltip_node.show()
		process_flashing(delta)
	else:
		# Switch only if necessary
		if tooltip_node.is_visible():
			tooltip_node.hide()

func set_tooltip(tooltip_text, action_required_to_finish):
	label.text = tooltip_text
	action_required = action_required_to_finish
	
	# Reset the tooltip and start flashing it
	tooltip_node.modulate.a = 0
	is_flashing_up = true
	is_tooltip_visible = true


func _input(_event):
	if is_tooltip_visible:
		if Input.is_action_just_pressed(action_required):
			is_tooltip_visible = false


func process_flashing(delta):
	if is_flashing_up:
		if tooltip_node.modulate.a < 1:
			tooltip_node.modulate.a += flashing_speed * delta
		else:
			is_flashing_up = false
	else:
		if tooltip_node.modulate.a > 0:
			tooltip_node.modulate.a -= flashing_speed * delta
		else:
			is_flashing_up = true
	
