extends Node2D

onready var audio_stream_player = $AudioStreamPlayer

var current_sfx_volume := -20.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	audio_stream_player.volume_db = -10.0
	audio_stream_player.playing = true

func set_volume(volume: float) -> void:
	audio_stream_player.volume_db = volume

func get_volume() -> float:
	return audio_stream_player.volume_db

func get_sfx_volume() -> float:
	return current_sfx_volume
	
func set_sfx_volume(value: float) -> void:
	current_sfx_volume = value
