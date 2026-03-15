extends CanvasLayer

@onready var life_label = $Control/life
@onready var status_label = $Control/GameStatus
@onready var restart_button = $Control/RestartButton

func set_life (life: int):
	life_label.text = str(life)

func show_win_screen():
	#get_tree().paused = true
	status_label.text = "🎉 YOU WIN 🎉"
	status_label.visible = true
	restart_button.visible = true

func show_lose_screen():
	status_label.text = "💀 GAME OVER 💀"
	status_label.visible = true
	restart_button.visible = true
	
func _on_restart_button_pressed() -> void:
	print("restart")
	get_tree().reload_current_scene()
