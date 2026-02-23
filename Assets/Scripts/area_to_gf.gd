extends Area2D

# Using an export makes it easy to pick the destination in the Inspector
# If you prefer the hardcoded $DestinationPoint, just remove this line
@export var destination: Marker2D 
@onready var portal_sound : AudioStreamPlayer2D = $op

func _on_body_entered(body: Node2D) -> void:
	portal_sound.play()
	print("Detected: ", body.name) # If this doesn't show in the console, it's a Signal/Collision issue
	# 1. Check the group (Make sure your Player node is in the "Player" group!)
	if body.is_in_group("Player"):
		portal_sound.play
		
		# 2. Use a fallback: try the export first, then the child node
		var target = destination if destination else get_node_or_null("DestinationPoint")
		
		if target:
			# 3. Use global_position to ensure the coordinates match perfectly
			body.global_position = target.global_position
		else:
			push_warning("Teleport failed: No DestinationPoint found!")
