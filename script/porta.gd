extends StaticBody2D

@onready var animation: AnimationPlayer = $animation
@onready var area_2d: Area2D = $Area2D
@onready var colisao_porta: CollisionShape2D = $colisaoPorta
@onready var colisao_area: CollisionShape2D = $Area2D/colisaoArea

@export var open = false

func closed():
	if open == false:
		animation.play("closed")
		colisao_porta.disabled = false
		set_collision_layer_value(1, true)

func openned():
	if open == true:
		animation.play("openned")
		colisao_porta.disabled = true
		set_collision_layer_value(1, false)

func open_door():
	open = true
	animation.play("opening")
	colisao_porta.disabled = true
	set_collision_layer_value(1, false)
	
func close_door():
	open = false
	animation.play("closing")
	colisao_porta.disabled = false
	set_collision_layer_value(1, true)
	

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player:
		open_door()
		open = true
		


func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.get_parent() is Player:
		close_door()
		open = false
