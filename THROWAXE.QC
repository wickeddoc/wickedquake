
void () AxeTouch = {

   local float clink;
   local entity stemp;

   if ( ((other == self.owner) && (self.num_bounces == Kick_em)) ) {

      return ;

   }
   self.avelocity = '300.000 300.000 300.000';
   self.movetype = MOVETYPE_BOUNCE;
   setsize (self,'-1.000 -2.000 -3.000','1.000 2.000 3.000');
   if ( ((other.classname == "player") && (self.velocity == VEC_ORIGIN)) ) {

      sound (other,CHAN_ITEM,"weapons/pkup.wav",AS_STRAIGHT,ATTN_NORM);
      stuffcmd (other,"bf\n");
      self.owner.throwaxe = (self.owner.throwaxe + AS_STRAIGHT);
      W_SetCurrentAmmo ();
      stemp = self;
      self = other;
      W_SetCurrentAmmo ();
      self = stemp;
      remove (self);

   }
   if ( (other.takedamage && (self.velocity != VEC_ORIGIN)) ) {

      if ( (self.num_bounces == Kick_em) ) {

         spawn_touchblood (80.000);
         SpawnChunk (self.origin,self.velocity);
         other.punchangle_x = -20.000;
         other.axhitme = AS_STRAIGHT;
         T_Damage (other,self,self.owner,50);

      } else {

         other.punchangle_x = -10.000;
         spawn_touchblood (40.000);
         self.velocity = (self.velocity * -0.500);
         other.axhitme = AS_STRAIGHT;
         T_Damage (other,self,self.owner,25.000);

      }

   } else {

      clink = (random () * WEAPON_ROCKET);
      if ( (clink <= AS_STRAIGHT) ) {

         sound (self,CHAN_WEAPON,"player/axhit2.wav",AS_STRAIGHT,ATTN_NORM);

      } else {

         sound (self,CHAN_WEAPON,"weapons/tink1.wav",AS_STRAIGHT,ATTN_NORM);

      }

   }
   self.num_bounces = (self.num_bounces + AS_STRAIGHT);
   if ( (self.num_bounces > 35.000) ) {

      SUB_Remove ();

   }

};

void () W_ThrowAxe = {

   local entity missile;

   sound (self,CHAN_WEAPON,"weapons/woosh.wav",AS_STRAIGHT,ATTN_NORM);
   self.punchangle_x = CONTENT_SKY;
   if ( (self.throwaxe < AS_STRAIGHT) ) {

      sprint (self,"You don't have a Throwing Axe");
      return ;

   }
   self.throwaxe = (self.throwaxe - AS_STRAIGHT);
   if ( (self.throwaxe < AS_STRAIGHT) ) {

      self.items = (self.items - IT_KEY1);

   }
   missile = spawn ();
   missile.owner = self;
   missile.movetype = MOVETYPE_FLYMISSILE;
   missile.solid = SOLID_TRIGGER;
   makevectors (self.v_angle);
   missile.velocity = aim (self,20000.000);
   missile.angles = vectoangles (missile.velocity);
   missile.velocity = (missile.velocity * 600.000);
   missile.touch = AxeTouch;
   missile.nextthink = (time + SEC);
   missile.think = SUB_Remove;
   setmodel (missile,"progs/throwaxe.mdl");
   setsize (missile,VEC_ORIGIN,VEC_ORIGIN);
   setorigin (missile,((self.origin + (v_forward * WEAPON_ROCKET)) + '0.000 0.000 16.000'));
   missile.velocity = aim (self,1000.000);
   missile.velocity = (missile.velocity * 1000.000);
   missile.num_bounces = Kick_em;
   W_SetCurrentAmmo ();

};
