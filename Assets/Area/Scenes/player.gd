extends CharacterBody2D
class_name Player

@export_group("Movement")
@export var speed: float = 200.0
@export var jump_force: float = 350.0
@export var friction: float = 0.25 

@onready var pivot: Node2D = $Pivot
@onready var animated_sprite: AnimatedSprite2D = $Pivot/AnimatedSprite2D
@onready var spwan_sprite = $AnimatedSprite2D1
@onready var jump_sound: AudioStreamPlayer2D = $JumpSound

# --- Timer Nodes (Make sure these paths match your scene!) ---
@onready var timer = $Timer
@onready var label = $CanvasLayer/TimerLabel
@onready var bar = $CanvasLayer/TimerBar

## --- State Variables ---
var is_attacking: bool = false

func _ready():
	# --- Timer Initialization ---
	if bar and timer:
		bar.max_value = timer.wait_time
		bar.value = timer.wait_time
	
	# Keep UI running when paused
	if has_node("CanvasLayer"):
		$CanvasLayer.show()
		$CanvasLayer.process_mode = PROCESS_MODE_ALWAYS

	# --- Spawn Animation Logic ---
	spwan_sprite.show()
	spwan_sprite.modulate.a = 1 
	animated_sprite.show()
	animated_sprite.modulate.a = 0.0 
	is_attacking = true
	spwan_sprite.play("spawn")
	await spwan_sprite.animation_finished
	
	var tween = create_tween() 
	tween.tween_property(spwan_sprite, "modulate:a", 0.0, 0.5)
	tween.parallel().tween_property(animated_sprite, "modulate:a", 1.0, 0.5)
	await tween.finished
	spwan_sprite.hide()
	animated_sprite.play("idle")
	is_attacking = false

func _process(_delta: float) -> void:
	# Update Timer UI every frame
	if timer and label and bar:
		if timer.time_left > 0:
			label.text = "TIME: " + str(ceil(timer.time_left))
			bar.value = timer.time_left

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if not is_attacking:
		handle_jump()
		handle_movement()
	else:
		velocity.x = move_toward(velocity.x, 0, speed * friction)

	if Input.is_action_just_pressed("attack") and is_on_floor() and not is_attacking:
		attack()

	move_and_slide()
	update_animation()

# --- Timer Signal ---
func _on_timer_timeout():
	get_tree().paused = true
	if label:
		label.text = "GAME OVER!"
		label.add_theme_color_override("font_color", Color.RED)

# --- Movement & Animation Helper Functions ---
func handle_jump() -> void:
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -jump_force
		jump_sound.play()

func handle_movement() -> void:
	var direction := Input.get_axis("left", "right")
	if direction != 0:
		velocity.x = direction * speed
		flip_character(direction)
	else:
		velocity.x = move_toward(velocity.x, 0, speed * friction)

func flip_character(direction: float) -> void:
	if direction > 0:
		pivot.scale.x = 1
	elif direction < 0:
		pivot.scale.x = -1

func update_animation() -> void:
	if is_attacking: return
	if not is_on_floor():
		play_anim("jump")
	else:
		if abs(velocity.x) > 0.1:
			play_anim("run")
		else:
			play_anim("idle")

func attack() -> void:
	is_attacking = true
	play_anim("attack")
	await animated_sprite.animation_finished
	is_attacking = false

func play_anim(anim_name: String) -> void:
	if animated_sprite.animation != anim_name:
		animated_sprite.play(anim_name)
