void () info_null = {

   remove (self);

};

void () info_notnull = {


};
float START_OFF    = 1.000;

void () light_use = {

   if ( (self.spawnflags & START_OFF) ) {

      lightstyle (self.style,"m");
      self.spawnflags = (self.spawnflags - START_OFF);

   } else {

      lightstyle (self.style,"a");
      self.spawnflags = (self.spawnflags + START_OFF);

   }

};

void () light = {

   if ( !self.targetname ) {

      remove (self);
      return ;

   }
   if ( (self.style >= DOOR_TOGGLE) ) {

      self.use = light_use;
      if ( (self.spawnflags & START_OFF) ) {

         lightstyle (self.style,"a");

      } else {

         lightstyle (self.style,"m");

      }

   }

};

void () light_fluoro = {

   if ( (self.style >= DOOR_TOGGLE) ) {

      self.use = light_use;
      if ( (self.spawnflags & START_OFF) ) {

         lightstyle (self.style,"a");

      } else {

         lightstyle (self.style,"m");

      }

   }
   precache_sound ("ambience/fl_hum1.wav");
   ambientsound (self.origin,"ambience/fl_hum1.wav",0.500,ATTN_STATIC);

};

void () light_fluorospark = {

   if ( !self.style ) {

      self.style = TE_LAVASPLASH;

   }
   precache_sound ("ambience/buzz1.wav");
   ambientsound (self.origin,"ambience/buzz1.wav",0.500,ATTN_STATIC);

};

void () light_globe = {

   precache_model ("progs/s_light.spr");
   setmodel (self,"progs/s_light.spr");
   makestatic (self);

};

void () FireAmbient = {

   precache_sound ("ambience/fire1.wav");
   ambientsound (self.origin,"ambience/fire1.wav",0.500,ATTN_STATIC);

};

void () light_torch_small_walltorch = {

   precache_model ("progs/flame.mdl");
   setmodel (self,"progs/flame.mdl");
   FireAmbient ();
   makestatic (self);

};

void () light_flame_large_yellow = {

   precache_model ("progs/flame2.mdl");
   setmodel (self,"progs/flame2.mdl");
   self.frame = WEAPON_SHOTGUN;
   FireAmbient ();
   makestatic (self);

};

void () light_flame_small_yellow = {

   precache_model ("progs/flame2.mdl");
   setmodel (self,"progs/flame2.mdl");
   FireAmbient ();
   makestatic (self);

};

void () light_flame_small_white = {

   precache_model ("progs/flame2.mdl");
   setmodel (self,"progs/flame2.mdl");
   FireAmbient ();
   makestatic (self);

};

void () fire_fly;

void () fire_touch;

void() misc_fireball =
{
	
	precache_model ("progs/lavaball.mdl");
	self.classname = "fireball";
	self.nextthink = time + (random() * 5);
	self.think = fire_fly;
	if (!self.speed)
		self.speed == 1000;
};

void () fire_fly = {

   local entity fireball;

   fireball = spawn ();
   fireball.solid = SOLID_TRIGGER;
   fireball.movetype = MOVETYPE_TOSS;
   fireball.velocity = '0.000 0.000 1000.000';
   fireball.velocity_x = ((random () * 100.000) - COST);
   fireball.velocity_y = ((random () * 100.000) - COST);
   fireball.velocity_z = (self.speed + (random () * 200.000));
   fireball.classname = "fireball";
   setmodel (fireball,"progs/lavaball.mdl");
   setsize (fireball,VEC_ORIGIN,VEC_ORIGIN);
   setorigin (fireball,self.origin);
   fireball.nextthink = (time + TE_LIGHTNING1);
   fireball.think = SUB_Remove;
   fireball.touch = fire_touch;
   self.nextthink = ((time + (random () * TE_LIGHTNING1)) + AS_MELEE);
   self.think = fire_fly;

};

void () fire_touch = {

   T_Damage (other,self,self,20.000);
   remove (self);

};

void () barrel_explode = {

   self.takedamage = DAMAGE_NO;
   self.classname = "explo_box";
   T_RadiusDamage (self,self,160.000,world);
   sound (self,CHAN_VOICE,"weapons/r_exp3.wav",WEAPON_SHOTGUN,ATTN_NORM);
   particle (self.origin,VEC_ORIGIN,75.000,255.000);
   self.origin_z = (self.origin_z + DOOR_TOGGLE);
   BecomeExplosion ();

};

void () misc_explobox = {

   local float oldz;

   self.solid = SOLID_BBOX;
   self.movetype = MOVETYPE_NONE;
   precache_model ("maps/b_explob.bsp");
   setmodel (self,"maps/b_explob.bsp");
   precache_sound ("weapons/r_exp3.wav");
   self.health = 20.000;
   self.th_die = barrel_explode;
   self.takedamage = DAMAGE_AIM;
   self.origin_z = (self.origin_z + WEAPON_ROCKET);
   oldz = self.origin_z;
   droptofloor ();
   if ( ((oldz - self.origin_z) > 250.000) ) {

      dprint ("item fell out of level at ");
      dprint (vtos (self.origin));
      dprint ("\n");
      remove (self);

   }

};

