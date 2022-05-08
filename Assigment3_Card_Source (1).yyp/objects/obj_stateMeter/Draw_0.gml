/// @description Insert description here
// You can write your code in this editor
draw_set_font(fnt_lemonmilk);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_self();
//draw_text(x+50,y+2, "combine")
//draw_text(x+350,y+2, "dissolve")
//draw_text(x+700,y+1, "play")

if(global.gameState == "combine"){
	draw_sprite(spr_combine_H,0,x+150,y+21)
	draw_sprite(spr_dissolve,0,x+450,y+21);
	draw_sprite(spr_play,0,x+730,y+20)
}else if (global.gameState == "dissolve"){
	draw_sprite(spr_combine,0,x+150,y+21)
	draw_sprite(spr_dissolve_H,0,x+450,y+21);
	draw_sprite(spr_play,0,x+730,y+20)
	
}else{
	draw_sprite(spr_combine,0,x+150,y+21)
	draw_sprite(spr_dissolve,0,x+450,y+21);
	draw_sprite(spr_play_H,0,x+730,y+20)

}
