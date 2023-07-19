extends Node2D


func _ready():
	#Update the buttons visually
	var uppercase = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
	var lowercase = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
	var special = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "!", "?", "_", ".", "@"]
	
	var upper_grid = $alphabet_container_UPPER
	for i in range(upper_grid.get_child_count()):
		var button = upper_grid.get_child(i)
		button.get_node("player_name_visual").text = uppercase[i]
	
	var lower_grid = $alphabet_container_lower
	for i in range(lower_grid.get_child_count()):
		var button = lower_grid.get_child(i)
		button.get_node("player_name_visual").text = lowercase[i]
	
	var special_grid = $alphabet_container_special
	for i in range(special_grid.get_child_count()):
		var button = special_grid.get_child(i)
		button.get_node("player_name_visual").text = special[i]

