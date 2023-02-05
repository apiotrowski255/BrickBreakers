extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var play_button = $"%playButton"
onready var option_button = $"%optionButton"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _on_playButton_pressed():
	get_tree().change_scene("res://actors/main.tscn")


func _on_optionButton_pressed():
	get_tree().change_scene("res://UI/optionMenu.tscn")
