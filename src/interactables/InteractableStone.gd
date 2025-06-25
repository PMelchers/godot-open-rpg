extends StaticBody2D
class_name InteractableStone

@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D
@onready var interaction_area = $Area2D
@onready var interaction_collision = $Area2D/CollisionShape2D

var player_in_range = false
var player_reference = null

signal stone_destroyed(stone)

func _ready():
	# Connect the interaction area signals
	interaction_area.body_entered.connect(_on_body_entered)
	interaction_area.body_exited.connect(_on_body_exited)
	
	# Set up the interaction area collision layer/mask if needed
	interaction_area.collision_layer = 0
	interaction_area.collision_mask = 1  # Assuming player is on layer 1

func _input(event):
	if player_in_range and Input.is_action_just_pressed("interact"):
		destroy_stone()

func _on_body_entered(body):
	if body.name == "Player" or body.is_in_group("player"):
		player_in_range = true
		player_reference = body
		show_interaction_hint()

func _on_body_exited(body):
	if body.name == "Player" or body.is_in_group("player"):
		player_in_range = false
		player_reference = null
		hide_interaction_hint()

func show_interaction_hint():
	# You can add a visual indicator here if desired
	# For example, change the stone's modulate color slightly
	sprite.modulate = Color(1.2, 1.2, 1.2, 1.0)

func hide_interaction_hint():
	# Reset the visual indicator
	sprite.modulate = Color.WHITE

func destroy_stone():
	# Emit signal that stone was destroyed (useful for tracking/statistics)
	stone_destroyed.emit(self)
	
	# Optional: Add particle effect or sound here
	create_destruction_effect()
	
	# Remove the stone
	queue_free()

func create_destruction_effect():
	# Simple tween effect before destruction
	var tween = create_tween()
	tween.parallel().tween_property(sprite, "modulate:a", 0.0, 0.3)
	tween.parallel().tween_property(sprite, "scale", Vector2(1.5, 1.5), 0.3)
	tween.tween_callback(func(): queue_free())
