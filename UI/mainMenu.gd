extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var play_button = $"%playButton"
onready var option_button = $"%optionButton"
onready var audio_stream_player = $AudioStreamPlayer
onready var timer = $Timer
onready var animation_player = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	audio_stream_player.volume_db = AudioMusic.get_sfx_volume()
#	play_button.grab_focus()
	pass # Replace with function body.



func _on_playButton_pressed():
	audio_stream_player.play()
	animation_player.play("fade_to_black")
	yield(animation_player, "animation_finished")
	get_tree().change_scene("res://actors/main.tscn")


func _on_optionButton_pressed():
	audio_stream_player.play()
	animation_player.play("fade_to_black")
	yield(animation_player, "animation_finished")
	get_tree().change_scene("res://UI/optionMenu.tscn")
