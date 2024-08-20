extends Sprite2D

var textures := {
	0: preload("res://assets/empty.png"),
	1: preload("res://assets/1_5.png"),
	2: preload("res://assets/2_5.png"),
	3: preload("res://assets/3_5.png"),
	4: preload("res://assets/4_5.png"),
	5: preload("res://assets/5_5.png")
}

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var value = Globals.current_ballon_size
	if value in textures:
		texture = textures[value]
	else:
		print("Error: Value out of range")
