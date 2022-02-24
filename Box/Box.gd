extends KinematicBody2D
class_name Box

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var gravity_scale = 400
export var speed = 400
export var type: String

var carried = false

var target_x_position;
var target_y_position;
var moving = false
var falling = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func drop_to_y_position(pos):
	falling = true
	target_y_position = pos
	
func move_to_x_position(pos):
	moving = true
	target_x_position = pos
	
func is_falling():
	return falling
	
func is_moving():
	return moving
	
func is_steady():
	return not (moving or falling)
	
func _physics_process(_delta):
	var velocity = Vector2()
	if falling:
		velocity.y = gravity_scale
	if moving:
		velocity.x = -speed
		
	# snap to position
	if falling:
		if self.position.y > target_y_position:
			self.position.y = target_y_position
			
		if abs(self.position.y - target_y_position) < 0.05:
			velocity.y = 0
			falling = false
		
	# snap to position
	if moving:
		if self.position.x < target_x_position:
			self.position.x = target_x_position
			
		if abs(self.position.x - target_x_position) < 0.05:
			velocity.x = 0
			moving = false
	
	velocity = move_and_slide(velocity, Vector2.UP)

# functions to enable / disable the collision properties of the box
# used for when the player picks up / puts down the box.
func disable_collision():
	set_player_collision(true)
	
func enable_collision():
	set_player_collision(false)
	
func set_player_collision(disabled):
	$CollisionShape2D.disabled = disabled
	$PlayerCollisionLeft/CollisionShape2D.disabled = disabled
	$PlayerCollisionRight/CollisionShape2D.disabled = disabled
	$PlayerCollisionTop/CollisionShape2D.disabled = disabled
	$PlayerInteractArea/CollisionShape2D.disabled = disabled
	$PlayerInsideDetector/CollisionShape2D.disabled = disabled

# if player is inside box push the player up through the box.
func _on_PlayerInsideDetector_body_entered(body):
	if not body.is_in_group("Player"): return 
	body.position.y -= 100
