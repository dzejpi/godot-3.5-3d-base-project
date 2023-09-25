extends TextureButton


var time_out = 0
var platform = OS.get_name()
var button_pressed = false


func _ready():
	# Disable if running in browser
	if platform == "HTML5":
		self.disabled = true


func _process(_delta):
	if button_pressed:
		if button_pressed:
			if transition_overlay.transition_completed:
				release_focus()
				get_tree().quit()


func _on_QuitGameButton_pressed():
	button_pressed = true
	transition_overlay.fade_in()
