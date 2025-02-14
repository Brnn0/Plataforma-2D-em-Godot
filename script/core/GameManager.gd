extends Node

signal gained_hearts(int)
signal losed_lives(int)
const GETHEART = preload("res://assets/sounds/Items/GETHEART.wav")
var sfx_collect: AudioStreamWAV = GETHEART

var hearts : int
var current_checkpoint: Checkpoint
var player: Player
var max_lives = 3
var lives : int = max_lives

func respawn_player():
	player.is_alive = true
	player.health = player.max_health
	player.health_changed.emit()
	if current_checkpoint != null:
		player.position = current_checkpoint.global_position
		player.bg_music.play()
		lives -= 1
		losed_lives.emit()
	if lives < 0:
		hearts = 0
		get_tree().reload_current_scene()
		get_tree().change_scene_to_file("res://scenes/UI/game_over_screen.tscn")
		
func gain_hearts(hearts_gained):
	hearts += hearts_gained
	sfx_collect
	emit_signal("gained_hearts", hearts_gained)
