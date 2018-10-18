extends Sprite

export var current_frame = 0
export var start_frame = 0
export var end_frame = 0
var current_animation = 0
export var is_playing = false
var play_once = false
var time = 0

func _ready():
	set_process(true)
	current_frame = start_frame

func play(s_frame, e_frame):
	if not is_playing:
		current_frame = s_frame
	is_playing = true
	start_frame = s_frame
	end_frame = e_frame

func play_once(s_frame, e_frame):
	if not is_playing:
		current_frame = s_frame
	is_playing = true
	play_once = true
	start_frame = s_frame
	end_frame = e_frame

func stop(f):
	is_playing = false
	current_frame = f
	frame = f

func _process(delta):
	if is_playing:
		time += delta
		if time > 0.100:
			current_frame += 1
			time = 0
		if current_frame > end_frame:
			current_frame = start_frame
			if play_once:
				is_playing = false
				play_once = false
				current_frame = end_frame
		if current_frame < start_frame:
			current_frame = start_frame
		frame = current_frame
