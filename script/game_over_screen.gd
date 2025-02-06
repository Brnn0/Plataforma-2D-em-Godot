extends CanvasLayer
@onready var music: AudioStreamPlayer = $music
@onready var restart_button: Button = $PanelContainer/MarginContainer/Rows/CenterContainer/RestartButton

func _ready() -> void:
	music.play()
	restart_button.grab_focus()
	
func _on_restart_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/fase.tscn")

func _on_quit_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/UI/menu.tscn")
