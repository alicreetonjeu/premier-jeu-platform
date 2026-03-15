extends Node2D

@onready var arrow_scene = preload("res://scenes/arrow.tscn")
@onready var spawn_timer = $SpawnTimer
@onready var screen_size = get_viewport().get_visible_rect().size

func _ready():
	spawn_timer.timeout.connect(_on_SpawnTimer_timeout)

func _on_SpawnTimer_timeout():
	var arrow = arrow_scene.instantiate()
	var player = get_node("/root/Game/Player")  # Adjust path if needed
	var side = randi() % 2  # 0: right-to-left, 1: top-down

	if side == 0:
		# ➡️ Horizontal arrow from right to left
		var target_player = randf() < 0.5  # 50% chance to target the player directly

		var y_spawn: float
		if target_player:
			y_spawn = player.global_position.y - 10
		else:
			# Get a random Y between player's Y and top of screen
			y_spawn = randf_range(0, player.global_position.y - 10)  # 10px buffer
		
		# Clamp just in case player is already near top
		y_spawn = clamp(y_spawn, 0, player.global_position.y - 10)

		arrow.position = Vector2(screen_size.x + 100, y_spawn)
		arrow.direction = Vector2.LEFT
	elif side == 1:
		# Spawn top, move down
		var x = randf_range(0, screen_size.x)
		arrow.position = Vector2(x, -100)
		arrow.direction = Vector2.DOWN

	get_tree().current_scene.add_child(arrow)
