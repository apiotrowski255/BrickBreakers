extends Node2D

var brick = preload("res://actors/brick.tscn")
var explosion = preload("res://actors/brick_explosion.tscn")
var powerup = preload("res://actors/powerup.tscn")
var ball_scene = preload("res://actors/ball.tscn")

onready var brick_explosion_holder: Node2D = $holders/brickExplosionHolder
onready var powerup_holder: Node2D = $holders/powerupHolder
onready var ball_holder: Node2D = $holders/ballHolder
onready var brick_holder: Node2D = $holders/brickHolder

onready var original_ball: KinematicBody2D = $holders/ballHolder/ball


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_bricks()
	original_ball.connect("tree_exited", self ,"_on_ball_delete")
	original_ball.start_moving()
	

func _process(delta: float) -> void:
	for emitter in brick_explosion_holder.get_children():
		if emitter.emitting == false:
			emitter.queue_free()
	pass

	
func load_brick_layer(y_position : int) -> void:
	var i := 0
	while i < 6:
		var new_brick = brick.instance()
		new_brick.global_position = Vector2(i * 100 + 50, y_position)
		brick_holder.add_child(new_brick)
		new_brick.connect("spawn_particles", self, "_on_brick_hit")
		new_brick.connect("spawn_powerup", self, "_spawn_powerup")
		new_brick.connect("tree_exited", self, "_on_brick_exit")
		new_brick.lives = 1
		i += 1

func _on_brick_exit() -> void: 
	print(brick_holder.get_child_count())
	if brick_holder.get_child_count() == 0:
		print("Level complete")
		
func load_bricks() -> void:
	var i:= 0
	while i < 8:
		load_brick_layer(30 + i * 20)
		i += 1

func _on_brick_hit(position : Vector2) -> void:
	var new_explosion = explosion.instance()
	new_explosion.global_position = position
	new_explosion.emitting = true
	brick_explosion_holder.add_child(new_explosion)


func _spawn_powerup(position: Vector2) -> void:
	var new_powerup = powerup.instance()
	new_powerup.global_position = position
	new_powerup.connect("trigger_power_up", self, "_trigger_power_up")
	if rand_range(-1.0, 1.0) > 0.0:
		new_powerup.powerupType = "multiply"
	powerup_holder.add_child(new_powerup)

func _trigger_power_up(powerupType : String) -> void:
	if powerupType == "multiply":
		_trigger_multiply_power_up()
	else: 
		_trigger_speed_power_up()

# Takes all existings balls and doubles their speed
func _trigger_speed_power_up() -> void:
	for b in ball_holder.get_children():
		b.activate_speed_power_up()

# Takes all existings balls and duplicates them
func _trigger_multiply_power_up() -> void:
	var ball_array := []
	for b in ball_holder.get_children():
		var ball_new = ball_scene.instance()
		ball_new.global_position = b.global_position
		ball_new.direction = b.direction.rotated(PI/24)
		b.direction = b.direction.rotated(-PI/24)
		ball_new.connect("tree_exited", self ,"_on_ball_delete")
		ball_array.append(ball_new)
		
	# Now we can add the addition balls to the ball_holder node
	for b in ball_array:
		ball_holder.add_child(b)


func _on_ball_delete() -> void:
	if ball_holder.get_child_count() == 0:
		print("player lose life")
		spawn_ball()

func spawn_ball() -> void:
	original_ball = ball_scene.instance()
	original_ball.global_position = Vector2(300, 450)
	ball_holder.add_child(original_ball)
	original_ball.connect("tree_exited", self ,"_on_ball_delete")
	original_ball.start_moving()
