extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

export (int) var speed = 400 # diexport biar keliatan di inspektornya. biar ez lebi fleksibel
export (int) var GRAVITY = 1200
export (int) var jump_speed = -600

#var right_counter = 0
#var left_counter = 0

var last_move_right_press_time = 0
var double_tap_threshold = 0.15

const UP = Vector2(0,-1)

var velocity = Vector2()

#var direction = Vector2()

func get_input():
	velocity.x = 0
	
	
	if is_on_floor() and Input.is_action_just_pressed('up'):
		velocity.y = jump_speed
		
		# https://www.youtube.com/watch?v=xweO2LCx_Yc
		
	if Input.is_action_pressed("right"):
		
		#if Input.is_action_just_pressed("right"): # deteksi sekali tekan -> GA IMMIDIATE WKWWKKWWKWK SALAH, kayaknya main just realeased, OH MAKE TIMER
		#	right_counter += 1
		#	print(right_counter)
		
		#if right_counter == 2:
		#	speed = 600
		#	right_counter = 0
		#else:
		#	speed = 400
		var current_time = OS.get_ticks_msec() / 1000.0
		if Input.is_action_just_pressed("right"):
			  # Convert to seconds
			print(current_time)
			if current_time - last_move_right_press_time < double_tap_threshold:
				# Double tap detected
				print("Double tap detected!") # mantab, integrate bareng ama is just
				speed = 600 #bejir la kekiri juga keefek wkwk
		
		
		velocity.x += speed
		last_move_right_press_time = current_time
		#direction = Vector2.RIGHT
	if Input.is_action_just_released("right"):
		speed = 400
		
	# PERFEK!!
	
	if Input.is_action_pressed("left"):
		velocity.x -= speed
		#direction = Vector2.LEFT
		
	# Crouching
	if Input.is_action_just_pressed("down"):
		speed = 100
	if Input.is_action_just_released("down"):
		speed = 400
		
	#if Input.hold
	
	#velocity.x = direction.x * speed
	
func _physics_process(delta):
	velocity.y += delta * GRAVITY
	get_input()
	velocity = move_and_slide(velocity,UP)
