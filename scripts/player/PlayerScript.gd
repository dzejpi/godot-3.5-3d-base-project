extends KinematicBody


const SPEED = 5.0
const JUMP_VELOCITY = 4.5


onready var player_head = $PlayerHead
onready var ray = $PlayerHead/RayCast

onready var pause_scene = $UI/Pause/PauseScene
onready var game_over_scene = $UI/GameEnd/GameOverScene
onready var game_won_scene = $UI/GameEnd/GameWonScene

onready var animation_player = $PlayerHead/PlayerCamera/AnimationPlayer
onready var player_camera = $PlayerHead/PlayerCamera

# UI
onready var player_ui = $UI/PlayerUI
onready var typewriter_dialog = $UI/PlayerUI/TypewriterDialog
onready var tooltip = $UI/PlayerUI/Tooltip


var is_game_over = false
var is_game_won = false

var basic_fov = 90
var increased_fov = 91
var current_fov = basic_fov

var ground_acceleration = 8
var air_acceleration = 2
var acceleration = ground_acceleration

var slide_prevention = 10
var mouse_sensitivity = 0.75

var direction = Vector3()
var velocity = Vector3()
var movement = Vector3()
var gravity_vector = Vector3()

var is_on_ground = true
var is_paused = false

# Name of the observed object for debugging purposes
var observed_object = "" 

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


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
	
	if is_paused:
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


func _physics_process(delta):
	# Gravity
	if not is_on_floor():
		velocity.y -= gravity * delta
		is_on_ground = false
	else:
		if !is_on_ground:
			is_on_ground = true
			animation_player.play("Jump Land")
		
	# Jump
	if Input.is_action_just_pressed("move_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Input direction
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		if Input.is_action_pressed("move_sprint"):
			if !pause_scene.is_game_paused && !is_game_over && !is_game_won:
				increase_fov()
				velocity.x = direction.x * SPEED * 2
				velocity.z = direction.z * SPEED * 2
			else:
				decrease_fov()
				velocity.x = direction.x * 0
				velocity.z = direction.z * 0
		else:
			decrease_fov()
			if !pause_scene.is_game_paused && !is_game_over && !is_game_won:
				velocity.x = direction.x * SPEED
				velocity.z = direction.z * SPEED
			else:
				velocity.x = direction.x * 0
				velocity.z = direction.z * 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	move_and_slide(velocity, Vector3.UP)


func _input(event):
	# Looking around
	if !pause_scene.is_game_paused && !is_game_over && !is_game_won:
		
		# Hack that usually forces the game to capture cursor in HTML5 after player presses Escape and then goes back
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
		if event is InputEventMouseMotion:
			rotation_degrees.y -= event.relative.x * mouse_sensitivity / 10
			player_head.rotation_degrees.x = clamp(player_head.rotation_degrees.x - event.relative.y * mouse_sensitivity / 10, -90, 90)
	
	# Handling the options menu
	if Input.is_action_just_pressed("game_pause"):
		if !is_game_over && !is_game_won:
			handle_pause_change()


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
		current_fov += 0.1
		change_fov(current_fov)


func decrease_fov():
	current_fov = player_camera.fov
	
	if current_fov > basic_fov:
		current_fov -= 0.2
		change_fov(current_fov)


func change_fov(player_current_fov):
	player_camera.fov = player_current_fov
