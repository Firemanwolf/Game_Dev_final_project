if (global.phase == global.phase_select){
	
	////raise the card to highlight it if it's in the hand and the mouse is over it
	//if (position_meeting(mouse_x, mouse_y, id)){
	//	target_y =544;
	//	//also set this variable so we know which card to play if there's a click
	//	global.selected_card = id;
	//	//global.second_selected_card = id;
	//}
	//else if (global.selected_card == id){
	//	target_y = 550;
	//	//global.selected_card = noone;
	//	global.second_selected_card = id;
	//}
	
	//in deal object check instance position mouse x & y object card will return id of card object
	// if no object it will return noone
	//if no global selected set global to anything under my mouse currently 
	//(code looks similar to above sorta)
	// if already selected and second selected is not set then set it 
	//card = instance_posiiton(mouse_x,mouse_y, obj_card)
	var card = instance_position(mouse_x, mouse_y, obj_card);
	if(card != noone){
		if(card.in_hand){
			if (global.selected_card == noone){
				global.selected_card = card;
			}else if (global.second_selected_card == noone){
				global.second_selected_card = card;
			}
		}
	}else{
		global.selected_card = noone;
		global.second_selected_card = noone;
		
	}

}