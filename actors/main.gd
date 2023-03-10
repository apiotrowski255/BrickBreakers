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
onready var player_paddle = $playerPaddle
onready var main_game_ui = $"%mainGameUI"
onready var timer = $Timer
onready var audio_stream_player = $AudioStreamPlayer


var score := 0 setget set_score
var player_lives := 5 setget decrement_lives
var current_level := 1 setget increment_level

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	read_level(current_level)
	# read_level_03()
	original_ball.connect("tree_exited", self ,"_on_ball_delete")
	original_ball.start_moving()
	audio_stream_player.volume_db = AudioMusic.get_sfx_volume()

func set_score(value : int) -> void:
	score = value
	main_game_ui.update_score(score)

func increment_level(increment: int) -> void:
	current_level += increment
	main_game_ui.update_level(current_level)

func decrement_lives(increment: int = 1) -> void:
	player_lives -= increment
	main_game_ui.update_lives(player_lives)

func _process(delta: float) -> void:
	for emitter in brick_explosion_holder.get_children():
		if emitter.emitting == false:
			emitter.queue_free()
	pass
	if Input.is_action_just_pressed("quit"):
		get_tree().change_scene("res://UI/mainMenu.tscn")

func load_brick_layer(y_position: int, texture_number: int = 1, lives: int = 1) -> void:
	var current_x_position := 50
	if texture_number > 20:
		current_x_position = 10
	while current_x_position < 600:
		var new_brick = brick.instance()
		new_brick.global_position = Vector2(current_x_position, y_position)
		brick_holder.add_child(new_brick)
		new_brick.connect("spawn_particles", self, "_on_brick_destroy")
		new_brick.connect("spawn_powerup", self, "_spawn_powerup")
		new_brick.connect("tree_exited", self, "_on_brick_exit")
		new_brick.lives = lives
		new_brick.set_texture_number(texture_number)
		if texture_number > 20:
			current_x_position += 20
		else:
			current_x_position += 100

func _on_brick_exit() -> void: 
	if brick_holder.get_child_count() == 0:
		set_score(score + 100)
		player_paddle.reset_paddle_size()
		increment_level(1)
		if current_level == 4:
			clear_balls_except_for_one()
			clear_powerups()
			original_ball = ball_holder.get_child(0)
			original_ball.hide()
			original_ball.speed = 0
			original_ball.global_position = Vector2(300, 450)
			main_game_ui.show_center_text("You win! Thanks for playing")
			timer.start(4.0)
			yield(timer, "timeout")
			get_tree().change_scene("res://UI/mainMenu.tscn")
		else: 
			main_game_ui.show_center_text("Level Completed!")
			clear_balls_except_for_one()
			clear_powerups()
			original_ball = ball_holder.get_child(0)
			original_ball.reset()

func clear_powerups() -> void:
	var i = 0
	while i < powerup_holder.get_child_count():
		powerup_holder.get_child(i).queue_free()
		i += 1

func clear_balls_except_for_one() -> void:
	var i = 1
	while i < ball_holder.get_child_count():
		ball_holder.get_child(i).queue_free()
		i += 1

func load_bricks() -> void:
	var i:= 0
	while i < 8:
		load_brick_layer(30 + i * 20)
		i += 1

func _on_brick_destroy(position : Vector2) -> void:
	var new_explosion = explosion.instance()
	new_explosion.global_position = position
	new_explosion.emitting = true
	brick_explosion_holder.add_child(new_explosion)
	set_score(score + 10)


func _spawn_powerup(position: Vector2) -> void:
	var new_powerup = powerup.instance()
	new_powerup.global_position = position
	new_powerup.connect("trigger_power_up", self, "_trigger_power_up")
	new_powerup.powerupType = pick_random_powerup_type()
	powerup_holder.add_child(new_powerup)

func pick_random_powerup_type() -> Resource:
	randomize()
	var random = rand_range(0, 1.2)
	if random < 0.2:
		return PowerUp.PowerUps.MULTIPLY
	elif random < 0.4:
		return PowerUp.PowerUps.SPEEDUP
	elif random < 0.6:
		return PowerUp.PowerUps.SEEK
	elif random < 0.8:
		return PowerUp.PowerUps.SHRINK_PADDLE
	elif random < 1.0:
		return PowerUp.PowerUps.EXPAND_PADDLE
	else:
		return PowerUp.PowerUps.ADD_POINTS
	
