
void () BananaTouch = {

   local entity banana;

   if ( (self.velocity != VEC_ORIGIN) ) {

      return ;

   }
   if ( (other.takedamage && (self.velocity == VEC_ORIGIN)) ) {

      sound (other,CHAN_BODY,"weapons/wheee.wav",TRUE,ATTN_NORM);
      other.punchangle_y = -25.000;
      other.velocity = (other.velocity * 25);
      other.armorvalue = 0;
      banana = spawn ();
      banana.owner = self;
      banana.origin = self.origin;
      remove (self);
      banana.movetype = MOVETYPE_TOSS;
      banana.solid = SOLID_NOT;
      banana.classname = "banana";
      banana.velocity = '0.000 0.000 400.000';
      banana.avelocity = '300.000 300.000 300.000';
      banana.think = SUB_Remove;
      banana.touch = SUB_Null;
      banana.nextthink = (time + TRUE);
      setmodel (banana,"progs/nanner.mdl");
      sound (banana,CHAN_BODY,"weapons/woohoo.wav",TRUE,ATTN_NORM);

   }

};

void () ThrowPeel = {

   local entity banana;

   if ( (self.bananas < TRUE) ) {

      return ;

   }
   self.bananas = (self.bananas - TRUE);
   banana = spawn ();
   banana.owner = self;
   banana.movetype = MOVETYPE_TOSS;
   banana.solid = SOLID_TRIGGER;
   banana.classname = "banana";
   makevectors (self.v_angle);
   if ( self.v_angle_x ) {

      banana.velocity = ((((v_forward * 600.000) + (v_up * 200.000)) + ((crandom () * v_right) * MOVETYPE_BOUNCE)) + ((crandom () * v_up) * MOVETYPE_BOUNCE));

   } else {

      banana.velocity = aim (self,10000.000);
      banana.velocity = (banana.velocity * 600.000);
      banana.velocity_z = 200.000;

   }
   banana.avelocity = '0.000 300.000 0.000';
   banana.touch = BananaTouch;
   banana.nextthink = (time + 240.000);
   banana.think = SUB_Remove;
   setsize (banana,VEC_ORIGIN,VEC_ORIGIN);
   setmodel (banana,"progs/nanner.mdl");
   setorigin (banana,self.origin);

};
