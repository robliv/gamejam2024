extends CharacterBody2D

const SPEED = 300.0
const SCALE_FACTOR = 1.2 # Adjust this factor to scale the character up or down.
const MAX_SIZE = 5

var current_size = 1

var audio: AudioStreamPlayer2D

signal request_endgame

func _ready() -> void:
	audio = $AudioStreamPlayer2D

func _physics_process(delta: float) -> void:
	
	# end current game level if max size is reached
	if(current_size>MAX_SIZE):
		end_game()
		
	# Get the input direction and handle the movement.
	var direction := Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	)

	# If there's input, set the velocity in that direction.
	if direction != Vector2.ZERO:
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
		audio.play()
		# Scale the character by the scale factor.
		self.scale *= SCALE_FACTOR
		current_size += 1
		Globals.current_ballon_size += 1
		Globals.enflate_pressed = true

func end_game():
	Globals.set_game_result_won(true)
	print("setting game_result_win to true")
	emit_signal("request_endgame")
