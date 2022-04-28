//STATE MACHINE
switch (global.phase){
	//deal out the cards, three per player
	case global.phase_deal:
		global.gameState = "deal";
		//show_debug_message("i am dealing");
		//move_timer kicks over to 0 every 16 frames
		if (move_timer == 0){
			audio_play_sound(snd_flip,0,0);
			
			//first deal until the computer hand is full
			if (ds_list_size(hand_computer) < 3){
				var card = deck[| ds_list_size(deck)-1];
				ds_list_delete(deck,ds_list_size(deck)-1);
				ds_list_add(hand_computer,card);
				
				card.target_x = 120 + 100*ds_list_size(hand_computer);
				card.target_y = 80;
			}
			//then deal until player hand is full
			else if (ds_list_size(hand_player) < 3){
				var card = deck[| ds_list_size(deck)-1];
				ds_list_delete(deck,ds_list_size(deck)-1);
				
				card.target_x = 220 + 100*ds_list_size(hand_player);
				card.target_y = 550;
				card.in_hand=true;
				
				ds_list_add(hand_player,card);
			}
			//then flip the player cards up and change state
			else {
				for (i=0; i<3; i++){
					hand_player[| i].face_up = true;	
				}
				wait_timer=0;
				global.phase = global.phase_computer;	
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
				   &&(hand_computer[|0].type != hand_computer[|2].type))
			{
				play_computer = instance_create_depth(320,240,0,obj_card)
				play_computer.type = global.virus;
				play_computer.target_x = 320;
				play_computer.target_y = 240;
				play_computer.face_up = true;
				audio_play_sound(snd_flip,0,0);
				wait_timer = 0;
				global.gameState = "play";
				global.phase = global.phase_select;
			}else {
				if(hand_computer[|0].type == hand_computer[|1].type && hand_computer[|1].type == hand_computer[|2].type){
					computer_buffed = true;
				}
					//computer plays random card then change state
					var index = irandom_range(0,ds_list_size(hand_computer)-1);
					play_computer = hand_computer[| index];
					play_computer.target_x = 320;
					play_computer.target_y = 240;
					if(computer_buffed){
						play_computer.rank = 3;
						computer_buffed = false;
					}
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
		if(hand_player[|0].type == hand_player[|1].type && hand_player[|1].type == hand_player[|2].type){
			buffed = true;
		}else if(hand_player[|0].type != hand_player[|1].type
			   &&(hand_player[|1].type != hand_player[|2].type)
			   &&(hand_player[|0].type != hand_player[|2].type))
		{
			play_player = instance_create_depth(320,386,0,obj_card)
			play_player.type = global.virus;
			play_player.target_x = 320;
			play_player.target_y = 386;
			play_player.face_up = true;
			audio_play_sound(snd_flip,0,0);
			global.phase = global.phase_play;
			wait_timer = 0;
		}
		if(global.gameState == "play"){
			//show_debug_message("in play");
			if (mouse_check_button_pressed(mb_left)){
				//this selected_card variable is set by the card itself
				if (global.selected_card != noone){
					//play the card
					var hand_index = ds_list_find_index(hand_player, global.selected_card);
					play_player = hand_player[| hand_index];
					play_player.target_x = 320;
					play_player.target_y = 386;
					play_player.in_hand = false;
					if(buffed){
						play_player.rank = 3;
						buffed = false;
					}
					//ds_list_delete(hand_player,hand_index);
					audio_play_sound(snd_flip,0,0);
					global.phase = global.phase_play;
					global.selected_card = noone;
					wait_timer = 0;
				
				}
			}
		}else if (global.gameState == "combine"){
			//show_debug_message("in combine");
			//show_debug_message(ds_list_size(discard_pile));
			if (!global.made_first_choice){
				if (global.selected_card != noone){
					//show_debug_message("made first choice");
					//show_debug_message(global.selected_card);
					//play the card
					var hand_index = ds_list_find_index(hand_player, global.selected_card);
					play_player = hand_player[| hand_index];
					//play_player.target_x = 320;
					play_player.target_y = 400;
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
					play_player.target_y = 400;
					play_player.in_hand = false;
					global.second_choice = play_player;
					global.made_second_choice = true;
				}
				wait_timer = 0;
			}
			
			if(global.temp != noone && global.second_selected_card != noone){
				global.phase = global.combine;
			}
			
		}
		break;
		
	case global.combine:
		//show_debug_message("combine");
		//show_debug_message(global.temp)
		//show_debug_message(global.second_selected_card);
		var card = noone;
		var second_card = noone;
		if (!combine){
			if (global.temp.type == global.rock && global.second_selected_card.type == global.rock){
				show_debug_message(ds_list_size(hand_player));
				card = instance_create_depth(320,240,0,obj_card)
				card.type = global.rock2;
				
				second_card = instance_create_depth(320,240,0,obj_card)
				second_card.type = global.rock2;
				
				var hand_index = ds_list_find_index(hand_player, global.temp);
				var second_index = ds_list_find_index(hand_player, global.second_selected_card);
				var card1 = hand_player[| hand_index];
				var card2 = hand_player[| second_index];
			
				
				card.target_x = card1.target_x;
				//card.target_y = card1.target_y;
				card.target_y = 550;
				card.face_up = true;
				
				second_card.target_x = card2.target_x;
				//second_card.target_y = card2.target_y;
				second_card.target_y = 550;
				second_card.face_up = true;
			
				card.in_hand = true;
				second_card.in_hand = true;

				ds_list_replace(hand_player, hand_index,card);
				ds_list_replace(hand_player, second_index, second_card);
				show_debug_message(ds_list_size(hand_player));
				
				instance_destroy(card1);
				instance_destroy(card2);
				combine = true;
			
				//global.phase = global.phase_play;
			}else if (global.temp.type == global.paper && global.second_selected_card.type == global.paper){
				show_debug_message(ds_list_size(hand_player));
				card = instance_create_depth(320,240,0,obj_card)
				card.type = global.paper2;
				
				second_card = instance_create_depth(320,240,0,obj_card)
				second_card.type = global.paper2;
				
				var hand_index = ds_list_find_index(hand_player, global.temp);
				var second_index = ds_list_find_index(hand_player, global.second_selected_card);
				var card1 = hand_player[| hand_index];
				var card2 = hand_player[| second_index];
			
				
				card.target_x = card1.target_x;
				//card.target_y = card1.target_y;
				card.target_y = 550;
				card.face_up = true;
				
				second_card.target_x = card2.target_x;
				//second_card.target_y = card2.target_y;
				second_card.target_y = 550;
				second_card.face_up = true;
			
			
				card.in_hand = true;
				second_card.in_hand = true;

				ds_list_replace(hand_player, hand_index,card);
				ds_list_replace(hand_player, second_index, second_card);
				show_debug_message(ds_list_size(hand_player));
				
				instance_destroy(card1);
				instance_destroy(card2);
				combine = true;
			
			
				//global.phase = global.phase_play;
			} else if (global.temp.type == global.scissors && global.second_selected_card.type == global.scissors){
				show_debug_message(ds_list_size(hand_player));
				card = instance_create_depth(320,240,0,obj_card)
				card.type = global.scissors2;
				
				second_card = instance_create_depth(320,240,0,obj_card)
				second_card.type = global.scissors2;
				
				var hand_index = ds_list_find_index(hand_player, global.temp);
				var second_index = ds_list_find_index(hand_player, global.second_selected_card);
				var card1 = hand_player[| hand_index];
				var card2 = hand_player[| second_index];
			
				
				card.target_x = card1.target_x;
				//card.target_y = card1.target_y;
				card.target_y = 550;
				card.face_up = true;
				
				second_card.target_x = card2.target_x;
				//second_card.target_y = card2.target_y;
				second_card.target_y = 550;
				second_card.face_up = true;
			
			
				card.in_hand = true;
				second_card.in_hand = true;

				ds_list_replace(hand_player, hand_index,card);
				ds_list_replace(hand_player, second_index, second_card);
				show_debug_message(ds_list_size(hand_player));
				
				instance_destroy(card1);
				instance_destroy(card2);
				combine = true;
			}else{
				//global.phase = global.phase_select;
				//global.selected_card.target_y = 550;
				//global.second_selected_card.target_y = 550;
				//global.selected_card.in_hand = true;
				//global.second_selected_card.in_hand = true;
				//global.made_first_choice = false;
				//global.made_second_choice = false;
				global.phase = global.phase_select;
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
				}else if (play_computer.type == global.paper){
					if (play_player.type == global.rock){
						global.phase = global.phase_computer_choice;
						audio_play_sound(snd_lose,0,0);
					}
					else if (play_player.type == global.scissors){
						global.phase = global.phase_player_choice;
						audio_play_sound(snd_win,0,0);
					}
				}
				else if (play_computer.type == global.rock){
					if (play_player.type == global.scissors){
						global.phase = global.phase_computer_choice;
						audio_play_sound(snd_lose,0,0);
					}
					else if (play_player.type == global.paper){
						global.phase = global.phase_player_choice;
						audio_play_sound(snd_win,0,0);
					}
				}
				if (play_computer.type == global.scissors){
					if (play_player.type == global.paper){
						global.phase = global.phase_computer_choice;
						audio_play_sound(snd_lose,0,0);
					}
					else if (play_player.type == global.rock){
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
				var inst = instance_create_depth(200 + 300*i,514,0,obj_choice);
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
				instance_destroy(play_computer)
				play_computer = noone;
				}else{
					//show_debug_message("comp added");
					//show_debug_message(play_computer);
					//ds_list_add(discard_pile,play_computer);
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
						instance_destroy(play_player)
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
				//show_debug_message("finish comp hand");
				var card = hand_computer[| 0];
				//show_debug_message(card);
				ds_list_delete(hand_computer, 0);
				ds_list_add(discard_pile, card);
				card.target_y = 320 - ds_list_size(discard_pile)*2;
				card.target_x = 600;
				card.face_up = true;
				card.targetdepth = deck_size-ds_list_size(discard_pile);
				audio_play_sound(snd_flip, 0,0);
			}
			else if (ds_list_size(hand_player) > 0){
				//show_debug_message("finish player hand");
				var card = hand_player[| 0];
				ds_list_delete(hand_player, 0);
				ds_list_add(discard_pile, card);
				card.target_y = 320 - ds_list_size(discard_pile)*2;
				card.target_x = 600;
				card.targetdepth = deck_size-ds_list_size(discard_pile);
				card.in_hand = false;
				audio_play_sound(snd_flip, 0,0);
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
		//play_player = noone;
		//global.first_choice = noone;
		//global.second_choice = noone;
		global.made_first_choice = false;
		global.made_second_choice = false;
		global.selected_card = noone;
		global.second_selected_card = noone;
		combine = false;
	
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
				card.target_x = 40;
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
	//show_debug_message("i reshuffle")
	
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
