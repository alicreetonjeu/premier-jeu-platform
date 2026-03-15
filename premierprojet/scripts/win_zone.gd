extends Area2D

@onready var ui = get_node("/root/Game/UI")
@onready var player = get_node("/root/Game/Player")

func _on_body_entered(body: Node2D) -> void:
	if body.name == "ThrowableObject":  # Replace with your object's name
		print("🎉 You win!")
		player.set_process(false)
		player.set_physics_process(false)
		player.set_process_input(false)
		ui.show_win_screen()
