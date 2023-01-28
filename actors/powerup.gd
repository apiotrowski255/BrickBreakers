extends KinematicBody2D

var direction: Vector2 = Vector2.DOWN
var speed: float = 5.0
# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

export var powerupType: String

signal trigger_power_up

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var result = move_and_collide(speed * direction)
	if result != null:
		if result.collider.get_collision_layer() == 4:
			emit_signal("trigger_power_up", powerupType)
		self.queue_free()
