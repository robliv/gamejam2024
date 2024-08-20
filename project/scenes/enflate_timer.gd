extends Control

@export var circle_duration : float = 2.0  # Duration to complete the circle
@export var circle_radius : float = 100.0  # Radius of the circle

var timer : Timer
var elapsed_time : float = 0.0
var refresh: bool = false

func _ready():
	# Initialize Timer
	timer = $Timer
	timer.wait_time = 0.1  # Update every 0.1 seconds
	timer.autostart = false
	timer.one_shot = false
	timer.connect("timeout", Callable(self, "_on_Timer_timeout"))
	# Ensure _draw() is called initially
	queue_redraw() 
	
func _process(delta: float) -> void:
	if Globals.player_enetered_light:
		timer.start()
		Globals.player_enetered_light = false
		queue_redraw()
		
	if Globals.player_exited_light:
		refresh = true
		queue_redraw()

func _on_Timer_timeout():
	# Update the elapsed time
	elapsed_time += timer.wait_time
	if elapsed_time >= circle_duration:
		elapsed_time = circle_duration  # Ensure we don't exceed the duration
		timer.stop()
		Globals.game_over = true
	queue_redraw()  # Request a redraw

func _draw():
	if Globals.game_paused:
		return  # Ensure timer is initialized before using it
	
	if refresh:
		draw_rect(Rect2(Vector2.ZERO, size), Color(1, 1, 1, 0))
		elapsed_time = 0.0
		refresh = false
		Globals.player_exited_light = false
		timer.stop()
	
	var completion_fraction = elapsed_time / circle_duration
	var start_angle = -90  # Start angle in degrees
	var end_angle = -90 + (360 * completion_fraction)  # End angle in degrees

	# Convert angles to radians
	var start_angle_rad = deg_to_rad(start_angle)
	var end_angle_rad = deg_to_rad(end_angle)
	
	# Draw the arc
	draw_arc(Vector2(size.x / 2, size.y / 2), circle_radius, start_angle_rad, end_angle_rad, 15, Color(1, 0, 0))
	draw_arc(Vector2(size.x / 2, size.y / 2), circle_radius - 0.1, start_angle_rad, end_angle_rad, 15, Color(1, 0, 0))
	draw_arc(Vector2(size.x / 2, size.y / 2), circle_radius - 0.2, start_angle_rad, end_angle_rad, 15, Color(1, 0, 0))
	draw_arc(Vector2(size.x / 2, size.y / 2), circle_radius - 0.3, start_angle_rad, end_angle_rad, 15, Color(1, 0, 0))
	
	draw_arc(Vector2(size.x / 2, size.y / 2), circle_radius - 0.4, start_angle_rad, end_angle_rad, 15, Color(1, 0, 0))
	draw_arc(Vector2(size.x / 2, size.y / 2), circle_radius - 0.5, start_angle_rad, end_angle_rad, 15, Color(1, 0, 0))
	draw_arc(Vector2(size.x / 2, size.y / 2), circle_radius - 0.6, start_angle_rad, end_angle_rad, 15, Color(1, 0, 0))
	draw_arc(Vector2(size.x / 2, size.y / 2), circle_radius - 0.7, start_angle_rad, end_angle_rad, 15, Color(1, 0, 0))
	
