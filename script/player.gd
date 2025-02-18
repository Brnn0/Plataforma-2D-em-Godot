extends CharacterBody2D
class_name Player

signal health_changed

@onready var animation = $AnimationPlayer
@onready var sprite = $Trevor
@onready var collisionStand: CollisionShape2D = $collisionStand
@onready var collisionCrouch: CollisionShape2D = $collisionCrouch
@onready var area_collisionStand: CollisionShape2D = $hurtbox/AreaCollisionStand
@onready var area_collisionCrouch: CollisionShape2D = $hurtbox/AreaCollisionCrouch
@onready var whip = $whip
@onready var sfx_jump: AudioStreamPlayer = $Sounds/sfx_jump
@onready var bg_music: AudioStreamPlayer = $"../Musica/bg_music"
@onready var sfx_take_damage: AudioStreamPlayer = $Sounds/sfx_take_damage
@onready var sfx_hit: AudioStreamPlayer = $Sounds/sfx_hit
@onready var sfx_whip: AudioStreamPlayer = $Sounds/sfx_whip
@onready var sfx_death: AudioStreamPlayer = $Sounds/sfx_death
@onready var sfx_death_music: AudioStreamPlayer = $Sounds/sfx_death_music
@onready var sfx_attack_voice_audio: AudioStreamPlayer = $Sounds/sfx_attack_voice
@export var sfx_attack_voice : Array
@export var SPEED = 120.0
@export var JUMP_VELOCITY = -300.0
@export var hit = false
@export var is_alive = true

var attacking = false
var crouching = false
var max_health = 3
var health = 0
var can_take_damage = true

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready() -> void:
	GameManager.player = self
	health = max_health
	health_changed.emit()
	if is_alive == true:
		bg_music.play()

func _process(delta):

	if is_alive == true:
		if Input.is_action_just_pressed("attack") and !hit:
			attack()
			
		if Input.is_action_pressed("move_down") and !hit:
			crouching = true
			crouch()

func _physics_process(delta: float) -> void:

	collisionStand.disabled = false
	collisionCrouch.disabled = true
	area_collisionStand.disabled = false
	area_collisionCrouch.disabled = true
	
	if is_alive == true and !hit:
		
		if not is_on_floor():
			velocity += get_gravity() * delta
		
		if Input.is_action_just_pressed("jump") and is_on_floor():
			if Input.is_action_pressed("move_down"):
				position.y += 2
			else:
				velocity.y = JUMP_VELOCITY
				sfx_jump.play()
		if Input.is_action_just_released("jump"):
			velocity.y *= 0.4
			
		if !attacking and !crouching:
			var direction := Input.get_axis("move_left", "move_right")
			if direction:
				if  Input.is_action_pressed("move_left"):

					sprite.scale.x = abs(sprite.scale.x) * -1
					whip.scale.x = abs(sprite.scale.x) * -1
					velocity.x = direction * SPEED
				if  Input.is_action_pressed("move_right"):
					sprite.scale.x = abs(sprite.scale.x) * 1
					whip.scale.x = abs(sprite.scale.x) * 1
					velocity.x = direction * SPEED
			else:
				velocity.x = move_toward(velocity.x, 0, SPEED)
		else:
			if is_on_floor():
				velocity = Vector2.ZERO
	if !hit and is_alive == false:
		velocity.x = 0
		velocity.y = 1 * gravity * 0.2
		
		
	update_animation()
	move_and_slide()

func crouch():
	if is_on_floor() and attacking == false:
		whip.visible = false
		collisionStand.disabled = true
		collisionCrouch.disabled = false
		area_collisionStand.disabled = true
		area_collisionCrouch.disabled = false
		animation.play("anim/crouch")
	if is_on_floor() and attacking == true:
		collisionStand.disabled = true
		collisionCrouch.disabled = false
		area_collisionStand.disabled = true
		area_collisionCrouch.disabled = false
		animation.play("anim/crouch_attack")
	if is_on_floor() == false:
		crouching = false

func attack():
	var attack_voice = sfx_attack_voice[randi() % sfx_attack_voice.size()]
	sfx_attack_voice_audio.stream = attack_voice
	
	if is_on_floor() and crouching == false:
		attacking = true
		whip.visible = true
		animation.play("anim/attack")
	if is_on_floor() and crouching == true:
		attacking = true
		whip.visible = true
	if is_on_floor() == false:
		attacking = true
		whip.visible = true
		animation.play("anim/jump_attack")
	if attacking == true:
		sfx_whip.play()
		sfx_attack_voice_audio.play()
		

func _on_whip_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("Enemies"):
			area.get_parent().take_damage(3)
			sfx_hit.play()

func update_animation():
	if !attacking and !hit and is_alive != false:
		crouching= false
		whip.visible = false
		if is_on_floor() and velocity.x != 0:
			animation.play("anim/walk")
		else:
			animation.play("anim/idle")
		if is_on_floor() == false:
			animation.play("anim/jump")

func take_damage(damage_amount : int):
	if can_take_damage:
		hit = true
		attacking = false
		animation.play("anim/hit")
		sfx_take_damage.play()
		iframes()
		health -= damage_amount
		health_changed.emit()
		if health <= 0:
			die()

func iframes():
	can_take_damage = false
	await get_tree().create_timer(1).timeout
	can_take_damage = true
	
func die():
	hit = false
	is_alive = false
	whip.visible = false
	if is_alive == false:
		bg_music.stop()
		animation.play("anim/death")
		sfx_death_music.play()
		sfx_death.play()
		await animation.animation_finished
	GameManager.respawn_player()
