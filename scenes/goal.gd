extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.

func _ready():
	$AnimationPlayer.play("archer-idle")
	$AnimationPlayer2.play("sorcerer-idle")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_goal_body_entered(body):
	if(body.name == "Player"):
		yield(get_tree().create_timer(1), "timeout")
		get_tree().change_scene("res://scenes/Finish.tscn")
	pass # Replace with function body.
