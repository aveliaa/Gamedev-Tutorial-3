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

func idle():
	animation.play("idle")
	$idle.show()
	$walk.hide()
	$jump.hide()
	
func walk(flip):
	animation.play("walk")
	$walk.flip_h = flip
	$walk.show()
	$idle.hide()
	$jump.hide()

func jump():
	animation.play("jump")
	$walk.hide()
	$idle.hide()
	
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
	
	#if is_on_floor() and Input.is_action_just_pressed('up'):
		
	#	velocity.y = jump_speed
		
		
	#	var current_time = OS.get_ticks_msec() / 1000.0
		# https://www.youtube.com/watch?v=xweO2LCx_Yc
		
	if Input.is_action_pressed("right"):
		
		movement_history = "right"
		
		if jumps_remaining == 2: #if not in the air
			walk(false)
		
		var is_double = double_tap("right",last_move_right_press_time)
		if is_double:
			speed = 1000 
		
		velocity.x += speed
		
		var current_time = OS.get_ticks_msec() / 1000.0
		last_move_right_press_time = current_time

	if Input.is_action_just_released("right"):
		idle()
		speed = 400
		

	if Input.is_action_pressed("left"):
		
		movement_history = "left"
		
		if jumps_remaining == 2: #if not in the air
			walk(true)
		
		var is_double = double_tap("left",last_move_left_press_time) 
		if is_double:
			speed = 1000
			
		velocity.x -= speed
		
		var current_time = OS.get_ticks_msec() / 1000.0
		last_move_left_press_time = current_time
		
	
	if Input.is_action_just_released("left"):
		speed = 400
		idle()
		
	# Crouching
	if Input.is_action_just_pressed("down"):
		speed = 100
	if Input.is_action_just_released("down"):
		speed = 400
	
	# next idea, roll? slide? shoot? punch?
	
func _physics_process(delta):
	velocity.y += delta * GRAVITY
	get_input()
	velocity = move_and_slide(velocity,UP)
