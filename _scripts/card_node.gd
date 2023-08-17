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
func _ready():
	this_card_id = generate_random_card()
	update_card_information(this_card_id)

#-------------------------------------------------------------------------------
func generate_random_card():
	var card_id : String
	
	randomize()
	var random_number : int = randi() % CardList.card_list.keys().size()
	card_id = String(random_number).pad_zeros(5)
	
	return card_id

#-------------------------------------------------------------------------------
func update_card_information(card_id : String):
	#Get from the CardList Dictionary 'this_card' information, based on passed 'card_id'
	var this_card : Dictionary = CardList.card_list[card_id]
	
	#Set the global variable on this script
	this_card_id = card_id
	
	#The only basic ones are setting the card Artwork and Attribute
	$card_design/artwork.texture = load("res://_resources/_card_artwork/" + card_id + ".png")
	$summon_controls/faceup_summon/artwork.texture = load("res://_resources/_card_artwork/" + card_id + ".png")
	$card_design/attribute.texture = load("res://_resources/_attributes/" + this_card.attribute + ".png")
	
	#try to fit the card name as much as it can on the card
	$card_design/card_name.text = this_card.card_name
	var card_name_length : int = this_card.card_name.length()
	var correction : float = clamp(((card_name_length - 14) * 0.033), 0, 0.4) #completely arbitrary, try-and-error based, values
	$card_design/card_name.rect_scale.x = 1
	$card_design/card_name.clip_text = false
	
	if card_name_length > 14:
		$card_design/card_name.rect_scale.x = 1 - correction
		$card_design/card_name.clip_text = true
	
	#Determine background texture color and type of 'card_frame'
	match this_card.attribute:
		"spell":
			$card_design/card_frame.texture = load("res://_resources/card_design/frame_spelltrap.png")
			$card_design/background_texture.texture = load("res://_resources/card_design/texture_green.png")
			if this_card.type == "ritual":
				$card_design/background_texture.texture = load("res://_resources/card_design/texture_blue.png")
		
		"trap":
			$card_design/card_frame.texture = load("res://_resources/card_design/frame_spelltrap.png")
			$card_design/background_texture.texture = load("res://_resources/card_design/texture_pink.png")
		
		_: #monsters
			$card_design/card_frame.texture = load("res://_resources/card_design/frame_monster.png")
			$card_design/background_texture.texture = load("res://_resources/card_design/texture_yellow.png")
			#Special cases where the background color will change. Effect, Fusion, Rituals, Synchro, Tokens
			if this_card.effect.size() > 0:
				$card_design/background_texture.texture = load("res://_resources/card_design/texture_orange.png")
			if this_card_flags.fusion_type == "fusion":
				$card_design/background_texture.texture = load("res://_resources/card_design/texture_purple.png")
			if this_card_flags.fusion_type == "ritual":
				$card_design/background_texture.texture = load("res://_resources/card_design/texture_blue.png")
			if this_card_flags.fusion_type == "token":
				$card_design/background_texture.texture = load("res://_resources/card_design/texture_gray.png")
	
	#Determine if it will show 'monster_features' or 'spelltrap_features' on the design
	match this_card.attribute:
		"spell", "trap": 
			$card_design/card_name.add_color_override("font_color", Color(1,1,1))
			$card_design/monster_features.hide()
			$card_design/spelltrap_features.show()
			
			if this_card.type != this_card.attribute:
				$card_design/spelltrap_features/type_of_spelltrap.text = this_card.type + " " + this_card.attribute + " card"
			else:
				$card_design/spelltrap_features/type_of_spelltrap.text = this_card.attribute + " card"
			
		_: 
			$card_design/card_name.add_color_override("font_color", Color(0,0,0))
			$card_design/spelltrap_features.hide()
			$card_design/monster_features.show()
			
			#Show correct amount of Level Stars
			if this_card.level == 12:
				$card_design/monster_features/level/upto11.hide()
				$card_design/monster_features/level/level12.show()
			else:
				$card_design/monster_features/level/level12.hide()
				$card_design/monster_features/level/upto11.show()
				
				for i in range(1, 12):
					get_node("card_design/monster_features/level/upto11/level" + String(i)).hide()
				for i in range(0, this_card.level):
					get_node("card_design/monster_features/level/upto11/level" + String(i+1)).show()
			
			#Show ATK and DEF
			$card_design/monster_features/atk_def/atk.text = String(clamp(this_card.atk + this_card_flags.atk_up, 0, 9999))
			$card_design/monster_features/atk_def/def.text = String(clamp(this_card.def + this_card_flags.def_up, 0, 9999))
	
	#Show or hide card_back based on 'is_facedown' flag
	if this_card_flags.is_facedown == true:
		$card_design/card_back.show()
	else:
		$card_design/card_back.hide()

