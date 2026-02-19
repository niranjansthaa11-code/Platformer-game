extends CheckBox

func _ready() -> void:
	
	if MusicManager.has_method("is_paused"):
		button_pressed = not MusicManager.is_paused()
	else:
		
		button_pressed = true 

func _on_toggled(toggled_on: bool) -> void:
	
	MusicManager.set_paused(not toggled_on)
	
	if toggled_on:
		print("Music Unmuted")
	else:
		print("Music Muted")
