extends Button
var this_card_id : String = String(101).pad_zeros(5)

#This card personal flags
var this_card_flags : Dictionary = {
	"is_defense_position" : false,
	"has_field_boost" : false,
	"is_facedown" : false,
	"has_battled" : false,
	"fusion_type" : null,
	"atk_up" : 0,
	"def_up" : 0,
	"has_activated_effect" : false,
	"multiple_attacks" : 0,
}

#-------------------------------------------------------------------------------
func update_card_information(card_id : String):
	#Get from the CardList Dictionary 'this_card' information, based on passed 'card_id'
	var this_card : Dictionary = CardList.card_list[card_id]
	
	#Set the global variable on this script
	this_card_id = card_id
	
	#The only basic ones are setting the card Artwork and Attribute
	$z_indexer/card_design/artwork.texture = load("res://_resources/_card_artwork/" + card_id + ".png")
	#$summon_controls/faceup_summon/artwork.texture = load("res://_resources/_card_artwork/" + card_id + ".png")
	$z_indexer/card_design/attribute.texture = load("res://_resources/_attributes/" + this_card.attribute + ".png")
	
	#try to fit the card name as much as it can on the card
	$z_indexer/card_design/card_name.text = this_card.card_name
	var card_name_length : int = this_card.card_name.length()
	var correction : float = clamp(((card_name_length - 14) * 0.033), 0, 0.4) #completely arbitrary, try-and-error based, values
	$z_indexer/card_design/card_name.rect_scale.x = 1
	$z_indexer/card_design/card_name.clip_text = false
	
	if card_name_length > 14:
		$z_indexer/card_design/card_name.rect_scale.x = 1 - correction
		$z_indexer/card_design/card_name.clip_text = true
	
	#Determine background texture color and type of 'card_frame'
	match this_card.attribute:
		"spell":
			$z_indexer/card_design/card_frame.texture = load("res://_resources/card_design/frame_spelltrap.png")
			$z_indexer/card_design/background_texture.texture = load("res://_resources/card_design/texture_green.png")
			if this_card.type == "ritual":
				$z_indexer/card_design/background_texture.texture = load("res://_resources/card_design/texture_blue.png")
		
		"trap":
			$z_indexer/card_design/card_frame.texture = load("res://_resources/card_design/frame_spelltrap.png")
			$z_indexer/card_design/background_texture.texture = load("res://_resources/card_design/texture_pink.png")
		
		_: #monsters
			$z_indexer/card_design/card_frame.texture = load("res://_resources/card_design/frame_monster.png")
			$z_indexer/card_design/background_texture.texture = load("res://_resources/card_design/texture_yellow.png")
			#Special cases where the background color will change. Effect, Fusion, Rituals, Synchro
			if this_card.effect.size() > 0:
				$z_indexer/card_design/background_texture.texture = load("res://_resources/card_design/texture_orange.png")
	
	#Determine if it will show 'monster_features' or 'spelltrap_features' on the design
	match this_card.attribute:
		"spell", "trap": 
			$z_indexer/card_design/card_name.add_color_override("font_color", Color(1,1,1))
			$z_indexer/card_design/monster_features.hide()
			$z_indexer/card_design/spelltrap_features.show()
			
			if this_card.type != this_card.attribute:
				$z_indexer/card_design/spelltrap_features/type_of_spelltrap.text = this_card.type + " " + this_card.attribute + " card"
			else:
				$z_indexer/card_design/spelltrap_features/type_of_spelltrap.text = this_card.attribute + " card"
			
		_: 
			$z_indexer/card_design/card_name.add_color_override("font_color", Color(0,0,0))
			$z_indexer/card_design/spelltrap_features.hide()
			$z_indexer/card_design/monster_features.show()
			
			#Show correct amount of Level Stars
			if this_card.level == 12:
				$z_indexer/card_design/monster_features/level/upto11.hide()
				$z_indexer/card_design/monster_features/level/level12.show()
			else:
				$z_indexer/card_design/monster_features/level/level12.hide()
				$z_indexer/card_design/monster_features/level/upto11.show()
				
				for i in range(1, 12):
					get_node("z_indexer/card_design/monster_features/level/upto11/level" + String(i)).hide()
				for i in range(0, this_card.level):
					get_node("z_indexer/card_design/monster_features/level/upto11/level" + String(i+1)).show()
			
			#Show ATK and DEF
			$z_indexer/card_design/monster_features/atk_def/atk.text = String(this_card.atk)
			$z_indexer/card_design/monster_features/atk_def/def.text = String(this_card.def)


#---------------------------------------------------------------------------------------------------
onready var card_info_box = get_node("/root/free_duel/user_interface/card_info_box")
var init_scale = Vector2(0.175, 0.175)
var big_scale = Vector2(0.22, 0.22)
var init_position = Vector2(43, -10.5)
var onBig_rarity_position = Vector2(52, -22)

func _on_rarity_card_button_up():
	#Prevent an invisible card of updating the user interface (as they're just partially hidden but the button is still 'visible')
	if !$z_indexer.is_visible():
		return
	
	SoundControl.play_sound("poc_cursor")
	
	#Reset previous card, if any
	reset_highlighted_card()
	
	#The first click should highlight the card
	card_info_box.current_highlighted_card = self
	card_info_box.update_user_interface(self)
	$z_indexer.z_index = 1
	$card_self_tween.interpolate_property($z_indexer/card_design, "rect_scale", $z_indexer/card_design.rect_scale, big_scale, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$card_self_tween.start()
	
	#move the rarity indicator
	$card_self_tween2.interpolate_property($z_indexer/rarity_indicator, "position", $z_indexer/rarity_indicator.position, onBig_rarity_position, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$card_self_tween2.start()

func reset_highlighted_card():
	if card_info_box.current_highlighted_card != null:
		card_info_box.current_highlighted_card.get_child(0).z_index = 0
		$card_self_tween.interpolate_property(card_info_box.current_highlighted_card.get_child(0).get_child(0), "rect_scale", card_info_box.current_highlighted_card.get_child(0).get_child(0).rect_scale, init_scale, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$card_self_tween.start()
		
		#move the rarity indicator
		$card_self_tween2.interpolate_property(card_info_box.current_highlighted_card.get_child(0).get_child(2), "position", card_info_box.current_highlighted_card.get_child(0).get_child(2).position, init_position, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$card_self_tween2.start()
