extends Node

signal dialogue_box_clicked

var out_screen_x = -640
var on_screen_x = 0

func _ready():
	#Initial status of dialogue screen is everything empty and character body out of screen
	$character_body.position.x = out_screen_x
	$dialogue_box/character_name.text = ""
	$dialogue_box/dialog_text.text = ""

func _on_dialogue_button_button_up():
	#prevent dialogue button click if the current text isn't fully shown
	if $dialogue_box/dialog_text.percent_visible != 1:
		#TODO, just show everything and cancel animation
		return
	
	#This is the signal to be used by the individual scenes containing Dialogues
	SoundControl.play_sound("poc_move")
	emit_signal("dialogue_box_clicked")

func get_dialog(character_name : String, specific_dialog : String):
	var dialog = dialogs[character_name][specific_dialog]
	return [character_name, dialog]

func update_screen_dialog(to_show_character_name : String, to_show_dialog : String, dont_show_character = false):
	#Hide button animation to show it only when the text is finished and player can click again
	$dialogue_box/button_animation.hide()
	
	#Display character name as the first thing to do
	$dialogue_box/character_name.text = to_show_character_name
	
	#Optional parameter to hide the character sprite
	if dont_show_character == true:
		$character_body.hide()
	else:
		$character_body.show()
	
	#Animate the Character moving in if it's a differente character than the one currently being shown
	var current_character_name_from_resource = $character_body.texture.resource_path.split("/")[-1].trim_suffix("0.png")
	if current_character_name_from_resource != to_show_character_name:
		if ResourceLoader.exists("res://_resources/character_bodys/" + to_show_character_name + "0.png"):
			$character_body.texture = load("res://_resources/character_bodys/" + to_show_character_name + "0.png")
		var animation_speed : float = 0.2
		$character_body/body_tween.interpolate_property($character_body, "position:x", out_screen_x, on_screen_x, animation_speed, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$character_body/body_tween.start()
		yield($character_body/body_tween, "tween_completed")
	
	#Animate the text character by character
	$dialogue_box/dialog_text.percent_visible = 0
	$dialogue_box/dialog_text.text = to_show_dialog
	
	var text_lenght = $dialogue_box/dialog_text.text.length()
	var time_per_character = 0.02
	var typewriter_time = clamp(text_lenght * time_per_character, 1, 1.5)
	
	$dialogue_box/dialog_text/typewriter_tween.interpolate_property($dialogue_box/dialog_text, "percent_visible", 0, 1, typewriter_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$dialogue_box/dialog_text/typewriter_tween.start()
	yield($dialogue_box/dialog_text/typewriter_tween, "tween_completed")
	
	#Show the button animation so player knows he can click to go to the next dialog
	$dialogue_box/button_animation.show()

func empty_dialog_box():
	$dialogue_box/button_animation.hide()
	
	$dialogue_box/character_name.text = ""
	$dialogue_box/dialog_text.text = ""
	
	var animation_speed : float = 0.2
	$character_body/body_tween.interpolate_property($character_body, "position:x", on_screen_x, out_screen_x, animation_speed, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$character_body/body_tween.start()
	yield($character_body/body_tween, "tween_completed")
	
#-------------------------------------------------------------------------------
var dialogs = {
	"generic" : {
		"pre_duel" : "It's nice to meet you. Now let's Duel!",
		"duel_defeated" : "Oh, I lost...",
		"duel_victorious" : "Wow! I won!",
		"tournament_rematch" : "You're not leaving without dueling me first!",
	},
	
	"roland" : {
		"tournament_1" : "Welcome, Duelists! To the Forbidden Memories Tournament! \nWhere duelists from all around the world are gathered for a chance to be the new Duel Monsters Champion!",
		"tournament_2" : "Since every rule we knew from the old game has changed in this new format, everyone has equal chances of being the next King or Queen of Duels!",
		"tournament_3" : "So let's start this already! All the participants will be randomly paired.\nGood Luck everyone!",
		
		"tournament_green_tier": "These are the first pairings, ladies and gentleman.\nCompetitors, go and meet your opponent because it's time to Duel.",
		
		"tournament_move_tier" : "Half the competitors were eliminated! \nLet's advance to the next stage of our event!",
		"tournament_final_tier" : "Now, for the Grand Finale! \nMay the best duelist win!",
		"tournament_champion" : "This is it, ladies and gentleman! We have the new Duel Monsters Champion here on the Forbidden Memories Tournament! \nBesides everything you have already won, here is your prize of 50 starchips to use in the Card Shop!",
		
		"tournament_hijack" : "Stop right there, New Champion!",
		"tournament_end" : "What a fun duel to watch. But that was it ladies and gentleman!\nSee you in the next Forbidden Memories Tournament!"
	},
	
	"shadi" : {
		"tournament_before_duel" : "It's an honor for me to duel against you. May the Gods decide our fates!",
		"tournament_defeated" : "Your victory was more than deserved. \nMay the Gods be on your side in all of your Duels.",
		"tournament_victorious" : "Looks like the Gods were on my side this time.",
	},
}



