////variables used for combining and desolving
//global.combine = false;
//global.desolve = false;


//enumerate states for the state machine
global.phase_deal = 0;
global.phase_computer = 1;
global.phase_select = 2;
global.phase_play= 3;
global.phase_computer_choice = 4;
global.phase_player_choice = 5;
global.phase_result = 6;
global.phase_cleanup = 7;
global.phase_reshuffle = 8;
global.phase = global.phase_deal;

//a global references so a card can tell us if it's selected
global.selected_card = noone;
global.selected_choice = noone;

//enumerate card types
global.rock = 0;
global.paper = 1;
global.scissors = 2;
global.virus = 3;

buffed = false;
computer_buffed = false;

//track scores
computer_score = 0;
player_score = 0;

//timer variables
move_timer = 0;
wait_timer = 0;

deck_size = 24;

win_condition = 5;

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
	deck[| i].x = 40;
	deck[| i].y = 320-(2*i);
	deck[| i].target_x = deck[| i].x;
	deck[| i].target_y = deck[| i].y;
	deck[| i].targetdepth = deck_size-i;
}

