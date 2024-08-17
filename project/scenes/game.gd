extends Control

const MAIN_MENU_SCENE_PATH = "res://scenes/menu.tscn"
var menu_button

signal request_level

func _ready():
	menu_button = $MenuButton
	menu_button.pressed.connect(self._on_menu_button_pressed)
	
func _on_menu_button_pressed():
	print("Menu button was pressed")
	emit_signal("request_level", MAIN_MENU_SCENE_PATH)
