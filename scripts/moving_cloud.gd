extends StaticBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var length = 20
var speed = 10

func _ready():
	get_node("flip_timer").connect("timeout",self,"flip_direction")
	get_node("flip_timer").start()

func flip_direction():
	var constant_linear_velocity = get_constant_linear_velocity()
	set_constant_linear_velocity(Vector2(-constant_linear_velocity.x, -constant_linear_velocity.y))
