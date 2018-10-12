extends KinematicBody2D

var speed = 300
var falling = true;
var jumping = false;
var moving_left = false
var moving_right = false
var on_ground = false
var mid_air_release = false
const FALL_SPEED = 100
const JUMP_SPEED = 800
var falling_speed = FALL_SPEED
var jump_speed = JUMP_SPEED
var gravity = 50

func _ready():
	set_process(true)
	set_process_input(true)
	get_node("jump_timer").connect("timeout",self,"jump_finished")

func jump_finished():
	jumping = false

func _input(event):
	if event.is_action_pressed("ui_left"):
		moving_left = true
		moving_right = false
	elif event.is_action_pressed("ui_right"):
		moving_right = true
		moving_left = false
	elif event.is_action_pressed("ui_accept"):
		jumping = true
		mid_air_release = false
		get_node("jump_timer").start()
	elif event.is_action_released("ui_accept"):
		mid_air_release = true
	elif event.is_action_released("ui_left"):
		moving_left = false
	elif event.is_action_released("ui_right"):
		moving_right = false

func _process(delta):
	if falling:
		if falling_speed != FALL_SPEED:
			jumping = false
		if jumping:
			move_and_slide(Vector2(0.0, -jump_speed), Vector2(0,-1))
			if mid_air_release:
				jump_speed -= 80
			else:
				jump_speed -= 50
			if is_on_ceiling():
				jumping = false
				get_node("jump_timer").stop()
		else:
			move_and_slide(Vector2(0.0, falling_speed), Vector2(0,-1))
		if is_on_floor():
			on_ground = true
			falling_speed = FALL_SPEED
			jump_speed = JUMP_SPEED
			jumping = false
		else:
			if not jumping:
				falling_speed += gravity
	if moving_left:
		move_and_slide(Vector2(-speed, 0))
	elif moving_right:
		move_and_slide(Vector2(speed,0))

