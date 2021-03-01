extends KinematicBody2D

var ball
var velocity
var screensize
var oldpos

func _ready():
	hide()
	screensize = get_viewport_rect().size
	
func start(pos, bal):
	position = pos
	ball = bal
	show()
	
func _process(delta):
	oldpos = position
		
	velocity = Vector2()
	if ball != null and ball.position.y < screensize.y/2:
		defance(delta)
	
	if ball != null and ball.position.y > screensize.y/2:
		offense(delta)
			
	var collision = move_and_collide(velocity * delta)	
	
	if collision:
		if collision.collider.name == "Ball":
			offense(delta)
			if position.x < screensize.x/2:
				position.x -= 25
			else:
				position.x += 25
	
	if (position.x<13+48 or position.x>screensize.x-48-13):
		position.x = oldpos.x
			
	if (position.y<13+48 or position.y>screensize.y/2-48-13):
		position.y = oldpos.y
		
func defance(delta):
	velocity = ball.position - position	
	if velocity.y < 0:
		velocity.y = velocity.y*100-50
		
	velocity = velocity.normalized() * 100
	position += velocity * delta
	
	
func offense(delta):
	var defpos = Vector2(screensize.x/2, screensize.y/4)
	velocity = defpos - position
	velocity = velocity.normalized() * 200
	position += velocity * delta
	if (position.x > screensize.x/2-5 and position.x < screensize.x/2+5 and position.y > screensize.y/4-5 and position.y < screensize.y/4+5):
		position.x = screensize.x/2
		position.y = screensize.y/4
		velocity = Vector2(0,0)
		