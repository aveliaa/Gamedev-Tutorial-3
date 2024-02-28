extends KinematicBody2D

func _ready():
	idle()

export (int) var speed = 400 #export
export (int) var GRAVITY = 1200
export (int) var jump_speed = -600

onready var animation = $AnimationPlayer

var last_move_right_press_time = 0
var last_move_left_press_time = 0
var double_tap_threshold = 0.15

var max_jumps = 2
var jumps_remaining = max_jumps

const UP = Vector2(0,-1)

var velocity = Vector2()

var movement_history = "right"
var is_running = false
var is_crouching = false
var is_attacking = false

func double_tap(direction,last_move_time):
	var current_time = OS.get_ticks_msec() / 1000.0
	
	if Input.is_action_just_pressed(direction):
		print(current_time)
		if current_time - last_move_time < double_tap_threshold:
			return true
	
	return false
	
func get_input():
	velocity.x = 0
	
	if is_on_floor():
		jumps_remaining = max_jumps
	
	if Input.is_action_just_pressed("up") and jumps_remaining > 0:
		jump()
		velocity.y = jump_speed
		jumps_remaining -= 1
	
	# Moving Right
	if Input.is_action_pressed("right"):
		
		movement_history = "right"
		
		
		var is_double = double_tap("right",last_move_right_press_time)
		if is_double:
			speed = 600
			is_running = true
			
		if not is_attacking and jumps_remaining == 2: #not in the air
			if is_running:
				run(false)
			elif is_crouching:
				crouch()
			else:
				walk(false)
		
		velocity.x += speed
		
		var current_time = OS.get_ticks_msec() / 1000.0
		last_move_right_press_time = current_time

	if Input.is_action_just_released("right"):
		idle()
		is_running = false
		speed = 400
		

	# Moving Left
	if Input.is_action_pressed("left"):
		
		movement_history = "left"
		
		
		var is_double = double_tap("left",last_move_left_press_time) 
		if is_double:
			speed = 600
			is_running = true
			
		if not is_attacking and jumps_remaining == 2 : #not in the air
			if is_running:
				run(true)
			elif is_crouching:
				crouch()
			else:
				walk(true)
			
		velocity.x -= speed
		
		var current_time = OS.get_ticks_msec() / 1000.0
		last_move_left_press_time = current_time
		
	
	if Input.is_action_just_released("left"):
		speed = 400
		is_running = false
		idle()
		
	# Crouching
	if Input.is_action_just_pressed("down"):
		speed = 100
		$default.disabled = true
		is_crouching = true
		
	if Input.is_action_just_released("down"):
		speed = 400
		$default.disabled = false
		is_crouching = false
	
	
	#Attacking
	if Input.is_action_just_pressed("attack"):
		is_attacking = true
		attack()
	
	if Input.is_action_just_released("attack"):
		yield(get_tree().create_timer(1), "timeout")
		is_attacking = false
		$"hit/hit-area-left".disabled = true
		$"hit/hit-area-right".disabled = true
		
	
func _physics_process(delta):
	velocity.y += delta * GRAVITY
	get_input()
	velocity = move_and_slide(velocity,UP)


func _on_hit_body_entered(body):
	if body.name == "Slime":
		body.queue_free()

	
# Sprite made separate to fit the character sheet

func idle():
	animation.play("idle")
	$idle.show()
	
	$walk.hide()
	$jump.hide()
	$run.hide()
	$attack.hide()
	
func walk(flip):
	animation.play("walk")
	$walk.flip_h = flip
	$walk.show()
	
	$idle.hide()
	$jump.hide()
	$run.hide()
	$attack.hide()
	
func run(flip):
	animation.play("run")
	$run.flip_h = flip
	$run.show()
	
	$walk.hide()
	$idle.hide()
	$jump.hide()
	$attack.hide()

func crouch():
	animation.play("crouch")
	$jump.flip_h = (movement_history == "left")
	$jump.show()
	
	$walk.hide()
	$idle.hide()
	$run.hide()
	$attack.hide()

func jump():
	animation.play("jump")
	$jump.flip_h = (movement_history == "left")
	$jump.show()
	
	$walk.hide()
	$idle.hide()
	$run.hide()
	$attack.hide()
	
func attack():
	animation.play("attack")
	$attack.show()
	
	$walk.hide()
	$idle.hide()
	$run.hide()
	$jump.hide()
	
	if movement_history == "left":
		$attack.flip_h = true
		$"hit/hit-area-left".disabled = false
	else:
		$attack.flip_h = false
		$"hit/hit-area-right".disabled = false
	
