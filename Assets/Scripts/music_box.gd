extends CheckBox

func _ready() -> void:
	# This ensures the CheckBox matches the music state when the menu opens
	# If music is NOT paused, the button should be CHECKED
	if MusicManager.has_method("is_paused"):
		button_pressed = not MusicManager.is_paused()
	else:
		# Fallback if you haven't made an is_paused function yet:
		button_pressed = true 

func _on_toggled(toggled_on: bool) -> void:
	# 1. Update the MusicManager
	MusicManager.set_paused(not toggled_on)
	
	# 2. Feedback for debugging
	if toggled_on:
		print("Music Unmuted")
	else:
		print("Music Muted")
