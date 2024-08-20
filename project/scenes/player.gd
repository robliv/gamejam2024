extends CharacterBody2D

class_name Player

const SPEED = 300.0
const DASH_SPEED = 900.0  # Dash speed is higher than normal speed
const DASH_DURATION = 0.3
const SCALE_FACTOR = 1.5 # Adjust this factor to scale the character up or down.
const MAX_SIZE = 5

var current_size = 1
var is_dashing = false
var dash_time_left = 0.0
var dash_direction = Vector2.ZERO

var enflate: AudioStreamPlayer2D
var deflate: AudioStreamPlayer2D

var particles: CPUParticles2D

var lightAreasEntered: int = 0

signal request_endgame

func _ready() -> void:
	enflate = $Enflate
	deflate = $Deflate
	particles = $CPUParticles2D

func _physics_process(delta: float) -> void:
	
	# end current game level if max size is reached
	if(current_size>MAX_SIZE):
		end_game(true)
		
	# Get the input direction and handle the movement.
	var direction := Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	)
	
	

	# Handle dash
	if Input.is_action_just_pressed("ui_shift") and Globals.current_ballon_size > 0:  # Replace "ui_shift" with your dash key
		is_dashing = true
		self.scale /= SCALE_FACTOR
		Globals.current_ballon_size -= 1
		current_size -= 1
		dash_time_left = DASH_DURATION
		dash_direction = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized()  # Generate a random direction
		var opposite_direction = -dash_direction
		particles.direction = opposite_direction
		particles.emitting = true
		deflate.play()

	if is_dashing:
		dash_time_left -= delta
		if dash_time_left <= 0:
			is_dashing = false

	# Set the velocity based on the current dash state
	if is_dashing:
		velocity = dash_direction * DASH_SPEED
	else:
		if direction != Vector2.ZERO:
			velocity = direction.normalized() * SPEED
		else:
			velocity = Vector2.ZERO

	# Move the character.
	move_and_slide()

	# Scale the character if spacebar is pressed.
	#if Input.is_action_just_pressed("ui_accept"):  # Default key is spacebar.
		#scale_character()

func scale_character() -> void:
	enflate.play()
	# Scale the character by the scale factor.
	self.scale *= SCALE_FACTOR
	current_size += 1
	Globals.current_ballon_size += 1

func _process(delta: float) -> void:
	if Globals.game_over:
		end_game(false)

func end_game(win: bool):
	Globals.set_game_result_won(win)
	emit_signal("request_endgame")
	
func enter_light():
	Globals.player_enetered_light = true
	lightAreasEntered += 1
	
func exit_light():
	Globals.player_exited_light = true
	lightAreasEntered -= 1
