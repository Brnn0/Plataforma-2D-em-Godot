extends CanvasLayer

@onready var quit: Button = $PanelContainer/MarginContainer/HBoxContainer/VBoxContainer/CenterContainer/VBoxContainer2/Quit
@onready var start: Button = $PanelContainer/MarginContainer/HBoxContainer/VBoxContainer/CenterContainer/VBoxContainer2/Start
@onready var music: AudioStreamPlayer = $music
@onready var title_container: VBoxContainer = $PanelContainer/MarginContainer/HBoxContainer/VBoxContainer/TitleContainer


func _ready() -> void:
	music.play()
	start.grab_focus()
	title_container.modulate

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/fase.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
