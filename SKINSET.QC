/*
========
display skin selection to user after respawn

set_Skin
========
*/

void () set_skin =
{
};

/*
========
Set skin color and display skin selection to user

Put_On_Skin
========
*/

void (float skin_num) put_on_skin =
{
//PIGBOYS CHANGES
    if (skin_num == 1) 
	{
                stuffcmd (self, "NAME Doc\n");
                stuffcmd (self, "COLOR 1");
                centerprint(self, "Doc Holliday (1)");
                bprint("\n\n\n    Doc Holliday joined in \n");
                sound (self, CHAN_VOICE, "say/01/01.wav", 1, ATTN_NORM);
                
	}
    else if (skin_num == 2) 
	{
                stuffcmd (self, "NAME Wotan\n");
                stuffcmd (self, "COLOR 2");
                centerprint(self, "Wotan (2)"); 
                bprint("\n\n\n    Wotan joined in \n");
                sound (self, CHAN_VOICE, "say/02/01.wav", 1, ATTN_NORM);
	}
    else if (skin_num == 3) 
	{
                stuffcmd (self, "NAME Scavenger\n");
                stuffcmd (self, "COLOR 3");
                centerprint(self, "Scavenger (3)");
                bprint("\n\n\n    Scavenger joined in \n");
                sound (self, CHAN_VOICE, "say/03/01.wav", 1, ATTN_NORM);
	}
    else if (skin_num == 4) 
	{
                stuffcmd (self, "NAME Bad_Blood\n");
                stuffcmd (self, "COLOR 4");
                centerprint(self, "Bad Blood (4)"); 
                bprint("\n\n\n    Bad Blood joined in \n");
                sound (self, CHAN_VOICE, "say/04/01.wav", 1, ATTN_NORM);
	}
    else if (skin_num == 5) 
	{
                stuffcmd (self, "NAME Moses\n");
                stuffcmd (self, "COLOR 5");
                centerprint(self, "Moses (5)");
                bprint("\n\n    Moses joined in \n");
                sound (self, CHAN_VOICE, "say/05/01.wav", 1, ATTN_NORM);
	}
    else if (skin_num == 6) 
	{
                stuffcmd (self, "NAME The_Lord\n");
                stuffcmd (self, "COLOR 11");
                centerprint(self, "The Lord (6)");
                bprint("\n\n\n    The Lord joined in \n");
                sound (self, CHAN_VOICE, "say/06/01.wav", 1, ATTN_NORM);
	}
    else if (skin_num == 7) 
	{
                stuffcmd (self, "NAME Syndrome\n");
                stuffcmd (self, "COLOR 12");
                centerprint(self, "Syndrome (7)");
                bprint("\n\n\n    Syndrome joined in \n");
                sound (self, CHAN_VOICE, "say/07/01.wav", 1, ATTN_NORM);
	}
    else if (skin_num == 8) 
	{
                stuffcmd (self, "NAME Darth_Vader\n");
                stuffcmd (self, "COLOR 2 5");
                centerprint(self, "Darth Vader (8)");
                bprint("\n\n    Darth Vader joined in \n");
                sound (self, CHAN_VOICE, "say/08/01.wav", 1, ATTN_NORM);
        }
    else if (skin_num == 9) 
	{
                stuffcmd (self, "NAME Peedee\n");
                stuffcmd (self, "COLOR 8 11");
                centerprint(self, "Peedee (9)");
                bprint("\n\n    Peedee joined in \n");
                sound (self, CHAN_VOICE, "say/09/01.wav", 1, ATTN_NORM);
        }
    else if (skin_num == 10) 
	{
                stuffcmd (self, "NAME Buzzer\n");
                stuffcmd (self, "COLOR 12 14");
                centerprint(self, "Buzzer (10)");
                bprint("\n\n    Buzzer joined in \n");
                sound (self, CHAN_VOICE, "say/10/01.wav", 1, ATTN_NORM);
        }
};
void () ResetSkin =
{
        self.skin = 0;
        self.obs = 0;
};
