extends Node2D

# Vamos precisar conhecer os objetos porque vamos
# cria-los dinamicamente. Para isso, fazemos um
# preload deles.
const Ship = preload("res://ship.tscn")
const Bomb = preload("res://bomb.tscn")
const Enemy = preload("res://enemy.tscn")
const Explosion = preload("res://explosion.tscn")
var score = 0                # pontuacao
var is_game_over = false     # se o jogo terminou
var screensize               # tamanho da tela

func _ready():
	screensize = get_viewport_rect().size

func _process(_delta):
	# Se for gameover e pressionar esc, o jogo reinicia
	if is_game_over:
		if Input.is_action_just_pressed("ui_cancel"):
			_reset()

# Reinicializacao do jogo
func _reset():
	is_game_over = false                # setamos gameover para falso
	score = 0                           # zeramos a pontuacao
	$Score.text = str(score)            # atualizamos o label
	var ship = Ship.instantiate()       # instanciamos uma nova nave
	# e colocamos ela em uma posicao espedifica
	ship.position = Vector2(screensize.y - 10, screensize.x / 2)
	add_child(ship)                     # adicionamos ela ao world
	$GameOver.visible = false           # imagem de gameover invisivel
	$Music.play()                       # tocamos a musica
	$EnemyTimer.start()                 # iniciamos o timer para criar inimigos

# Alteramos a pontuacao
func change_score(pts):
	score += pts
	$Score.text = str(score)

func game_over():
	is_game_over = true         # gameover true
	$GameOver.visible = true    # mostramos a imagem gameover
	$Music.stop()               # paramos a musica
	$EnemyTimer.stop()          # paramos o timer de criar inimigos

# Funcao usada para criar uma explosao em uma posicao (pos) especifica
# normamente vai ser a propria posicao do elemento que morreu
func new_explosion(pos):
	var explosion = Explosion.instantiate() # instanciamos um objeto Explosion
	explosion.position = pos                # colocamos ele na posicao
	add_child(explosion)                    # adicionamos ao jogo

# Cria uma bombinha. Normalmente feito pela nave Ship
# Entao usamos a posicao relativa a posicao x do personagem
# mais a metada da largura da imagem de Ship e menos a metade
# da largura da imagem da bomba. Esse calculo fazemos la no
# script de Ship. Isso para que a bombinha fique centralizada
# tambem colocamos, y acima da nave.
func new_bomb(pos):
	var bomb = Bomb.instantiate()  # Instanciamos um objeto bomba
	bomb.position = pos            # colocamos ele na posicao
	add_child(bomb)                # adicinamos ela ao jogo

# Quando o timer de criacao do inimigo der timeout
func _on_enemy_timer_timeout():
	if is_game_over:                           # se gameover nao cria mais
		return
	var enemy = Enemy.instantiate()            # instancia um novo inimigo
	add_child(enemy)                           # adiciona ele ao jogo
	$EnemyTimer.wait_time = (randi() % 2) + 1  # altera o wait_time aleatoriamente
	$EnemyTimer.start()                        # reinicia o timer
