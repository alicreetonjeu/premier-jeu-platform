extends Area2D

@export var speed: float = 150.0
var direction: Vector2 = Vector2.LEFT

@onready var screen_size = get_viewport().get_visible_rect().size

func _ready():
	# Rotate to face direction
	rotation = direction.angle()

func _process(delta: float) -> void:
	if is_outside_screen():
		queue_free()
	
	position += direction * speed * delta

func _on_body_entered(body: Node) -> void:
	if body.name == "Player":
		body.hit_by_arrow()  # Call the damage function
		queue_free()  # Destroy the arrow

func is_outside_screen() -> bool:
	var pos = global_position
	return pos.x < -100 or pos.y < -100 or pos.x > screen_size.x + 100 or pos.y > screen_size.y + 100
