extends StaticBody2D
class_name brick

export var lives := 1

signal spawn_particles
signal spawn_powerup # When a brick is destroy - chance to spawn a powerup

onready var white_square: Sprite = $WhiteSquare

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
func decrement_life() -> void:
	lives -= 1
	if lives == 0:
		emit_signal("spawn_particles", self.global_position)
		if rand_range(-1.0, 1.0) > 0:
			emit_signal("spawn_powerup", self.global_position)
		self.queue_free()
	
