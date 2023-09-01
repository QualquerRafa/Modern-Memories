extends Node2D

var player_trunk : Dictionary = PlayerData.player_trunk

func _ready():
	#Animate the transition when starting this scene
	$scene_transitioner.entering_this_scene()
	
	#Get everything on the correct language
	$user_interface/top_info_box/window_title.text = GameLanguage.card_shop.scene_title[PlayerData.game_language]
	$shop_panels/VBoxContainer/starchips/window_title.text = GameLanguage.card_shop.starchips[PlayerData.game_language]
	$shop_panels/VBoxContainer/code/window_title.text = GameLanguage.card_shop.card_code[PlayerData.game_language]
	$shop_panels/VBoxContainer/price/window_title.text = GameLanguage.card_shop.card_price[PlayerData.game_language]
	$shop_panels/VBoxContainer/price/buy_card/label.text = GameLanguage.card_shop.buy[PlayerData.game_language]
	
	#Initialize stuff on 'card_info_box' hidden
	$user_interface/card_info_box/colored_bar.hide()
	$user_interface/card_info_box/card_name.hide()
	$user_interface/card_info_box/atk_def.hide()
	$user_interface/card_info_box/extra_icons.hide()
	$user_interface/card_info_box/card_text.hide()
	
	#Initial state of stuff on screen
	$shop_panels/VBoxContainer/starchips/player_starchips.text = String(PlayerData.player_starchips)
	$shop_panels/VBoxContainer/price/card_price.text = String(0)
	$shop_panels/VBoxContainer/price/buy_card.modulate = Color(0.3, 0.3, 0.3, 1)

#---------------------------------------------------------------------------------------------------
func _on_player_input_text_changed(input_password):
	#When a 8-digit code is inputed
	if input_password.length() == 8:
		
		#Check if it matches any card on the game
		for i in range(CardList.card_list.keys().size()):
			var card_id = String(i).pad_zeros(5)
			var card_to_check = CardList.card_list[card_id]
			
			if input_password == card_to_check.passcode:
				var card_price : int = get_card_price(card_id)
				update_shop_card(card_id, card_price)
				break
	
	else: #if there isn't a 8 digit code active but there was an active card already, flip the card back down
		if !$card_slot/card_back_shop.is_visible():
			flip_down_shop_card()

#---------------------------------------------------------------------------------------------------
func get_card_price(card_id):
	var base_price = 8 #A perfect duel wields a max of 10 starchips
	var final_price : int
	
	match CardList.card_list[card_id].type:
		"equip": #Stat Boost divided by 100 times a multiplier
			var equip_bonus = ceil(CardList.card_list[card_id].effect[1] /100)
			final_price = equip_bonus * 4
		
		"field": final_price = 30
		
		"spell": final_price = 25
		
		"ritual": final_price = 25
		
		"trap":  final_price = 40
		
		_: #monsters are more complicated
			var monster_level = CardList.card_list[card_id].level
			var monster_atk = ceil(CardList.card_list[card_id].atk /100)
			var monster_def = ceil(CardList.card_list[card_id].def /100)
			var effect_multiplier = 1
			if CardList.card_list[card_id].effect.size() > 0:
				effect_multiplier = 1.5
				if monster_atk == 0:
					monster_atk = 25
				if monster_def == 0:
					monster_def = 25
			
			final_price = ceil((monster_level + monster_atk + monster_def) * effect_multiplier)
	
	#Pequenos mimos pra quem baixar cada versão, eu dou uma cartinha gratis
	if card_id in PlayerData.update_reward_ids:
		final_price = 0
	
	#Calculate the actual final price
	final_price = base_price * final_price
	return final_price

#---------------------------------------------------------------------------------------------------
#ANIMATION VARIABLES
var normal_scale = Vector2(1, 1)
var small_scale = Vector2(0.01, 1)
var flip_time = 0.2

