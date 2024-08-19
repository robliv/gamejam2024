extends Node2D

# Define possible states for the enemy
enum EnemyState { MOVE_FORWARD, STAND, CHANGE_DIRECTION }

# Variables to hold the current state and direction
var current_state: EnemyState = EnemyState.STAND
var direction: Vector2 = Vector2.RIGHT

# Speed at which the enemy moves
var speed: float = 100.0

# Timer to control the state change interval
var state_timer: Timer

func _ready() -> void:
	# Create and start the timer
	state_timer = Timer.new()
	state_timer.wait_time = 2.0
	state_timer.timeout.connect(_on_state_timer_timeout)  # Correct connection method
	add_child(state_timer)
	state_timer.start()

func _process(delta: float) -> void:
	# Handle enemy movement based on the current state
	match current_state:
		EnemyState.MOVE_FORWARD:
			position += direction * speed * delta
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
	current_state = random_state  # Directly assign the random state
	
	if current_state == EnemyState.CHANGE_DIRECTION:
		# Randomly choose a new direction and rotate the enemy accordingly
		var random_direction = randi() % 4
		match random_direction:
			0:
				direction = Vector2.RIGHT
				rotation_degrees = 0
			1:
				direction = Vector2.LEFT
				rotation_degrees = 180
			2:
				direction = Vector2.UP
				rotation_degrees = -90
			3:
				direction = Vector2.DOWN
				rotation_degrees = 90
