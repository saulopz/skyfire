extends CharacterBody2D

const type = 'explosion'

func _ready():
	$AnimatedSprite2D.play()
	$SoundExplosion.play()

# Quando termina a animacao cai fora do jogo
func _on_animated_sprite_2d_animation_finished():
	queue_free()
