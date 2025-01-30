extends Node2D
class_name Checkpoint

@export var spawnpont = false

var activated = false

func _ready() -> void:
	if spawnpont:
		activate()

func activate():
	GameManager.current_checkpoint = self
	activated = true

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player && !activated:
		activate()
