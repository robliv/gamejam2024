extends Control

const MAIN_MENU_SCENE_PATH = "res://scenes/menu.tscn"
const POST_GAME_SCENE_PATH = "res://scenes/post_game_screen.tscn"

var menu_button
var start_button
var starting_info

signal request_level

func _ready():
	$CurrentLevelLabel.text = "LEVEL: " + str(Globals.current_level)
	$FlashlightSizeLabel.text = "FLASHLIGHT SIZE: " + str(Globals.flashlight_size)
	$EnemySpeedLabel.text = "ENEMY SPEED: " + str(Globals.enemy_speed)
	
	starting_info = $StartingInfo
	
	menu_button = $MenuButton
	menu_button.pressed.connect(self._on_menu_button_pressed)
	
	start_button = $StartingInfo/Start
	start_button.pressed.connect(self._on_start_game_pressed)
	
	var player = $GameRoot/player/Player
	player.request_endgame.connect(_on_request_endgame)
	
	if(!Globals.info_showed):
		process_mode = Node.PROCESS_MODE_PAUSABLE
		get_tree().paused = true
		Globals.game_paused = true
	else:
		starting_info.visible = false
	
func _on_menu_button_pressed():
	print("Menu button was pressed")
	Globals.reset_game_data()
	emit_signal("request_level", MAIN_MENU_SCENE_PATH)

func _on_request_endgame():
	print("Game end requested from player node")
	emit_signal("request_level", POST_GAME_SCENE_PATH)
	
func _on_start_game_pressed():
	get_tree().paused = false
	starting_info.visible = false
	Globals.set_info_showed()
	Globals.game_paused = false
