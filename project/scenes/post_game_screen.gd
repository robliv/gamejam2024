extends Control

const MAIN_MENU_SCENE_PATH = "res://scenes/menu.tscn"
const GAME_LEVEL_SCENE_PATH = "res://scenes/game.tscn"

var menu_button
var game_result_label
var next_action_info_label
var choice_button_faster
var choice_button_flashlight

signal request_level

func _ready():
	print("Post game scene starting. Game was won = " + str(Globals.game_result_win))
	menu_button = $MenuButton
	menu_button.pressed.connect(self._on_menu_button_pressed)
	
	choice_button_faster = $GameResultBG/ChoiceButtonFaster
	choice_button_faster.pressed.connect(self._on_choice_button_faster_pressed)
	
	choice_button_flashlight = $GameResultBG/ChoiceButtonFlashlight
	choice_button_flashlight.pressed.connect(self._on_choice_button_flashlight_pressed)
	
	game_result_label = $GameResultBG/GameResultLabel
	next_action_info_label = $GameResultBG/NextActionInfoLabel
	if(Globals.game_result_win):
		game_result_label.text = "VICTORY! LEVEL " + str(Globals.current_level) + " COMPLETE!"
		next_action_info_label.text = "CHOOSE YOUR PUNISHMENT:"
	else:
		game_result_label.text = "DEFEAT! YOU MADE IT TO LEVEL " + str(Globals.current_level) + "!"
		next_action_info_label.text = "QUIT TO MENU AND TRY AGAIN..."
		choice_button_faster.hide()
		choice_button_flashlight.hide()
	Globals.set_game_result_won(false)
		

func _on_menu_button_pressed():
	print("Menu button was pressed")
	Globals.reset_game_data()
	emit_signal("request_level", MAIN_MENU_SCENE_PATH)

func _on_choice_button_faster_pressed():
	print("Choice button FASTER was pressed")
	Globals.increase_enemy_speed()
	Globals.advance_level()
	emit_signal("request_level", GAME_LEVEL_SCENE_PATH)
	
func _on_choice_button_flashlight_pressed():
	print("Choice button FLASHLIGHT was pressed")
	Globals.increase_flashlight_size()
	Globals.advance_level()
	emit_signal("request_level", GAME_LEVEL_SCENE_PATH)
