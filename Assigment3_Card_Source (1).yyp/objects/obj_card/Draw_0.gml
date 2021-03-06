//lerp to the target x and y, but snap if we're close 
image_index = 0;
if (abs(x - target_x) > 1) {
	x = lerp(x,target_x,0.2);
	depth = -1000;
}
else {
	x = target_x;
	depth = targetdepth;
}
if (abs(y - target_y) > 1) {
	y = lerp(y,target_y,0.2);
	depth = -1000;
}
else {
	y = target_y;
	depth = targetdepth;
}

//set the appearance based on the state of the card
if (type == global.rock) sprite_index = spr_rock;
if (type == global.paper) sprite_index = spr_paper;
if (type == global.scissors) sprite_index = spr_scissors;
if (type == global.virus) sprite_index = spr_virus;
if (type == global.rock2) sprite_index = spr_rock2;
if (type == global.paper2) sprite_index = spr_paper2;
if (type == global.scissors2) sprite_index = spr_scissors2;
if (type == global.rock3) sprite_index = spr_rock3;
if (type == global.paper3) sprite_index = spr_paper3;
if (type == global.scissors3) sprite_index = spr_scissors3;
if (type == global.rock4) sprite_index = spr_rock4;
if (type == global.paper4) sprite_index = spr_paper4;
if (type == global.scissors4) sprite_index = spr_scissors4;
if (type == global.rock9) sprite_index = spr_rock9;
if (type == global.paper9) sprite_index = spr_paper9;
if (type == global.scissors9) sprite_index = spr_scissors9;
if (face_up == false) sprite_index = spr_back;
if(rank == 3) image_index = 1;

//actually draw it
draw_sprite(sprite_index, image_index, x, y);
