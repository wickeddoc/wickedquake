float /* ERROR: Could not determine return type */ () crandom;

void () ShellHit = {

   if ( self.deadflag ) {

      return ;

   } else {

      if ( (self.ltime > (time - 0.200)) ) {

         self.deadflag = TRUE;
         return ;

      } else {

         sound (self,CHAN_WEAPON,"weapons/shellhit.wav",AS_STRAIGHT,ATTN_NORM);
         self.ltime = time;

      }

   }

};

void () DropShell = {

   self.movetype = MOVETYPE_BOUNCE;
   self.solid = SOLID_BBOX;
   setmodel (self,"progs/shelcase.mdl");
   setsize (self,VEC_ORIGIN,VEC_ORIGIN);
   makevectors (self.owner.v_angle);
   setorigin (self,((self.owner.origin + (v_forward * TE_LAVASPLASH)) - (v_right * TE_LAVASPLASH)));
   self.velocity = ((((((v_forward * SVC_INTERMISSION) + ((crandom () * v_forward) * SVC_INTERMISSION)) + (v_up * 220.000)) + ((crandom () * v_up) * TE_LAVASPLASH)) - (v_right * 50.000)) + ((crandom () * v_right) * 20.000));
   self.avelocity_x = (crandom () * 500.000);
   self.avelocity_y = (crandom () * 500.000);
   self.avelocity_z = (crandom () * 500.000);
   self.touch = ShellHit;
   self.nextthink = (time + TE_LAVASPLASH);
   self.think = SUB_Remove;
   self.ltime = (time - AS_STRAIGHT);
   self.deadflag = FALSE;

};

void () SpawnShell = {

   local entity shell;

   shell = spawn ();
   shell.owner = self;
   shell.classname = "shell";
   shell.nextthink = (time + 0.400);
   shell.think = DropShell;

};

void () Shell2Hit = {

   if ( self.deadflag ) {

      return ;

   } else {

      if ( (self.ltime > (time - 0.200)) ) {

         self.deadflag = TRUE;
         return ;

      } else {

         self.ltime = time;

      }

   }

};

void () DropShell2 = {

   self.movetype = MOVETYPE_BOUNCE;
   self.solid = SOLID_BBOX;
   setmodel (self,"progs/shell.mdl");
   setsize (self,VEC_ORIGIN,VEC_ORIGIN);
   makevectors (self.owner.v_angle);
   setorigin (self,((self.owner.origin + (v_forward * TE_LAVASPLASH)) - (v_right * TE_LAVASPLASH)));
   self.velocity = ((((((v_forward * SVC_INTERMISSION) + ((crandom () * v_forward) * SVC_INTERMISSION)) + (v_up * 220.000)) + ((crandom () * v_up) * TE_LAVASPLASH)) - (v_right * 50.000)) + ((crandom () * v_right) * 20.000));
   self.avelocity_x = (crandom () * 500.000);
   self.avelocity_y = (crandom () * 500.000);
   self.avelocity_z = (crandom () * 500.000);
   self.touch = Shell2Hit;
   self.nextthink = (time + TE_LIGHTNING1);
   self.think = SUB_Remove;
   self.ltime = (time - AS_STRAIGHT);
   self.deadflag = FALSE;

};

void () SpawnShell2 = {

   local entity shell;

   shell = spawn ();
   shell.owner = self;
   shell.classname = "shell2";
   shell.nextthink = (time + 0.400);
   shell.think = DropShell2;

};
