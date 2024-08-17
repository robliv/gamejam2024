extends Control

var play_button
var game_scene_path = "res://scenes/game.tscn"

signal request_level

func _ready():
	play_button = $PlayButton
	play_button.pressed.connect(self._on_play_button_pressed)
	
func _on_play_button_pressed():
	print("Play button was pressed")
	emit_signal("request_level", game_scene_path)
