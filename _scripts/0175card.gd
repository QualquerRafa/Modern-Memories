extends Button
var this_card_id : String = String(101).pad_zeros(5)

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
onready var deck_building_root = get_node("/root/deck_building")
onready var card_info_box = get_node("/root/deck_building/user_interface/card_info_box")
var init_scale = Vector2(0.175, 0.175)
var big_scale = Vector2(0.22, 0.22)

func _on_0175card_button_up():
	#Reset previous card, if any
	reset_highlighted_card()
	
	#The first click should highlight the card, and a second one move it to the other side
	card_info_box.current_highlighted_card = self
	card_info_box.update_user_interface(self)
	$z_indexer.z_index = 1
	$card_self_tween.interpolate_property($z_indexer/card_design, "rect_scale", $z_indexer/card_design.rect_scale, big_scale, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$card_self_tween.start()
	
	#Figure out where to move on second click
	if $z_indexer/card_design.rect_scale == big_scale:
		var self_onScreen_position_X = self.get_global_transform_with_canvas()[2][0]
		if self_onScreen_position_X >= 1280/2: #Right side, click should remove from deck
			if PlayerData.player_deck.has(this_card_id):
				#Remove the card and update the visual list
				PlayerData.player_deck.erase(this_card_id)
			
		else: #Left side, click should add to deck if possible
			if int($z_indexer/trunk_counter.text) > 0 and PlayerData.player_deck.size() < 40 and PlayerData.player_deck.count(this_card_id) < 3:
				PlayerData.player_deck.append(this_card_id)
		
		#update both sides' panels
		var sorter =  deck_building_root.get_child(0).get_child(2)
		var newly_sorted_trunk = sorter.sort_cards(PlayerData.player_trunk.keys(), sorter.last_sorted_type)
		reset_highlighted_card()
		deck_building_root.update_left_panel(newly_sorted_trunk)
		deck_building_root.update_right_panel()
		
	
	#move the trunk_counter indicator
	var onBig_trunk_counter_position = Vector2(4, 64)
	var original_counter_position = Vector2(-1, 54)
	if $z_indexer/trunk_counter.rect_position == original_counter_position:
		$card_self_tween2.interpolate_property($z_indexer/trunk_counter, "rect_position", $z_indexer/trunk_counter.rect_position, onBig_trunk_counter_position, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$card_self_tween2.start()
	else:
		$card_self_tween2.interpolate_property(card_info_box.current_highlighted_card.get_node("z_indexer/trunk_counter"), "rect_position", card_info_box.current_highlighted_card.get_node("z_indexer/trunk_counter").rect_position, original_counter_position, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$card_self_tween2.start()

func reset_highlighted_card():
	if card_info_box.current_highlighted_card != null:
		card_info_box.current_highlighted_card.get_child(0).z_index = 0
		$card_self_tween.interpolate_property(card_info_box.current_highlighted_card.get_child(0).get_child(0), "rect_scale", card_info_box.current_highlighted_card.get_child(0).get_child(0).rect_scale, init_scale, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$card_self_tween.start()
		
		print(card_info_box.current_highlighted_card)
		
		#move the trunk_counter indicator back to small position
		var original_counter_position = Vector2(-1, 54)
		$card_self_tween2.interpolate_property(card_info_box.current_highlighted_card.get_node("z_indexer/trunk_counter"), "rect_position", card_info_box.current_highlighted_card.get_node("z_indexer/trunk_counter").rect_position, original_counter_position, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$card_self_tween2.start()
