extends CharacterBody2D

const type = 'bomb'
var speed = 200

func _ready(): 
	$SoundBomb.play()

func _process(delta):
	var collision = move_and_collide(Vector2(0, -speed) * delta)
	if collision:
		var entity = collision.get_collider()
		if 'enemy' in entity.type:
			entity.kill() 
			queue_free()
			get_parent().change_score(1)
	if position.y < 0:
		queue_free()
