extends Node

#Reference values for hand cards position and rotation. Order: 0, 1, 2, 3, 4
const card_references = {
	"card_0_references" : {"rect_position" : Vector2(185-35, 280), "rect_rotation" : -11},
	"card_1_references" : {"rect_position" : Vector2(330-35, 258), "rect_rotation" : -6},
	"card_2_references" : {"rect_position" : Vector2(475-35, 250), "rect_rotation" : 0},
	"card_3_references" : {"rect_position" : Vector2(620-35, 258), "rect_rotation" : 6},
	"card_4_references" : {"rect_position" : Vector2(765-35, 280), "rect_rotation" : 11},
	"offscreen_reference" : {"rect_position" : Vector2(475-35, 400), "rect_rotation" : 0}}

#Player variables
var player_LP : int
var player_deck : Array = PlayerData.player_deck.duplicate(true) #populated by 'card_id':String
var player_hand : Array = [] #populated by 'card_id':String

#Player Logic variables
onready var GAME_LOGIC = get_node("../")
var fusion_order : Array = [] #populated by 'card_node':Node

#Rewards related variables
var fusion_count : int = 0
var effect_count : int = 0
var spelltrap_count : int = 0
var turn_count : int = 0

#-------------------------------------------------------------------------------
func _ready():
	#TEMPORARY DECK CREATION
	player_deck = PlayerData.player_deck.duplicate(true)
	player_deck.shuffle()
	player_hand = [] #Set specific cards to the player hand for testing purposes

#-------------------------------------------------------------------------------
func start_player_turn():
	#If the game has ended, stop everything
	if get_node("../../reward_scene").is_visible():
		return 
	
	#Increment the turn counter
	turn_count += 1
	get_node("../../user_interface/top_info_box/field_info/turn").text = GameLanguage.duel_scene.turn[PlayerData.game_language] + " " + String(turn_count)
	#print("------------------------------- TURN ", turn_count," -------------------------------")
	
	#Start player turn with hand hidden
	get_node("../../player_hand").hide()
	
	#Reset other properties just for safety
	get_node("../../").put_middle_card_in_hand()
	
	#Reset properties related to fusion_order, in case there's any leftover information
	fusion_order.clear()
	for i in range(5):
		var fusion_indicator_to_reset = get_node("../../player_hand/card_" + String(i) + "/fusion_indicator")
		fusion_indicator_to_reset.get_child(1).text = "" #fusion_order_no
		fusion_indicator_to_reset.hide()
	
	#Reset the 'has_battled' for all monsters on the field
	for i in range(5):
		var this_i_monster : Node = get_node("../../duel_field/player_side_zones/monster_" + String(i))
		if this_i_monster.is_visible():
			this_i_monster.this_card_flags.has_battled = false
	
	#Reset the flags for all cards in hand, just in case
	for i in range(5):
		var this_i_card : Node = get_node("../../player_hand/card_" + String(i))
		GAME_LOGIC.reset_a_card_node_properties(this_i_card)
	
	#Reset this at the start of the turn in case needed
	if GAME_LOGIC.waboku_protection == true:
		GAME_LOGIC.waboku_protection = false
	
	#Show the history button
	GAME_LOGIC.get_parent().get_node("side_menu").history_button_in()
	
	#Wait timer just for DEV reasons
	$player_timer.start(0.2); yield($player_timer, "timeout")
	#yield(get_tree().create_timer(0.2), "timeout")
	#print("player_logic.gd initial timeout!")
	
	#Start player turn with his Draw Phase
	player_draw_phase()

