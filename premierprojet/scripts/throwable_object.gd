extends RigidBody2D

var is_picked_up = false
var should_throw = false

@onready var player = get_node("../Player")
@onready var playerMarker = get_node("../Player/Marker2D")

func _physics_process(_delta: float) -> void:
	if is_picked_up:
		# L'objet suit la position du joueur (Marker2D = point de tenue)
		global_position = playerMarker.global_position
		linear_velocity = Vector2.ZERO

	if should_throw:
		throw_object()
		should_throw = false

func _input(_event: InputEvent) -> void:
	# ATTRAPER l'objet
	if Input.is_action_just_pressed("pick"):
		var bodies = $Area2D.get_overlapping_bodies()
		for body in bodies:
			if body.name == "Player" and player.canPick:
				is_picked_up = true
				player.canPick = false

	# LÂCHER l'objet
	if Input.is_action_just_pressed("drop") and is_picked_up:
		is_picked_up = false
		player.canPick = true

		# Appliquer une petite impulsion selon la direction du joueur
		var direction = -1 if player.animation.flip_h else 1
		apply_impulse(Vector2.ZERO, Vector2(90 * direction, -400))

	# LANCER l'objet
	if Input.is_action_just_pressed("throw") and is_picked_up:
		is_picked_up = false
		should_throw = true
		player.canPick = true

func throw_object():
	# Remise à zéro avant de lancer
	sleeping = false
	linear_velocity = Vector2.ZERO

	var force_x = 50
	var force_y = -200

	var direction = -1 if player.animation.flip_h else 1

	# Appliquer une force vers l’avant + vers le haut
	apply_central_impulse(Vector2(force_x * direction, force_y))
