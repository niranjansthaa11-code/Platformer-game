extends CharacterBody2D

@export var speed=10
@export var jump_energy=10

var speed_multiplier = 10
var jump_multiplier =-10

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_energy*jump_multiplier

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * speed*speed_multiplier
	else:
		velocity.x = move_toward(velocity.x, 0,speed)

	move_and_slide()
