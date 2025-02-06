extends CharacterBody2D

var SPEED = 2000.0
const JUMP_VELOCITY = -400.0
var direction := -1
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var wall_detec: RayCast2D = $wall_detec
@onready var floor_detec: RayCast2D = $floor_detec
@onready var collision_2: CollisionShape2D = $hitbox/collision2
@onready var sfx_death: AudioStreamPlayer = $Sound/sfx_death

var damage = 1

var max_health = 3
var health = 0
var dead = false
var player_in = false

func _ready() -> void:
	animation.play("walk")
	var health = max_health

func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if wall_detec.is_colliding():
		flip()
	if !floor_detec.is_colliding() && is_on_floor():
		flip()
	
	velocity.x = direction * SPEED * delta
	
	move_and_slide()
	
func flip():
	direction *= -1
	scale.x = abs(scale.x) * -1


func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.get_parent() is Player and not is_in_group("Whip") and !dead:
		area.get_parent().take_damage(damage)
		player_in = true

func _on_hitbox_area_exited(area: Area2D) -> void:
	player_in = false

func take_damage(damage_amount : int):
	health -= damage_amount
	if health <= 0:
		sfx_death.play()
		die()

func die():
	dead = true
	SPEED = 0
	animation.play("death")
