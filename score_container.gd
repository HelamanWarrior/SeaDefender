extends VBoxContainer

var player_containers = {}

func _ready():
	var high_score_spot = null
	for score in Global.score_data:
		if Global.highscore > score[2]:
			print(Global.highscore)
			high_score_spot = score
			print(high_score_spot)
			break
			
	var i = 0
	for child in get_children():
		if child.is_in_group("PlayerContainer"):
			# save nodes into player_containers variable
			player_containers[child] = [child.rank_label, child.name_label, child.score_label]
			
			# update scoreboard with score data
			child.rank_label.text = Global.score_data[i][0]
			child.name_label.text = Global.score_data[i][1]
			child.score_label.text = str(Global.score_data[i][2])
			
			if high_score_spot != null:
				if high_score_spot == Global.score_data[i]:
					child.flash()
					print(child)
			
			i += 1

func _updated_text(text_input):
	print(text_input)
