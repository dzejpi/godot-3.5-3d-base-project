extends KinematicBody


onready var ray = $RayCast

onready var pause_scene = $UI/Pause/PauseScene
onready var game_over_scene = $UI/GameEnd/GameOverScene
onready var game_won_scene = $UI/GameEnd/GameWonScene

onready var animation_player = $PlayerCamera/AnimationPlayer
onready var player_camera = $PlayerCamera

# UI
onready var player_ui = $UI/PlayerUI
onready var typewriter_dialog = $UI/PlayerUI/TypewriterDialog
onready var tooltip = $UI/PlayerUI/Tooltip

# Movement speed
var default_speed = 100.0
var current_speed = 100.0
var increased_speed = default_speed * 4

# A small amount of gravity
var gravity = Vector3(0, -2.5, 0) 
var mouse_sensitivity = 0.75
var jump = 100

var basic_fov = 90
var increased_fov = 94
var current_fov = basic_fov

var is_paused = false
var is_game_over = false
var is_game_won = false

# Name of the observed object for debugging purposes
var observed_object = "" 


func _ready():
	is_paused = false
	player_camera.fov = basic_fov
	current_fov = basic_fov
	pause_scene.is_game_paused = false
	pause_scene.hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	transition_overlay.fade_out()
	check_game_end()


func _process(_delta):
	check_game_end()
	check_pause_update()
	
	# If player is looking at something
	if ray.is_colliding():
		var collision_object = ray.get_collider().name
		
		if collision_object != observed_object:
			observed_object = collision_object
			print("Player is looking at: " + observed_object + ".")
	else:
		var collision_object = "nothing"
		if collision_object != observed_object:
			observed_object = collision_object
			print("Player is looking at: nothing.")


func _input(event):	
	if !pause_scene.is_game_paused && !is_game_over && !is_game_won:
		
		# Hack that mostly forces the game to capture cursor in HTML5 after player presses Escape
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
		if event is InputEventMouseMotion:
			rotation_degrees.y -= event.relative.x * mouse_sensitivity / 10
			rotation_degrees.x = clamp(rotation_degrees.x - event.relative.y * mouse_sensitivity / 10, -90, 90)
	
	# Handling the options menu
	if Input.is_action_just_pressed("game_pause"):
		if !is_game_over && !is_game_won:
			handle_pause_change()


func _physics_process(delta):
	var move_direction_forward = Vector3(0, 0, 0)
	var move_direction = Vector3(0, 0, 0)
	
	if !pause_scene.is_game_paused && !is_game_over && !is_game_won:
		# Normalisation is squishing the values weirdly when sprinting
		# Therefore, the logic for moving the player forward is separate
		if Input.is_action_pressed("move_sprint"):
			if Input.is_action_pressed("move_up"):
				increase_fov()
				current_speed = increased_speed
			else:
				current_speed = default_speed
				decrease_fov()
		else:
			current_speed = default_speed
			decrease_fov()
		
		if Input.is_action_pressed("move_up"):
			move_direction_forward += -transform.basis.z
			
		move_direction_forward = move_direction_forward.normalized()
		
		var motion_forward = move_direction_forward * current_speed * delta
		motion_forward += gravity * delta
		
		motion_forward = move_and_slide(motion_forward, Vector3(0, 1, 0))
		
		# Set the default speed back so that the sprint does not have influence on other directions
		current_speed = default_speed
		
		# Separate logic for other directions
		if Input.is_action_pressed("move_down"):
			move_direction += transform.basis.z
		if Input.is_action_pressed("move_left"):
			move_direction += -transform.basis.x
		if Input.is_action_pressed("move_right"):
			move_direction += transform.basis.x
		if Input.is_action_pressed("move_jump"):
			move_direction += transform.basis.y
		if Input.is_action_pressed("move_crouch"):
			move_direction += -transform.basis.y
		
		move_direction = move_direction.normalized()
		
		var motion = move_direction * current_speed * delta
		motion += gravity * delta
		
		motion = move_and_slide(motion, Vector3(0, 1, 0))


func check_pause_update():
	if is_paused != pause_scene.is_game_paused:
		handle_on_click_pause_change()


func handle_on_click_pause_change():
	if pause_scene.is_game_paused:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		is_paused = pause_scene.is_game_paused
			
		pause_scene.show()
		player_ui.hide()
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		is_paused = pause_scene.is_game_paused
	
		pause_scene.hide()
		player_ui.show()


func handle_pause_change():
	if pause_scene.is_game_paused:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		pause_scene.is_game_paused = false
		is_paused = pause_scene.is_game_paused
			
		pause_scene.hide()
		player_ui.show()
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		pause_scene.is_game_paused = true
		is_paused = pause_scene.is_game_paused
	
		pause_scene.show()
		player_ui.hide()


func check_game_end():
	# Game is over in both cases - when player loses or wins
	if is_game_over:
		game_over_scene.show()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		pause_scene.is_game_paused = false
		pause_scene.hide()
		player_ui.hide()
	elif is_game_won:
		game_won_scene.show()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		pause_scene.is_game_paused = false
		pause_scene.hide()
		player_ui.hide()
	else:
		game_over_scene.hide()


func increase_fov():
	current_fov = player_camera.fov
	
	if current_fov < increased_fov:
		current_fov += 0.025
		change_fov(current_fov)


func decrease_fov():
	current_fov = player_camera.fov
	
	if current_fov > basic_fov:
		current_fov -= 0.1
		change_fov(current_fov)


func change_fov(player_current_fov):
	player_camera.fov = player_current_fov
