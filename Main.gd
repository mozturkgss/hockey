extends Node

var timer
var score1
var score2
var screensize

func _ready():
	screensize = $KinematicBody2D.get_viewport_rect().size
	
func new_game():
	timer = 0
	score1 = 0
	score2 = 0
	$ScoreTimer.start()
	reload()
	$Menu.show_message("Ready")
	$Music.play()
	
func reload():
	$Ball.position.x = 240
	$Ball.position.y = 400
	$Player1.start($Position1.position)
	$Player2.start($Position2.position, $Ball)
	$Ball.start($Ball.position, $Player1, $Player2)
	$Menu.update_score(timer, score1, score2)
	
func game_over():
	$DeathSound.play()
	$Music.stop()
	$ScoreTimer.stop()
	$Menu.show_game_over()
	$Player1._ready()
	$Player2._ready()
	$Ball._ready()
	
func _on_ScoreTimer_timeout():
	timer += 1
	$Menu.update_score(timer, score1, score2)
	if (timer>=90):
		game_over()
		
func _process(delta):	
	if !$ScoreTimer.is_stopped():
		$Ball.setspeed1($Player1.position-$Player1.oldpos)
		$Ball.setspeed2($Player2.position-$Player2.oldpos)
		checkgoal()
		
func checkgoal():
	if ($Ball.position.y-100 >screensize.y):
		score2 = score2 + 1
		goal()
		
	if ($Ball.position.y+100 <0):
		score1 = score1 + 1
		goal()
		
func goal():
	reload()
	$Menu.show_message("Goal")
	$Music.play()
