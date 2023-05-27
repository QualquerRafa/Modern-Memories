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
}

#-------------------------------------------------------------------------------
func _ready():
	this_card_id = generate_random_card()
	update_card_information("00000")
	
#	generate_card_for_printScreen()
#func generate_card_for_printScreen():
#	self.rect_position = Vector2(480, 100)

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
	#$summon_controls/faceup_summon/artwork.texture = load("res://_resources/_card_artwork/" + card_id + ".png")
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
			#Special cases where the background color will change. Effect, Fusion, Rituals, Synchro
			if this_card.effect.size() > 0:
				$card_design/background_texture.texture = load("res://_resources/card_design/texture_orange.png")
			if this_card_flags.fusion_type == "fusion":
				$card_design/background_texture.texture = load("res://_resources/card_design/texture_purple.png")
			if this_card_flags.fusion_type == "ritual":
				$card_design/background_texture.texture = load("res://_resources/card_design/texture_blue.png")
	
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
