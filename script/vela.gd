extends StaticBody2D

@export var max_health = 1
@onready var animation: AnimatedSprite2D = $animation
@onready var area_2d: Area2D = $Area2D

var health = max_health
var breaked = false

func _ready() -> void:
	if breaked == false:
		animation.play("default")
		
func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("Whip") and not breaked:
		take_damage(1)

func take_damage(damage_amount : int):
	health -= damage_amount
	if health <= 0:
		break_candle()
		
func break_candle():
	breaked = true
	call_deferred("drop_items")
	animation.play("break")
	await animation.animation_finished
	queue_free()
	
func drop_items():
	var heart = preload("res://scenes/heart.tscn").instantiate()
	get_parent().add_child(heart)
	heart.position = position + Vector2(randf_range(0,0),0)
	
