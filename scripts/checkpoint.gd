extends Area2D

var time = 0
var activated = false

func _ready():
	connect("area_entered",self,"on_area_enter")
	set_process(false)
	get_node("blink_timer").connect("timeout",self,"end_blinking")

func on_area_enter(obj):
	if obj.name == "player_hitbox" and not activated:
		set_process(true)
		get_node("blink_timer").start()
		activated = true

func end_blinking():
	set_process(false)
	get_node("RichTextLabel").visible = false
	get_node("chkpoint_sprite").visible = false

func _process(delta):
	time += delta
	if time > 0.2:
		get_node("RichTextLabel").visible = false
		get_node("chkpoint_sprite").visible = false
	if time > 0.4:
		get_node("RichTextLabel").visible = true
		get_node("chkpoint_sprite").visible = true
		time = 0
