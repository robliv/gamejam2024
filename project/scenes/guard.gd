extends CharacterBody2D

# Define possible states for the enemy
enum EnemyState { MOVE_FORWARD, STAND, CHANGE_DIRECTION }

# Variables to hold the current state and direction
var current_state: EnemyState = EnemyState.STAND
var direction: Vector2 = Vector2.RIGHT

# Speed at which the enemy moves
var speed: float = 100.0

# Timer to control the state change interval
var state_timer: Timer

var light: PointLight2D
var lightDetectionArea: CollisionPolygon2D

var alertAudio: AudioStreamPlayer2D

var detected: bool = false

var target_rotation_degrees: float
var rotation_speed: float = 100.0 

func _ready() -> void:
	light = $PointLight2D
	lightDetectionArea = $Area2D/CollisionPolygon2D
	alertAudio = $AudioStreamPlayer2D
	
	speed += (Globals.enemy_speed * 50)
	rotation_speed += (Globals.enemy_speed * 50)
	
	light.texture_scale += (0.2 * Globals.flashlight_size)
	light.offset += Vector2((6.2 * Globals.flashlight_size), 0)
	lightDetectionArea.scale += Vector2((0.2 * Globals.flashlight_size), (0.2 * Globals.flashlight_size))
	light.position += Vector2((6.2 * Globals.flashlight_size), 0)
	
	# Create and start the timer
	state_timer = Timer.new()
	
	state_timer.wait_time = 0.5
	state_timer.timeout.connect(_on_state_timer_timeout)
	add_child(state_timer)
	state_timer.start()
	

func _physics_process(delta: float) -> void:
	# Handle enemy movement based on the current state
	match current_state:
		EnemyState.MOVE_FORWARD:
			# Set the velocity based on the direction and speed
			velocity = direction * speed
			move_and_slide()  # Move the enemy and handle collisions
			
			# Check for collisions and react accordingly
			if is_on_wall():
				direction = -direction
				rotation_degrees = direction.angle() * 180 / PI

		EnemyState.STAND:
			# Do nothing, the enemy stands still
			pass

		EnemyState.CHANGE_DIRECTION:
			var angle_difference = wrapf(target_rotation_degrees - rotation_degrees, -180.0, 180.0)

			# Determine the step to rotate based on the rotation speed and delta time
			var step = rotation_speed * delta

			# If the angle difference is small, snap to the target
			if abs(angle_difference) <= step:
				rotation_degrees = target_rotation_degrees
			else:
				# Rotate towards the target angle, considering the shortest path
				rotation_degrees += sign(angle_difference) * step

			# Update the direction vector based on the current rotation
			direction = Vector2(cos(deg_to_rad(rotation_degrees)), sin(deg_to_rad(rotation_degrees))).normalized()

# Called when the timer times out
func _on_state_timer_timeout() -> void:
	# Randomly select the next state
	if detected:
		current_state = EnemyState.STAND
		return
	
	var random_state = randi() % 3
	current_state = random_state
	
	if current_state == EnemyState.CHANGE_DIRECTION:
		target_rotation_degrees = randi() % 360
		state_timer.wait_time = randf_range(1, 2)
	elif current_state == EnemyState.STAND:
		state_timer.wait_time = 0.1
	elif current_state == EnemyState.MOVE_FORWARD:
		state_timer.wait_time = randf_range(1, 2)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":  # Replace with the actual name of your player node
		light.color = Color.RED
		var player = body as Player
		player.enter_light()
		alertAudio.play()
		detected = true
	elif body.name == "TileMapLayer":
		current_state = EnemyState.CHANGE_DIRECTION


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player":  # Replace with the actual name of your player node
		light.color = Color.WHITE
		var player = body as Player
		player.exit_light()
		alertAudio.stop()
		detected = false
