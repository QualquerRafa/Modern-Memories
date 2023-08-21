extends Node2D

var animation_ended = false

func _ready():
	#Animate the transition when starting this scene
	$scene_transitioner.entering_this_scene()
	
	#Load in the correct language
	$VBoxContainer/created_by.text = GameLanguage.credits_scene.created[PlayerData.game_language]
	$VBoxContainer/concept_programming_design.text = GameLanguage.credits_scene.general[PlayerData.game_language]
	$VBoxContainer/english_portuguese_translation.text = GameLanguage.credits_scene.translate_pt[PlayerData.game_language]
	$VBoxContainer/legacy_of_the_duelist.text = GameLanguage.credits_scene.art[PlayerData.game_language]
	$VBoxContainer/game_made_with.text = GameLanguage.credits_scene.godot[PlayerData.game_language]
	$VBoxContainer/testing_and_report.text = GameLanguage.credits_scene.testing.part1[PlayerData.game_language]
	$VBoxContainer/testing_and_report/credit.text = GameLanguage.credits_scene.testing.part2[PlayerData.game_language]
	$VBoxContainer/sr_adevogado.text = GameLanguage.credits_scene.disclaimer[PlayerData.game_language]
	$VBoxContainer/takahashi.text = GameLanguage.credits_scene.takahashi[PlayerData.game_language]
	
	var initial_pos = 720 + 20
	var final_pos = 0 - $VBoxContainer.rect_size.y + 420
	var duration_timer = 4.0 * $VBoxContainer.get_child_count() #in seconds
	
	$Tween.interpolate_property($VBoxContainer, "rect_position:y", initial_pos, final_pos, duration_timer, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	yield($Tween, "tween_completed")
	
	animation_ended = true


func _on_speed_up_button_down():
	#print("acelerando")
	Engine.set_time_scale(4.0)
	
	if animation_ended == true:
		Engine.set_time_scale(1.0)
		$scene_transitioner.scene_transition("main_menu")

func _on_speed_up_button_up():
	#print("velocidade normal")
	Engine.set_time_scale(1.0)
