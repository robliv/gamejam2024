extends Node2D
const MAIN_MENU_SCENE_PATH = "res://scenes/menu.tscn"


func _ready():
	load_main_menu()

func load_main_menu():
	print("Game started. Loading main menu.")
	var scene = load(MAIN_MENU_SCENE_PATH)
	var scene_instance = scene.instantiate()
	add_child(scene_instance)