void () misc_explobox2 = {

   local float oldz;

   self.solid = SOLID_BBOX;
   self.movetype = MOVETYPE_NONE;
   precache_model2 ("maps/b_exbox2.bsp");
   setmodel (self,"maps/b_exbox2.bsp");
   precache_sound ("weapons/r_exp3.wav");
   self.health = 20.000;
   self.th_die = barrel_explode;
   self.takedamage = DAMAGE_AIM;
   self.origin_z = (self.origin_z + WEAPON_ROCKET);
   oldz = self.origin_z;
   droptofloor ();
   if ( ((oldz - self.origin_z) > 250.000) ) {

      dprint ("item fell out of level at ");
      dprint (vtos (self.origin));
      dprint ("\n");
      remove (self);

   }

};
float SPAWNFLAG_SUPERSPIKE    = 1.000;
float SPAWNFLAG_LASER    = 2.000;

void () spikeshooter_use = {

   if ( (self.spawnflags & SPAWNFLAG_LASER) ) {

      sound (self,CHAN_VOICE,"enforcer/enfire.wav",WEAPON_SHOTGUN,ATTN_NORM);
      LaunchLaser (self.origin,self.movedir);

   } else {

      sound (self,CHAN_VOICE,"weapons/spike2.wav",WEAPON_SHOTGUN,ATTN_NORM);
      launch_spike (self.origin,self.movedir);
      newmis.velocity = (self.movedir * 500.000);
      if ( (self.spawnflags & SPAWNFLAG_SUPERSPIKE) ) {

         newmis.touch = superspike_touch;

      }

   }

};

void () shooter_think = {

   spikeshooter_use ();
   self.nextthink = (time + self.wait);
   newmis.velocity = (self.movedir * 500.000);

};

void () trap_spikeshooter = {

   SetMovedir ();
   self.use = spikeshooter_use;
   if ( (self.spawnflags & SPAWNFLAG_LASER) ) {

      precache_model2 ("progs/laser.mdl");
      precache_sound2 ("enforcer/enfire.wav");
      precache_sound2 ("enforcer/enfstop.wav");

   } else {

      precache_sound ("weapons/spike2.wav");

   }

};

void () trap_shooter = {

   trap_spikeshooter ();
   if ( (self.wait == Kick_em) ) {

      self.wait = WEAPON_SHOTGUN;

   }
   self.nextthink = ((self.nextthink + self.wait) + self.ltime);
   self.think = shooter_think;

};

void () make_bubbles;

void () bubble_remove;

void () air_bubbles = {

   if ( deathmatch ) {

      remove (self);
      return ;

   }
   precache_model ("progs/s_bubble.spr");
   self.nextthink = (time + WEAPON_SHOTGUN);
   self.think = make_bubbles;

};

void () make_bubbles = {

   local entity bubble;

   bubble = spawn ();
   setmodel (bubble,"progs/s_bubble.spr");
   setorigin (bubble,self.origin);
   bubble.movetype = MOVETYPE_NOCLIP;
   bubble.solid = SOLID_NOT;
   bubble.velocity = '0.000 0.000 15.000';
   bubble.nextthink = (time + 0.500);
   bubble.think = bubble_bob;
   bubble.touch = bubble_remove;
   bubble.classname = "bubble";
   bubble.frame = Kick_em;
   bubble.cnt = Kick_em;
   setsize (bubble,'-8.000 -8.000 -8.000','8.000 8.000 8.000');
   self.nextthink = ((time + random ()) + 0.500);
   self.think = make_bubbles;

};

void () bubble_split = {

   local entity bubble;

   bubble = spawn ();
   setmodel (bubble,"progs/s_bubble.spr");
   setorigin (bubble,self.origin);
   bubble.movetype = MOVETYPE_NOCLIP;
   bubble.solid = SOLID_NOT;
   bubble.velocity = self.velocity;
   bubble.nextthink = (time + 0.500);
   bubble.think = bubble_bob;
   bubble.touch = bubble_remove;
   bubble.classname = "bubble";
   bubble.frame = WEAPON_SHOTGUN;
   bubble.cnt = TE_LAVASPLASH;
   setsize (bubble,'-8.000 -8.000 -8.000','8.000 8.000 8.000');
   self.frame = WEAPON_SHOTGUN;
   self.cnt = TE_LAVASPLASH;
   if ( (self.waterlevel != AS_MELEE) ) {

      remove (self);

   }

};

