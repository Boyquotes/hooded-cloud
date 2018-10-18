extends Area2D
const Deadly_class = preload("res://scripts/deadly.gd")
const transition_screen = preload("res://nodes/transition_screen.tscn")

func _ready():
	connect("area_entered",self,"on_area_enter")
	get_parent().get_node("death_timer").connect("timeout",self,"death_transition")

func change_position():
	var newpos = get_tree().get_root().get_node("root/spawn_point").get_position()
	get_parent().set_position(newpos)
	get_parent().set_process_input(true)
	get_parent().set_process(true)

func change_level(obj):
	get_parent().set_process(true)
	get_parent().set_process_input(true)
	get_tree().change_scene(obj.next_scene)

func death_transition():
	var ts = transition_screen.instance()
	ts.connect("fully_covered", self, "change_position")
	get_tree().get_root().get_node("root/screen_swoop").add_child(ts)

func on_area_enter(obj):
	print(obj.name, " entered player area ", obj.get_class())
	if obj.name == "death_area":
		get_parent().set_process(false)
		get_parent().set_process_input(false)
		get_parent().get_node("Sprite").play_once(14,19)
		get_parent().moving_right = false
		get_parent().moving_left = false
		get_parent().get_node("death_timer").start()
	elif obj.name == "checkpoint":
		var spawn_point = get_tree().get_root().get_node("root/spawn_point")
		spawn_point.set_position(obj.get_position())
	elif obj.name == "next_level":
		get_parent().set_process(false)
		get_parent().set_process_input(false)
		var ts = transition_screen.instance()
		ts.connect("fully_covered", self, "change_level", [obj])
		get_tree().get_root().get_node("root/screen_swoop").add_child(ts)
		print("warp to next level")

