extends CharacterBody2D

const type : String = "bomb"
var speed : int = 200

func _ready() -> void: 
	$SoundBomb.play()

func _physics_process(delta: float) -> void:
	var collision = move_and_collide(Vector2(0, -speed) * delta)
	if collision:
		var entity = collision.get_collider()
		if 'enemy' in entity.type:
			entity.kill() 
			queue_free()
			get_parent().change_score(1)
	if position.y < 0:
		queue_free()
