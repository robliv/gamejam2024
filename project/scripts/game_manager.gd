extends Node2D
const MAIN_MENU_SCENE_PATH = "res://scenes/menu.tscn"


func _ready():
	load_level(MAIN_MENU_SCENE_PATH)

func load_level(scene_path):
	print("Loading scene: " + str(scene_path))
	remove_child_nodes()
	var scene = load(scene_path)
	var scene_instance = scene.instantiate()
	add_child(scene_instance)
	scene_instance.request_level.connect(_on_request_load_level)
	
func remove_child_nodes():
	if get_node_or_null("Menu"):
		print("Removing child node: menu")
		get_node("Menu").queue_free()
	if get_node_or_null("Game"):
		print("Removing child node: game")
		get_node("Game").queue_free()		

func _on_request_load_level(new_scene_path):
	print("Received new scene request signal: " + str(new_scene_path))
	load_level(new_scene_path)
