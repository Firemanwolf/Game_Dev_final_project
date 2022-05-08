	//STATE MACHINE
switch (global.phase){
	//deal out the cards, three per player
	case global.phase_deal:
		show_debug_message("in dealing");
		global.gameState = "deal";
		//show_debug_message("i am dealing");
		//move_timer kicks over to 0 every 16 frames
		if (move_timer == 0){
			if(ds_list_size(deck) > 0 || (ds_list_size(hand_player) == 3 && ds_list_size(hand_computer) == 3)){
				audio_play_sound(snd_flip,0,0);
			
				//first deal until the computer hand is full
				if (ds_list_size(hand_computer) < 3){
					var card = deck[| ds_list_size(deck)-1];
					ds_list_delete(deck,ds_list_size(deck)-1);
					ds_list_add(hand_computer,card);
				
					card.target_x = 120 + 200*ds_list_size(hand_computer);
					card.target_y = comp_hand_y;
				}
				//then deal until player hand is full
				else if (ds_list_size(hand_player) < 3){
					if(ds_list_size(deck)>0){
						var card = deck[| ds_list_size(deck)-1];
						ds_list_delete(deck,ds_list_size(deck)-1);
				
						card.target_x = 320 + 200*ds_list_size(hand_player);
						card.target_y = player_hand_y;
						card.in_hand=true;
				
						ds_list_add(hand_player,card);
					}
				}else {	//then flip the player cards up and change state
					for (i=0; i<3; i++){
						hand_player[| i].face_up = true;	
					}
					wait_timer=0;
					global.phase = global.phase_computer;	
				}
			}else{

				global.phase = global.phase_result;
				emptied_early = true;
			}
		}
		break;
	case global.phase_computer:
	global.gameState = "Computer Choice";
		//wait a few frames..
		wait_timer++;
		if (wait_timer == 40){
			if(hand_computer[|0].type != hand_computer[|1].type
				   &&(hand_computer[|1].type != hand_computer[|2].type)
				   &&(hand_computer[|0].type != hand_computer[|2].type)
				   && hand_computer[|0].rank == 1
				   && hand_computer[|1].rank == 1
				   && hand_computer[|2].rank == 1
				   && hand_computer[|0].type != global.virus
				   && hand_computer[|1].type != global.virus
				   && hand_computer[|2].type != global.virus)
			{
				play_computer = instance_create_depth(520,500,0,obj_card)
				play_computer.type = global.virus;
				play_computer.target_x = comp_select_x;
				play_computer.target_y = comp_select_y;
				play_computer.face_up = true;
				created_virus = true;
				instance_create_depth(anim_x, anim_y,-1, obj_animator);
				//sh
				audio_play_sound(snd_flip,0,0);
				wait_timer = 0;
				global.gameState = "play";
				global.phase = global.phase_select;
			}else {
				if(hand_computer[|0].type == hand_computer[|1].type && hand_computer[|1].type == hand_computer[|2].type){
					//computer_buffed = true;
				}
					//computer plays random card then change state
					var index = irandom_range(0,ds_list_size(hand_computer)-1);
					play_computer = hand_computer[| index];
					play_computer.target_x = comp_select_x;
					play_computer.target_y = comp_select_y;
					//ds_list_delete(hand_computer,index);
					audio_play_sound(snd_flip,0,0);
					wait_timer = 0;
					global.gameState = "combine";
					global.phase = global.phase_select;
			}
		}
	
	
		break;
	
	case global.phase_select:
	//global.gameState = "combine"
	//this needs to go into a different case for being able to handle combination or dissolving
		if(!started){
			if(hand_player[|0].type == hand_player[|1].type && hand_player[|1].type == hand_player[|2].type){
				//buffed = true;
				started = true;
			}else if(hand_player[|0].type != hand_player[|1].type
				   &&(hand_player[|1].type != hand_player[|2].type)
				   &&(hand_player[|0].type != hand_player[|2].type)
				   && hand_player[|0].rank == 1
				   && hand_player[|1].rank == 1
				   && hand_player[|2].rank == 1
				   && hand_player[|0].type != global.virus
				   && hand_player[|1].type != global.virus
				   && hand_player[|2].type != global.virus)
			{
				play_player = instance_create_depth(320,386,0,obj_card)
				play_player.type = global.virus;
				play_player.target_x = player_select_x;
				//play_player.target_y = 386;
				play_player.target_y = player_select_y;
				play_player.face_up = true;
				play_player.in_hand = true;
				var card = play_player;
				instance_destroy(hand_player[|0])
				instance_destroy(hand_player[|1])
				instance_destroy(hand_player[|2])
				ds_list_clear(hand_player);
				ds_list_add(hand_player, card);
				
				instance_create_depth(anim_x, anim_y,-1, obj_animator);
				audio_play_sound(snd_flip,0,0);
				//global.phase = global.phase_play;
				deck_size -= 2;
				wait_timer = 0;
				started = true;
				global.gameState = "play";
				global.phase = global.phase_select;
				
			}
			started = true;
			
		}
		
		if(global.gameState == "play"){
			//global.stateMeter.stateIndicator.x = global.stateMeter.x + 760;
			//show_debug_message("in play");
			var under = instance_position(mouse_x, mouse_y, obj_card);
			for(var i = 0; i < ds_list_size(hand_player); i++){
				if (hand_player[|i] != global.selected_card){
					hand_player[|i].target_y = player_hand_y;
				}
			}
			if(under != noone && under != global.selected_card){
				if(under.in_hand == true){
					under.target_y = player_hover
				}
			}
			if(mouse_check_button_released(mb_left)){
				if(global.selected_card == noone){
					global.selected_card = under;
				}else{
					global.second_selected_card = under
				}
			}
				
			//if (mouse_check_button_pressed(mb_left)){
				//this selected_card variable is set by the card itself
				//global.selected_card = instance_position(mouse_x, mouse_y, obj_card);
				//show_debug_message(global.selected_card);
				if (global.selected_card != noone){
					//play the card
					var hand_index = ds_list_find_index(hand_player, global.selected_card);
					play_player = hand_player[| hand_index];
					play_player.target_x = player_select_x;
					play_player.target_y = player_select_y;
					play_player.in_hand = false;
					//if(buffed){
					//	play_player.rank = 3;
					//	buffed = false;
					//}
					//ds_list_delete(hand_player,hand_index);
					audio_play_sound(snd_flip,0,0);
					started = false;
					global.phase = global.phase_play;
					global.selected_card = noone;
					wait_timer = 0;
				
				}
			//}
		}else if (global.gameState == "combine"){
			//show_debug_message("in combine");
			//show_debug_message(ds_list_size(discard_pile));
			//global.stateMeter.stateIndicator.x = global.stateMeter.x + 150;
			var under = instance_position(mouse_x, mouse_y, obj_card);
			for(var i = 0; i < 3; i++){
				if (hand_player[|i] != global.selected_card && hand_player[|i] != global.second_selected_card){
					hand_player[|i].target_y = player_hand_y;
				}
			}
			if(under != noone && under != global.selected_card && under != global.second_selected_card){
				if(under.in_hand == true){
					under.target_y = player_hover;
				}
			}
			if(mouse_check_button_released(mb_left)){
				if(global.selected_card == noone){
					global.selected_card = under;
				}else if (global.selected_card != under) {
					global.second_selected_card = under
				}
			}
				
			
			if (!global.made_first_choice){
				if (global.selected_card != noone){
					//show_debug_message("made first choice");
					//show_debug_message(global.selected_card);
					//play the card
					var hand_index = ds_list_find_index(hand_player, global.selected_card);
					play_player = hand_player[| hand_index];
					//play_player.target_x = 320;
					play_player.target_y = player_select_y;
					play_player.in_hand = false;
					global.first_choice = play_player;
					global.made_first_choice = true;
					global.temp = global.selected_card;
				}
				//global.selected_card = noone;
				wait_timer = 0;
			}
			//show_debug_message(global.temp);
			//show_debug_message(global.second_selected_card);
			if (!global.made_second_choice){
				if (global.selected_card != noone && (global.temp != global.second_selected_card) && global.second_selected_card != noone){
					//show_debug_message("made second choice");
					//show_debug_message(global.second_selected_card);
					//play the card
					var hand_index = ds_list_find_index(hand_player, global.second_selected_card);
					play_player = hand_player[| hand_index];
					//play_player.target_x = 320;
					play_player.target_y = player_select_y;
					play_player.in_hand = false;
					global.second_choice = play_player;
					global.made_second_choice = true;
				}
				wait_timer = 0;
			}
			
			if(global.selected_card != noone && global.second_selected_card != noone){

				global.phase = global.combine;
			}
			
		}else if (global.gameState == "dissolve"){
			//global.stateMeter.stateIndicator.x = global.stateMeter.x + 440 ;
			var under = instance_position(mouse_x, mouse_y, obj_card);
			for(var i = 0; i < ds_list_size(hand_player); i++){
				if (hand_player[|i] != global.selected_card){
					hand_player[|i].target_y = player_hand_y;
				}
			}
			if(under != noone && under != global.selected_card){
				if(under.in_hand == true){
					under.target_y = player_hover
				}
			}
			if(mouse_check_button_released(mb_left)){
				if(global.selected_card == noone){
					global.selected_card = under;
				}else{
					global.second_selected_card = under
				}
			}
				
			
			if (!global.made_dissolve_choice){
				if (global.selected_card != noone){
					//play the card
					var hand_index = ds_list_find_index(hand_player, global.selected_card);
					play_player = hand_player[| hand_index];
					//play_player.target_x = 320;
					play_player.target_y = player_select_y;
					play_player.in_hand = false;
					global.first_choice = play_player;
					global.made_dissolve_choice = true;
					global.temp = global.selected_card;
					show_debug_message(global.temp);
				}
				
			if(global.temp != noone){
				global.phase = global.dissolve;
			}
				wait_timer = 0;
			}
			
		}
		break;
		
	case global.combine:
		//show_debug_message("combine");
		//show_debug_message(global.temp)
		//show_debug_message(global.second_selected_card);
		var card = noone;
		//var second_card = noone;
		if (!global.combine_happen){
			if (global.selected_card.type == global.rock && global.second_selected_card.type == global.rock){
				//show_debug_message(ds_list_size(hand_player));
				card = instance_create_depth(320,240,0,obj_card)
				instance_create_depth(anim_x,anim_y,0,obj_animator)
				card.type = global.rock2;
				card.rank = 2;
				
				var hand_index = ds_list_find_index(hand_player, global.selected_card);
				var card1 = hand_player[| hand_index];
				
				var second_index = ds_list_find_index(hand_player, global.second_selected_card);
				var card2 = hand_player[| second_index];
			
				
				card.target_x = card1.target_x;
				card.target_y = player_hand_y;
				card.face_up = true;
				card.in_hand = true;
				

				ds_list_replace(hand_player, hand_index,card);
				ds_list_delete(hand_player,second_index);

				instance_destroy(card1);
				instance_destroy(card2);
				deck_size -= 1;
				global.combine_happen = true;
			
				//global.phase = global.phase_play;
			}else if (global.selected_card.type == global.rock && global.second_selected_card.type == global.rock2 || (global.selected_card.type == global.rock2 && global.second_selected_card.type == global.rock )){
				//show_debug_message(ds_list_size(hand_player));
				card = instance_create_depth(320,240,0,obj_card)
				instance_create_depth(anim_x,anim_y,0,obj_animator)
				card.type = global.rock3;
				card.rank = 3;
				
				var hand_index = ds_list_find_index(hand_player, global.selected_card);
				var card1 = hand_player[| hand_index];
				
				var second_index = ds_list_find_index(hand_player, global.second_selected_card);
				var card2 = hand_player[| second_index];
			
				
				card.target_x = card1.target_x;
				card.target_y = player_hand_y;
				card.face_up = true;
				card.in_hand = true;
				

				ds_list_replace(hand_player, hand_index,card);
				ds_list_delete(hand_player,second_index);

				instance_destroy(card1);
				instance_destroy(card2);
				deck_size -= 1;
				global.combine_happen = true;
			
			
			}else if (global.selected_card.type == global.virus && global.second_selected_card.type == global.rock2 || (global.selected_card.type == global.rock2 && global.second_selected_card.type == global.virus)){
				//show_debug_message(ds_list_size(hand_player));
				card = instance_create_depth(320,240,0,obj_card)
				instance_create_depth(anim_x,anim_y,0,obj_animator)
				card.type = global.rock4;
				card.rank = 4;
				
				var hand_index = ds_list_find_index(hand_player, global.selected_card);
				var card1 = hand_player[| hand_index];
				
				var second_index = ds_list_find_index(hand_player, global.second_selected_card);
				var card2 = hand_player[| second_index];
			
				
				card.target_x = card1.target_x;
				card.target_y = player_hand_y;
				card.face_up = true;
				card.in_hand = true;
				

				ds_list_replace(hand_player, hand_index,card);
				ds_list_delete(hand_player,second_index);

				instance_destroy(card1);
				instance_destroy(card2);
				deck_size -= 1;
				global.combine_happen = true;
			
			
			}else if (global.selected_card.type == global.virus && global.second_selected_card.type == global.rock3 || (global.selected_card.type == global.rock3 && global.second_selected_card.type == global.virus)){
				//show_debug_message(ds_list_size(hand_player));
				card = instance_create_depth(320,240,0,obj_card)
				instance_create_depth(anim_x,anim_y,0,obj_animator)
				card.type = global.rock9;
				card.rank = 9;
				
				var hand_index = ds_list_find_index(hand_player, global.selected_card);
				var card1 = hand_player[| hand_index];
				
				var second_index = ds_list_find_index(hand_player, global.second_selected_card);
				var card2 = hand_player[| second_index];
			
				
				card.target_x = card1.target_x;
				card.target_y = player_hand_y;
				card.face_up = true;
				card.in_hand = true;
				

				ds_list_replace(hand_player, hand_index,card);
				ds_list_delete(hand_player,second_index);

				instance_destroy(card1);
				instance_destroy(card2);
				deck_size -= 1;
				global.combine_happen = true;
			
			
			}else if (global.selected_card.type == global.paper && global.second_selected_card.type == global.paper){
				//show_debug_message(ds_list_size(hand_player));
				card = instance_create_depth(320,240,0,obj_card)
				instance_create_depth(anim_x,anim_y,0,obj_animator)
				card.type = global.paper2;
				card.rank = 2;
				var hand_index = ds_list_find_index(hand_player, global.selected_card);
				var card1 = hand_player[| hand_index];
				
				var second_index = ds_list_find_index(hand_player, global.second_selected_card);
				var card2 = hand_player[| second_index];
			
				
				card.target_x = card1.target_x;
				//card.target_y = card1.target_y;
				card.target_y = player_hand_y;
				card.face_up = true;
			
				card.in_hand = true;
				//second_card.in_hand = true;

				ds_list_replace(hand_player, hand_index,card);
				ds_list_delete(hand_player,second_index);

				instance_destroy(card1);
				instance_destroy(card2);
				deck_size -= 1;
				global.combine_happen = true;
			
			
				//global.phase = global.phase_play;
			} else if (global.selected_card.type == global.paper && global.second_selected_card.type == global.paper2 || (global.selected_card.type == global.paper2 && global.second_selected_card.type == global.paper )){
				//show_debug_message(ds_list_size(hand_player));
				card = instance_create_depth(320,240,0,obj_card)
				instance_create_depth(anim_x,anim_y,0,obj_animator)
				card.type = global.paper3;
				card.rank = 3;
				var hand_index = ds_list_find_index(hand_player, global.selected_card);
				var card1 = hand_player[| hand_index];
				
				var second_index = ds_list_find_index(hand_player, global.second_selected_card);
				var card2 = hand_player[| second_index];
			
				
				card.target_x = card1.target_x;
				//card.target_y = card1.target_y;
				card.target_y = player_hand_y;
				card.face_up = true;
			
				card.in_hand = true;
				//second_card.in_hand = true;

				ds_list_replace(hand_player, hand_index,card);
				ds_list_delete(hand_player,second_index);

				instance_destroy(card1);
				instance_destroy(card2);
				deck_size -= 1;
				global.combine_happen = true;
			
			
				//global.phase = global.phase_play;
			}else if (global.selected_card.type == global.virus && global.second_selected_card.type == global.paper2 || (global.selected_card.type == global.paper2 && global.second_selected_card.type == global.virus)){
				//show_debug_message(ds_list_size(hand_player));
				card = instance_create_depth(320,240,0,obj_card)
				instance_create_depth(anim_x,anim_y,0,obj_animator)
				card.type = global.paper4;
				card.rank = 4;
				
				var hand_index = ds_list_find_index(hand_player, global.selected_card);
				var card1 = hand_player[| hand_index];
				
				var second_index = ds_list_find_index(hand_player, global.second_selected_card);
				var card2 = hand_player[| second_index];
			
				
				card.target_x = card1.target_x;
				card.target_y = player_hand_y;
				card.face_up = true;
				card.in_hand = true;
				

				ds_list_replace(hand_player, hand_index,card);
				ds_list_delete(hand_player,second_index);

				instance_destroy(card1);
				instance_destroy(card2);
				deck_size -= 1;
				global.combine_happen = true;
			
			
			}else if (global.selected_card.type == global.virus && global.second_selected_card.type == global.paper3 || (global.selected_card.type == global.paper3 && global.second_selected_card.type == global.virus)){
				//show_debug_message(ds_list_size(hand_player));
				card = instance_create_depth(320,240,0,obj_card)
				instance_create_depth(anim_x,anim_y,0,obj_animator)
				card.type = global.paper9;
				card.rank = 9;
				
				var hand_index = ds_list_find_index(hand_player, global.selected_card);
				var card1 = hand_player[| hand_index];
				
				var second_index = ds_list_find_index(hand_player, global.second_selected_card);
				var card2 = hand_player[| second_index];
			
				
				card.target_x = card1.target_x;
				card.target_y = player_hand_y;
				card.face_up = true;
				card.in_hand = true;
				

				ds_list_replace(hand_player, hand_index,card);
				ds_list_delete(hand_player,second_index);

				instance_destroy(card1);
				instance_destroy(card2);
				deck_size -= 1;
				global.combine_happen = true;
			
			
			}else if (global.selected_card.type == global.scissors && global.second_selected_card.type == global.scissors){
				//show_debug_message(ds_list_size(hand_player));
				card = instance_create_depth(320,240,0,obj_card)
				instance_create_depth(anim_x,anim_y,0,obj_animator)
				card.type = global.scissors2;
				card.rank = 2;
				var hand_index = ds_list_find_index(hand_player, global.selected_card);
				var card1 = hand_player[| hand_index];
				
				
				var second_index = ds_list_find_index(hand_player, global.second_selected_card);
				var card2 = hand_player[| second_index];

				
				card.target_x = card1.target_x;
				//card.target_y = card1.target_y;
				card.target_y = player_hand_y;
				card.face_up = true;
			
				card.in_hand = true;


				ds_list_replace(hand_player, hand_index,card);
				ds_list_delete(hand_player,second_index);

				instance_destroy(card1);
				instance_destroy(card2);
				deck_size -= 1;
				global.combine_happen = true;
			}else if (global.selected_card.type == global.scissors && global.second_selected_card.type == global.scissors2 || (global.selected_card.type == global.scissors2 && global.second_selected_card.type == global.scissors)){
				//show_debug_message(ds_list_size(hand_player));
				card = instance_create_depth(320,240,0,obj_card)
				instance_create_depth(anim_x,anim_y,0,obj_animator)
				card.type = global.scissors3;
				card.rank = 3;
				var hand_index = ds_list_find_index(hand_player, global.selected_card);
				var card1 = hand_player[| hand_index];
				
				
				var second_index = ds_list_find_index(hand_player, global.second_selected_card);
				var card2 = hand_player[| second_index];

				
				card.target_x = card1.target_x;
				//card.target_y = card1.target_y;
				card.target_y = player_hand_y;
				card.face_up = true;
			
				card.in_hand = true;


				ds_list_replace(hand_player, hand_index,card);
				ds_list_delete(hand_player,second_index);

				instance_destroy(card1);
				instance_destroy(card2);
				deck_size -= 1;
				global.combine_happen = true;
			}else if (global.selected_card.type == global.virus && global.second_selected_card.type == global.scissors2 || (global.selected_card.type == global.scissors2 && global.second_selected_card.type == global.virus)){
				//show_debug_message(ds_list_size(hand_player));
				card = instance_create_depth(anim_x,anim_y,0,obj_card)
				instance_create_depth(320,240,0,obj_animator)
				card.type = global.scissors4;
				card.rank = 4;
				
				var hand_index = ds_list_find_index(hand_player, global.selected_card);
				var card1 = hand_player[| hand_index];
				
				var second_index = ds_list_find_index(hand_player, global.second_selected_card);
				var card2 = hand_player[| second_index];
			
				
				card.target_x = card1.target_x;
				card.target_y = player_hand_y;
				card.face_up = true;
				card.in_hand = true;
				

				ds_list_replace(hand_player, hand_index,card);
				ds_list_delete(hand_player,second_index);

				instance_destroy(card1);
				instance_destroy(card2);
				deck_size -= 1;
				global.combine_happen = true;
			
			
			}else if (global.selected_card.type == global.virus && global.second_selected_card.type == global.scissors3 || (global.selected_card.type == global.scissors3 && global.second_selected_card.type == global.virus)){
				//show_debug_message(ds_list_size(hand_player));
				card = instance_create_depth(anim_x,anim_y,0,obj_card)
				instance_create_depth(320,240,0,obj_animator)
				card.type = global.scissors9;
				card.rank = 9;
				
				var hand_index = ds_list_find_index(hand_player, global.selected_card);
				var card1 = hand_player[| hand_index];
				
				var second_index = ds_list_find_index(hand_player, global.second_selected_card);
				var card2 = hand_player[| second_index];
			
				
				card.target_x = card1.target_x;
				card.target_y = player_hand_y;
				card.face_up = true;
				card.in_hand = true;
				

				ds_list_replace(hand_player, hand_index,card);
				ds_list_delete(hand_player,second_index);

				instance_destroy(card1);
				instance_destroy(card2);
				deck_size -= 1;
				global.combine_happen = true;
			
			
			}else{
				global.selected_card.target_y = player_hand_y;
				global.second_selected_card.target_y = player_hand_y;

				global.selected_card.in_hand = true;
				global.second_selected_card.in_hand = true;
				
				
				
				global.temp = noone;
				global.selected_card = noone;
				global.second_selected_card = noone;
				
				global.made_first_choice = false;
				global.made_second_choice = false;
				global.phase = global.phase_select;
			}
		}
	
	
	break;
	
	case global.dissolve:
		var card = noone;
		var card2 = noone;
		var card3 = noone;
		if(!global.dissolve_happen){
			if(global.temp.type == global.rock2){
				card = instance_create_depth(320,240,0,obj_card)
				instance_create_depth(anim_x,anim_y,0,obj_animator)
				card.type = global.rock;
				
				
				var hand_index = ds_list_find_index(hand_player, global.temp);
				
				var card1 = hand_player[| hand_index];
			
				card.target_x = card1.target_x;
				//card.target_y = card1.target_y;
				card.target_y = player_hand_y;
				card.face_up = true;
				card.in_hand = true;

				ds_list_replace(hand_player, hand_index,card);

				instance_destroy(card1);
				
				//show_debug_message(ds_list_size(discard_pile));
				card2 = instance_create_depth(320,240,0,obj_card)
				card2.type = global.rock;
				ds_list_add(discard_pile, card2);
				card2.target_y = discard_y - ds_list_size(discard_pile)*2;
				card2.target_x = discard_x;
				card2.face_up = true;
				card2.targetdepth = deck_size-ds_list_size(discard_pile);
				//show_debug_message(ds_list_size(discard_pile));
				deck_size += 1;
				
				global.dissolve_happen = true;
				
				
			}else if(global.temp.type == global.rock3){
				card = instance_create_depth(320,240,0,obj_card)
				instance_create_depth(anim_x,anim_y,0,obj_animator)
				card.type = global.rock;
				
				
				var hand_index = ds_list_find_index(hand_player, global.temp);
				
				var card1 = hand_player[| hand_index];
			
				card.target_x = card1.target_x;
				//card.target_y = card1.target_y;
				card.target_y = player_hand_y;
				card.face_up = true;
				card.in_hand = true;

				ds_list_replace(hand_player, hand_index,card);

				instance_destroy(card1);
				

				card2 = instance_create_depth(320,240,0,obj_card)
				card2.type = global.rock;
				ds_list_add(discard_pile, card2);
				card2.target_y = discard_y - ds_list_size(discard_pile)*2;
				card2.target_x = discard_x;
				card2.face_up = true;
				card2.targetdepth = deck_size-ds_list_size(discard_pile);
				
				card3 = instance_create_depth(320,240,0,obj_card)
				card3.type = global.rock;
				ds_list_add(discard_pile, card3);
				card3.target_y = discard_y - ds_list_size(discard_pile)*2;
				card3.target_x = discard_x;
				card3.face_up = true;
				card3.targetdepth = deck_size-ds_list_size(discard_pile);
				
				
				deck_size += 2;
				
				global.dissolve_happen = true;
				
				
			}else if(global.temp.type == global.rock4){
				card = instance_create_depth(320,240,0,obj_card)
				instance_create_depth(anim_x,anim_y,0,obj_animator)
				card.type = global.rock2;
				card.rank = 2;
				
				
				var hand_index = ds_list_find_index(hand_player, global.temp);
				show_debug_message(hand_index);
				
				var card1 = hand_player[| hand_index];
			
				card.target_x = card1.target_x;
				//card.target_y = card1.target_y;
				card.target_y = player_hand_y;
				card.face_up = true;
				card.in_hand = true;

				ds_list_replace(hand_player, hand_index,card);

				instance_destroy(card1);
				

				card2 = instance_create_depth(320,240,0,obj_card)
				card2.type = global.virus;
				card2.rank = 1;
				ds_list_add(discard_pile, card2);
				card2.target_y = discard_y - ds_list_size(discard_pile)*2;
				card2.target_x = discard_x;
				card2.face_up = true;
				card2.targetdepth = deck_size-ds_list_size(discard_pile);
		
				
				deck_size += 1;
				
				global.dissolve_happen = true;
				
				
			}else if(global.temp.type == global.rock9){
				card = instance_create_depth(320,240,0,obj_card)
				instance_create_depth(anim_x,anim_y,0,obj_animator)
				card.type = global.rock3;
				card.rank = 3
				
				
				var hand_index = ds_list_find_index(hand_player, global.temp);
				show_debug_message(hand_index);
				
				var card1 = hand_player[| hand_index];
			
				card.target_x = card1.target_x;
				//card.target_y = card1.target_y;
				card.target_y = player_hand_y;
				card.face_up = true;
				card.in_hand = true;

				ds_list_replace(hand_player, hand_index,card);

				instance_destroy(card1);
				

				card2 = instance_create_depth(320,240,0,obj_card)
				card2.type = global.virus;
				card2.rank = 1
				ds_list_add(discard_pile, card2);
				card2.target_y = discard_y - ds_list_size(discard_pile)*2;
				card2.target_x = discard_x;
				card2.face_up = true;
				card2.targetdepth = deck_size-ds_list_size(discard_pile);
				
				
				deck_size += 1;
				
				global.dissolve_happen = true;
				
				
			}else if (global.temp.type == global.scissors2){
				card = instance_create_depth(320,240,0,obj_card)
				instance_create_depth(anim_x,anim_y,0,obj_animator)
				card.type = global.scissors;
				
				
				var hand_index = ds_list_find_index(hand_player, global.temp);
				show_debug_message(hand_index);
				
				var card1 = hand_player[| hand_index];
			
				card.target_x = card1.target_x;
				//card.target_y = card1.target_y;
				card.target_y = player_hand_y;
				card.face_up = true;
				card.in_hand = true;

				ds_list_replace(hand_player, hand_index,card);

				instance_destroy(card1);
							
				//show_debug_message(ds_list_size(discard_pile));
				card2 = instance_create_depth(320,240,0,obj_card)
				card2.type = global.scissors;
				ds_list_add(discard_pile, card2);
				card2.target_y = discard_y - ds_list_size(discard_pile)*2;
				card2.target_x = discard_x;
				card2.face_up = true;
				card2.targetdepth = deck_size-ds_list_size(discard_pile);
				//show_debug_message(ds_list_size(discard_pile));
				deck_size += 1;
				
				global.dissolve_happen = true;
				

			}else if (global.temp.type == global.scissors3){
				card = instance_create_depth(320,240,0,obj_card)
				instance_create_depth(anim_x,anim_y,0,obj_animator)
				card.type = global.scissors;
				
				
				var hand_index = ds_list_find_index(hand_player, global.temp);
				show_debug_message(hand_index);
				
				var card1 = hand_player[| hand_index];
			
				card.target_x = card1.target_x;
				//card.target_y = card1.target_y;
				card.target_y = player_hand_y;
				card.face_up = true;
				card.in_hand = true;

				ds_list_replace(hand_player, hand_index,card);

				instance_destroy(card1);
							
				card2 = instance_create_depth(320,240,0,obj_card)
				card2.type = global.scissors;
				ds_list_add(discard_pile, card2);
				card2.target_y = discard_y - ds_list_size(discard_pile)*2;
				card2.target_x = discard_x;
				card2.face_up = true;
				card2.targetdepth = deck_size-ds_list_size(discard_pile);
				
				card3 = instance_create_depth(320,240,0,obj_card)
				card3.type = global.scissors;
				ds_list_add(discard_pile, card3);
				card3.target_y = discard_y - ds_list_size(discard_pile)*2;
				card3.target_x = discard_x;
				card3.face_up = true;
				card3.targetdepth = deck_size-ds_list_size(discard_pile);
				

				deck_size += 2;
				
				global.dissolve_happen = true;
				

			}else if(global.temp.type == global.scissors4){
				card = instance_create_depth(320,240,0,obj_card)
				instance_create_depth(anim_x,anim_y,0,obj_animator)
				card.type = global.scissors2;
				card.rank = 2;
				
				
				var hand_index = ds_list_find_index(hand_player, global.temp);
				show_debug_message(hand_index);
				
				var card1 = hand_player[| hand_index];
			
				card.target_x = card1.target_x;
				//card.target_y = card1.target_y;
				card.target_y = player_hand_y;
				card.face_up = true;
				card.in_hand = true;

				ds_list_replace(hand_player, hand_index,card);

				instance_destroy(card1);
				

				card2 = instance_create_depth(320,240,0,obj_card)
				card2.type = global.virus;
				card2.rank = 1
				ds_list_add(discard_pile, card2);
				card2.target_y = discard_y - ds_list_size(discard_pile)*2;
				card2.target_x = discard_x;
				card2.face_up = true;
				card2.targetdepth = deck_size-ds_list_size(discard_pile);
		
				
				deck_size += 1;
				
				global.dissolve_happen = true;
				
				
			}else if(global.temp.type == global.scissors9){
				card = instance_create_depth(320,240,0,obj_card)
				instance_create_depth(anim_x,anim_y,0,obj_animator)
				card.type = global.scissors3;
				card.rank = 3
				
				
				var hand_index = ds_list_find_index(hand_player, global.temp);
				show_debug_message(hand_index);
				
				var card1 = hand_player[| hand_index];
			
				card.target_x = card1.target_x;
				//card.target_y = card1.target_y;
				card.target_y = player_hand_y;
				card.face_up = true;
				card.in_hand = true;

				ds_list_replace(hand_player, hand_index,card);

				instance_destroy(card1);
				

				card2 = instance_create_depth(320,240,0,obj_card)
				card2.type = global.virus;
				card2.rank = 1;
				ds_list_add(discard_pile, card2);
				card2.target_y = discard_y - ds_list_size(discard_pile)*2;
				card2.target_x = discard_x;
				card2.face_up = true;
				card2.targetdepth = deck_size-ds_list_size(discard_pile);
				
				
				deck_size += 1;
				
				global.dissolve_happen = true;
				
				
			}else if (global.temp.type == global.paper2){
				card = instance_create_depth(320,240,0,obj_card)
				instance_create_depth(anim_x,anim_y,0,obj_animator)
				card.type = global.paper;
				
				
				var hand_index = ds_list_find_index(hand_player, global.temp);
				show_debug_message(hand_index);
				
				var card1 = hand_player[| hand_index];
			
				card.target_x = card1.target_x;
				//card.target_y = card1.target_y;
				card.target_y = player_hand_y;
				card.face_up = true;
				card.in_hand = true;

				ds_list_replace(hand_player, hand_index,card);

				instance_destroy(card1);
				
								
				//show_debug_message(ds_list_size(discard_pile));
				card2 = instance_create_depth(320,240,0,obj_card)
				card2.type = global.paper;
				ds_list_add(discard_pile, card2);
				card2.target_y = discard_y - ds_list_size(discard_pile)*2;
				card2.target_x = discard_x;
				card2.face_up = true;
				card2.targetdepth = deck_size-ds_list_size(discard_pile);
				//show_debug_message(ds_list_size(discard_pile));
				deck_size += 1;
				
				global.dissolve_happen = true;
				
			}else if (global.temp.type == global.paper3){
				card = instance_create_depth(320,240,0,obj_card)
				instance_create_depth(anim_x,anim_y,0,obj_animator)
				card.type = global.paper;
				
				
				var hand_index = ds_list_find_index(hand_player, global.temp);
				show_debug_message(hand_index);
				
				var card1 = hand_player[| hand_index];
			
				card.target_x = card1.target_x;
				//card.target_y = card1.target_y;
				card.target_y = player_hand_y;
				card.face_up = true;
				card.in_hand = true;

				ds_list_replace(hand_player, hand_index,card);

				instance_destroy(card1);
				
								

				card2 = instance_create_depth(320,240,0,obj_card)
				card2.type = global.paper;
				ds_list_add(discard_pile, card2);
				card2.target_y = discard_y - ds_list_size(discard_pile)*2;
				card2.target_x = discard_x;
				card2.face_up = true;
				card2.targetdepth = deck_size-ds_list_size(discard_pile);

				
				
				
				
				deck_size += 2;
				
				global.dissolve_happen = true;
				
			}else if(global.temp.type == global.paper4){
				card = instance_create_depth(anim_x,anim_y,0,obj_card)
				card.type = global.paper2;
				card.rank = 2;
				
				var hand_index = ds_list_find_index(hand_player, global.temp);
				show_debug_message(hand_index);
				
				var card1 = hand_player[| hand_index];
			
				card.target_x = card1.target_x;
				//card.target_y = card1.target_y;
				card.target_y = player_hand_y;
				card.face_up = true;
				card.in_hand = true;

				ds_list_replace(hand_player, hand_index,card);

				instance_destroy(card1);
				

				card2 = instance_create_depth(320,240,0,obj_card)
				card2.type = global.virus;
				card2.rank = 1;
				ds_list_add(discard_pile, card2);
				card2.target_y = discard_y - ds_list_size(discard_pile)*2;
				card2.target_x = discard_x;
				card2.face_up = true;
				card2.targetdepth = deck_size-ds_list_size(discard_pile);
		
				
				deck_size += 1;
				
				global.dissolve_happen = true;
				
				
			}else if(global.temp.type == global.paper9){
				card = instance_create_depth(320,240,0,obj_card)
				card.type = global.paper3;
				card.rank = 3;
				
				
				var hand_index = ds_list_find_index(hand_player, global.temp);
				show_debug_message(hand_index);
				
				var card1 = hand_player[| hand_index];
			
				card.target_x = card1.target_x;
				//card.target_y = card1.target_y;
				card.target_y = player_hand_y;
				card.face_up = true;
				card.in_hand = true;

				ds_list_replace(hand_player, hand_index,card);

				instance_destroy(card1);
				

				card2 = instance_create_depth(320,240,0,obj_card)
				card2.type = global.virus;
				card2.rank = 1;
				ds_list_add(discard_pile, card2);
				card2.target_y = discard_y - ds_list_size(discard_pile)*2;
				card2.target_x = discard_x;
				card2.face_up = true;
				card2.targetdepth = deck_size-ds_list_size(discard_pile);
				
				
				deck_size += 1;
				
				global.dissolve_happen = true;
				
			}else if(global.temp.type == global.virus){
				var temp_type = [global.paper, global.rock, global.scissors];
				randomize();
				var index = irandom(array_length(temp_type)-1);
				card = instance_create_depth(320,240,0,obj_card)
				card.type = temp_type[index];
				card.rank = 1;
				array_delete(temp_type,index,1);
				
				
				var hand_index = ds_list_find_index(hand_player, global.temp);
				
				var card1 = hand_player[| hand_index];
			
				card.target_x = card1.target_x;
				//card.target_y = card1.target_y;
				card.target_y = player_hand_y;
				card.face_up = true;
				card.in_hand = true;

				ds_list_replace(hand_player, hand_index,card);

				instance_destroy(card1);
				

				card2 = instance_create_depth(320,240,0,obj_card)
				index = irandom(array_length(temp_type)-1);
				card2.type = temp_type[index];
				card2.rank = 1;
				array_delete(temp_type,index,1);
				ds_list_add(discard_pile, card2);
				card2.target_y = discard_y - ds_list_size(discard_pile)*2;
				card2.target_x = discard_x;
				card2.face_up = true;
				card2.targetdepth = deck_size-ds_list_size(discard_pile);
				
				card3 = instance_create_depth(320,240,0,obj_card)
				index = irandom(array_length(temp_type)-1);
				card3.type = temp_type[index];
				card3.rank = 1;
				array_delete(temp_type,index,1);
				ds_list_add(discard_pile, card3);
				card3.target_y = discard_y - ds_list_size(discard_pile)*2;
				card3.target_x = discard_x;
				card3.face_up = true;
				card3.targetdepth = deck_size-ds_list_size(discard_pile);
				
				
				deck_size += 2;
				
				global.dissolve_happen = true;
			
			}else{
				//if(!moved){
					global.temp.target_y = player_hand_y;
					global.temp.in_hand = true;
				
								
					global.temp = noone;
					global.selected_card = noone;
					global.second_selected_card = noone;
				
					global.made_dissolve_choice = false;
					global.dissolve_happen = false;
				
					global.phase = global.phase_select;
					moved = true;
			}
		}
		
	
	break;
		
	//resolve the winner or loser after a delay	
	case global.phase_play:
	
	global.gameState = "result";
	//global.temp = noone;
	////global.first_choice = noone;
	////global.second_choice = noone;
	//global.made_first_choice = false;
	//global.made_second_choice = false;
	//global.selected_card = noone;
	//global.second_selected_card = noone;
	
	//global.selected_card = noone;
		wait_timer++;
		if (wait_timer > 100){
			play_computer.face_up = true;
			global.phase = global.phase_result;
			if(play_computer.type != play_player.type){
				if (play_computer.type == global.virus){
					global.phase = global.phase_computer_choice;
					audio_play_sound(snd_lose,0,0);
				}else if (play_player.type == global.virus){
					global.phase = global.phase_player_choice;
					audio_play_sound(snd_win,0,0);
				}else if (play_computer.type == global.paper || play_computer.type == global.paper2|| play_computer.type == global.paper3|| play_computer.type == global.paper4|| play_computer.type == global.paper9){
					if (play_player.type == global.rock || play_player.type == global.rock2|| play_player.type == global.rock3|| play_player.type == global.rock4|| play_player.type == global.rock9){
						global.phase = global.phase_computer_choice;
						audio_play_sound(snd_lose,0,0);
					}
					else if (play_player.type == global.scissors || play_player.type == global.scissors2 || play_player.type == global.scissors3|| play_player.type == global.scissors4|| play_player.type == global.scissors9){
						global.phase = global.phase_player_choice;
						audio_play_sound(snd_win,0,0);
					}
				}
				else if (play_computer.type == global.rock || play_computer.type == global.rock2 || play_computer.type == global.rock3|| play_computer.type == global.rock4|| play_computer.type == global.rock9 ){
					if (play_player.type == global.scissors || play_player.type == global.scissors2 || play_player.type == global.scissors3|| play_player.type == global.scissors4|| play_player.type == global.scissors9){
						global.phase = global.phase_computer_choice;
						audio_play_sound(snd_lose,0,0);
					}
					else if (play_player.type == global.paper || play_player.type == global.paper2 || play_player.type == global.paper3 || play_player.type == global.paper4|| play_player.type == global.paper9){
						global.phase = global.phase_player_choice;
						audio_play_sound(snd_win,0,0);
					}
				}
				if (play_computer.type == global.scissors || play_computer.type == global.scissors2|| play_computer.type == global.scissors3|| play_computer.type == global.scissors4|| play_computer.type == global.scissors9 ){
					if (play_player.type == global.paper || play_player.type == global.paper2 || play_player.type == global.paper3|| play_player.type == global.paper4|| play_player.type == global.paper9){
						global.phase = global.phase_computer_choice;
						audio_play_sound(snd_lose,0,0);
					}
					else if (play_player.type == global.rock || play_player.type == global.rock2 || play_player.type == global.rock3|| play_player.type == global.rock4|| play_player.type == global.rock9){
						global.phase = global.phase_player_choice;
						audio_play_sound(snd_win,0,0);
					}
				}
			}
			wait_timer = 0;
		}
		break;
		
		case global.phase_computer_choice:
			randomize();
			var strategy = global.Strategy[irandom(array_length(global.Strategy)-1)];
			if(strategy == "attack"){
				audio_play_sound(snd_attack,0,false);
				player_score-= play_computer.rank;
			}else{
				audio_play_sound(snd_defend,0,false);
				computer_score+= play_computer.rank;
				}
			wait_timer = 0;
			global.phase = global.phase_result;
			break;
			
		case global.phase_player_choice:
			for(var i = 0; i< array_length(global.Strategy);i++){
				var inst = instance_create_depth(350 + 480*i,700,0,obj_choice);
				inst.choice = global.Strategy[i];
			}
			if(global.selected_choice){
				if(mouse_check_button(mb_left)){
					if(global.selected_choice.choice == "attack"){
						audio_play_sound(snd_attack,0,false);
						computer_score-= play_player.rank;
						}
					else{
						audio_play_sound(snd_defend,0,false);
						player_score+= play_player.rank;
						}
					instance_destroy(obj_choice);
					wait_timer = 0;
					global.phase = global.phase_result;
				}
			}
		break;
		
	//move the cards over to the discard pile after a delay
	case global.phase_result:
		wait_timer++;
		//show_debug_message(global.second_selected_card);
		if (move_timer == 0) && (wait_timer>60){
			
			if (play_computer != noone){
				if(play_computer.type == global.virus) {
					if(created_virus){
						instance_destroy(play_computer)
						created_virus = false;
					}
					play_computer = noone;
				}else{
					//show_debug_message("comp added");
					//show_debug_message(play_computer);
					//ds_list_add(discard_pile,play_computer);å
					//play_computer.target_x = 600;
					//play_computer.target_y = 320 - ds_list_size(discard_pile)*2;
					//play_computer.targetdepth = deck_size-ds_list_size(discard_pile);
					//play_computer.rank = 1;
					play_computer = noone;
					audio_play_sound(snd_flip, 0,0);
				}
			}
			else if (play_player != noone){
				if(play_player.type == global.virus){
						//instance_destroy(play_player)
						play_player = noone;
				}else{
					//show_debug_message("player add");
					//show_debug_message(play_player);
					//ds_list_add(discard_pile,play_player);
					//play_player.target_x = 600;
					//play_player.target_y = 320 - ds_list_size(discard_pile)*2;
					//play_player.targetdepth= deck_size-ds_list_size(discard_pile);
					//play_player.in_hand = false;
					//play_player.rank = 1;
					//ds_list_delete(hand_player,0);
					play_player = noone;
					audio_play_sound(snd_flip, 0,0);
				}
			}
			else if (ds_list_size(hand_computer) > 0){
				var card = hand_computer[| 0];
				//show_debug_message(card);
				//if(card != noone){
					ds_list_delete(hand_computer, 0);
					ds_list_add(discard_pile, card);
					card.target_y = discard_y - ds_list_size(discard_pile)*2;
					card.target_x = discard_x;
					card.face_up = true;
					card.targetdepth = deck_size-ds_list_size(discard_pile);
					audio_play_sound(snd_flip, 0,0);
				//}
			}
			else if (ds_list_size(hand_player) > 0){
				var card = hand_player[| 0];
				//if(card != noone){
					ds_list_delete(hand_player, 0);
					ds_list_add(discard_pile, card);
					card.target_y = discard_y - ds_list_size(discard_pile)*2;
					card.target_x = discard_x;
					card.targetdepth = deck_size-ds_list_size(discard_pile);
					card.in_hand = false;
					audio_play_sound(snd_flip, 0,0);
				//}
			}
			//if there are still cards in the deck, deal them
			else if (ds_list_size(deck) > 0) {
				global.phase = global.phase_deal;	
				wait_timer = 0;
			}
			//...or reshuffle and replace the deck from the discard pile
			else {
				global.phase = global.phase_cleanup;
				wait_timer = 0;
			}
		}
		global.temp = noone;
		global.made_first_choice = false;
		global.made_second_choice = false;
		global.made_dissolve_choice = false;
		global.selected_card = noone;
		global.second_selected_card = noone;
		global.combine_happen = false;
		global.dissolve_happen = false;
		started = false;
		moved = false;
	
		break;
		
	//reshuffle and replace the deck	
	case global.phase_cleanup:
	//show_debug_message("i clean");
		//first move 'em back into the deck
		if (move_timer%4 == 0){
			audio_play_sound(snd_flip,0,0);
			var index = ds_list_size(discard_pile)-1;
			if (index >= 0){
				var card = discard_pile[| index];
				
				ds_list_add(deck,card);
				ds_list_delete(discard_pile, index);
				
				card.face_up = false;
				card.target_x = 80;
				card.target_y = 320 - 2*ds_list_size(deck);
				card.targetdepth = deck_size - ds_list_size(deck);
			}
				
		}
		wait_timer++;
		//after a delay, randomize the deck and switch phase to do an animation for it
		//show_debug_message(ds_list_size(deck));
		//show_debug_message(wait_timer);
		if (ds_list_size(deck) == deck_size)&&(wait_timer > 100){
			//reshuffle actual deck 
			ds_list_shuffle(deck);
			// play shuffle anim
			current_card = 0;
			global.phase = global.phase_reshuffle;	
		}
		break;
		
	//this last state just animates the cards into their new shuffled index positions
	case global.phase_reshuffle:
	show_debug_message("i reshuffle")
	
		if (move_timer%4 == 0){
			audio_play_sound(snd_flip,0,0);
			var card = deck[| current_card];
			card.target_y = 320 - 2*current_card;
			card.y = 320 - 40;
			card.targetdepth = deck_size - current_card;
			current_card ++;
			
			//ready to deal
			if (current_card == ds_list_size(deck)){
				global.phase = global.phase_deal;
			}	
		
		}

		break;
}

//increment main timer
move_timer++;
if (move_timer ==16){
	move_timer = 0;
}
