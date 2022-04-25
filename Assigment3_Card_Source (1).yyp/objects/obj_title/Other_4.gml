if(global.winner == "Player") audio_play_sound(snd_round_win,0,false);
else if(global.winner == "Computer") audio_play_sound(snd_round_lose,0,false);
else audio_play_sound(snd_round_draw,0,false);