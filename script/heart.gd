extends Node2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player:
		GameManager.gain_hearts(1)
		queue_free()