#-------------------------------------------------------------------------------
#MOUSE FUNCTIONS SHOULD BE DEPENDENT ON WHAT SCENE THE NODE IS CURRENTLY IN
onready var scene_root := get_tree().get_current_scene()
onready var scene_root_name : String = scene_root.get_name()
onready var GAME_LOGIC := get_tree().get_current_scene().get_child(0)

#-------------------------------------------------------------------------------
var recorded_position : Vector2 = self.rect_position
var recorded_rotation : float = self.rect_rotation
var middle_screen_position : Vector2 = Vector2(475-25, -104) #arbitrary middle of the screen
var middle_screen_scale : Vector2 = Vector2(0.666, 0.666)
var to_middle_time : float = 0.2 #in seconds

func _on_card_node_button_up():
	match scene_root_name:
		"duel_scene": #during a duel
			#When Clicking on any card, update the user interface with this card's information
			var dont_update_card_info_phases = ["choosing_combat_options", "card_options", "checking_for_fusions"]
			if !(GAME_LOGIC.GAME_PHASE in dont_update_card_info_phases):
				#prevent the click on a facedown enemy card of showing the info on bottom bar
				if self.get_parent().get_name().find("enemy") != -1 and self.this_card_flags.is_facedown:
					pass
				else:
					scene_root.update_user_interface(self)
			
			#What to do with a clicked card if it's GAME_PHASE "looking_at_hand" and it's a card in "player_hand"
			if GAME_LOGIC.GAME_PHASE == "looking_at_hand" and self.get_parent().get_name() == "player_hand":
				GAME_LOGIC.GAME_PHASE = "card_options"
				
				#for control reasons pass the calling node
				scene_root.card_in_the_middle = self 
				
				#Show Summon Controls
				$summon_controls.show()
				if CardList.card_list[this_card_id].attribute == "trap": $summon_controls/faceup_summon.hide()
				else: $summon_controls/faceup_summon.show()
				
				#Move card to the middle of the screen, darken background and show summoning options
				get_node("../darken_screen").show()
				scene_root.hide_player_entire_hand()
				card_self_tween.interpolate_property(self, "rect_position", self.rect_position, middle_screen_position, to_middle_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
				card_self_tween.interpolate_property(self, "rect_rotation", self.rect_rotation, 0, to_middle_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
				card_self_tween.interpolate_property(self, "rect_scale", self.rect_scale, middle_screen_scale, to_middle_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
				card_self_tween.start()
				
				SoundControl.play_sound("poc_decide")
			
			#What to do with a clicked card if it's on a card on the field
			elif GAME_LOGIC.GAME_PHASE == "main_phase" or GAME_LOGIC.GAME_PHASE == "choosing_combat_options":
				#Make sure the player can't call the combat controls for enemy cards
				if self.get_parent().get_name().find("enemy") != -1:
					return
				
				#Make sure the player can't even try to activate it's own trap cards by himself
				if CardList.card_list[self.this_card_id].attribute == "trap":
					return
				
				if $combat_controls.is_visible(): #this card already called it, so cancel everything
					cancel_all_combat_controls()
					SoundControl.play_sound("poc_unable")
				else:
					cancel_all_combat_controls()
					show_card_combat_controls()
					SoundControl.play_sound("poc_cursor")
			
			#What to do with a card if the player is choosing a enemy target to battle
			elif GAME_LOGIC.GAME_PHASE == "selecting_combat_target":
				if self.get_parent().get_name().find("enemy") != -1:
					GAME_LOGIC.card_ready_to_defend = self
					
					SoundControl.play_sound("poc_decide")
					
					#Call battle phase now that both cards are defined
					GAME_LOGIC.do_battle(GAME_LOGIC.card_ready_to_attack, GAME_LOGIC.card_ready_to_defend)
			
			#What to do when effects.gd activated an equip card from the field and is waiting for the player to pick it's target
			elif GAME_LOGIC.GAME_PHASE == "activating_equip_from_field":
				if self.get_parent().get_name().find("player") != -1: #can only click on your own card
					GAME_LOGIC.GAME_PHASE = "between"
					#print(CardList.card_list[self.this_card_id].card_name)
					GAME_LOGIC.get_node("effects").equip_from_field_to_target(self) #pass itself as the target_node to continue the effect
		
		_: #No scene defined
			print("No defined function for this Scene")

func show_card_combat_controls():
	#Before anything, go to choosing_combat_options phase
	GAME_LOGIC.GAME_PHASE = "choosing_combat_options"
	
	#Hide the buttons to Change Field View and End Turn, if they are visible
	if get_node("../../../").is_change_field_visible: #I only really gotta check for one... i hope?
		get_node("../../../").toggle_visibility_of_change_field_view_button()
		get_node("../../../").toggle_visibility_of_turn_end_button()
	
	#To make sure the card is zoomed up, do all the same steps to scale it (THIS IS A modified COPY-PASTE OF on_card_node_mouse_enter)
	var initial_size : Vector2 = Vector2(GAME_LOGIC.atk_orientation_x_scale, GAME_LOGIC.atk_orientation_y_scale)
	var scaled_up_size : Vector2 = Vector2(initial_size[0]*1.05, initial_size[1]*1.05)
	var scale_timer : float = 0.2 #in seconds 
	card_self_tween.interpolate_property(self, "rect_scale", self.rect_scale, scaled_up_size, scale_timer, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	card_self_tween.start()
	
	#If it's a spell/trap card, hide combat options and show activate option
	if CardList.card_list[this_card_id].attribute in ["spell", "trap"]:
		unique_spelltrap_activation = false #reset the ability to click on activation button
		$combat_controls/attack_button.hide()
		$combat_controls/defense_button.hide()
		if CardList.card_list[this_card_id].attribute != "trap":
			$combat_controls/activate_button.show()
	#If the card has already battled, the Attacking button should have it's oppacity reduced to indicate it can't battle again
	if this_card_flags.has_battled or this_card_flags.is_defense_position == true:
		$combat_controls/attack_button.modulate = Color(1,1,1, 0.3)
	else:
		$combat_controls/attack_button.modulate = Color(1,1,1, 1)
	#If the card has already battled, fade out the change battle position button
	if this_card_flags.has_battled:
		$combat_controls/defense_button.modulate = Color(1,1,1, 0.3)
	else:
		$combat_controls/defense_button.modulate = Color(1,1,1, 1)
	#If the card is in defense position, change the icon to a Sword so the player knows it will change back to ATK position
	if this_card_flags.is_defense_position == true:
		$combat_controls/defense_button.icon = load("res://_resources/scene_duel/button_atk.png")
	
	$combat_controls.show()

func cancel_all_combat_controls():
	#Cancel the combat controls for ALL CARDS at the same time, as a safety mesure
	for i in range(5):
		var node_to_cancel_M = get_node("../monster_" + String(i))
		var node_to_cancel_ST = get_node("../spelltrap_" + String(i))
		
		node_to_cancel_M.get_node("combat_controls").hide()
		node_to_cancel_ST.get_node("combat_controls").hide()
		
		#Since the card was 'locked_in' on it's zoomed in version, do all the same steps to scale it back down (THIS IS A COPY-PASTE OF on_card_node_mouse_exited)
		#var initial_size : Vector2 = Vector2(initial_size[0]*1.1, initial_size[1]*1.1)
		var scaled_back_size : Vector2 = Vector2(GAME_LOGIC.atk_orientation_x_scale, GAME_LOGIC.atk_orientation_y_scale)
		var scale_timer : float = 0.2 #in seconds
		
		card_self_tween.interpolate_property(node_to_cancel_M, "rect_scale", node_to_cancel_M.rect_scale, scaled_back_size, scale_timer, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		card_self_tween.interpolate_property(node_to_cancel_ST, "rect_scale", node_to_cancel_ST.rect_scale, scaled_back_size, scale_timer, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		card_self_tween.start()
		
		#For visual coherency, force all  cards that are facedown to show it's facedown texture completely
		if get_node("../monster_" + String(i)).get_name() != self.get_name():
			get_node("../monster_" + String(i)).facedown_transparency_animation("make_opaque")
		if get_node("../spelltrap_" + String(i)).get_name() != self.get_name():
			get_node("../spelltrap_" + String(i)).facedown_transparency_animation("make_opaque")
	
	#Show again the buttons to Change Field View, if they are not visible
	if !(get_node("../../../").is_change_field_visible):
		get_node("../../../").toggle_visibility_of_change_field_view_button()
	if !(get_node("../../../").is_turn_end_visible):
		get_node("../../../").toggle_visibility_of_turn_end_button()
	
	#After everything, back to main_phase
	GAME_LOGIC.GAME_PHASE = "main_phase"

func _on_not_a_card_on_field_button_up():
	if GAME_LOGIC.GAME_PHASE == "choosing_combat_options":
		cancel_all_combat_controls()

#-------------------------------------------------------------------------------
var height_variant : int = 60 #in pixels
var movement_time : float = 0.2 #in seconds
onready var card_self_tween = $card_self_tween
onready var card_hand_id : int = int(self.get_name()[-1])
onready var original_hand_heights : Array = [280, 258, 250, 258, 280]
onready var upped_hand_heights : Array = [280-height_variant, 258-height_variant, 250-height_variant, 258-height_variant, 280-height_variant]

func _on_card_node_mouse_entered():
	match scene_root_name:
		"duel_scene": #during a duel
			#Protection so no mousing over can happen and confuse the player
			if GAME_LOGIC.GAME_PHASE == "card_options" or GAME_LOGIC.GAME_PHASE == "checking_for_fusions" : #or GAME_LOGIC.GAME_PHASE == "choosing_combat_options":
				return
			
			#When mousing over any card, update the user interface with this card's information
			if self.get_parent().get_name().find("player") != -1:
				scene_root.update_user_interface(self)
			elif self.get_parent().get_name().find("enemy") != -1 and self.get_node("card_design/card_back").is_visible() == false: #only update enemy cards that are face_up
				scene_root.update_user_interface(self)
			else:
				#Put stuff on 'card_info_box' hidden
				scene_root.get_node("user_interface/card_info_box/colored_bar").hide()
				scene_root.get_node("user_interface/card_info_box/card_name").hide()
				scene_root.get_node("user_interface/card_info_box/atk_def").hide()
				scene_root.get_node("user_interface/card_info_box/extra_icons").hide()
				scene_root.get_node("user_interface/card_info_box/card_text").hide()
			
			#When mousing over a card on Player Hand, during looking_at_hand phase
			if GAME_LOGIC.GAME_PHASE == "looking_at_hand" and self.get_parent().get_name() == "player_hand":
				#Move any other card that is up so it will be down
				for i in range(5):
					var card_to_move = get_node("../card_" + String(i))
					if card_to_move != self and card_to_move.rect_position.y != original_hand_heights[i]:
						card_self_tween.interpolate_property(card_to_move, "rect_position:y", card_to_move.rect_position.y, original_hand_heights[i], movement_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
						card_self_tween.start()
				#Move card Up
				if self.rect_position.y == original_hand_heights[card_hand_id]:
					card_self_tween.interpolate_property(self, "rect_position:y", self.rect_position.y, upped_hand_heights[card_hand_id], movement_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
					card_self_tween.start()
			
			#When mousing over a card on Field, during main Phase (Player Turn only) or 'selecting_combat_target' phase
			if GAME_LOGIC.GAME_PHASE == "main_phase" or GAME_LOGIC.GAME_PHASE == "selecting_combat_target":
				#If card is Facedown, animate the transparency of the card background unless it's a facedown enemy
				if self.get_parent().get_name().find("player") != -1 and self.get_node("card_design/card_back").is_visible():
						facedown_transparency_animation("make_transparent")
				
				#Scale the card a bit up just to indicate to the player
				var initial_size : Vector2 = Vector2(GAME_LOGIC.atk_orientation_x_scale, GAME_LOGIC.atk_orientation_y_scale)
				var scaled_up_size : Vector2 = Vector2(initial_size[0]*1.05, initial_size[1]*1.05)
				var scale_timer : float = 0.2 #in seconds 
				
				card_self_tween.interpolate_property(self, "rect_scale", initial_size, scaled_up_size, scale_timer, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
				card_self_tween.start()
			
			#When mousing over a facedown card during the combat options of any card (usually only on player field)
			if GAME_LOGIC.GAME_PHASE == "choosing_combat_options":
				#If card is Facedown, animate the transparency of the card background
				facedown_transparency_animation("make_transparent")

func _on_card_node_mouse_exited():
	match scene_root_name:
		"duel_scene": #during a duel
			
			#Mouse out of the hand card, during looking_at_hand phase
			if GAME_LOGIC.GAME_PHASE == "looking_at_hand" and self.get_parent().get_name() == "player_hand":
				#Move card Down
				if self.rect_position.y != original_hand_heights[card_hand_id]:
					card_self_tween.interpolate_property(self, "rect_position:y", self.rect_position.y, original_hand_heights[card_hand_id], movement_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
					card_self_tween.start()
			
			#Mouse out of a card on Field, during main Phase or 'selecting_combat_target' phase
			if GAME_LOGIC.GAME_PHASE == "main_phase" or GAME_LOGIC.GAME_PHASE == "selecting_combat_target":
				#If card is Facedown, animate the transparency of the card background
				facedown_transparency_animation("make_opaque")
				
				#Scale the card back down
				#var initial_size : Vector2 = Vector2(initial_size[0]*1.1, initial_size[1]*1.1)
				var scaled_back_size : Vector2 = Vector2(GAME_LOGIC.atk_orientation_x_scale, GAME_LOGIC.atk_orientation_y_scale)
				var scale_timer : float = 0.2 #in seconds
				
				card_self_tween.interpolate_property(self, "rect_scale", self.rect_scale, scaled_back_size, scale_timer, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
				card_self_tween.start()
			
			#When mousing out a facedown card during the combat options of any card
			if GAME_LOGIC.GAME_PHASE == "choosing_combat_options":
				#If card is Facedown, animate the transparency of the card background
				facedown_transparency_animation("make_opaque")

func facedown_transparency_animation(back_property):
	#Animate in or out the transparency of a Facedown Card
	if this_card_flags.is_facedown == true:
		var timer_for_transparency = 0.4 #in seconds
		
		match back_property:
			"make_opaque":
				card_self_tween.interpolate_property($card_design/card_back, "modulate", $card_design/card_back.modulate, Color(1,1,1,1), timer_for_transparency, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
				card_self_tween.start()
			"make_transparent":
				card_self_tween.interpolate_property($card_design/card_back, "modulate", $card_design/card_back.modulate, Color(1,1,1,0.3), timer_for_transparency, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
				card_self_tween.start()

#-------------------------------------------------------------------------------
var time_to_enlarge : float = 0.2 #in seconds
var original_size : Vector2 = Vector2(1, 1)
var big_size : Vector2 = Vector2(1.2, 1.2)

func _on_fusion_summon_mouse_entered():
	enlarge_button($summon_controls/fusion_summon)
func _on_faceup_summon_mouse_entered():
	enlarge_button($summon_controls/faceup_summon)
func _on_facedown_summon_mouse_entered():
	enlarge_button($summon_controls/facedown_summon)
func _on_fusion_indicator_mouse_entered():
	if GAME_LOGIC.GAME_PHASE == "looking_at_hand" and self.get_parent().get_name() == "player_hand":
		enlarge_button($fusion_indicator)
func _on_attack_button_mouse_entered():
	enlarge_button($combat_controls/attack_button)
func _on_defense_button_mouse_entered():
	enlarge_button($combat_controls/defense_button)

func enlarge_button(button_to_enlarge):
	$summon_controls/summons_tween.interpolate_property(button_to_enlarge, "rect_scale", original_size, big_size, time_to_enlarge, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$summon_controls/summons_tween.start()

func _on_fusion_summon_mouse_exited():
	reduce_button($summon_controls/fusion_summon)
func _on_faceup_summon_mouse_exited():
	reduce_button($summon_controls/faceup_summon)
func _on_facedown_summon_mouse_exited():
	reduce_button($summon_controls/facedown_summon)
func _on_fusion_indicator_mouse_exited():
	if GAME_LOGIC.GAME_PHASE == "looking_at_hand" and self.get_parent().get_name() == "player_hand":
		reduce_button($fusion_indicator)
func _on_attack_button_mouse_exited():
	reduce_button($combat_controls/attack_button)
func _on_defense_button_mouse_exited():
	reduce_button($combat_controls/defense_button)

func reduce_button(button_to_reduce):
	$summon_controls/summons_tween.interpolate_property(button_to_reduce, "rect_scale", big_size, original_size, time_to_enlarge, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$summon_controls/summons_tween.start()

#-------------------------------------------------------------------------------
onready var PLAYER_LOGIC = GAME_LOGIC.get_child(0)

func _on_fusion_summon_button_up():
	if GAME_LOGIC.GAME_PHASE == "card_options":
		#Add the 'card_node' to the Fusion Order list
		if !PLAYER_LOGIC.fusion_order.has(scene_root.card_in_the_middle):
			SoundControl.play_sound("poc_cursor")
			PLAYER_LOGIC.fusion_order.append(scene_root.card_in_the_middle)
		else:
			remove_a_card_from_fusion_order(scene_root.card_in_the_middle)
		
		#Show the indicator with the proper value
		$fusion_indicator/fusion_order_no.text = String(PLAYER_LOGIC.fusion_order.find(scene_root.card_in_the_middle) +1)
		if $fusion_indicator/fusion_order_no.text != "0":
			$fusion_indicator.show()
		
		#Put the card back down
		reduce_button($summon_controls/fusion_summon)
		scene_root.put_middle_card_in_hand()

func _on_fusion_indicator_button_up():
	remove_a_card_from_fusion_order(self)

func remove_a_card_from_fusion_order(card_to_remove):
	SoundControl.play_sound("poc_unable")
	
	#Remove the 'card_node' from the Fusion Order list
	if PLAYER_LOGIC.fusion_order.has(card_to_remove):
		PLAYER_LOGIC.fusion_order.remove(PLAYER_LOGIC.fusion_order.find(card_to_remove))
	
	#Hide the indicator for this card
	$fusion_indicator.hide()
	
	#Update all other indicators to their new position in the order
	for i in range(PLAYER_LOGIC.fusion_order.size()):
		var card_node_to_modify = PLAYER_LOGIC.fusion_order[i].get_path()
		get_node(String(card_node_to_modify) + "/fusion_indicator/fusion_order_no").text = String(i +1)

#-------------------------------------------------------------------------------
func _on_faceup_summon_button_up():
	SoundControl.play_sound("poc_decide")
	var card_to_summon : Node = self
	
	#Add this card to 'fusion_order' if there are cards on the list and this isn't yet
	if PLAYER_LOGIC.fusion_order.size() > 0 and !(PLAYER_LOGIC.fusion_order.has(self)):
		PLAYER_LOGIC.fusion_order.append(self)
	
	PLAYER_LOGIC.get_field_slot_for_new_card(card_to_summon)

func _on_facedown_summon_button_up():
	SoundControl.play_sound("poc_decide")
	var card_to_summon : Node = self
	this_card_flags.is_facedown = true #at first, it's flagged to be faced down. If it is or not by the end is decided by player_logic.gd
	
	#Add this card to 'fusion_order' if there are cards on the list and this isn't yet
	if PLAYER_LOGIC.fusion_order.size() > 0 and !(PLAYER_LOGIC.fusion_order.has(self)):
		PLAYER_LOGIC.fusion_order.append(self)
	
	PLAYER_LOGIC.get_field_slot_for_new_card(card_to_summon)

#-------------------------------------------------------------------------------
func _on_defense_button_button_up(): #This is actually Defense AND Attack button, it just changes functions when needed
	#Toggle monster battle position if it hasn't battled this turn
	if this_card_flags.has_battled == false:
		toggle_battle_position()

func toggle_battle_position():
	SoundControl.play_sound("poc_move")
	var position_rotate_timer : float = 0.2 #in seconds
	
	if this_card_flags.is_defense_position == false: #it's in attack, toggle to defense
		this_card_flags.is_defense_position = true
		$combat_controls/defense_button.icon = load("res://_resources/scene_duel/button_atk.png")
		$combat_controls/combat_tween.interpolate_property($card_design, "rect_rotation", 0, -90, position_rotate_timer, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$combat_controls/combat_tween.interpolate_property($combat_controls/attack_button, "modulate", $combat_controls/attack_button.modulate, Color(1,1,1, 0.3), position_rotate_timer, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$combat_controls/combat_tween.start()
	else: #it's in defense, toggle to attack
		this_card_flags.is_defense_position = false
		$combat_controls/defense_button.icon = load("res://_resources/scene_duel/button_def.png")
		$combat_controls/combat_tween.interpolate_property($card_design, "rect_rotation", -90, 0, position_rotate_timer, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		if self.this_card_flags.has_battled == false: #if it hasn't battled, change the Attack Button to be visible again
			$combat_controls/combat_tween.interpolate_property($combat_controls/attack_button, "modulate", $combat_controls/attack_button.modulate, Color(1,1,1, 1), position_rotate_timer, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$combat_controls/combat_tween.start()

func _on_attack_button_button_up():
	if this_card_flags.is_defense_position == true or this_card_flags.has_battled == true:
		return #this card can't battle if met these conditions
	
	SoundControl.play_sound("poc_move")
	
	#This is the button to enter Battle Phase with this card
	GAME_LOGIC.GAME_PHASE = "selecting_combat_target"
	GAME_LOGIC.card_ready_to_attack = self
	
	#Show enemy field and button to go back and cancel battle phase
	get_node("../../../").change_field_view()
	get_node("../../../").toggle_visibility_of_change_field_view_button()

var unique_spelltrap_activation = false
func _on_activate_button_button_up():
	if unique_spelltrap_activation == false:
		unique_spelltrap_activation = true
	
		#This calls for the activation of a facedown spell/trap card on the field
		GAME_LOGIC.effect_activation(self, "on_flip")
