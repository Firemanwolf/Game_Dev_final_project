image_speed = 1;
if(global.phase == global.combine){
	sprite_index = spr_star_combined_anim;
} else if(global.phase == global.dissolve){
	sprite_index = spr_star_dissolve_anim;
}

if(image_index == sprite_get_number(sprite_index)-1){
	instance_destroy(self);
}