extends KinematicBody2D

var velocity = Vector2()
var screensize
var oldpos

func _ready():
	hide()
	screensize = get_viewport_rect().size
	
func start(pos):
	position = pos
	show()
			
func _process(delta):
	if(Input.is_mouse_button_pressed(BUTTON_LEFT)):		
		oldpos = position
		
		position = get_viewport().get_mouse_position()
		
		var collision = move_and_slide(velocity * delta)		
		
		if (position.x<13+48 or position.x>screensize.x-48-13):
			position.x = oldpos.x
			
		if (position.y<(screensize.y/2)+48 or position.y>screensize.y-48-15):
			position.y = oldpos.y			
