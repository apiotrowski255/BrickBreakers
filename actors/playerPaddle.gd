extends KinematicBody2D


export var speed := 5.0
var direction : Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _physics_process(delta: float) -> void:
	global_position.y = 900 # Clamp the y position to this value
	if Input.is_action_pressed("ui_right"):
		direction = Vector2.RIGHT
	elif Input.is_action_pressed("ui_left"):
		direction = Vector2.LEFT
	else:
		direction = direction.move_toward(Vector2.ZERO, 0.05)
	move_and_collide(direction * speed)
