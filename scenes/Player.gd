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

const UP = Vector2(0,-1)

var velocity = Vector2()

#var direction = Vector2()

func get_input():
	velocity.x = 0
	
	if is_on_floor() and Input.is_action_just_pressed('up'):
		velocity.y = jump_speed
		
		# https://www.youtube.com/watch?v=xweO2LCx_Yc
		
	if Input.is_action_pressed("right"):
		velocity.x += speed
		#direction = Vector2.RIGHT
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
