extends Sprite

var current_highlighted_card : Node

#---------------------------------------------------------------------------------------------------
func update_user_interface(card_node):
	#'this_card' is defined by the passed ID when clicking a card on screen
	var this_card : Dictionary = CardList.card_list[card_node.this_card_id]
	
	#On every box update, reset this
	#container_mode = "TXT"
	#update_description_mode()
	
	#Update the specifics that may vary from card to card
	match this_card.attribute:
		"spell", "trap":
			#Hide monster-related information
			$atk_def.hide()
			$extra_icons/level_indicator.hide()
			$extra_icons/level.hide()
			#Green or Pink bar, very simple
			$colored_bar.texture = load("res://_resources/scene_duel/bar_"+ this_card.attribute +".png")
			#Blue bar for Ritual cards
			if this_card.type == "ritual":
				$colored_bar.texture = load("res://_resources/scene_duel/bar_"+ this_card.type +".png")
			#No need for text clipping in Spell/Trap cards
			$card_name/card_name.clip_text = false
			
		_: #monsters
			#Show monster-related information, such as ATK/DEF and Level
			$atk_def.show()
			var atk_def_base_x_position : Vector2 = Vector2(458, 0)
			var charactere_width : int = 28
			var name_box_total_width : float = this_card.card_name.length() * charactere_width
			
			if name_box_total_width >= atk_def_base_x_position[0]:
				$atk_def.rect_position = Vector2(clamp(name_box_total_width + charactere_width, 458, 660), 0)
				$card_name/card_name.rect_size = Vector2(660-charactere_width, 45)
				$card_name/card_name.clip_text = true
			else:
				$atk_def.rect_position = atk_def_base_x_position
			
			$atk_def/atk.text = String(clamp(this_card.atk + card_node.this_card_flags.atk_up, 0, 9999))
			$atk_def/def.text = String(clamp(this_card.def + card_node.this_card_flags.def_up, 0, 9999))
			
			$extra_icons/level_indicator.show()
			$extra_icons/level.show()
			$extra_icons/level.text = String(this_card.level)
			
			#Colors for the bar: normal, effect, fusion, ritual, synchro
			if this_card.effect.size() == 0:
				$colored_bar.texture = load("res://_resources/scene_duel/bar_normal.png")
			else:
				$colored_bar.texture = load("res://_resources/scene_duel/bar_effect.png")
			if card_node.this_card_flags.fusion_type == "fusion":
				$colored_bar.texture = load("res://_resources/scene_duel/bar_fusion.png")
			if card_node.this_card_flags.fusion_type == "ritual":
				$colored_bar.texture = load("res://_resources/scene_duel/bar_ritual.png")
			if card_node.this_card_flags.fusion_type == "token":
				$colored_bar.texture = load("res://_resources/scene_duel/bar_token.png")
	
	#update basic information about the card
	$card_name/card_name.text = this_card.card_name
	$card_name.show()
	$extra_icons/type_indicator.texture = load("res://_resources/_types/"+ this_card.type +".png")
	$extra_icons/type_indicator/icon_shadow.texture = load("res://_resources/_types/"+ this_card.type +".png")
	$extra_icons/attribute_indicator.texture = load("res://_resources/_attributes/"+ this_card.attribute +".png")
	$extra_icons.show()
	$colored_bar.show()
	
	#update card descriptive text
	text_tween.stop_all()
	$card_text/Container/description_line1.rect_position.y = 5
	$card_text.show()
	var card_text = $card_text_gd.get_card_text(card_node.this_card_id)
	$card_text/Container/description_line1.text = card_text
	
	#Start the timer so the information gets cleaned after a while. Pure aesthetic reasons.
	$interface_timer.start(20.0)

func _on_interface_timer_timeout():
	#Reset all info about a card on user_interface
	$colored_bar.hide()
	$card_name.hide()
	$atk_def.hide()
	$extra_icons.hide()
	$card_text.hide()
	
	#unhighlight the card
	var init_scale = Vector2(0.175, 0.175)
	if current_highlighted_card != null:
		current_highlighted_card.get_child(0).z_index = 0
		current_highlighted_card.get_child(1).interpolate_property(current_highlighted_card.get_child(0).get_child(0), "rect_scale", current_highlighted_card.get_child(0).get_child(0).rect_scale, init_scale, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		current_highlighted_card.get_child(1).start()
		current_highlighted_card = null

#When mousing over the Description box, it can scroll down to show more text
onready var text_node = $card_text/Container/description_line1
onready var text_tween = $card_text/description_tween
var scroll_time : float = 1

func _on_description_mouse_over_mouse_entered():
	if text_node.get_line_count() > 2:
		if text_node.rect_position.y == 5:
			text_tween.interpolate_property(text_node, "rect_position:y", text_node.rect_position.y, clamp(text_node.rect_position.y-32, 5-32, 5), scroll_time/2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			text_tween.start()

func _on_description_mouse_over_mouse_exited():
	text_tween.interpolate_property(text_node, "rect_position:y", text_node.rect_position.y, 5, scroll_time/3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	text_tween.start()

#The button to toggle between the Containers for card description: either show TXT form (classic) or IMG form (testing)
#var container_mode = "TXT"
#func _on_toggle_img_txt_button_up():
#	#Figure out which mode to use
#	if container_mode == "TXT":
#		container_mode = "IMG"
#	elif container_mode == "IMG":
#		container_mode = "TXT"
#	update_description_mode()
	
#func update_description_mode():
#	if container_mode == "TXT":
#		$card_text/Container.show()
#		$card_text/Container_images.hide()
#	elif container_mode == "IMG":
#		$card_text/Container.hide()
#		$card_text/Container_images.show()
#
#	#Update toggle button text
#	$card_text/toggle_img_txt.text = container_mode
