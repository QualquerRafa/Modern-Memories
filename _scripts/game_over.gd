extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	#Animate the transition when starting this scene
	$scene_transitioner.entering_this_scene()
	
	#Reload all "zeroed" stuff into playerdata
	reset_player_data_to_empty_status()
	
	$timer.start(9.5); yield($timer, "timeout")
	
	SoundControl.play_sound("lohweo_main_menu", "music")
	$scene_transitioner.scene_transition("main_menu")


func reset_player_data_to_empty_status():
	#Basically copy and paste the 'blank state' of PlayerData script
	
	#Player Variables that are stored within the save
	PlayerData.player_name = ""
	PlayerData.player_deck = []
	PlayerData.player_trunk = {}
	PlayerData.player_starchips = 0
	PlayerData.password_bought_cards = []
	PlayerData.recorded_duels = {}
	PlayerData.last_reward_cards = []
	
	PlayerData.recorded_dialogs = []

	PlayerData.game_loaded = false
	
	PlayerData.last_reward_cards = []
	PlayerData.scene_to_return_after_duel = ""
	PlayerData.going_to_duel = ""
	PlayerData.last_duel_result = ""
	
	PlayerData.tournament_last_progression_saved = ""
	PlayerData.tournament_competitors_saved = {"green" : [], "blue" : [], "purple" : [], "red" : [], "gold" : []}
	PlayerData.tournament_last_duelist_saved = ""
