extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var current_level = $"%current_level"
onready var score = $"%score"
onready var lives = $"%lives"

onready var center_text = $"%centerText"
onready var timer = $Timer

signal next_level

# Called when the node enters the scene tree for the first time.
func _ready():
	current_level.text = "  Current Level: 1"
	lives.text = "lives: " + str(5) + "          "
	score.text = "      Score: " + str(0)
	center_text.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func update_level(level: int) -> void:
	current_level.text = "  Current Level: " + str(level)

func update_lives(player_lives: int) -> void:
	lives.text = "lives: " + str(player_lives) + "          "

func update_score(player_score: int) -> void:
	score.text = "      Score: " + str(player_score)

func show_center_text(text: String) -> void:
	center_text.text = text
	center_text.show()
	timer.start(3.0)
	yield(timer, "timeout")
	emit_signal("next_level")

func hide_center_text() -> void:
	center_text.hide()
