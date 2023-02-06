extends KinematicBody2D
class_name ball

export var speed: float = 8.0
var direction: Vector2
var spawn_position: Vector2 = Vector2(300, 450)
var allow_speed_deactivate: bool = false

onready var cpu_particles_2d: CPUParticles2D = $CPUParticles2D
onready var timer: Timer = $Timer
onready var line_2d: Line2D = $Line2D
onready var tween: Tween = $Tween
onready var ball: KinematicBody2D = $"."

signal player_lose_life

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func start_moving() -> void:
	randomize()
	cpu_particles_2d.emitting = false
	line_2d.visible = true
	timer.start(1.0)
	yield(timer, "timeout")
	speed = 0
	tween.interpolate_property(self, "direction",  Vector2.RIGHT, choose_random_direction(), 1, Tween.TRANS_LINEAR)
	tween.start()
	yield(tween, "tween_completed")
	timer.start(0.5)
	yield(timer, "timeout")
	speed = 8.0
	cpu_particles_2d.direction = -direction
	cpu_particles_2d.emitting = true
	line_2d.visible = false
	tween.start()

func reset() -> void:
	global_position = Vector2(300, 450)
	speed = 0
	start_moving() 

func choose_random_direction() -> Vector2:
	var x = rand_range(-1.0, 1.0)
	var y = rand_range(0.2, 1.0)
	if rand_range(0.0, 1.0) >= 0.5:
		y = -y
	var v = Vector2(x, y).normalized()
	return v

func activate_speed_power_up() -> void:
	if speed == 8.0:
		speed = speed * 2


# Deactivates the speed power up when the ball collides with the wall
func deactivate_speed_power_up() -> void:
	if speed == 16.0 and allow_speed_deactivate == true:
		speed = speed / 2

func _physics_process(delta: float) -> void:
	var result = move_and_collide(direction * speed)
	line_2d.rotation = direction.angle()
	if result != null:
#		Colliding with a brick
		if log(result.collider.get_collision_layer())/log(2) + 1 == 2:
			result.collider.decrement_life()
			if speed == 8.0:
				direction = direction.bounce(result.normal)
			else:
				allow_speed_deactivate = true

#		Colliding with the player
		elif log(result.collider.get_collision_layer())/log(2) + 1 == 3:
			direction = result.collider.global_position.direction_to(global_position)

#		Colliding with bottom wall
#		respawn the ball
		elif log(result.collider.get_collision_layer())/log(2) + 1 == 7:
			self.queue_free()
		else:
			if speed == 16.0:
				deactivate_speed_power_up()
				allow_speed_deactivate = false
			direction = direction.bounce(result.normal)

		if abs(direction.y) < 0.05:
			direction.y += 0.1
			direction = direction.normalized()
		
		cpu_particles_2d.direction = -direction
