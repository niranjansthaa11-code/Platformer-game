extends Control

# 1. Fixed the 'y' and added a check
@onready var weep = $AudioStreamPlayer 

func _ready() -> void:
	# Stop the global music
	if MusicManager:
		MusicManager.stop_music()
	
	# 2. Safety Check: Only play if the node was actually found
	if weep != null:
		weep.play()

func _process(_delta: float) -> void:
	pass

func _on_new_game_pressed() -> void:
	MusicManager.play_music()
	get_tree().change_scene_to_file("res://Assets/Area/Scenes/area_1.tscn")

func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://Assets/Area/Scenes/main_menu.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit()
