extends VBoxContainer

var player_containers = {}
var high_score_spot_data = null
var high_score_spot_node = null

var game_over = false

func update_current_scoreboard_values():
	for score in Global.score_data:
		if Global.last_play_score > score[1]:
			high_score_spot_data = score
			print(high_score_spot_data)
			break
	
	#Global.score_data.resize(6)
	#Global.score_data.insert(Global.score_data.find(high_score_spot_data), ["aaa", Global.last_play_score])
	#Global.score_data.resize(5)
	#print(Global.score_data)
	
	var i = 0
	for child in get_children():
		if child.is_in_group("PlayerContainer"):
			# save nodes into player_containers variable
			player_containers[child] = [child.rank_label, child.name_label, child.score_label]
				
			# update scoreboard with score data
			#child.rank_label.text = Global.score_data[i][0]
			child.name_label.text = Global.score_data[i][0]
			child.score_label.text = str(Global.score_data[i][1])
			
			# flash current score row the player's updating
			if !game_over:
				if high_score_spot_data != null:
					if high_score_spot_data == Global.score_data[i]:
						print(Global.score_data[i])
						child.flash()
						child.score_label.text = str(Global.last_play_score)
						high_score_spot_node = child
				
			i += 1

func _updated_text(text_input):
	if high_score_spot_node != null:
		high_score_spot_node.update_text(text_input)
