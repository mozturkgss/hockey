extends CanvasLayer

signal start_game

func _ready():
	$TimerLabel.hide()
	$Score1Label.hide()
	$Score2Label.hide()
	
func show_message(text):
	$MessageLabel.text = text
	$MessageLabel.show()
	$MessageTimer.start()
	
func show_game_over():
	show_message("Game Over")
	yield($MessageTimer, "timeout")
	$StartButton.show()
	$MessageLabel.text = "Hokey"
	$MessageLabel.show()
	
func update_score(timer, score1, score2):
	$TimerLabel.text = str(timer)
	$Score1Label.text = str(score1)
	$Score2Label.text = str(score2)

func _on_StartButton_pressed():
	$StartButton.hide()
	$TimerLabel.show()
	$Score1Label.show()
	$Score2Label.show()
	emit_signal("start_game")

func _on_MessageTimer_timeout():
	$MessageLabel.hide()