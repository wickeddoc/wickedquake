
void (entity Head) BreakChain = {

   local entity link;

   link = Head.goalentity;
   while ( (link != world) ) {

      Head = link.goalentity;
      remove (link);
      link = Head;

   }

};

void () LinkPos = {

   makevectors (self.enemy.angles);
   setorigin (self,(self.owner.origin + ((((self.enemy.origin + ((v_up * IT_GRENADE_LAUNCHER) * !self.enemy.button2)) + (v_forward * IT_GRENADE_LAUNCHER)) - self.owner.origin) * self.weapon)));
   self.nextthink = (time + 0.100);

};
entity (entity head, entity tail, float num) MakeChain = {

   local entity link;
   local entity prevlink;
   local float linknum;

   linknum = num;
   num = (num + AS_STRAIGHT);
   prevlink = world;
   while ( (linknum > Kick_em) ) {

      link = spawn ();
      link.goalentity = prevlink;
      prevlink = link;
      link.owner = head;
      link.enemy = tail;
      link.weapon = (linknum / num);
      link.movetype = MOVETYPE_NOCLIP;
      link.solid = SOLID_NOT;
      link.angles_z = (51.000 * linknum);
      link.angles_y = (41.000 * linknum);
      link.angles_x = (SVC_FINALE * linknum);
      link.avelocity = '310.000 410.000 510.000';
      setmodel (link,"progs/bit.mdl");
      setsize (link,VEC_ORIGIN,VEC_ORIGIN);
      makevectors (tail.angles);
      setorigin (link,(head.origin + ((((tail.origin + ((v_up * IT_GRENADE_LAUNCHER) * !tail.button2)) + (v_forward * IT_GRENADE_LAUNCHER)) - head.origin) * link.weapon)));
      link.nextthink = (time + 0.100);
      link.think = LinkPos;
      linknum = (linknum - AS_STRAIGHT);

   }
   return ( link );

};

void () HookVanish = {

   self.owner.hook_out = FALSE;
   sound (self.owner,CHAN_WEAPON,"weapons/bounce2.wav",AS_STRAIGHT,ATTN_NONE);
   BreakChain (self);
   remove (self);

};

void () HookPull = {

   local vector vel;
   local vector spray;
   local float v;
   local float dorg;

   if ( (((!self.owner.button0 && (self.owner.weapon == IT_MORNINGSTAR)) || (self.owner.teleport_time > time)) || self.owner.deadflag) ) {

      HookVanish ();
      return ;

   } else {

      if ( self.enemy.takedamage ) {

         if ( ((self.enemy.classname != "player") || !teamplay) ) {

            sound (self,CHAN_WEAPON,"blob/land1.wav",AS_STRAIGHT,ATTN_NORM);
            makevectors (self.v_angle);
            spray_x = (100.000 * crandom ());
            spray_y = (100.000 * crandom ());
            spray_z = ((100.000 * crandom ()) + COST);
            SpawnBlood (self.origin,spray,20.000);

         }
         if ( (self.enemy.solid == SOLID_SLIDEBOX) ) {

            self.velocity = VEC_ORIGIN;
            setorigin (self,((self.enemy.origin + self.enemy.mins) + (self.enemy.size * 0.500)));

         } else {

            self.velocity = self.enemy.velocity;

         }

      } else {

         self.velocity = self.enemy.velocity;

      }
      if ( (self.enemy.solid == SOLID_NOT) ) {

         HookVanish ();
         return ;

      }
      makevectors (self.owner.angles);
      vel = (self.origin - ((self.owner.origin + ((v_up * IT_GRENADE_LAUNCHER) * !self.owner.button2)) + (v_forward * IT_GRENADE_LAUNCHER)));
      v = vlen (vel);
      if ( (v <= 100.000) ) {

         vel = ((normalize (vel) * v) * TE_LAVASPLASH);

      }
      if ( (v > 100.000) ) {

         vel = (normalize (vel) * 1000.000);

      }
      dorg = vlen ((self.owner.origin - self.dest));
      if ( ((dorg > TE_LAVASPLASH) && (self.style == AS_MELEE)) ) {

         sound (self.owner,CHAN_WEAPON,"weapons/chain2.wav",AS_STRAIGHT,ATTN_NORM);
         self.style = WEAPON_ROCKET;

      }
      if ( ((dorg < TE_LAVASPLASH) && (self.style == WEAPON_ROCKET)) ) {

         sound (self.owner,CHAN_WEAPON,"weapons/chain3.wav",AS_STRAIGHT,ATTN_NORM);
         self.style = AS_MELEE;

      }
      self.owner.velocity = vel;
      self.dest = self.owner.origin;
      self.nextthink = (time + 0.100);

   }

};

void () T_ChainTouch = {

   if ( (other == self.owner) ) {

      return ;

   }
   if ( (pointcontents (self.origin) == CONTENT_SKY) ) {

      HookVanish ();
      return ;

   }
   if ( ((other.classname == "player") && teamplay) ) {

      return ;

   }
   if ( other.takedamage ) {

      if ( (other.classname == "player") ) {

         other.axhitme = AS_STRAIGHT;

      } else {

         sound (self,CHAN_WEAPON,"player/axhit2.wav",AS_STRAIGHT,ATTN_NORM);

      }
      SpawnBlood (self.origin,self.velocity,TE_LAVASPLASH);

   } else {

      sound (self,CHAN_WEAPON,"player/axhit2.wav",AS_STRAIGHT,ATTN_NORM);
      self.avelocity = VEC_ORIGIN;

   }
   if ( !self.owner.button0 ) {

      HookVanish ();
      return ;

   } else {

      if ( (other.solid == SOLID_SLIDEBOX) ) {

         setorigin (self,((other.origin + other.mins) + (other.size * 0.500)));
         self.velocity = VEC_ORIGIN;

      } else {

         self.velocity = other.velocity;

      }
      self.weapon = (other.nextthink - time);
      sound (self.owner,CHAN_WEAPON,"weapons/chain2.wav",AS_STRAIGHT,ATTN_NORM);
      self.style = WEAPON_ROCKET;
      self.enemy = other;
      self.nextthink = (time + 0.100);
      self.think = HookPull;
      self.touch = SUB_Null;

   }

};

void () W_FireChain = {

   local entity hook;

   self.hook_out = TRUE;
   hook = spawn ();
   hook.owner = self;
   hook.movetype = MOVETYPE_FLY;
   hook.solid = SOLID_BBOX;
   makevectors (self.v_angle);
   hook.velocity = aim (self,1000.000);
   hook.velocity = (hook.velocity * 800.000);
   hook.angles = vectoangles (hook.velocity);
   hook.avelocity = '0.000 0.000 -500.000';
   hook.touch = T_ChainTouch;
   hook.nextthink = (time + TE_LIGHTNING1);
   hook.think = HookVanish;
   setmodel (hook,"progs/star.mdl");
   setsize (hook,VEC_ORIGIN,VEC_ORIGIN);
   setorigin (hook,((self.origin + (v_forward * IT_GRENADE_LAUNCHER)) + '0.000 0.000 16.000'));
   sound (self,CHAN_WEAPON,"weapons/chain1.wav",AS_STRAIGHT,ATTN_NORM);
   hook.goalentity = MakeChain (hook,self,AS_MELEE);

};
