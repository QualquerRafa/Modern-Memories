extends Control

var transparent = Color(0,0,0, 0.1)
var full_black = Color(0,0,0, 1)
var transition_time = 0.8

func _ready():
	$loading_indicator/loading_label.text = GameLanguage.system.loading[PlayerData.game_language] + " . . ."

func entering_this_scene():
	$loading_indicator/loading_label.text = GameLanguage.system.loading[PlayerData.game_language] + " . . ."
	#Play the scene BGM
	var scene_bgm_file = "lohweo_" + self.get_parent().get_name()
	SoundControl.play_sound(scene_bgm_file, "music")
	
	self.show()
	yield(get_tree().create_timer(transition_time/3), "timeout")
	$loading_indicator.hide()
	
	$transitioner_tween.interpolate_property($darker_screen, "modulate", full_black, transparent, transition_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$transitioner_tween.start()
	yield($transitioner_tween, "tween_completed")
	
	self.hide()

func scene_transition(scene):
	$loading_indicator/loading_label.text = GameLanguage.system.loading[PlayerData.game_language] + " . . ."
	SoundControl.bgm_fadeout()
	SoundControl.play_sound("poc_scene")
	
	self.show()
	$loading_indicator.show()
	
	$transitioner_tween.interpolate_property($darker_screen, "modulate", transparent, full_black, transition_time/1.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$transitioner_tween.start()
	yield($transitioner_tween, "tween_completed")
	
	self.hide()
	
	var _scene_change = get_tree().change_scene("res://_scenes/" + scene + ".tscn")
