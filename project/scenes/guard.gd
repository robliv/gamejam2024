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

func _ready() -> void:
	light = $PointLight2D
	lightDetectionArea = $Area2D/CollisionPolygon2D
	
	speed += (Globals.enemy_speed * 50)
	
	light.texture_scale += (0.2 * Globals.flashlight_size)
	light.offset += Vector2((6.2 * Globals.flashlight_size), 0)
	lightDetectionArea.scale += Vector2((0.2 * Globals.flashlight_size), (0.2 * Globals.flashlight_size))
	light.position += Vector2((6.2 * Globals.flashlight_size), 0)
	
	# Create and start the timer
	state_timer = Timer.new()
	state_timer.wait_time = 1.0
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
				# If the enemy hits a wall, change to stand or change direction
				current_state = EnemyState.STAND  # or EnemyState.CHANGE_DIRECTION

		EnemyState.STAND:
			# Do nothing, the enemy stands still
			pass

		EnemyState.CHANGE_DIRECTION:
			# Direction change is handled in the timeout function
			pass

# Called when the timer times out
func _on_state_timer_timeout() -> void:
	# Randomly select the next state
	var random_state = randi() % 3
	current_state = random_state
	
	if current_state == EnemyState.CHANGE_DIRECTION:
		# Randomly choose a new direction and rotate the enemy accordingly
		var random_angle_degrees = randi() % 360
		var random_angle_radians = deg_to_rad(random_angle_degrees)
	
		# Calculate the direction vector based on the random angle
		direction = Vector2(cos(random_angle_radians), sin(random_angle_radians)).normalized()
	
		# Set the rotation to the random angle
		rotation_degrees = random_angle_degrees


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":  # Replace with the actual name of your player node
		light.color = Color.RED
		var player = body as Player
		player.enter_light()


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player":  # Replace with the actual name of your player node
		light.color = Color.WHITE
		var player = body as Player
		player.exit_light()
