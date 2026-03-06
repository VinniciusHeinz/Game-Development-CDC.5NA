extends StaticBody2D

var dir = Vector2(0 , 0)
var speed = 400.0

@export var up = KEY_W
@export var down = KEY_S

# Referência ao Label que você criou dentro do Player
@onready var score_label = $ScoreLabel

func _ready() -> void:
	# Garante que o placar comece escondido ao iniciar o jogo
	if score_label:
		score_label.visible = false
	pass

func _physics_process(delta: float) -> void:
	Move(delta)

func Move(delta):
	dir = Vector2(0,0)
	
	# Movimentação com trava para não sair da tela
	if Input.is_key_label_pressed(up) and global_position.y > 0:
		dir = Vector2(0 , -1)
	
	if Input.is_key_label_pressed(down) and global_position.y < get_viewport_rect().size.y:
		dir = Vector2(0 , 1)
	
	global_position += dir * speed * delta
