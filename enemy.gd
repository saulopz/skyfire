extends CharacterBody2D

const type = 'enemy'
const LEFT = 0
const RIGHT = 1

var screensize      # tamanho da tela
var direction       # direcao do inimigo [esquerda|direita]
var w               # largura da imagem
var h               # altura da imagem
var half_w          # metade da largura da imagem
var half_h          # metade da altura da imagem
var speed_y = 200   # velocidade para baixo
var speed_x = 300   # velocidade para os lados

func _ready():
	randomize()
	screensize = get_viewport_rect().size
	w = $Sprite2D.texture.get_width()
	h = $Sprite2D .texture.get_height()
	half_w = w / 2
	half_h = h / 2
	# Criamos nosso inimigo acima da area visivel do jogo
	# com posicao e direcao aleatorias
	position.x = (randi() % int(screensize.x - w)) + half_w
	position.y = -100
	direction = randi() % 2
	
func _process(delta):
	var vec = Vector2()
	vec.y += speed_y
	# Se o inimigo encosta dos lados da tela, ele muda a
	# o movimento para a direcao oposta
	if direction == RIGHT:
		vec.x += speed_x
		if position.x + half_w > screensize.x:
			direction = LEFT
	elif direction == LEFT:
		vec.x -= speed_x
		if position.x - half_w < 0:
			direction = RIGHT
	var collision = move_and_collide(vec * delta)
	if collision:
		var entity = collision.get_collider()
		if 'ship' in entity.type:
			kill()
			entity.kill()
	# Se sair da tela, passou da tela pra baixo,
	# o jogador perde ponto
	if position.y - half_h > screensize.y:
		get_parent().change_score(-1)
		queue_free()
	# Se o jogo acabou, libera o inimigo
	if get_parent().is_game_over:
		queue_free()

# Se o inimigo morrer, cria uma explosao nessa mesma posicao
# e retira o inimigo do jogo com queue_free.
func kill():
	get_parent().new_explosion(position)
	queue_free()
