extends Node2D

@onready var timer = $Timer
@onready var timer_bar = $CanvasLayer/TimerBar
@onready var timer_label = $CanvasLayer/TimerLabel
@onready var dead : AudioStreamPlayer = $dying
func _ready() -> void:
	# 1. Force UI Position (Human shortcut to fix the negative Y issue)
	timer_label.position = Vector2(20, 20)
	timer_bar.position = Vector2(20, 60)
	
	# 2. Setup Bar
	if timer:
		timer_bar.max_value = timer.wait_time
		timer_bar.value = timer.wait_time
	
	# 3. Handle Music (Only call this once at the start!)
	if has_node("Music_Manager"):
		$Music_Manager.play()
	
	# 4. Make sure UI works while paused
	$CanvasLayer.process_mode = PROCESS_MODE_ALWAYS
	$CanvasLayer.show()

func _process(_delta: float) -> void:
	if timer and not timer.is_stopped():
		timer_bar.value = timer.time_left
		timer_label.text = "TIME LEFT: " + str(ceil(timer.time_left))
		
		# Optional: Pulse red when low on time
		if timer.time_left < 5:
			timer_label.modulate = Color.RED
		else:
			timer_label.modulate = Color.WHITE

	


func _on_timer_timeout() -> void:
	# Stop the game
	get_tree().paused = true
	dead.play()
	
	timer_label.text = "GAME OVER!"
	timer_label.add_theme_color_override("font_color", Color.RED)
	
	
	pass 
