if (global.phase == global.phase_select || global.phase == global.dissolve || global.phase == global.combine){

	if(mouse_check_button(mb_left)){
		audio_play_sound(snd_click,0,false);
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

}