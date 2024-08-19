extends Node

var current_level: int = 1
var flashlight_size: int = 1
var enemy_speed: int = 1
var game_result_win: bool

func reset_game_data():
	current_level = 1
	flashlight_size = 1.0
	enemy_speed = 1.0

# Function to advance to the next level
func advance_level():
	current_level += 1

# Function to update flashlight size
func increase_flashlight_size():
	flashlight_size += 1
	
# Function to update enemy speed
func increase_enemy_speed():
	enemy_speed += 1
	
func set_game_result_won(win_bool:bool):
	game_result_win = win_bool