void () bubble_remove = {

   if ( (other.classname == self.classname) ) {

      return ;

   }
   remove (self);

};

void () bubble_bob = {

   local float rnd1;
   local float rnd2;
   local float rnd3;
   local vector vtmp1;
   local vector modi;

   self.cnt = (self.cnt + WEAPON_SHOTGUN);
   if ( (self.classname == "bubble") ) {

      if ( (self.cnt == DOOR_DONT_LINK) ) {

         bubble_split ();

      }
      if ( (self.cnt == 20.000) ) {

         remove (self);

      }

   } else {

      if ( (((self.cnt == COST) && (self.classname != "player")) && (self.classname != "bodyque")) ) {

         remove (self);

      }

   }
   rnd1 = (self.velocity_x + (-10.000 + (random () * 20.000)));
   rnd2 = (self.velocity_y + (-10.000 + (random () * 20.000)));
   rnd3 = ((self.velocity_z + TE_LAVASPLASH) + (random () * TE_LAVASPLASH));
   if ( (rnd1 > TE_LAVASPLASH) ) {

      rnd1 = TE_LIGHTNING1;

   }
   if ( (rnd1 < -10.000) ) {

      rnd1 = CONTENT_LAVA;

   }
   if ( (rnd2 > TE_LAVASPLASH) ) {

      rnd2 = TE_LIGHTNING1;

   }
   if ( (rnd2 < -10.000) ) {

      rnd2 = CONTENT_LAVA;

   }
   if ( (rnd3 < TE_LAVASPLASH) ) {

      rnd3 = SEC;

   }
   if ( (rnd3 > SVC_INTERMISSION) ) {

      rnd3 = 25.000;

   }
   self.velocity_x = rnd1;
   self.velocity_y = rnd2;
   self.velocity_z = rnd3;
   self.nextthink = (time + 0.500);
   self.think = bubble_bob;

};

void () viewthing = {

   self.movetype = MOVETYPE_NONE;
   self.solid = SOLID_NOT;
   precache_model ("progs/player.mdl");
   setmodel (self,"progs/player.mdl");

};

void () func_wall_use = {

   self.frame = (SPAWNFLAG_SUPERSPIKE - self.frame);

};

void () func_wall = {

   self.angles = VEC_ORIGIN;
   self.movetype = MOVETYPE_PUSH;
   self.solid = SOLID_BSP;
   self.use = func_wall_use;
   setmodel (self,self.model);

};

void () func_illusionary = {

   self.angles = VEC_ORIGIN;
   self.movetype = MOVETYPE_NONE;
   self.solid = SOLID_NOT;
   setmodel (self,self.model);
   makestatic ();

};

void () func_episodegate = {

   if ( !(serverflags & self.spawnflags) ) {

      return ;

   }
   self.angles = VEC_ORIGIN;
   self.movetype = MOVETYPE_PUSH;
   self.solid = SOLID_BSP;
   self.use = func_wall_use;
   setmodel (self,self.model);

};

void () func_bossgate = {

   if ( ((serverflags & SEC) == SEC) ) {

      return ;

   }
   self.angles = VEC_ORIGIN;
   self.movetype = MOVETYPE_PUSH;
   self.solid = SOLID_BSP;
   self.use = func_wall_use;
   setmodel (self,self.model);

};

void () ambient_suck_wind = {

   precache_sound ("ambience/suck1.wav");
   ambientsound (self.origin,"ambience/suck1.wav",SPAWNFLAG_SUPERSPIKE,ATTN_STATIC);

};

void () ambient_drone = {

   precache_sound ("ambience/drone6.wav");
   ambientsound (self.origin,"ambience/drone6.wav",0.500,ATTN_STATIC);

};

void () ambient_flouro_buzz = {

   precache_sound ("ambience/buzz1.wav");
   ambientsound (self.origin,"ambience/buzz1.wav",SPAWNFLAG_SUPERSPIKE,ATTN_STATIC);

};

void () ambient_drip = {

   precache_sound ("ambience/drip1.wav");
   ambientsound (self.origin,"ambience/drip1.wav",0.500,ATTN_STATIC);

};

void () ambient_comp_hum = {

   precache_sound ("ambience/comp1.wav");
   ambientsound (self.origin,"ambience/comp1.wav",SPAWNFLAG_SUPERSPIKE,ATTN_STATIC);

};

void () ambient_light_buzz = {

   precache_sound ("ambience/fl_hum1.wav");
   ambientsound (self.origin,"ambience/fl_hum1.wav",0.500,ATTN_STATIC);

};

void () ambient_swamp1 = {

   precache_sound ("ambience/swamp1.wav");
   ambientsound (self.origin,"ambience/swamp1.wav",0.500,ATTN_STATIC);

};

