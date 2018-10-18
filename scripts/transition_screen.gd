extends Sprite

var transition = true
signal fully_covered

func _ready():
	set_process(true)

func _process(delta):
	if transition:
		set_position(get_position() + Vector2(-32,0))
		if get_position().x == 0:
			print("fully covered")
			emit_signal("fully_covered")
		elif get_position().x == -1024:
			transition = false
			set_position(Vector2(1024,0))
			queue_free()
			
