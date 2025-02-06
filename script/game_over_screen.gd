extends CanvasLayer
@onready var music: AudioStreamPlayer = $music

func _ready() -> void:
	music.play()

func _on_restart_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/fase.tscn")
