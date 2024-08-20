extends CharacterBody2D

const SPEED = 300.0
const DASH_SPEED = 600.0  # Dash speed is higher than normal speed
const DASH_DURATION = 0.2
const SCALE_FACTOR = 1.2 # Adjust this factor to scale the character up or down.
const MAX_SIZE = 5

var current_size = 1
var is_dashing = false
var dash_time_left = 0.0

var enflate: AudioStreamPlayer2D
var deflate: AudioStreamPlayer2D

signal request_endgame

func _ready() -> void:
	enflate = $Enflate
	deflate = $Deflate

func _physics_process(delta: float) -> void:
	
	# end current game level if max size is reached
	if(current_size>MAX_SIZE):
		end_game()
		
	# Get the input direction and handle the movement.
	var direction := Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	)

	# Handle dash
	if Input.is_action_just_pressed("ui_shift") && Globals.current_ballon_size > 0:  # Replace "ui_shift" with your dash key
		is_dashing = true
		Globals.current_ballon_size -= 1
		dash_time_left = DASH_DURATION
		deflate.play()

	if is_dashing:
		dash_time_left -= delta
		if dash_time_left <= 0:
			is_dashing = false

	# Set the velocity based on the current dash state
	if direction != Vector2.ZERO:
		if is_dashing:
			velocity = direction.normalized() * DASH_SPEED
		else:
			velocity = direction.normalized() * SPEED
	else:
		velocity = Vector2.ZERO

	# Move the character.
	move_and_slide()

	# Scale the character if spacebar is pressed.
	if Input.is_action_just_pressed("ui_accept"):  # Default key is spacebar.
		scale_character()

func scale_character() -> void:
	if !Globals.enflate_cooldown:
		enflate.play()
		# Scale the character by the scale factor.
		self.scale *= SCALE_FACTOR
		current_size += 1
		Globals.current_ballon_size += 1
		Globals.enflate_pressed = true

func end_game():
	Globals.set_game_result_won(true)
	print("setting game_result_win to true")
	emit_signal("request_endgame")
