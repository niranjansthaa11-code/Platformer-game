extends CharacterBody2D

@onready var heart_anim = $AnimatedSprite2D2
@onready var meetup_song = $Romantic
@onready var meetup = $Label



func _ready():
	heart_anim.hide()
	heart_anim.stop()
	meetup.hide()
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == 'player' or body.name == 'Player':
		heart_anim.show()
		heart_anim.play()
		meetup.show()
		MusicManager.stop_music()
		meetup_song.play()
		await get_tree().create_timer(5.0).timeout
		get_tree().change_scene_to_file("res://Assets/Area/Scenes/main_menu.tscn")
		
		
	
	
	pass # Replace with function body.
