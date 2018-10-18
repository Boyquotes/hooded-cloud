extends Node


func _ready():
	set_process_input(true)
	get_node("on_timer").connect("timeout",self,"on_pulse")
	get_node("off_timer").connect("timeout",self,"off_pulse")
	get_node("on_timer").start()
	get_node("start_delay").connect("timeout",self,"game_play")

func on_pulse():
	get_node("RichTextLabel").visible = true
	get_node("off_timer").start()

func off_pulse():
	get_node("RichTextLabel").visible = false
	get_node("on_timer").start()

func game_play():
	get_tree().change_scene("res://nodes/root.tscn")
	var music_player = load("res://nodes/music.tscn").instance()
	get_tree().get_root().add_child(music_player)
	
func _input(ev):
	if ev.is_action_released("ui_accept"):
		get_node("start_sound").play()
		get_node("start_delay").start()
		
