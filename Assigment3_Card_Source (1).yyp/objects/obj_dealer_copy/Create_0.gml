//LOCATION VARIABLES
//comp_hand_x = 0;
comp_hand_y = 120;

comp_select_x= 520;
comp_select_y= 370;

//player_hand_x= 0;
player_hand_y = 900;

player_select_x = 520;
player_select_y = 625;

player_hover = 880;

discard_y= 525;
discard_x= 1100;

//position of animation
anim_x = room_width/2-10;
anim_y = room_height/2+200;


// meter handler
//global.stateMeter = instance_find(obj_stateMeter, 0);



created_virus = false;
started = false;
emptied_early = false;
moved = false;

//variables used for combining and desolving
global.combine = false;
global.combine_happen = false;
global.dissolve = false;
global.dissolve_happen = false;


global.made_first_choice = false;
global.made_second_choice = false;
global.made_dissolve_choice = false;


global.first_choice = noone;
global.second_choice = noone;
global.temp = noone;

global.gameState = "combine";
global.second_selected_card = noone;



//enumerate states for the state machine
global.phase_deal = 0;
global.phase_computer = 1;
global.phase_select = 2;
global.combine = 3;
global.dissolve = 4;
global.phase_play= 5;
global.phase_computer_choice = 6;
global.phase_player_choice = 7;
global.phase_result = 8;
global.phase_cleanup = 9;
global.phase_reshuffle = 10;
global.phase = global.phase_deal;

//a global references so a card can tell us if it's selected
global.selected_card = noone;
global.selected_choice = noone;

//enumerate card types
global.rock = 0;
global.paper = 1;
global.scissors = 2;
global.virus = 3;
global.rock2 = 4;
global.paper2 = 5;
global.scissors2 = 6;
global.rock3 = 7;
global.paper3 = 8;
global.scissors3 = 9;
global.rock4 = 10;
global.paper4 = 11;
global.scissors4 = 12;
global.rock9 = 13;
global.paper9 = 14;
global.scissors9 = 15;


//buffed = false;
//computer_buffed = false;

//track scores
computer_score = 0;
player_score = 0;

//timer variables
move_timer = 0;
wait_timer = 0;

deck_size = 24;

win_condition = 10;

global.Strategy[0] = "attack";
global.Strategy[1] = "defend";

global.winner = "";

//create lists
deck = ds_list_create();
hand_computer = ds_list_create();
hand_player = ds_list_create();
discard_pile = ds_list_create();

//single card refs for the play, no need for a list there
play_computer = noone;
play_player = noone;

//create card instances and place in deck for start
for (i=0; i<deck_size; i++) {
	var newcard = instance_create_layer(0,0,"Instances",obj_card);
	newcard.face_up = false;
	if (i<deck_size/3){
		newcard.type = global.rock;
	}
	else if (i<2*deck_size/3){
		newcard.type = global.paper;
	}
	else {
		newcard.type = global.scissors;
	}
	ds_list_add(deck,newcard);	
}
	
	
//shuffle
randomize();
ds_list_shuffle(deck);

//position them nicely
for (i = 0; i<deck_size; i++){
	deck[| i].x = 80;
	deck[| i].y = 320-(2*i);
	deck[| i].target_x = deck[| i].x;
	deck[| i].target_y = deck[| i].y;
	deck[| i].targetdepth = deck_size-i;
}

audio_play_sound(snd_desert_conflict,0,true);