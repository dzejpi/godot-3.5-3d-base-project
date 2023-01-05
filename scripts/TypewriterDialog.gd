extends Node2D


var letter_change_speed = 16
var displayed_text_timeout = 0
var dialog_timeout = 0
var dialog_timeout_time = 1
var dialog_switch_timeout = 0
var dialog_switch_timeout_time = 4
var dialog_text_array = ["This is the first text.", "This is the second one.", "And the last, third one."]

var displayed_dialog_array_number = 0
var currently_displayed_character = 0
var current_dialog = ""

var processing_dialog = true
var text_fully_displayed = false

onready var text_label = $TextBgSprite/TextLabel


func _ready():
	visible = true


func _process(delta):
	if processing_dialog:
		process_dialog(delta)
	else:
		visible = false


func start_dialog(delta):
	visible = true
	processing_dialog = true
	displayed_dialog_array_number = 0
	currently_displayed_character = 0
	
	process_dialog(delta)


func process_dialog(delta):
	var text_length_of_array = dialog_text_array[displayed_dialog_array_number].length()
	var last_array_position = dialog_text_array.size() - 1;
		
	if Input.is_action_just_pressed("dialog_end"):
		if currently_displayed_character < text_length_of_array:
			currently_displayed_character = text_length_of_array
		else:
			displayed_dialog_array_number += 1
			if displayed_dialog_array_number > last_array_position:
				processing_dialog = false
			else:
				currently_displayed_character = 0
	else:
		if dialog_timeout < dialog_timeout_time:
			dialog_timeout += (letter_change_speed * delta)
		else:
			dialog_timeout = 0
			if currently_displayed_character < text_length_of_array:
				currently_displayed_character += 1
			
			if currently_displayed_character == text_length_of_array:
				if dialog_switch_timeout < dialog_switch_timeout_time:
					dialog_switch_timeout += (letter_change_speed * delta)
				else:
					dialog_switch_timeout = 0
					displayed_dialog_array_number += 1
					if displayed_dialog_array_number > last_array_position:
						processing_dialog = false
					else:
						currently_displayed_character = 0
	
	if displayed_dialog_array_number > last_array_position:
		processing_dialog = false
	else:
		text_label.text = dialog_text_array[displayed_dialog_array_number].left(currently_displayed_character)
