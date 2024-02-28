extends Node2D

var t := 0.0
func _process(delta):
	t+= delta
	$Path2D/PathFollow2D.offset = t*200.0
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