#-------------------------------------------------------------------------------
func player_draw_phase():
	GAME_LOGIC.GAME_PHASE = "draw_phase"
	
	#Hide card nodes that the player doesn't have corresponding card on it's hand
	for i in range(5):#4, player_hand.size()-1, -1):                            <-------- this was hidden so every turn all cards are animated in hand
		var card_node_to_hide = get_node("../../player_hand/card_" + String(i))
		card_node_to_hide.hide()
	
	#Pull the correct number of cards from the Deck to the Player Hand
	var cards_to_pull : int = 5 - player_hand.size()
	for _i in range(cards_to_pull):
		if player_deck.size() > 0:
			player_hand.append(player_deck[0]) #add to the player_hand the first card from the deck
			player_deck.remove(0) #remove from the deck that same card
		else:
			print("player deck out")
			GAME_LOGIC.check_for_game_end("PLAYER_deck_out")
			return "exit game"
	
	#Update the card_nodes visually to match cards in hand
	for i in range(5):
		var card_in_hand : Node = get_node("../../player_hand/card_" + String(i))
		card_in_hand.update_card_information(player_hand[i])
	
	#Show player hand and do the animation for pulling cards
	var hand_tween = get_node("../../player_hand/hand_tween")
	var waiting_time : float = 0.3 #in seconds
	get_node("../../player_hand/").show()
	get_node("../../").show_player_entire_hand()
	
	for i in range(5):#-cards_to_pull, 5):                                      <-------- this was hidden so every turn all cards are animated in hand
		var card_node_to_animate = get_node("../../player_hand/card_" + String(i))
		card_node_to_animate.show()
		
		#Set position and rotation to starting value, out of the screen
		var final_position_reference = card_references["card_"+ String(i) +"_references"]
		card_node_to_animate.rect_position = card_references.offscreen_reference.rect_position
		card_node_to_animate.rect_rotation = card_references.offscreen_reference.rect_rotation
		
		SoundControl.play_sound("poc_move")
		
		#Do the tween animation
		hand_tween.interpolate_property(card_node_to_animate, "rect_position", card_node_to_animate.rect_position, final_position_reference.rect_position, waiting_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		hand_tween.interpolate_property(card_node_to_animate, "rect_rotation", card_node_to_animate.rect_rotation, final_position_reference.rect_rotation, waiting_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		hand_tween.start()
		$player_timer.start(waiting_time); yield($player_timer, "timeout")
		#yield(get_tree().create_timer(waiting_time), "timeout")                #<-------- if I comment out this yield timer all cards are animated at once. Pretty cool effect
		
		#Animate the deck counter
		if i < cards_to_pull:
			get_node("../../user_interface/top_info_box/player_info/deck").text = String(int(get_node("../../user_interface/top_info_box/player_info/deck").text) - 1)
	
	#Show the button to look at the other side of the field
	get_node("../..").toggle_visibility_of_change_field_view_button()
	
	GAME_LOGIC.GAME_PHASE = "looking_at_hand"
	
#-------------------------------------------------------------------------------
var clicked_field_position = null #will be set by 'duel_field/[slots_for_animation]/slot_#'
var card_to_summon : Node
func get_field_slot_for_new_card(passed_card_to_summon):
	card_to_summon = passed_card_to_summon
	GAME_LOGIC.GAME_PHASE = "selecting_field_slot"
	
	#Hide the button to look at the other side of the field
	get_node("../..").toggle_visibility_of_change_field_view_button()
	
	#Check if it's a card to be placed in top row or bottom row
	if CardList.card_list[card_to_summon.this_card_id].attribute in ["spell", "trap"]:
		#With spell and traps we got to figure out which row of slots to show
		#If has monsters on fusion chain, show top row
		if fusion_order.size() > 0:
			for i in range(fusion_order.size()):
				#If there is even one monster on the fusion order, show top row
				if !(CardList.card_list[fusion_order[i].this_card_id].attribute in ["spell", "trap"]):
					show_player_field_slots("monster_field_slots")
					return
		
		#If there wasn't any reason to show top row, just show bottom row then
		show_player_field_slots("spelltrap_field_slots")
		
	else:
		#Show top row with buttons that will keep the Summoning logic going
		show_player_field_slots("monster_field_slots")

func show_player_field_slots(field_slots_to_show):
	if GAME_LOGIC.GAME_PHASE != "selecting_field_slot":
		return
	
	#Make sure the player is looking at it's own field on this phase
	if get_node("../../duel_field").position != get_node("../../").player_field_camera_position:
		get_node("../../").change_field_view()
	
	#Hide player hand, show the zones on the field
	get_node("../../player_hand").hide()
	get_node("../../duel_field/player_side_zones/" + field_slots_to_show).show()
	
	#Animate_in the button to go back to the hand
	get_node("../../").toggle_visibility_of_back_to_hand_button()
	
	#Animate infinitelly the slot indicators
	recursive_slot_animation(field_slots_to_show)

func recursive_slot_animation(field_slots_to_show):
	var animation_time : float = 0.7 #in seconds
	var slots_for_animation : Node = get_node("../../duel_field/player_side_zones/" + field_slots_to_show)
	var tween_slots : Node = get_node("../../duel_field/player_side_zones/"+ field_slots_to_show +"/tween_slots")
	var small_size : Vector2 = Vector2(1, 1)
	var big_size : Vector2 = Vector2(1.05, 1.05)
	
	#Slots Animation
	for i in range(5):
		if slots_for_animation.get_child(i).rect_scale == small_size:
			tween_slots.interpolate_property(get_node("../../duel_field/player_side_zones/"+ field_slots_to_show +"/slot_" + String(i)), "rect_scale", small_size, big_size, animation_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			tween_slots.start()
		elif slots_for_animation.get_child(i).rect_scale == big_size:
			tween_slots.interpolate_property(get_node("../../duel_field/player_side_zones/"+ field_slots_to_show +"/slot_" + String(i)), "rect_scale", big_size, small_size, animation_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			tween_slots.start()
	$player_timer.start(animation_time + 0.3); yield($player_timer, "timeout")
	#yield(get_tree().create_timer(animation_time + 0.3), "timeout")
	
	#Recursive
	if get_node("../../duel_field/player_side_zones/" + field_slots_to_show).is_visible():
		recursive_slot_animation(field_slots_to_show)
	else:
		return

func _on_slot_0_button_up():
	player_try_to_summon(0)
func _on_slot_1_button_up():
	player_try_to_summon(1)
func _on_slot_2_button_up():
	player_try_to_summon(2)
func _on_slot_3_button_up():
	player_try_to_summon(3)
func _on_slot_4_button_up():
	player_try_to_summon(4)

#Called by the '[kind_of_card]_field_slots' that were set visible by 'show_player_field_slots()':
func player_try_to_summon(field_slot_to_summon : int):
	#Hide the button to go back to the hand
	get_node("../../").toggle_visibility_of_back_to_hand_button()
	
	var card_on_slot : Node
	var kind_of_card : String = "monster"
	if CardList.card_list[card_to_summon.this_card_id].attribute in ["spell", "trap"] and fusion_order.size() <= 1: kind_of_card = "spelltrap"
	
	#If there is a card on the selected 'field_slot_to_summon', add it to the beginning of 'fusion_order' list
	if get_node("../../duel_field/player_side_zones/" + kind_of_card + "_" + String(field_slot_to_summon)).is_visible():
		card_on_slot = get_node("../../duel_field/player_side_zones/" + kind_of_card + "_" + String(field_slot_to_summon))
		fusion_order.push_front(card_on_slot)
	
	GAME_LOGIC.GAME_PHASE = "checking_for_fusions"
	get_node("../../duel_field/player_side_zones/monster_field_slots").hide()
	get_node("../../duel_field/player_side_zones/spelltrap_field_slots").hide()
	
	var final_card_to_summon #: Node
	#Check if any fusions have to be done	
	match fusion_order.size():
		0: #Trying to summon a single card
			final_card_to_summon = card_to_summon
			
			#remove that card from player's hand
			if player_hand.find(card_to_summon.this_card_id) != -1:
				player_hand.remove(player_hand.find(card_to_summon.this_card_id))
			
			summon_final_card(final_card_to_summon, field_slot_to_summon)
		
		1: #Might be a single card, or summoning with another single one in fusion order
			if card_to_summon in fusion_order:
				#Alright, it's the same card already registered for fusion, but it's alone
				final_card_to_summon = card_to_summon
				
				#remove that card from player's hand
				player_hand.remove(player_hand.find(card_to_summon.this_card_id))
				
				summon_final_card(final_card_to_summon, field_slot_to_summon)
				
			else:
				#There is another card, so it has to be fused to the single one in fusion order (that was added because it's on the field and player summoned on top of it)
				fusion_order.append(card_to_summon)
				
				#Remove the cards from player's hand
				for card_node in fusion_order:
					if player_hand.has(card_node.this_card_id):
						player_hand.remove(player_hand.find(card_node.this_card_id))
				
				final_card_to_summon = call_fusion_logic(field_slot_to_summon)
		
		_: #Confirmed Fusion Summon
			final_card_to_summon = call_fusion_logic(field_slot_to_summon)
			
			#Remove the cards from player's hand
			for card_node in fusion_order:
				if player_hand.has(card_node.this_card_id):
					player_hand.remove(player_hand.find(card_node.this_card_id))

func call_fusion_logic(passing_field_slot_to_summon):
	#SETUP the dummy node that will be keeping the fusion results information
	var fusion_result = $fusion_animation/fusion_result_card
	
	#Call fusion logic, return only the result
	var card_to_fuse_1 : Node = fusion_order[0]
	var card_to_fuse_2 : Node = fusion_order[1]
	var fusion_information_array : Array = GAME_LOGIC.fusing_cards_logic(card_to_fuse_1, card_to_fuse_2) #[ID:String, Extra Info]
	
	#Animate the fusing of the two cards
	var fusion_timer : float = 0.8 #in seconds
	var fusion_start_pos_0 : Vector2 = Vector2(83+60, 80)
	var fusion_start_pos_1 : Vector2 = Vector2(856-60, 80)
	var fusion_final_pos : Vector2 = Vector2(475, 80)
	
	SoundControl.play_sound("poc_fusion1")
	
	$fusion_animation/fusion_order_0.rect_position = fusion_start_pos_0
	$fusion_animation/fusion_order_1.rect_position = fusion_start_pos_1
	$fusion_animation/fusion_order_0.this_card_flags.fusion_type = fusion_order[0].this_card_flags.fusion_type
	$fusion_animation/fusion_order_0.this_card_flags.atk_up = fusion_order[0].this_card_flags.atk_up 
	$fusion_animation/fusion_order_0.this_card_flags.def_up = fusion_order[0].this_card_flags.def_up
	$fusion_animation/fusion_order_0.update_card_information(fusion_order[0].this_card_id)
	$fusion_animation/fusion_order_1.update_card_information(fusion_order[1].this_card_id)
	$fusion_animation/fusion_order_0.show()
	$fusion_animation/fusion_order_1.show()
	$fusion_animation.show()
	$fusion_animation/tween_fusion.interpolate_property($fusion_animation/fusion_order_0, "rect_position", fusion_start_pos_0, fusion_final_pos, fusion_timer, Tween.TRANS_QUINT, Tween.EASE_IN_OUT)
	$fusion_animation/tween_fusion.interpolate_property($fusion_animation/fusion_order_0, "modulate", Color(1, 1, 1, 1), Color(10, 10, 10, 0.666), fusion_timer*0.9, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$fusion_animation/tween_fusion.interpolate_property($fusion_animation/fusion_order_1, "rect_position", fusion_start_pos_1, fusion_final_pos, fusion_timer, Tween.TRANS_QUINT, Tween.EASE_IN_OUT)
	$fusion_animation/tween_fusion.interpolate_property($fusion_animation/fusion_order_1, "modulate", Color(1, 1, 1, 1), Color(10, 10, 10, 0.666), fusion_timer*0.9, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$fusion_animation/tween_fusion.start()
	$player_timer.start(fusion_timer); yield($player_timer, "timeout")
	#yield(get_tree().create_timer(fusion_timer), "timeout")
	$fusion_animation/fusion_order_0.hide()
	$fusion_animation/fusion_order_1.hide()
	
	#Transform the dummy 'fusion_result' into the actual fusion result that was just returned
	fusion_result.this_card_id = fusion_information_array[0]
	
	#Depending on the Type of 'fusion' that was done, do appropriate changes
	var fusion_failled_sound_trigger = false
	match typeof(fusion_information_array[1]):
		TYPE_ARRAY: #equip [monster_card_id, [status, value_change]]
			#The flags for the result of an Equip are exactly the same as the non-spell/trap card used
			var monster_is : Node = card_to_fuse_1
			if CardList.card_list[card_to_fuse_1.this_card_id].attribute in ["spell", "trap"]:
				monster_is = card_to_fuse_2
			fusion_result.this_card_flags = monster_is.this_card_flags
			
			match fusion_information_array[1][0]:
				"atk_up", "def_up":
					fusion_result.this_card_flags[fusion_information_array[1][0]] += fusion_information_array[1][1]
				"stats_up":
					fusion_result.this_card_flags.atk_up += fusion_information_array[1][1]
					fusion_result.this_card_flags.def_up += fusion_information_array[1][1]
					fusion_result.this_card_flags.is_facedown = false
			
			#"Fusing" with an Equip card will actually count as spelltrap activation
			GAME_LOGIC.get_node("player_logic").spelltrap_count += 1
			
			#Safeguard reset of status if the result ISN'T the same monster that was equipped
			if fusion_result.this_card_id != monster_is.this_card_id:
				fusion_result.this_card_flags.atk_up = 0
				fusion_result.this_card_flags.def_up = 0
			
		TYPE_BOOL: #regular fusion [monster_card_id, fusion_success : bool]
			if fusion_information_array[1] == true: #fusion was a success
				fusion_result.this_card_flags.fusion_type = "fusion"
				fusion_result.this_card_flags.is_defense_position = false #Force fusion results to be in ATK
			
			#Increment the counter for Duel Rewards
			GAME_LOGIC.get_node("player_logic").fusion_count += 1
			
			#Safeguard for remaining Equip results
			if fusion_result.this_card_id != $fusion_animation/fusion_order_0.this_card_id:
				fusion_result.this_card_flags.atk_up = 0
				fusion_result.this_card_flags.def_up = 0
			
		_: 
			#Safeguard reset fusion_type after any failed fusion
			fusion_result.this_card_flags.fusion_type = null
			fusion_failled_sound_trigger = true
			
			#Correction to keep the colored border when a sucessfull Fusion Monster fails to fuse with a spell
			if $fusion_animation/fusion_order_0.this_card_flags.fusion_type != null or $fusion_animation/fusion_order_1.this_card_flags.fusion_type != null:
				if CardList.card_list[$fusion_animation/fusion_order_0.this_card_id].attribute in ["spell", "trap"] or CardList.card_list[$fusion_animation/fusion_order_1.this_card_id].attribute in ["spell", "trap"]:
					fusion_result.this_card_flags.fusion_type = "fusion"
	
	#Animate the showing of the result
	var fusion_result_start_size : Vector2 = Vector2(0.7, 0.7)
	var fusion_result_final_size : Vector2 = Vector2(0.9, 0.9)
	
	$fusion_animation/fusion_result_card.modulate = Color(10, 10, 10)
	$fusion_animation/fusion_result_card.rect_scale = fusion_result_start_size
	$fusion_animation/fusion_result_card.update_card_information(fusion_result.this_card_id)
	$fusion_animation/fusion_result_card.show()
	
	#Play the correct sound if Fusion Worked or Fusion Failled
	if fusion_failled_sound_trigger == false:
		SoundControl.play_sound("poc_fusion2")
	else:
		SoundControl.play_sound("poc_ignore")
	
	$fusion_animation/tween_fusion.interpolate_property($fusion_animation/fusion_result_card, "modulate", Color(10, 10, 10), Color(1, 1, 1), fusion_timer*0.8, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$fusion_animation/tween_fusion.interpolate_property($fusion_animation/fusion_result_card, "rect_scale", fusion_result_start_size, fusion_result_final_size, fusion_timer*0.8, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$fusion_animation/tween_fusion.start()
	$player_timer.start(fusion_timer*1.5); yield($player_timer, "timeout")
	#yield(get_tree().create_timer(fusion_timer*1.5), "timeout")
	$fusion_animation/fusion_result_card.hide()
	$fusion_animation.hide()
	
	#Remove from fusion order the used cards
	fusion_order.remove(0) #card_to_fuse_1 is discarted
	fusion_order.remove(0) #card_to_fuse_2 became the first, it is also discarted
	fusion_order.push_front(fusion_result) #the result of the fusion is now the first in the order
	
	#Recursive check until there aren't any more Fusions to do
	if fusion_order.size() <= 1:
		fusion_order.clear()
		
		#Flip monsters as result of fusion are always forced Face up, but they shouldn't activate their effects
		if CardList.card_list[fusion_result.this_card_id].effect.size() > 0 and CardList.card_list[fusion_result.this_card_id].effect[0] == "on_flip":
			fusion_result.this_card_flags.has_activated_effect = true
		
		summon_final_card(fusion_result, passing_field_slot_to_summon)
	else:
		call_fusion_logic(passing_field_slot_to_summon)

func summon_final_card(final_card_to_summon, field_slot_to_summon):
	SoundControl.play_sound("poc_move")
	
	var kind_of_card : String = "monster"
	if CardList.card_list[final_card_to_summon.this_card_id].attribute in ["spell", "trap"]: kind_of_card = "spelltrap"
	
	#Update information on the invisible node waiting on the field, then show it
	var node_slot_to_change = get_node("../../duel_field/player_side_zones/" + kind_of_card + "_" + String(field_slot_to_summon))
	
	#Force traps to always be facedown!
	if CardList.card_list[final_card_to_summon.this_card_id].attribute == "trap":
		final_card_to_summon.this_card_flags.is_facedown = true
	
	#Change the necessary flags to reflect the new card
	node_slot_to_change.this_card_flags = final_card_to_summon.this_card_flags
	node_slot_to_change.update_card_information(final_card_to_summon.this_card_id)
	node_slot_to_change.show()
	
	#Clear the Dummy 'fusion_result' node after it's information was already used
	GAME_LOGIC.reset_a_card_node_properties($fusion_animation/fusion_result_card)
	
	#Correct rotation if the card is still being shown horizontally
	if node_slot_to_change.this_card_flags.is_defense_position == false:
		node_slot_to_change.get_node("card_design").rect_rotation = 0
		node_slot_to_change.get_node("combat_controls/defense_button").icon = load("res://_resources/scene_duel/button_def.png")

	#Check if it is to be placed with facedown
	var card_back = node_slot_to_change.get_node("card_design/card_back")
	if node_slot_to_change.this_card_flags.is_facedown == true:
		card_back.show()
	else: 
		card_back.hide()
		
		#Safeguard for flip effects
		if CardList.card_list[node_slot_to_change.this_card_id].effect.size() > 0 and CardList.card_list[node_slot_to_change.this_card_id].effect[0] == "on_flip":
			node_slot_to_change.this_card_flags.has_activated_effect = true
	
	if node_slot_to_change.this_card_flags.atk_up != 0:
		node_slot_to_change.this_card_flags.is_facedown = false
		card_back.hide()
	
	#Small animation just so it's pretty
	var tween_field_cards = get_node("../../duel_field/player_side_zones/tween_field_cards")
	var summon_animation_time = 0.1
	var summon_size_big : Vector2 = Vector2(0.8, 0.8)
	var summon_field_size : Vector2 = Vector2(GAME_LOGIC.atk_orientation_x_scale, GAME_LOGIC.atk_orientation_y_scale)

	tween_field_cards.interpolate_property(node_slot_to_change, "rect_scale", summon_size_big, summon_field_size, summon_animation_time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween_field_cards.start()
	$player_timer.start(summon_animation_time); yield($player_timer, "timeout")
	#yield(get_tree().create_timer(summon_animation_time), "timeout")
	
	#Check if this card will get a field bonus
	var field_name : String
	var field_element_colors = {
		"fire":  Color("ff4a4a"),
		"earth": Color("0ca528"),
		"water": Color("1c68ff"),
		"wind":  Color("4dedff"),
		"dark":  Color("5100ff"),
		"light": Color("ffef00"),
	}
	
	for attribute in field_element_colors.keys():
		var color = field_element_colors[attribute]
		if GAME_LOGIC.get_parent().get_node("duel_field/player_side_zones").self_modulate == color:
			field_name = attribute
			break
	
	get_node("../effects").field_bonus(field_name)
	
	#If it's facedown, do an extra animation of card back transparency toggling
	if node_slot_to_change.this_card_flags.is_facedown == true:
		node_slot_to_change.facedown_transparency_animation("make_transparent")
		
	#If it's not facedown, check if it has an effect to activate
	else:
		if CardList.card_list[final_card_to_summon.this_card_id].effect.size() > 0 and final_card_to_summon.this_card_flags.has_activated_effect == false:
			GAME_LOGIC.effect_activation(node_slot_to_change, "on_summon") #important to pass 'node_slot_to_change' so effects can target the exact card on the field
			yield(get_node("../effects"), "effect_fully_executed")
	
	#Show again the button to look at the other side of the field, and end player's turn
	get_node("../../").toggle_visibility_of_change_field_view_button()
	get_node("../../").toggle_visibility_of_turn_end_button()
	
	#Automatically update User Interface with the resulting card information (if it's still visible)
	if node_slot_to_change.is_visible():
		get_node("../../").update_user_interface(node_slot_to_change)
	
	GAME_LOGIC.GAME_PHASE = "main_phase" #finished summoning, FINALLY lmao
