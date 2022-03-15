extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var score = 0
var game_over = false

# Called when the node enters the scene tree for the first time.
func _ready():
	score = 0
	$UI/Control/GameOver.visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if game_over:
		$UI/Control/Label.visible = true
		$UI/Control/Label.set_position(Vector2(390,0))
		$UI/Control/GameOver.visible = true
	pass

func add_score(val):
	score += val
	$UI/Control/Label.text = str(score)
