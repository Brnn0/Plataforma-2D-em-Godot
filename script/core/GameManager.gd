extends Node

signal gained_hearts(int)

var hearts : int
var current_checkpoint: Checkpoint
var player: Player

func respawn_player():
	if current_checkpoint != null:
		player.position = current_checkpoint.global_position
		
func gain_hearts(hearts_gained):
	hearts += hearts_gained
	emit_signal("gained_hearts", hearts_gained)
