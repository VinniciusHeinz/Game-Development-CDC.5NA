extends RigidBody2D

var speed = 500
var dir = [-1, 1]
@export var speed_multiplier: float = 1.05
@export var display_time: float = 2.0 

var score_p1 = 0
var score_p2 = 0

# Verifique se os nomes "Player" e "Player2" estão iguais na sua árvore de cena!
@onready var player1 = get_node("../Player")
@onready var player2 = get_node("../Player2")

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	Reset()

func _on_body_entered(body: Node) -> void:
	linear_velocity *= speed_multiplier

func Reset():
	linear_velocity = Vector2.ZERO
	angular_velocity = 0
	global_position = get_viewport_rect().size / 2
	freeze = true 
	await get_tree().create_timer(1.0).timeout
	freeze = false
	var direction = Vector2(dir.pick_random(), dir.pick_random()).normalized()
	apply_central_impulse(direction * speed)

func Score():
	# Gol do Player 1 (Bola saiu pela direita)
	if global_position.x >= get_viewport_rect().size.x:
		score_p1 += 1
		show_score_temp(player1, score_p1)
		Reset()
	
	# Gol do Player 2 (Bola saiu pela esquerda)
	if global_position.x <= 0:
		score_p2 += 1
		show_score_temp(player2, score_p2)
		Reset()

func _physics_process(_delta: float) -> void:
	Score()

func show_score_temp(player_node: Node2D, current_score: int):
	# Essa linha é a mágica: ela procura o Label que você criou
	var label = player_node.get_node("ScoreLabel")
	if label:
		label.text = str(current_score)
		label.visible = true
		await get_tree().create_timer(display_time).timeout
		label.visible = false
