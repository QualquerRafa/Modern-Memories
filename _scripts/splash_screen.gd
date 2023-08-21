extends Node2D

func _ready():
	#Initial Status of stuff
	$scn_logo.modulate = Color(1,1,1,0)
	$godot_shout.modulate = Color(1,1,1,0)
	
	$tween.interpolate_property(self, "modulate", Color(1,1,1,0), Color(1,1,1,1), 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$tween.start()
	SoundControl.play_sound("lohweo_game_over", "music")
	yield($tween, "tween_completed")
	
	#SCN LETTERS COMMING IN
	var letter_timer = 0.7
	var final_S_pos = Vector2(356, 174)
	SoundControl.play_sound("letra", "sfx")
	$tween.interpolate_property($S, "position", Vector2(-196,-202), final_S_pos, letter_timer, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
	$tween.start()
	$timer.start(0.4); yield($timer, "timeout")
	
	var final_C_pos = Vector2(553, 174)
	SoundControl.play_sound("letra", "sfx")
	$tween.interpolate_property($C, "position", Vector2(553,-202), final_C_pos, letter_timer, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
	$tween.start()
	$timer.start(0.4); yield($timer, "timeout")
	
	var final_N_pos = Vector2(737, 174)
	SoundControl.play_sound("letra", "sfx")
	$tween.interpolate_property($N, "position", Vector2(1280,-202), final_N_pos, letter_timer, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
	$tween.start()
	$timer.start(0.8); yield($timer, "timeout")
	
	#SCN LOGO FADE IN
	SoundControl.play_sound("logo", "sfx")
	$tween.interpolate_property($canal, "modulate", Color(1,1,1,0), Color(1,1,1,1), 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$tween.start()
	yield($tween, "tween_completed")
	$timer.start(0.6); yield($timer, "timeout")
	
	#MADE WITH GODOT FADE IN
	SoundControl.play_sound("shout_out", "sfx")
	$tween.interpolate_property($godot_shout, "modulate", Color(1,1,1,0), Color(1,1,1,1), 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$tween.start()
	
	#Fade out into game main menu
	$timer.start(3.3); yield($timer, "timeout")
	skip_once = true
	$scene_transitioner.scene_transition("main_menu")

var skip_once = false
func _on_SKIP_button_up():
	if skip_once == false:
		skip_once = true
		$scene_transitioner.scene_transition("main_menu")
