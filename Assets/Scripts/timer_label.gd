extends Node2D

@onready var game_timer = $Timer
@onready var label = $TimerLabel
@onready var bar = $TimerBar # Only if you added a ProgressBar

func _ready():
	# Set the progress bar max value to match the timer
	if bar:
		bar.max_value = game_timer.wait_time

func _process(_delta):
	# 1. Update the Text Label
	# We use 'ceil' to show 10, 9, 8 instead of 9.432...
	var time_left = game_timer.time_left
	label.text = "Time Left: " + str(ceil(time_left))
	
	# 2. Update the Progress Bar (Visual Animation)
	if bar:
		bar.value = time_left
	
	# 3. Optional: Make the text turn red when under 5 seconds
	if time_left < 5:
		label.add_theme_color_override("font_color", Color.RED)

func _on_timer_timeout():
	get_tree().paused = true
	print("YOU FAILED!")
	$GameOverLabel.show()
