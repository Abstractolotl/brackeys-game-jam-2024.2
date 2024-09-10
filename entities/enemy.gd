extends RigidBody2D
class_name Enemy

@export var player: Node2D
@export var speed: float = 100

var animation: AnimationPlayer;
var health: HealthComponent
var sprite: Sprite2D
var flash: Sprite2D

var dead = false

func _ready():
    animation = $animation_player
    health = $health
    sprite = $sprite
    flash = $flash

func _process(_delta):
    if health.health <= 0:
        return
        
    if linear_velocity.x > 0:
        sprite.flip_h = true
        flash.flip_h = true
    else:
        sprite.flip_h = false
        flash.flip_h = false

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
    if health.health <= 0:
        return

    var direction = (player.global_position - global_position).normalized()
    state.linear_velocity = direction * speed
    pass

func _on_hit(_amount: float, new_health: float):
    if dead:
        return

    animation.play("hit")
    GameScene.shake.emit(0.2, 0.5)
    if new_health <= 0:
        dead = true
        call_deferred("on_death")

func on_death():
    GameScene.shake.emit(1, 1)
    lock_rotation = false
