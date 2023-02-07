extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var button = $"%Button"
onready var h_slider = $MarginContainer/VBoxContainer/HSlider
onready var h_slider_2 = $MarginContainer/VBoxContainer/HSlider2
onready var audio_stream_player = $AudioStreamPlayer
onready var animation_player = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	h_slider.value = AudioMusic.get_volume()
	h_slider_2.value = AudioMusic.get_sfx_volume()
	audio_stream_player.volume_db = AudioMusic.get_sfx_volume()

func _on_Button_pressed():
	audio_stream_player.play()
	animation_player.play("fade_to_black")
	yield(animation_player, "animation_finished")
	get_tree().change_scene("res://UI/mainMenu.tscn")


func _on_HSlider_value_changed(value):
	AudioMusic.set_volume(value)

func _on_HSlider2_value_changed(value):
	AudioMusic.set_sfx_volume(value)
