extends KinematicBody2D

var speed = 200
var falling = false
var jumping = false
var moving_left = false
var moving_right = false
var on_ground = false
var mid_air_release = false

const FALL_SPEED = 20
const JUMP_SPEED = 450
var falling_speed = FALL_SPEED
var jump_speed = JUMP_SPEED
var gravity = 20
var can_play_jump_sound = true

func _ready():
	set_physics_process(true)
	set_process_input(true)
	get_node("jump_timer").connect("timeout",self,"jump_finished")

func jump_finished():
	can_play_jump_sound = true
	jumping = false

func _input(event):
	if event.is_action_pressed("ui_left"):
		moving_left = true
		moving_right = false
		get_node("Sprite").flip_h = true
	elif event.is_action_pressed("ui_right"):
		moving_right = true
		moving_left = false
		get_node("Sprite").flip_h = false
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

func _physics_process(delta):
	if falling_speed != FALL_SPEED:
		get_node("Sprite").play(4,7)
		jumping = false
		falling = true
	if jumping:
		if can_play_jump_sound:
			var jmpnode = get_node("jump_sound")
			var signadd = 1 if rand_range(0.0, 1.0) > 0.5 else -1
			jmpnode.pitch_scale += rand_range(0.1,0.3) * signadd;
			if jmpnode.pitch_scale > 1.5:
				jmpnode.pitch_scale = 1.0
			elif jmpnode.pitch_scale < 0.5:
				jmpnode.pitch_scale = 1.0
			jmpnode.play()
			can_play_jump_sound = false
		get_node("Sprite").play(4,7)
		if jump_speed > -400:
			if mid_air_release:
				jump_speed -= 40
			else:
				jump_speed -= 25
		else:
			jump_speed = -400
			falling_speed = -jump_speed
		move_and_slide(Vector2(0.0, -jump_speed), Vector2(0,-1))
		if is_on_ceiling():
			jumping = false
			get_node("jump_timer").stop()
	else:
		move_and_slide(Vector2(0.0, falling_speed), Vector2(0,-1))
	if is_on_floor():
		can_play_jump_sound = true
		on_ground = true
		falling = false
		falling_speed = FALL_SPEED
		jump_speed = JUMP_SPEED
		if jumping:
			get_node("Sprite").stop(0)

		if not on_ground:
			get_node("Sprite").play(4,7)
		jumping = false
	else:
		if not jumping:
			if falling_speed <= 400:
				print("FIXME: introduce some grace time for jumping")
				falling_speed += gravity
			else:
				print("falling?")
				falling_speed = 400
				
	if moving_left:
		move_and_slide(Vector2(-speed, 0))
		if not jumping:
			get_node("Sprite").play(7, 12)
	elif moving_right:
		move_and_slide(Vector2(speed,0))
		if not jumping:
			get_node("Sprite").play(7, 12)
	elif not moving_right and not moving_left and on_ground and not jumping:
		get_node("Sprite").stop(0)
	if falling:
		get_node("Sprite").play(5,7)