func _trigger_power_up(powerupType) -> void:
	if powerupType == PowerUp.PowerUps.MULTIPLY:
		_trigger_multiply_power_up()
	elif powerupType == PowerUp.PowerUps.SPEEDUP:
		_trigger_speed_power_up()
	elif powerupType == PowerUp.PowerUps.SEEK:
		_trigger_seek_power_up()
	elif powerupType == PowerUp.PowerUps.SHRINK_PADDLE:
		player_paddle.shrink_paddle()
	elif powerupType == PowerUp.PowerUps.EXPAND_PADDLE:
		player_paddle.expand_paddle()
	elif powerupType == PowerUp.PowerUps.ADD_POINTS:
		set_score(score + 50)
	audio_stream_player.play()

func get_random_brick_position() -> Vector2:
	if brick_holder.get_child_count() == 0:
		return Vector2.ZERO
	randomize()
	var random_brick = brick_holder.get_child(int(rand_range(0, brick_holder.get_child_count())))
	return random_brick.position

func _trigger_seek_power_up() -> void:
	for b in ball_holder.get_children():
		var p1: Vector2 = get_random_brick_position()
		var p2: Vector2 = b.position
		var direction = p2.direction_to(p1)
		b.direction = direction


# Takes all existings balls and doubles their speed
func _trigger_speed_power_up() -> void:
	for b in ball_holder.get_children():
		b.activate_speed_power_up()

# Takes all existings balls and duplicates them by 3
func _trigger_multiply_power_up() -> void:
	var ball_array := []
	for b in ball_holder.get_children():
		var ball_new = ball_scene.instance()
		ball_new.global_position = b.global_position
		ball_new.direction = b.direction.rotated(PI/24)
		ball_new.speed = b.speed
		ball_new.connect("tree_exited", self ,"_on_ball_delete")
		ball_array.append(ball_new)
		
		var ball_new2 = ball_scene.instance()
		ball_new2.global_position = b.global_position
		ball_new2.direction = b.direction.rotated(-PI/24)
		ball_new2.speed = b.speed
		ball_new2.connect("tree_exited", self ,"_on_ball_delete")
		ball_array.append(ball_new2)
		
	# Now we can add the addition balls to the ball_holder node
	for b in ball_array:
		ball_holder.add_child(b)


func _on_ball_delete() -> void:
	if ball_holder.get_child_count() == 0:
		decrement_lives()
		for p in powerup_holder.get_children():
			p.queue_free()
		if player_lives != 0:
			spawn_ball()
		else:
			for b in ball_holder.get_children():
				b.queue_free()
			for b in brick_explosion_holder.get_children():
				b.queue_free()
			main_game_ui.show_center_text("You lose! Better luck next time. ")
			timer.start(4.0)
			yield(timer, "timeout")
			get_tree().change_scene("res://UI/mainMenu.tscn")

func spawn_ball() -> void:
	original_ball = ball_scene.instance()
	original_ball.global_position = Vector2(300, 450)
	ball_holder.add_child(original_ball)
	original_ball.connect("tree_exited", self ,"_on_ball_delete")
	original_ball.start_moving()
	player_paddle.reset_paddle_size()


func handle_line(line: String, line_number: int) -> void:
	if line[0] == "l":
		handle_l_function(line, line_number)

func handle_l_function(line: String, line_number: int) -> void:
	var texture: int = 1
	var lives: int = 1
	if line == "l":
		pass
	elif line.length() == 3:
		texture = int(line[1]) * 10 + int(line[2])
	elif line.length() == 4:
		texture = int(line[1]) * 10 + int(line[2])
		lives = int(line[3])
	load_brick_layer(50 + 20*line_number, texture, lives)


func read_level(level_number: int) -> void:
	if level_number < 10:
		var file = File.new()
		file.open("res://levels/level0" + str(level_number) + ".txt", File.READ)
		var line_number := 0
		while file.get_position() != file.get_len():
			var line = file.get_line()
			handle_line(line, line_number)
			line_number += 1
		file.close()
	else:
		# Most likely will not have more than 9 levels. 
		pass

func spawn_brick(x_position: int, y_position: int, color_number: int, lives: int = 1) -> void:
	var new_brick = brick.instance()
	new_brick.global_position = Vector2(x_position, y_position)
	brick_holder.add_child(new_brick)
	new_brick.connect("spawn_particles", self, "_on_brick_destroy")
	new_brick.connect("spawn_powerup", self, "_spawn_powerup")
	new_brick.connect("tree_exited", self, "_on_brick_exit")
	new_brick.lives = lives
	new_brick.set_texture_number(color_number)



func _on_mainGameUI_next_level():
	if current_level == 4 or player_lives == 0:
		pass
	else:
		read_level(current_level)
		main_game_ui.hide_center_text()
