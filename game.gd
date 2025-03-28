extends Node2D

var timer
var score1
var score2
var screensize
var rnd = RandomNumberGenerator.new()

func _ready() -> void:
	screensize = get_viewport_rect().size
	Engine.max_fps = 60	
	Engine.max_physics_steps_per_frame = 200
	Engine.physics_ticks_per_second = 200
	new_game()

func new_game():
	timer = 0
	score1 = 0
	score2 = 0
	$ScoreTimer.start()
	reload()
	show_message("Ready")
	
func show_message(text):
	$MessageLabel.text = "[center]" + text + "[/center]"
	$MessageLabel.show()
	$MessageTimer.start()
	
func _on_MessageTimer_timeout():
	$MessageLabel.hide()
	
func update_score(timer, score1, score2):
	$Player1Score.text = str(score1)
	$Player2Score.text = str(score2)
	
func reload():
	$Ball.reset()
	$Ball.position.x = screensize.x/2
	$Ball.position.y = screensize.y/2
	$Player1.position.x = screensize.x/2
	$Player1.position.y = screensize.y/4*3
	$Player2.position.x = screensize.x/2
	$Player2.position.y = screensize.y/4
	update_score(timer, score1, score2)
	
func game_over():
	$DeathSound.play()
	$ScoreTimer.stop()
	if score1 > score2:
		show_message("You Win!")
	if score1 < score2:
		show_message("You Lose!")
	if score1 == score2:
		show_message("Draw")
	$GameOverTimer.start()
	
func _on_game_over_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://menu.tscn") # Replace with
	
func _on_ScoreTimer_timeout():
	timer += 1
	update_score(timer, score1, score2)
	if (timer>=60):
		game_over()
		
func _process(delta):	
	if !$ScoreTimer.is_stopped():
		checkgoal()
	
		if (Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)):		
			player1move()
			
		player2move(delta)
		
func checkgoal():
	if ($Ball.position.y-100 >screensize.y):
		score2 = score2 + 1
		goal()
		
	if ($Ball.position.y+100 <0):
		score1 = score1 + 1
		goal()
		
func goal():
	$GoalSound.play()
	reload()
	show_message("Goal")
	
func player1move():
	var mx = get_viewport().get_mouse_position().x
	var my = get_viewport().get_mouse_position().y
	
	if  mx < $Player1.position.x + 96 and \
		mx > $Player1.position.x - 96 and \
		my < $Player1.position.y + 96 and \
		my > $Player1.position.y - 96 : \
		$Player1.position = get_viewport().get_mouse_position()
	
	var pad = 48 + 4
	
	if $Player1.position.x < pad:
		$Player1.position.x = pad + 1
		
	if $Player1.position.x > screensize.x - pad:
		$Player1.position.x = screensize.x - pad - 1
		
	if $Player1.position.y < (screensize.y/2) + pad - 4:
		$Player1.position.y = (screensize.y/2) + pad + 1 - 4
		
	if $Player1.position.y > screensize.y - pad:
		$Player1.position.y = screensize.y - pad - 1					
		
func player2move(delta):
	var velocity = Vector2.ZERO
	var target = $Player2.position
	
	if $Ball.position.y < (screensize.y)/8*5:
		target = $Ball.position
	else:
		target = Vector2(screensize.x/2, (screensize.y)/4)
		
	var speedplayer2 = rnd.randf_range(100, 150)	
	
	if $Player2.position.y < target.y+50:
		velocity.y += speedplayer2
	else:
		velocity.y -= speedplayer2
	
	if $Player2.position.x < target.x:
		velocity.x += speedplayer2
	else:
		velocity.x -= speedplayer2
		
	$Player2.position += velocity * delta
	
	var pad = 48 + 4
	
	if $Player2.position.x < pad:
		$Player2.position.x = pad + 1
		
	if $Player2.position.x > screensize.x - pad:
		$Player2.position.x = screensize.x - pad - 1
		
	if $Player2.position.y > (screensize.y/2) - pad - 4:
		$Player2.position.y = (screensize.y/2) - pad + 1 - 4
		
	if $Player2.position.y > screensize.y - pad:
		$Player2.position.y = screensize.y - pad - 1				

func _on_player_1_area_entered(area: Area2D) -> void:
	if area.name == "Ball":
		var x = abs(area.position.x-$Player1.position.x)
		var y = abs(area.position.y-$Player1.position.y)
		if area.position.x < $Player1.position.x:
			x = -1 * x
		if area.position.y < $Player1.position.y:
			y = -1 * y
		area._speed += abs(y) 
		area.direction = (area.direction + Vector2(x,y)).normalized()
		$JumpSound.play()
		
func _on_player_2_area_entered(area: Area2D) -> void:
	if area.name == "Ball":
		var x = abs(area.position.x-$Player2.position.x)
		var y = abs(area.position.y-$Player2.position.y)
		if area.position.x < $Player2.position.x:
			x = -1 * x
		if area.position.y < $Player2.position.y:
			y = -1 * y
		area._speed += abs(y)
		area.direction = (area.direction + Vector2(x,y)).normalized()
		$JumpSound.play()

func _on_sol_duvar_area_entered(area: Area2D) -> void:
	if area.name == "Ball":
		area.direction = Vector2(abs(area.direction.x),area.direction.y).normalized()

func _on_sag_duvar_area_entered(area: Area2D) -> void:
	if area.name == "Ball":
		area.direction = Vector2(-1*abs(area.direction.x),area.direction.y).normalized()

func _on_ust_sol_duvar_area_entered(area: Area2D) -> void:
	if area.name == "Ball":
		area.direction = Vector2(area.direction.x,-1*area.direction.y).normalized()

func _on_ust_sag_duvar_area_entered(area: Area2D) -> void:
	if area.name == "Ball":
		area.direction = Vector2(area.direction.x,-1*area.direction.y).normalized()

func _on_alt_sol_duvar_area_entered(area: Area2D) -> void:
	if area.name == "Ball":
		area.direction = Vector2(area.direction.x,-1*area.direction.y).normalized()

func _on_alt_sag_duvar_area_entered(area: Area2D) -> void:
	if area.name == "Ball":
		area.direction = Vector2(area.direction.x,-1*area.direction.y).normalized()
 
