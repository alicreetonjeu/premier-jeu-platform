extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -250.0

# Roll
const ROLL_SPEED = 300.0
const ROLL_DURATION = 0.15
var is_rolling = false
var roll_timer = 0.0

var canPick = true

# Health
const MAX_HEALTH = 10
const HIT_DURATION = 0.15
var health = MAX_HEALTH
var is_hit = false
var hit_timer = 0.0
var is_dead = false

@onready var animation = $AnimatedSprite2D
@onready var ui = get_node("/root/Game/UI")

func _ready() -> void:
	ui.set_life(health)
	
func _input(_event: InputEvent) -> void:
	if is_dead:
		return
	if Input.is_action_just_pressed("roll") and is_on_floor() and not is_rolling:
		is_rolling = true
		roll_timer = ROLL_DURATION		
		
func _physics_process(delta: float) -> void:	
	# Stop all movement if dead
	if is_dead:
		return
	
	# Handle hit delay
	if is_hit:
		hit_timer -= delta
		if hit_timer <= 0.0:
			is_hit = false
		move_and_slide()
		return  # Stop normal movement/animation during hit
		
	#Handle roll
	if is_rolling:
		roll_timer -= delta
		var roll_direction = -1 if animation.flip_h else 1
		velocity.x = roll_direction * ROLL_SPEED
		animation.play("roll")
		if roll_timer <= 0.0:
			is_rolling = false
			
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Regular movement if not rolling
	if not is_rolling:
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction := Input.get_axis("ui_left", "ui_right")
			
		if direction > 0:
			animation.flip_h = false
		elif direction < 0:
			animation.flip_h = true
			
		if is_on_floor():
			if direction == 0:
				animation.play("idle")
			else:
				animation.play("run")
		else:
			animation.play("jump")
			
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func hit_by_arrow():
	if is_dead:
		return

	health -= 1
	ui.set_life(health)
	is_hit = true
	hit_timer = HIT_DURATION
	animation.play("hit")
	print("Player hit! Remaining HP:", health)

	if health <= 0:
		die()

func die():
	is_dead = true
	velocity = Vector2.ZERO
	animation.play("death")
	ui.show_lose_screen()
