extends CharacterBody2D

const type : String = "ship"
var speed : int = 500     # velocidade para os lados
var screensize : Vector2  # tamanho da tela
var h : int               # altura da imagem
var half_w : int          # metade da largura da imagem
var half_h : int          # metade da altura da imagem

# Quando o personagem eh criado, ele eh colocado no
# meio da tela, so que temos um deslocamento para a esquerda
# contando metade da textura da nave, senao a nave fica meio
# para a direita, por isso precisamos do half_w
func _ready() -> void:
	screensize = get_viewport_rect().size
	h = $Sprite2D.texture.get_height()
	half_w = $Sprite2D.texture.get_width() / 2
	half_h = int(h / 2.0)

func _process(delta) -> void:
	var vec = Vector2()
	if Input.is_action_pressed("ui_left"):
		vec.x -= speed
	elif Input.is_action_pressed("ui_right"):
		vec.x += speed
	# Quando pressiomamos a barra de espaco, damos um tiro. Isso
	# na verdade cria um objeto bomba em cima do personagem.
	if Input.is_action_just_pressed("ui_select"):
		get_parent().new_bomb(Vector2(position.x, position.y - half_h - 20))
	var _info = move_and_collide(vec * delta)
	# Se vai sair da tela, volta
	position.x = clamp(position.x, half_w, screensize.x - half_w)
	# Se pontuacao negativa, morre
	if get_parent().score < 0:
		kill()

func kill() -> void:
	queue_free()
	get_parent().new_explosion(position)
	get_parent().game_over()
