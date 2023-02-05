extends Node2D

onready var audio_stream_player = $AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	audio_stream_player.playing = true

func set_volume(volume: float) -> void:
	audio_stream_player.volume_db = volume

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
