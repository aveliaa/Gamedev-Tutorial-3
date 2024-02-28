extends KinematicBody2D

# TODO : perkecil collision saat nunduk, enermy, game over, decor, attack, dash animation
func _ready():
	idle()
	pass # Replace with function body.



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

func idle():
	animation.play("idle")
	$idle.show()
	$walk.hide()
	$jump.hide()
	$run.hide()
	
func walk(flip):
	animation.play("walk")
	$walk.flip_h = flip
	$walk.show()
	$idle.hide()
	$jump.hide()
	$run.hide()
	
func run(flip):
	print("hi")
	animation.play("run")
	$run.flip_h = flip
	$walk.hide()
	$idle.hide()
	$jump.hide()
	$run.show()

func crouch():
	animation.play("crouch")
	$walk.hide()
	$idle.hide()
	$run.hide()
	
	if movement_history == "left":
		$jump.flip_h = true
	else:
		$jump.flip_h = false
	$jump.show()

func jump():
	animation.play("jump")
	$walk.hide()
	$idle.hide()
	$run.hide()
	
	if movement_history == "left":
		$jump.flip_h = true
	else:
		$jump.flip_h = false
	$jump.show()

func double_tap(direction,last_move_time):
	var current_time = OS.get_ticks_msec() / 1000.0
	
	if Input.is_action_just_pressed(direction):
		print(current_time)
		if current_time - last_move_time < double_tap_threshold:

			print("Double tap detected!") 
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
		
	if Input.is_action_pressed("right"):
		
		movement_history = "right"
		
		
		var is_double = double_tap("right",last_move_right_press_time)
		if is_double:
			speed = 600
			is_running = true
			
		if jumps_remaining == 2: #not in the air
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
		

	if Input.is_action_pressed("left"):
		
		movement_history = "left"
		
		
		var is_double = double_tap("left",last_move_left_press_time) 
		if is_double:
			speed = 600
			is_running = true
			
		if jumps_remaining == 2: #not in the air
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
		is_crouching = true
		
	if Input.is_action_just_released("down"):
		speed = 400
		is_crouching = false
	
	# next idea, roll? slide? shoot? punch?
	
func _physics_process(delta):
	velocity.y += delta * GRAVITY
	get_input()
	velocity = move_and_slide(velocity,UP)
