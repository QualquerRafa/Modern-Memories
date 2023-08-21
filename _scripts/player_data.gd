extends Node

#ON UPDATE PLAYER REWARDS <3
var update_reward_ids = ["00703"]

#Player Variables that are stored within the save
var player_name : String
var player_deck : Array = [] #populated by ID:String
var player_trunk: Dictionary = {} #populated by {ID:String : COPIES:int}
var player_starchips : int = 0
var password_bought_cards : Array = [] #populated by ID:String
var recorded_duels : Dictionary = {} #populated by {duelist_name : {W:int, L:int}}
var last_reward_cards : Array = [] #populated by ID:String
var list_of_player_decks : Dictionary = {} #populated by {deck_name:String : {deck:Array, color:Color(1,1,1,1)}}
var active_deck_name : String = ""
var registered_freeduel_speed : float = 1.0 #to keep between duels

var recorded_campaign_defeats : Array = [] #populated by Dialogic's variables "campaign_defeat_NAME"
var recorded_dialogs : Array = [] #populated by Dialogic Timeline Names

#Game Settings, stored in a separate file
var game_language : String = "en" #default is english
var game_volume : float = 0.1 #0 to 1, 'linear2db' converts it into db in 'sound_control.gd'
var game_autosave : bool = false #starts as false, player can opt in

#Variables that aren't persistent
var game_loaded : bool = false #set to true after the 'savefile' has been correctly loaded

var scene_to_return_after_duel : String = ""
var going_to_duel : String = "" #populated by a Duelist Name from 'npc_decks.gd'
var last_duel_result : String = "" #win or lose passed by the reward_scene

var tournament_last_progression_saved : String = ""
var tournament_competitors_saved = {"green" : [], "blue" : [], "purple" : [], "red" : [], "gold" : []}
var tournament_last_duelist_saved : String = ""

#---------------------------------------------------------------------------------------------------
func create_player_deck():
	if player_deck.size() == 40: return
	
	#Elemental Bases
	var earth_base = ["00253", "00253", "00255", "00255", "00254", "00254", "00254", "00256", "00283", "00283", "00289", "00295", "00305", "00305", "00106", "00112"]
	var fire_base =  ["00260", "00260", "00262", "00262", "00261", "00261", "00261", "00263", "00284", "00284", "00290", "00296", "00308", "00308", "00107", "00113"]
	var water_base = ["00267", "00267", "00269", "00269", "00268", "00268", "00268", "00270", "00285", "00285", "00291", "00297", "00311", "00311", "00109", "00115"]
	var wind_base =  ["00274", "00274", "00276", "00276", "00275", "00275", "00275", "00277", "00286", "00286", "00292", "00298", "00314", "00314", "00110", "00116"]
	
	#Extra Fixed cards to be added
	var list_of_type_destruction = ["00221", "00222", "00223", "00224", "00225", "00226", "00227", "00228", "00229", "00230"]
	var list_of_type_boost_equip = ["00196", "00197", "00198", "00199", "00200", "00201", "00202", "00203", "00204", "00205", "00206", "00207", "00208", "00209", "00210"]
	
	#Initial Rituals for the player
	var tier_1_ritual = ["01185", "00581", "01183", "00635"] #50%
	var tier_2_ritual = ["00538", "00667", "01120", "01176"] #35%
	var tier_3_ritual = ["01240", "01236", "01242", "01044"] #15%
	
	#Token Invocations of 2
	var token = ["01083", "01085", "01087", "01089", "01091", "01093"]
	
	#Generate the player deck by using one of the premade elemental bases + random from type_destruction + random from type_boost_equip + ritual
	var picked_elemental_base = []
	randomize()
	var rand_base =  randi() %4
	match rand_base:
		0: picked_elemental_base = earth_base
		1: picked_elemental_base = fire_base
		2: picked_elemental_base = water_base
		3: picked_elemental_base = wind_base
	player_deck = picked_elemental_base
	
	#add the 2 extra cards
	var rand_type_destruction = randi() %list_of_type_destruction.size()
	player_deck.append(list_of_type_destruction[rand_type_destruction])
	var rand_type_equip = randi() %list_of_type_boost_equip.size()
	player_deck.append(list_of_type_boost_equip[rand_type_equip])
	
	#Get one random ritual from the available ones
	var random_tier = randf()
	var selected_tier : Array
	if random_tier <= 0.15:
		selected_tier = tier_3_ritual
	elif random_tier > 0.15 and random_tier <= 0.5:
		selected_tier = tier_2_ritual
	else:
		selected_tier = tier_1_ritual
	var rand_ritual = randi() %selected_tier.size()
	player_deck.append(selected_tier[rand_ritual])
	
	#Add one of Token Summoners
	var rand_token = randi() %token.size()
	player_deck.append(token[rand_token])
	
	#Complete the deck with random cards from the General Card Pool (MONSTERS ONLY)
	var general_card_pool : Array = CardList.general_card_pool
	fill_deck_with_cards(general_card_pool)
	
	#Register this deck as "Start" on 'list_of_player_decks'
	active_deck_name = "Elmnt"
	list_of_player_decks[active_deck_name] = {"deck":[], "color":Color(1,1,1,0.333)}
	list_of_player_decks[active_deck_name].deck = player_deck
	
	var starter_deck_color = Color(1,1,1,0.333)
	match picked_elemental_base:
		earth_base: starter_deck_color = Color(148/255.0, 85/255.0, 22/255.0, 1)
		fire_base:  starter_deck_color = Color(212/255.0, 54/255.0, 36/255.0, 1)
		water_base: starter_deck_color = Color(41/255.0, 127/255.0, 194/255.0, 1)
		wind_base:  starter_deck_color = Color(147/255.0, 237/255.0, 210/255.0, 1)
	list_of_player_decks[active_deck_name].color = starter_deck_color
	
	register_deck_on_trunk()
	return player_deck

func fill_deck_with_cards(general_card_pool):
	#Generate random card
	var rand_no = randi() %general_card_pool.size()
	
	#If it's not a Spell or Trap card and there are less than 3 copies of this card in the deck, add it to the deck
	if !(CardList.card_list[general_card_pool[rand_no]].attribute in ["spell", "trap"]) and player_deck.count(general_card_pool[rand_no]) < 3:
		player_deck.append(general_card_pool[rand_no])
	
	#If deck isn't completed yet, run this function again
	if player_deck.size() < 40:
		fill_deck_with_cards(general_card_pool)
	else:
		#print("Deck Size: " + String(player_deck.size()), "\n", player_deck)
		return player_deck

#---------------------------------------------------------------------------------------------------
func create_random_deck():
	#No restrictions, just 40 cards
	randomize()
	for _slot in range (0, 40):
		var rand_no = randi() %CardList.card_list.keys().size()
		var card_id = String(rand_no).pad_zeros(5)
		player_deck.append(card_id)
	
	register_deck_on_trunk()
	return player_deck

#---------------------------------------------------------------------------------------------------
func register_deck_on_trunk():
	for i in range(player_deck.size()):
		var card = player_deck[i]
		if card in player_trunk:
			player_trunk[card] += 1 #register another copy of the card to the already existing id key
		else: 
			player_trunk[card] = 1 #card is not in trunk, so add it's key:value pair as id:count
