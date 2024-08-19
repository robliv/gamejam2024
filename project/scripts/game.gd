extends Control

const MAIN_MENU_SCENE_PATH = "res://scenes/menu.tscn"
const POST_GAME_SCENE_PATH = "res://scenes/post_game_screen.tscn"

var menu_button

signal request_level

func _ready():
	$CurrentLevelLabel.text = "LEVEL: " + str(Globals.current_level)
	$FlashlightSizeLabel.text = "FLASHLIGHT SIZE: " + str(Globals.flashlight_size)
	$EnemySpeedLabel.text = "ENEMY SPEED: " + str(Globals.enemy_speed)
	
	menu_button = $MenuButton
	menu_button.pressed.connect(self._on_menu_button_pressed)
	var player = $GameRoot/player/CharacterBody2D
	player.request_endgame.connect(_on_request_endgame)
	
func _on_menu_button_pressed():
	print("Menu button was pressed")
	Globals.reset_game_data()
	emit_signal("request_level", MAIN_MENU_SCENE_PATH)

func _on_request_endgame():
	print("Game end requested from player node")
	emit_signal("request_level", POST_GAME_SCENE_PATH)
