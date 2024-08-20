extends Control

@export var circle_duration : float = 2.0  # Duration to complete the circle
@export var circle_radius : float = 100.0  # Radius of the circle

var timer : Timer
var elapsed_time : float = 0.0
var redraw_circle: bool = false

func _ready():
	# Initialize Timer
	timer = $Timer
	timer.wait_time = 0.1  # Update every 0.1 seconds
	timer.autostart = true
	timer.one_shot = false
	timer.connect("timeout", Callable(self, "_on_Timer_timeout"))
	
	# Ensure _draw() is called initially
	queue_redraw() 
	
func _process(delta: float) -> void:
	if Globals.enflate_pressed:
		redraw_circle = true
		Globals.enflate_pressed = false
		queue_redraw()

func _on_Timer_timeout():
	# Update the elapsed time
	elapsed_time += timer.wait_time
	if elapsed_time >= circle_duration:
		elapsed_time = circle_duration  # Ensure we don't exceed the duration
		timer.stop()
		Globals.enflate_cooldown = false  # Stop the timer when the drawing is complete
	queue_redraw()  # Request a redraw

func _draw():
	if Globals.game_paused:
		return  # Ensure timer is initialized before using it
	
	if redraw_circle:
		draw_rect(Rect2(Vector2.ZERO, size), Color(1, 1, 1, 0))
		Globals.enflate_cooldown = true
		elapsed_time = 0.0
		redraw_circle = false
		timer.start()
	
	var completion_fraction = elapsed_time / circle_duration
	var start_angle = -90  # Start angle in degrees
	var end_angle = -90 + (360 * completion_fraction)  # End angle in degrees

	# Convert angles to radians
	var start_angle_rad = deg_to_rad(start_angle)
	var end_angle_rad = deg_to_rad(end_angle)
	
	# Draw the arc
	draw_arc(Vector2(size.x / 2, size.y / 2), circle_radius, start_angle_rad, end_angle_rad, 15, Color(0.8, 0.5, 0.1))
	draw_arc(Vector2(size.x / 2, size.y / 2), circle_radius - 0.1, start_angle_rad, end_angle_rad, 15, Color(0.8, 0.5, 0.1))
	draw_arc(Vector2(size.x / 2, size.y / 2), circle_radius - 0.2, start_angle_rad, end_angle_rad, 15, Color(0.8, 0.5, 0.1))
	draw_arc(Vector2(size.x / 2, size.y / 2), circle_radius - 0.3, start_angle_rad, end_angle_rad, 15, Color(0.8, 0.5, 0.1))
	
