
void (vector fireorg) SpawnTouchFlame;

void () BurnThem;

void (float num_bubbles, vector bub_origin) NewBubbles = {

   local entity bubble_spawner;

   bubble_spawner = spawn ();
   setorigin (bubble_spawner,bub_origin);
   bubble_spawner.movetype = MOVETYPE_NONE;
   bubble_spawner.solid = SOLID_NOT;
   bubble_spawner.nextthink = (time + 0.100);
   if ( (self.classname == "player") ) {

      bubble_spawner.owner = self;

   } else {

      bubble_spawner.owner = self.firewood;

   }
   bubble_spawner.think = DeathBubblesSpawn;
   bubble_spawner.bubble_count = num_bubbles;
   return ;

};

void () BurnSelf = {

   local entity flame;

   flame = spawn ();
   flame.owner = self;
   flame.movetype = MOVETYPE_FLYMISSILE;
   flame.velocity = '0.000 0.000 75.000';
   flame.solid = SOLID_NOT;
   flame.classname = "fire";
   flame.origin = self.origin;
   self.onfire = TRUE;
   flame.firewood = self;
   flame.think = BurnThem;
   flame.nextthink = time;
   setmodel (flame,"progs/s_explod.spr");
   setsize (flame,VEC_ORIGIN,VEC_ORIGIN);

};

void () BurnThem = {

   if ( (self.firewood.waterlevel >= AS_STRAIGHT) ) {

      NewBubbles (TE_LIGHTNING2,self.firewood.origin);
      self.firewood.onfire = FALSE;
      self.firewood.effects = (self.firewood.effects - EF_DIMLIGHT);
      remove (self);
      return ;

   } else {

      if ( (self.firewood.health > Kick_em) ) {

         SpawnTouchFlame (self.firewood.origin);
         T_Damage (self.firewood,self,self.owner,15);
         self.nextthink = (time + 0.250);

      } else {

         if ( (self.firewood.health <= Kick_em) ) {

            self.firewood.effects = (self.firewood.effects - EF_DIMLIGHT);

         }

      }

   }

};

void (vector fireorg) SpawnTouchFlame = {

   local entity flame;
   local float rn;

   flame = spawn ();
   flame.owner = self;
   flame.movetype = MOVETYPE_FLYMISSILE;
   flame.velocity = '0.000 0.000 75.000';
   flame.solid = SOLID_NOT;
   flame.classname = "fire";
   flame.origin = fireorg;
   flame.think = s_explode1;
   flame.nextthink = time;
   setmodel (flame,"progs/s_explod.spr");
   setsize (flame,VEC_ORIGIN,VEC_ORIGIN);

};

void () FlameTouch = {

   local float rn;

   if ( (other == self.owner) ) {

      return ;

   }
   if ( other.takedamage ) {

      rn = random ();
      if ( ((rn <= 0.200) && !other.onfire) ) {

         if ( (other.classname == "player") ) {

            centerprint (other,"You are on fire! Find WATER!\n");
            stuffcmd (other,"bf\n");

         }
         else s_explode1;
         other.onfire = TRUE;
         self.firewood = other;
         self.think = BurnThem;
         self.nextthink = time;
         self.solid = SOLID_NOT;
         setmodel (self,"");
         other.effects = (other.effects | 8);

      } else {

         SpawnTouchFlame (other.origin);
         T_Damage (other,self,self.owner,10);
         remove (self);

      }

   } else {

      if ( (other.classname == "worldspawn") ) {

         self.velocity = VEC_ORIGIN;

      }

   }

};

void () W_FireFlame = {

   local entity flame;
   local float rn;

   if ( (self.waterlevel > WEAPON_ROCKET) ) {

      makevectors (self.v_angle);
      NewBubbles (WEAPON_ROCKET,(self.origin + (v_forward * IT_LIGHTNING)));
      rn = random ();
      if ( (rn < 0.500) ) {

         sound (self,CHAN_WEAPON,"misc/water1.wav",AS_STRAIGHT,ATTN_NORM);

      } else {

         sound (self,CHAN_WEAPON,"misc/water2.wav",AS_STRAIGHT,ATTN_NORM);

      }
      return ;

   }
   self.ammo_rockets = (self.ammo_rockets - AS_STRAIGHT);
   self.currentammo = (self.ammo_rockets - AS_STRAIGHT);
   sound (self,CHAN_WEAPON,"hknight/hit.wav",AS_STRAIGHT,ATTN_NORM);
   flame = spawn ();
   flame.owner = self;
   flame.movetype = MOVETYPE_FLYMISSILE;
   flame.solid = SOLID_BBOX;
   flame.classname = "fire";
   makevectors (self.v_angle);
   flame.velocity = aim (self,10000.000);
   flame.velocity = (flame.velocity * 300.000);
   flame.touch = FlameTouch;
   flame.think = s_explode1;
   flame.nextthink = (time + 1);
//   flame.nextthink = (time + 0.150);
   setmodel (flame,"progs/s_explod.spr");
   setsize (flame,VEC_ORIGIN,VEC_ORIGIN);
   setorigin (flame,((self.origin + (v_forward * IT_GRENADE_LAUNCHER)) + '0.000 0.000 16.000'));

};
