/// @description Insert description here
// You can write your code in this editor

if(global.gameState == "combine"){
	
	if(!global.combine_happen){
		if(global.temp != noone){
		global.temp.target_y = 550;
		global.temp.in_hand = true;
		}
	
		if(global.second_selected_card != noone){
			global.second_selected_card.target_y = 550;
			global.second_selected_card.in_hand = true;
		}
	}
				
							
	global.temp = noone;
	global.selected_card = noone;
	global.second_selected_card = noone;
				
	global.made_first_choice = false;
	global.made_second_choice = false;
	
	//global.gameState = "play";
	global.gameState = "dissolve";
	global.phase = global.phase_select;


}else if (global.gameState == "dissolve"){
	
	if(!global.dissolve_happen){
		if(global.temp != noone){
		global.temp.target_y = 550;
		global.temp.in_hand = true;
		}
	
	}
	
	global.temp = noone;
	global.selected_card = noone;
	global.second_selected_card = noone;
				
	global.made_dissolve_choice = false;
	
	global.gameState = "play";
	global.phase = global.phase_select;
	
}