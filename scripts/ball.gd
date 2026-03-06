extends RigidBody2D

# Configurações básicas
var speed = 500
var dir = [-1, 1]

# Multiplicador de velocidade: 1.05 aumenta 5% a cada batida. 
# Você pode ajustar esse valor direto no Inspetor do Godot agora!
@export var speed_multiplier: float = 1.05

func _ready() -> void:
	# Importante: Conecta o sinal de colisão para a função abaixo rodar
	body_entered.connect(_on_body_entered)
	Reset()

func _physics_process(_delta: float) -> void:
	Score()

# Esta função roda toda vez que a bola bate em algo (Player ou Parede)
func _on_body_entered(body: Node) -> void:
	# Aumenta a velocidade linear atual da bola
	linear_velocity *= speed_multiplier
	
	# Debug no console para você ver a velocidade subindo
	print("Batida detectada em: ", body.name, " | Nova velocidade: ", linear_velocity.length())

func Reset():
	# Para a bola completamente antes de resetar
	linear_velocity = Vector2.ZERO
	angular_velocity = 0
	
	# Reposiciona no centro
	global_position = get_viewport_rect().size / 2
	
	# Congela a bola por um momento
	freeze = true 
	await get_tree().create_timer(1.5).timeout
	freeze = false
	
	# Lança a bola com a velocidade inicial
	var direction = Vector2(dir.pick_random(), dir.pick_random()).normalized()
	apply_central_impulse(direction * speed)

func Score():
	# Verifica se saiu da tela (Gols)
	if global_position.x >= get_viewport_rect().size.x or global_position.x <= 0:
		Reset()
