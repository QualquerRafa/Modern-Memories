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
	var dialog = dialogs[character_name][specific_dialog][PlayerData.game_language]
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
	var current_character_name_from_resource = $character_body.texture.resource_path.split("/")[-1].trim_suffix(".png")
	if current_character_name_from_resource != to_show_character_name:
		if ResourceLoader.exists("res://_resources/character_bodys/" + to_show_character_name + ".png"):
			$character_body.texture = load("res://_resources/character_bodys/" + to_show_character_name + ".png")
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
		"pre_duel" : {
			"en" : "It's nice to meet you. Now let's Duel!",
			"pt" : "Prazer em conhecer. Agora vamos ao Duelo!"
		},
		"duel_defeated" : {
			"en" : "Oh, I lost...",
			"pt" : "Ah, eu perdi..."
		},
		"duel_victorious" : {
			"en" : "Wow! I won!",
			"pt" : "Eita! Eu venci!"
		},
		"tournament_rematch" : {
			"en" : "You're not leaving without dueling me first!",
			"pt" : "Você não vai sair sem duelar comigo primeiro!"
		},
	},
	
	"roland" : {
		"tournament_1" : {
			"en" : "Welcome, Duelists! To the Forbidden Memories Tournament!\nWhere duelists from all around the world are gathered for a chance to be the new Duel Monsters Champion!",
			"pt" : "Bem vindos, Duelistas! Ao Torneio de Forbidden Memories!\nEm que duelistas de todo o mundo se reunem pela chance de ser o novo Rei dos Monstros de Duelo!"
		},
		"tournament_2" : {
			"en" : "Since every rule we knew from the old game has changed in this new format, everyone has equal chances of being the next King or Queen of Duels!",
			"pt" : "Já que todas as regras do jogo antigo mudaram com esse novo formato, todo mundo tem as mesmas chances de ser o próximo Rei ou Rainha dos Duelos!"
		},
		"tournament_3" : {
			"en" : "So let's start this already! All the participants will be randomly paired.\nGood Luck everyone!",
			"pt" : "Então vamos começar logo! Todos os participantes serão pareados aleatoriamente.\nBoa sorte a todos!"
		},
		"tournament_green_tier": {
			"en" : "These are the first pairings, ladies and gentleman.\nCompetitors, go and meet your opponent because it's Time to Duel.",
			"pt" : "Estas são as primeiras duplas, senhoras e senhores.\nCompetidores, encontrem seus oponentes porque é Hora do Duelo!"
		},
		"tournament_move_tier" : {
			"en" : "Half the competitors were eliminated!\nLet's advance to the next stage of our event!",
			"pt" : "Metade dos competidores foi eliminada!\nSeguimos para o próximo estágio do evento!"
		},
		"tournament_final_tier" : {
			"en" : "Now, for the Grand Finale!\nMay the best duelist win!",
			"pt" : "Agora, para a Grande Final!\nQue vença o melhor duelista!"
		},
		"tournament_champion" : {
			"en" : "This is it, ladies and gentleman! We have the new Duel Monsters Champion here on the Forbidden Memories Tournament!\nBesides everything you have already won, here is your prize of 25 starchips to use in the Card Shop!",
			"pt" : "Isso é tudo, pessoal! Temos nosso novo Campeão de Monstros de Duelo aqui no Torneio de Forbidden Memories!\nE além de tudo o que você já ganhou, aqui está seu premio de 25 estrelas para usar na Loja de Carta!"
		},
		"tournament_hijack" : {
			"en" : "Stop right there, New Champion!",
			"pt" : "Parado ai, Novo Campeão!"
		},
		"tournament_end" : {
			"en" : "What a fun duel to watch! But that was it ladies and gentleman.\nSee you in the next Forbidden Memories Tournament!",
			"pt" : "E que partida divertida! Mas é isso, senhoras e senhores.\nNos vemos no próximo Torneio de Forbidden Memories!"
		},
	},
}



