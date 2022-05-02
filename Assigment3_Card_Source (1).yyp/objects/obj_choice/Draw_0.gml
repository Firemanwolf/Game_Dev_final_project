draw_self();

if(choice == "attack") image_blend = make_color_rgb(217,66,50);
if(choice == "defend") image_blend = make_color_rgb(50,89,217);

draw_set_font(fnt_lemonmilk);
draw_set_halign(fa_center);
draw_set_valign(fa_center);
draw_text_transformed(x,y,choice,.7,.7,0);