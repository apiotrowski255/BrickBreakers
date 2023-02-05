extends StaticBody2D
class_name brick

export var lives := 1

signal spawn_particles
signal spawn_powerup # When a brick is destroy - chance to spawn a powerup

onready var sprite: Sprite = $sprite

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
func decrement_life() -> void:
	lives -= 1
	
	if lives == 1 and get_texture_number() % 2 == 1 and get_texture_number() < 20:
		# Update the texture here
		var new_number: String = increment_texture()
		var path: String = "res://sprites/Breakout Tile Set Free/PNG/" + new_number + "-Breakout-Tiles.png"
		sprite.texture = load(path)
		pass
	if lives == 0:
		emit_signal("spawn_particles", self.global_position)
		if rand_range(-1.0, 1.0) > 0:
			emit_signal("spawn_powerup", self.global_position)
		self.queue_free()
		
	
func get_texture_name() -> String:
	return sprite.texture.get_path().substr(sprite.texture.get_path().rfind('/') + 1, sprite.texture.get_path().length())

# Gets the number infront of the texture name
func get_texture_number() -> int:
	var text : String = sprite.texture.get_path().substr(sprite.texture.get_path().rfind('/') + 1, sprite.texture.get_path().length())
	return text.left(2).to_int()

func set_texture_number(number: int) -> void:
	var path: String
	if number < 10:
		path = "res://sprites/Breakout Tile Set Free/PNG/0" + str(number) + "-Breakout-Tiles.png"
	else:
		path = "res://sprites/Breakout Tile Set Free/PNG/" + str(number) + "-Breakout-Tiles.png"
		
	if number >= 21:
		print(number)
		sprite.scale = Vector2(0.156, 0.156)
		self.get_node("CollisionShape2D").set_shape(RectangleShape2D.new())
	sprite.texture = load(path)

func increment_texture() -> String:
	var current_number = get_texture_number() + 1
	if current_number < 10:
		return "0" + str(current_number)
	else:
		return str(current_number)
