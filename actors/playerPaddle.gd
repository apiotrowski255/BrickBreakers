extends KinematicBody2D


export var speed := 5.0
var direction : Vector2 = Vector2.ZERO
onready var cpu_particles_2d = $CPUParticles2D
onready var collision_shape_2d = $CollisionShape2D
onready var white_square = $WhiteSquare
onready var tween = $Tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _physics_process(delta: float) -> void:
	global_position.y = 900 # Clamp the y position to this value
	if Input.is_action_pressed("ui_right"):
		direction = Vector2.RIGHT
		cpu_particles_2d.emitting = true
		cpu_particles_2d.direction = -direction
	elif Input.is_action_pressed("ui_left"):
		direction = Vector2.LEFT
		cpu_particles_2d.emitting = true
		cpu_particles_2d.direction = -direction
	else:
		direction = direction.move_toward(Vector2.ZERO, 0.05)
		cpu_particles_2d.emitting = false
	move_and_collide(direction * speed)

func shrink_paddle() -> void:
	if collision_shape_2d.scale == Vector2(1.5, 1):
		tween.interpolate_property(collision_shape_2d, "scale", null, Vector2(1, 1), 1.0)
		tween.interpolate_property(white_square, "scale", null, Vector2(12.5, 2.5), 1.0)
		tween.start()
	elif collision_shape_2d.scale == Vector2(1, 1):
		tween.interpolate_property(collision_shape_2d, "scale", null, Vector2(0.5, 1), 1.0)
		tween.interpolate_property(white_square, "scale", null, Vector2(6.25, 2.5), 1.0)
		tween.start()
	else:
		return


