draw_self();

if(choice == "attack") image_blend = c_red;
if(choice == "defend") image_blend = c_blue;

draw_set_font(fnt_lemonmilk);
draw_set_halign(fa_center);
draw_set_valign(fa_center);
draw_text(x,y,choice);