void () ambient_swamp2 = {

   precache_sound ("ambience/swamp2.wav");
   ambientsound (self.origin,"ambience/swamp2.wav",0.500,ATTN_STATIC);

};

void () noise_think = {

   self.nextthink = (time + 0.500);
   sound (self,SPAWNFLAG_SUPERSPIKE,"enforcer/enfire.wav",SPAWNFLAG_SUPERSPIKE,ATTN_NORM);
   sound (self,WEAPON_ROCKET,"enforcer/enfstop.wav",SPAWNFLAG_SUPERSPIKE,ATTN_NORM);
   sound (self,AS_MELEE,"enforcer/sight1.wav",SPAWNFLAG_SUPERSPIKE,ATTN_NORM);
   sound (self,DOOR_DONT_LINK,"enforcer/sight2.wav",SPAWNFLAG_SUPERSPIKE,ATTN_NORM);
   sound (self,TE_LIGHTNING1,"enforcer/sight3.wav",SPAWNFLAG_SUPERSPIKE,ATTN_NORM);
   sound (self,TE_LIGHTNING2,"enforcer/sight4.wav",SPAWNFLAG_SUPERSPIKE,ATTN_NORM);
   sound (self,TE_WIZSPIKE,"enforcer/pain1.wav",SPAWNFLAG_SUPERSPIKE,ATTN_NORM);

};

void () misc_noisemaker = {

   precache_sound2 ("enforcer/enfire.wav");
   precache_sound2 ("enforcer/enfstop.wav");
   precache_sound2 ("enforcer/sight1.wav");
   precache_sound2 ("enforcer/sight2.wav");
   precache_sound2 ("enforcer/sight3.wav");
   precache_sound2 ("enforcer/sight4.wav");
   precache_sound2 ("enforcer/pain1.wav");
   precache_sound2 ("enforcer/pain2.wav");
   precache_sound2 ("enforcer/death1.wav");
   precache_sound2 ("enforcer/idle1.wav");
   self.nextthink = ((time + 0.100) + random ());
   self.think = noise_think;

};

void () rain_touch = {

   remove (self);

};

void () rain_think = {

   local float temp1;
   local float temp2;
   local vector rain_org;
   local vector rain_vel;
   local entity drop;

   rain_org = self.origin;
   temp1 = random ();
   temp2 = random ();
   if ( (temp1 < 0.500) ) {

      rain_org_x = (rain_org_x - (IT_LIGHTNING * random ()));

   } else {

      rain_org_x = (rain_org_x + (IT_LIGHTNING * random ()));

   }
   if ( (temp2 < 0.500) ) {

      rain_org_y = (rain_org_y - (IT_LIGHTNING * random ()));

   } else {

      rain_org_y = (rain_org_y + (IT_LIGHTNING * random ()));

   }
   drop = spawn ();
   setorigin (drop,rain_org);
   setmodel (drop,"progs/s_rain.spr");
   drop.classname = "raindrop";
   drop.movetype = MOVETYPE_TOSS;
   drop.solid = SOLID_BBOX;
   setsize (drop,VEC_ORIGIN,VEC_ORIGIN);
   rain_vel = VEC_ORIGIN;
   rain_vel_z = (-20.000 * random ());
   drop.touch = rain_touch;
   self.nextthink = (time + 0.500);
   self.think = rain_think;

};

void () func_rain = {

   precache_model ("progs/s_rain.spr");
   self.think = rain_think;
   self.nextthink = (time + random ());

};

void () ambient_rain = {

   precache_sound ("ambience/rain.wav");
   ambientsound (self.origin,"ambience/rain.wav",0.500,ATTN_STATIC);

};

void () ambient_rumble = {

   precache_sound ("ambience/rumble.wav");
   ambientsound (self.origin,"ambience/rumble.wav",0.500,ATTN_STATIC);

};

void () ambient_cactus = {

   precache_sound ("ambience/cactus.wav");
   ambientsound (self.origin,"ambience/cactus.wav",0.500,ATTN_STATIC);

};

void () ambient_test = {

   precache_sound ("ambience/test.wav");
   ambientsound (self.origin,"ambience/test.wav",0.500,ATTN_STATIC);

};
void () thunder_go_boom = {

   sound (self,CHAN_AUTO,"ambience/thunder1.wav",0.500,ATTN_NORM);
   self.think = thunder_go_boom;
   self.nextthink = (time + (40.000 * random ()));

};

void () ambient_thunder = {

   precache_sound ("ambience/thunder1.wav");
   self.think = thunder_go_boom;
   self.nextthink = (time + random ());

};
void () light_lantern = {

   precache_model ("progs/lantern.mdl");
   setmodel (self,"progs/lantern.mdl");
   makestatic (self);

};

void () light_candle = {

   precache_model ("progs/candle.mdl");
   setmodel (self,"progs/candle.mdl");
   makestatic (self);

};


