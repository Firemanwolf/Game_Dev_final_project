var hue = color_get_hue(image_blend);
var satuation= color_get_saturation(image_blend);
var luminosity= color_get_value(image_blend);

if(global.phase==global.phase_player_choice){
	if (position_meeting(mouse_x, mouse_y, id)){
		luminosity -= 100;
		//also set this variable so we know which card to play if there's a click
		global.selected_choice = id;
	}
	else if (global.selected_choice == id){
		luminosity= color_get_value(image_blend);
		global.selected_choice = noone;
	}
}

image_blend = make_color_hsv(hue, satuation, luminosity);