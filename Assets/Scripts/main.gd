extends Node2D

@onready var timer = $Timer
@onready var timer_bar = $CanvasLayer/TimerBar
@onready var timer_label = $CanvasLayer/TimerLabel
@onready var dead : AudioStreamPlayer = $dying
@onready var button = $"Music Button/Node2D/CheckBox"
@onready var exit = $"Music Button/Node2D/Button"

func _ready() -> void:
	var screen_size = get_viewport_rect().size
	
	timer_bar.custom_minimum_size.x = screen_size.x * 0.7
	timer_bar.size.x = screen_size.x * 0.7
	
	timer_label.global_position = Vector2((screen_size.x / 2) - (timer_label.size.x / 2), 15)
	timer_bar.global_position = Vector2((screen_size.x / 2) - (timer_bar.size.x / 2), 45)
	
	button.position = Vector2((screen_size.x/2)-50, 150)
	exit.global_position = Vector2(screen_size.x - exit.size.x - 20, 20)
	
	if timer:
		timer_bar.max_value = timer.wait_time
		timer_bar.value = timer.wait_time
	
	if has_node("Music_Manager"):
		$Music_Manager.play()
	
	$CanvasLayer.process_mode = PROCESS_MODE_ALWAYS
	$CanvasLayer.show()

func _process(_delta: float) -> void:
	if timer and not timer.is_stopped():
		var ratio = timer.time_left / timer.wait_time
		var percent = int(ratio * 100)
		
		timer_bar.value = timer.time_left
		timer_label.text = "TIME LEFT: " + str(ceil(timer.time_left)) +" Sec"+ " (" + str(percent) + "%)"
		
		timer_bar.modulate = Color(1.0 - ratio, ratio, 0.0)
		
		if timer.time_left < 5:
			timer_label.modulate = Color.RED
		else:
			timer_label.modulate = Color.WHITE

func _on_timer_timeout() -> void:
	get_tree().paused = true
	dead.play()
	
	timer_label.text = "GAME OVER!"
	timer_label.add_theme_color_override("font_color", Color.RED)
	
	await get_tree().create_timer(2.0, true).timeout
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_check_box_toggled(toggled_on: bool) -> void:
	if has_node("Music_Manager"):
		if toggled_on:
			$Music_Manager.play()
		else:
			$Music_Manager.stop()
