extends Node2D
class_name Checkpoint

@export var spawnpoint = false

var activated = false

func activate():
	GameManager.current_checkpoint = self
	activated = true

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player && !activated:
		activate()
