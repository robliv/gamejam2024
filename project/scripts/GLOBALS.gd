extends Node

var current_level: int = 1
var flashlight_size: int = 0
var enemy_speed: int = 0
var game_result_win: bool
var info_showed: bool = false
var current_ballon_size: int
var game_paused: bool

var player_enetered_light: bool = false
var player_exited_light: bool = false

var game_over: bool = false


func reset_enemy_data():
	flashlight_size = 0.0
	enemy_speed = 0.0

func reset_game_data():
	current_level = 1
	flashlight_size = 0.0
	enemy_speed = 0.0
	current_ballon_size = 0
	game_over = false
	player_enetered_light = false
	player_exited_light = false

# Function to advance to the next level
func advance_level():
	current_level += 1
	current_ballon_size = 0

# Function to update flashlight size
func increase_flashlight_size():
	flashlight_size += 1
	
# Function to update enemy speed
func increase_enemy_speed():
	enemy_speed += 1
	
func set_game_result_won(win_bool:bool):
	game_result_win = win_bool
	
func set_info_showed():
	info_showed = true
