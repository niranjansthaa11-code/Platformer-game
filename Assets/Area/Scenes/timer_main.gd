extends Node2D

@onready var timer = $Timer
@onready var label = $TimerLabel
@onready var bar = $TimerBar

func _ready():
	# Set the bar's maximum to match the timer's total time
	bar.max_value = timer.wait_time

func _process(_delta):
	# 1. Update the Text (Countdown)
	label.text = "TIME: " + str(ceil(timer.time_left))
	
	# 2. Update the Progress Bar (Animation)
	bar.value = timer.time_left

# Connect this signal from the Timer node's "timeout"
	

func _on_timer_timeout() -> void:
	get_tree().paused = true
	print("YOU FAILED!")
	# Optional: change label color to red on fail
	label.text = "FAILED!"
	label.add_theme_color_override("font_color", Color.RED)
	pass # Replace with function body
	
