extends RigidBody2D

@onready var raycast_bot: RayCast2D = $raycast_bot

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if raycast_bot.is_colliding():
		freeze = true
	
func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player:
		GameManager.gain_hearts(1)
		queue_free()
