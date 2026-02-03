extends CharacterBody2D

@export_group("Movement")
@export var speed: float = 200.0
@export var jump_force: float = 350.0
@export var friction: float = 0.25 # How fast the player stops (0 to 1)


@onready var pivot: Node2D = $Pivot
@onready var animated_sprite: AnimatedSprite2D = $Pivot/AnimatedSprite2D

## --- State Variables ---
var is_attacking: bool = false

func _physics_process(delta: float) -> void:
	# 1. Apply Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# 2. Handle Inputs
	if not is_attacking:
		handle_jump()
		handle_movement()
	else:
		# Apply friction while attacking
		velocity.x = move_toward(velocity.x, 0, speed * friction)

	# 3. Handle Combat
	if Input.is_action_just_pressed("attack") and is_on_floor() and not is_attacking:
		attack()

	# 4. Finalize
	move_and_slide()
	update_animation()


func handle_jump() -> void:
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -jump_force

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
	if is_attacking:
		return

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
