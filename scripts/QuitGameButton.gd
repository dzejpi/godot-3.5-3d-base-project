extends TextureButton


var platform = OS.get_name()
var button_pressed = false
onready var transition_overlay = $"../../TransitionOverlay"


func _ready():
	# Disable if running in browser
	if platform == "HTML5":
		self.disabled = true


func _process(delta):
	if button_pressed:
		if transition_overlay.time_out == 1:
			release_focus()
			get_tree().quit()

func _on_QuitGameButton_pressed():
	button_pressed = true
	transition_overlay.time_out = 1
