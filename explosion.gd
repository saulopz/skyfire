extends CharacterBody2D

func _ready() -> void:
	$AnimatedSprite2D.play()
	$SoundExplosion.play()

# Quando termina a animacao cai fora do jogo
func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()
