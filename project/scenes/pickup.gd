extends Node2D

# This signal will be emitted when the player picks up the item
signal picked_up

func _ready():
	# Connect the area_entered signal from Area2D to a function in this script
	$Area2D.area_entered.connect(self._on_Area2D_area_entered)

func _on_Area2D_area_entered(area):
	# Check if the area that entered belongs to the player
	if area.name == "PlayerArea":
		# Emit the picked_up signal
		emit_signal("picked_up")
		# queue_free() removes the pickup from the scene
		queue_free()
