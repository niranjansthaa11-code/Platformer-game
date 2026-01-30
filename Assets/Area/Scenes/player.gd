extends CharacterBody2D

@export var speed: float = 200.0
@export var jump_force: float = 350

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	if Input.is_action_just_pressed("attack"):
		play_anim("attack")
	
	

	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -jump_force
	
	var direction := Input.get_axis("left", "right")
	if direction != 0:
		velocity.x = direction * speed
		animated_sprite.flip_h = direction < 0
	else:
		velocity.x = 0

	move_and_slide()

	update_animation(direction)


func update_animation(direction: float) -> void:
	if not is_on_floor():
		play_anim("jump")
	elif direction != 0:
		play_anim("run")
	else:
		play_anim("idle")
		
		
func attack() -> void:
	play_anim("attack")
	await animated_sprite.animation_finished




func play_anim(name: String) -> void:
	
	if animated_sprite.animation != name:
		animated_sprite.play(name)