func update_shop_card(card_id : String, card_price : int):
	#If the player already bought the card from this password, don't even show it
	if PlayerData.password_bought_cards.has(card_id):
		SoundControl.play_sound("poc_unable")
		return
	
	#Update visual stuff on screen
	$shop_panels/VBoxContainer/price/card_price.text = String(card_price)
	$card_slot/card_centerer/card_visual_only.update_card_information(card_id)
	if PlayerData.player_starchips >= int($shop_panels/VBoxContainer/price/card_price.get_text()):
		$shop_panels/VBoxContainer/price/buy_card.modulate = Color(1, 1, 1, 1)
	else:
		$shop_panels/VBoxContainer/price/buy_card.modulate = Color(0.3, 0.3, 0.3, 1)
	
	#Update bottom bar
	$user_interface/card_info_box.update_user_interface($card_slot/card_centerer/card_visual_only)
	
	#Animate the flipping of the card
	SoundControl.play_sound("poc_move")
	
	$card_slot/shop_tweener.interpolate_property($card_slot/card_back_shop, "scale", $card_slot/card_back_shop.scale, small_scale, flip_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$card_slot/shop_tweener.start()
	yield($card_slot/shop_tweener,"tween_completed")
	$card_slot/card_back_shop.hide()
	
	$card_slot/card_centerer.rect_scale = small_scale
	$card_slot/card_centerer.show()
	
	$card_slot/shop_tweener.interpolate_property($card_slot/card_centerer, "rect_scale", $card_slot/card_centerer.rect_scale, normal_scale, flip_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$card_slot/shop_tweener.start()
	yield($card_slot/shop_tweener,"tween_completed")

func flip_down_shop_card():
	#Update visual stuff on screen
	$shop_panels/VBoxContainer/price/card_price.text = String(0)
	$shop_panels/VBoxContainer/price/buy_card.modulate = Color(0.3, 0.3, 0.3, 1)
	
	#Erase info on bottom bar
	$user_interface/card_info_box/colored_bar.hide()
	$user_interface/card_info_box/card_name.hide()
	$user_interface/card_info_box/atk_def.hide()
	$user_interface/card_info_box/extra_icons.hide()
	$user_interface/card_info_box/card_text.hide()
	
	#Animate the flipping of the card
	SoundControl.play_sound("poc_move")
	$card_slot/shop_tweener.interpolate_property($card_slot/card_centerer, "rect_scale", $card_slot/card_centerer.rect_scale, small_scale, flip_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$card_slot/shop_tweener.start()
	yield($card_slot/shop_tweener,"tween_completed")
	$card_slot/card_centerer.hide()
	
	$card_slot/card_back_shop.scale = small_scale
	$card_slot/card_back_shop.show()
	
	$card_slot/shop_tweener.interpolate_property($card_slot/card_back_shop, "scale", $card_slot/card_back_shop.scale, normal_scale, flip_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$card_slot/shop_tweener.start()
	yield($card_slot/shop_tweener,"tween_completed")	

#---------------------------------------------------------------------------------------------------
func _on_back_button_button_up():
	SoundControl.play_sound("poc_decide")
	
	#Animate the button being clicked
	var btn_small_scale = Vector2(0.8 , 0.8)
	var btn_normal_scale = Vector2(1 , 1)
	$user_interface/UI_tween.interpolate_property($user_interface/back_button, "rect_scale", $user_interface/back_button.rect_scale, btn_small_scale, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$user_interface/UI_tween.start()
	yield($user_interface/UI_tween, "tween_completed")
	$user_interface/UI_tween.interpolate_property($user_interface/back_button, "rect_scale", $user_interface/back_button.rect_scale, btn_normal_scale, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$user_interface/UI_tween.start()
	
	#Return to Main Menu screen
	$scene_transitioner.scene_transition("main_menu")

#---------------------------------------------------------------------------------------------------
func _on_buy_card_button_up():
	if $shop_panels/VBoxContainer/price/buy_card.modulate !=  Color(1,1,1, 1):
		SoundControl.play_sound("poc_unable")
		return
	
	#Animate the button being clicked
	var btn_small_scale = Vector2(0.8 , 0.8)
	var btn_normal_scale = Vector2(1 , 1)
	$user_interface/UI_tween.interpolate_property($shop_panels/VBoxContainer/price/buy_card, "rect_scale", $shop_panels/VBoxContainer/price/buy_card.rect_scale, btn_small_scale, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$user_interface/UI_tween.start()
	yield($user_interface/UI_tween, "tween_completed")
	$user_interface/UI_tween.interpolate_property($shop_panels/VBoxContainer/price/buy_card, "rect_scale", $shop_panels/VBoxContainer/price/buy_card.rect_scale, btn_normal_scale, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$user_interface/UI_tween.start()
	
	SoundControl.play_sound("poc_decide")
	
	var get_card_id_from_displayed = $card_slot/card_centerer/card_visual_only.this_card_id
	var get_price_from_displayer = int($shop_panels/VBoxContainer/price/card_price.get_text())
	
	if PlayerData.player_starchips >= get_price_from_displayer:
		if not PlayerData.password_bought_cards.has(get_card_id_from_displayed):
			if get_card_id_from_displayed in PlayerData.player_trunk:
				player_trunk[get_card_id_from_displayed] += 1 #register another copy of the card to the already existing id key
			else: 
				player_trunk[get_card_id_from_displayed] = 1 #card is not in trunk, so add it's key:value pair as id:count
			
			PlayerData.player_starchips -= get_price_from_displayer
			PlayerData.password_bought_cards.append(get_card_id_from_displayed)
			PlayerData.last_reward_cards.append(get_card_id_from_displayed)
			
			reset_scene_after_buy()
	#print("Password Bought Cards (ids): ", PlayerData.password_bought_cards)

func reset_scene_after_buy():
	flip_down_shop_card()
	$shop_panels/VBoxContainer/starchips/player_starchips.text = String(PlayerData.player_starchips)
	$shop_panels/VBoxContainer/code/player_input.clear()
