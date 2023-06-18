extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	#Animate the transition when starting this scene
	$scene_transitioner.entering_this_scene()
	
	$timer.start(9.5); yield($timer, "timeout")
	
	$scene_transitioner.scene_transition("main_menu")
