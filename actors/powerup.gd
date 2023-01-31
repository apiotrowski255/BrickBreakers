extends KinematicBody2D
class_name PowerUp

var direction: Vector2 = Vector2.DOWN
var speed: float = 5.0
# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
onready var sprite = $Sprite
enum PowerUps {MULTIPLY, SPEEDUP, SEEK, SHRINK_PADDLE, EXPAND_PADDLE, ADD_POINTS}

var powerupType

signal trigger_power_up

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if powerupType == PowerUps.MULTIPLY:
		sprite.texture = load("res://sprites/Breakout Tile Set Free/PNG/43-Breakout-Tiles.png")
	elif powerupType == PowerUps.SPEEDUP:
		sprite.texture = load("res://sprites/Breakout Tile Set Free/PNG/44-Breakout-Tiles.png")
	elif powerupType == PowerUps.SEEK:
		sprite.texture = load("res://sprites/Breakout Tile Set Free/PNG/45-Breakout-Tiles.png")
	elif powerupType == PowerUps.SHRINK_PADDLE:
		sprite.texture = load("res://sprites/Breakout Tile Set Free/PNG/46-Breakout-Tiles.png")
	elif powerupType == PowerUps.EXPAND_PADDLE:
		sprite.texture = load("res://sprites/Breakout Tile Set Free/PNG/47-Breakout-Tiles.png")
	elif powerupType == PowerUps.ADD_POINTS:
		sprite.texture = load("res://sprites/Breakout Tile Set Free/PNG/31-Breakout-Tiles.png")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var result = move_and_collide(speed * direction)
	if result != null:
		# collide with the player paddle
		if result.collider.get_collision_layer() == 4:
			emit_signal("trigger_power_up", powerupType)
		self.queue_free()
