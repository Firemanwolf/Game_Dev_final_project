if(player_score == win_condition){
	room_goto(rm_end);
	global.winner = "Player";
}else if(computer_score == win_condition){
	room_goto(rm_end);
	global.winner = "Computer";
}else if(computer_score == player_score && play_computer == win_condition){
	global.winner = "No one";
	room_goto(rm_end);
}