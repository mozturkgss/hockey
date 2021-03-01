extends KinematicBody2D

var speedPlayer1 = 300
var speedPlayer2 = 300
var player1
var player2
var velocity = Vector2()

func _ready():
	hide()
	
func start(pos, pl1, pl2):
	position = pos
	player1 = pl1
	player2 = pl2
	velocity = Vector2(0, 0)
	show()

func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		if collision.collider.name == "Player1":
			var fark = position - player1.position
			rotation = fark.angle()
			velocity = Vector2(speedPlayer1, 0).rotated(rotation)
		elif collision.collider.name == "Player2":
			var fark = position - player2.position
			rotation = fark.angle()
			velocity = Vector2(speedPlayer2, 0).rotated(rotation)
		else:
			velocity = velocity.bounce(collision.normal)
			if collision.collider.has_method("hit"):
				collision.collider.hit()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
	
func setspeed1(pos):
	speedPlayer1 = 500 + abs(pos.x*10) + abs(pos.y*10)
	
func setspeed2(pos):
	speedPlayer2 = 500 + abs(pos.x*10) + abs(pos.y*10)