void () player_chain5;
void () player_chain4;
void () player_chainsound = {

   if ( (self.weapon == IT_CHAINSAW) ) {

      if ( (self.waterlevel > FL_SWIM) ) {

         self.weaponmodel = "progs/v_chain.mdl";

      }
      if ( self.button0 ) {

         if ( (self.weaponframe < MOVETYPE_WALK) ) {

            self.weaponframe = MOVETYPE_WALK;

         }

      } else {

         if ( (self.weaponframe > FL_SWIM) ) {

            self.weaponframe = TRUE;

         }

      }
      self.weaponframe = (self.weaponframe + TRUE);
      if ( (self.weaponframe == MOVETYPE_WALK) ) {

         self.weaponframe = TRUE;

      }
      if ( (self.weaponframe == MOVETYPE_FLY) ) {

         self.weaponframe = MOVETYPE_WALK;

      }
      self.chainsound = (self.chainsound - TRUE);
      if ( (self.chainsound < TRUE) ) {

         sound (self,CHAN_WEAPON,"weapons/saw2.wav",TRUE,ATTN_NORM);
         self.chainsound = (FL_SWIM + (random () * FL_SWIM));

      }

   } else {

      if ( (self.weapon == IT_AXE) ) {

/*         if ( (self.waterlevel > FL_SWIM) ) {

            self.weaponmodel = "progs/v_light.mdl";

         }*/
         self.chainsound = (self.chainsound - TRUE);
         if ( (self.chainsound < TRUE) ) {

            if ( ((random () < 0.100) || (self.owner.button0 && (random () < 0.300))) ) {

               sound (self,CHAN_WEAPON,"weapons/saberhup.wav",WEAPON_SHOTGUN,ATTN_NORM);

            } else {

               sound (self,CHAN_WEAPON,"weapons/saberhum.wav",WEAPON_SHOTGUN,ATTN_NORM);

            }
            self.chainsound = (FL_SWIM + (random () * FL_SWIM));

         }

      }

   }

};

void () player_stand1 = [ 17.000, player_stand1 ] {

   self.player_dead = Kick_em;
   self.weaponframe = Kick_em;
   if ( (self.velocity_x || self.velocity_y) ) {

      self.walkframe = Kick_em;
      player_run ();
      return ;

   }
   if ( ((self.weapon == IT_AXE) || (self.weapon == IT_MORNINGSTAR)) ) {

      if ( (self.walkframe >= 12.000) ) {

         self.walkframe = Kick_em;

      }
      self.frame = (17.000 + self.walkframe);

   } else {

      if ( (self.walkframe >= TE_LIGHTNING1) ) {

         self.walkframe = Kick_em;

      }
      self.frame = (12.000 + self.walkframe);

   }
   player_chainsound ();
   self.walkframe = (self.walkframe + WEAPON_SHOTGUN);

};

void () player_run = [ 6.000, player_run ] {

   self.weaponframe = Kick_em;
   if ( (!self.velocity_x && !self.velocity_y) ) {

      self.walkframe = Kick_em;
      player_stand1 ();
      return ;

   }
   if ( ((self.weapon == IT_AXE) || (self.weapon == IT_MORNINGSTAR)) ) {

      if ( (self.walkframe == TE_LIGHTNING2) ) {

         self.walkframe = Kick_em;

      }
      self.frame = (Kick_em + self.walkframe);

   } else {

      if ( (self.walkframe == TE_LIGHTNING2) ) {

         self.walkframe = Kick_em;

      }
      self.frame = (self.frame + self.walkframe);

   }
   self.walkframe = (self.walkframe + WEAPON_SHOTGUN);
   player_chainsound ();

};

void () player_shot1 = [ 113.000, player_shot2 ] {

   self.weaponframe = WEAPON_SHOTGUN;
   self.effects = (self.effects | EF_MUZZLEFLASH);

};

void () player_shot2 = [ 114.000, player_shot3 ] {

   self.weaponframe = WEAPON_ROCKET;

};

void () player_shot3 = [ 115.000, player_shot4 ] {

   self.weaponframe = AS_MELEE;

};

void () player_shot4 = [ 116.000, player_shot5 ] {

   self.weaponframe = WEAPON_SPIKES;

};

void () player_shot5 = [ 117.000, player_shot6 ] {

   self.weaponframe = TE_LIGHTNING1;

};

void () player_shot6 = [ 118.000, player_run ] {

   self.weaponframe = TE_LIGHTNING2;

};

void () player_tax1 = [ 119.000, player_tax2 ] {

   self.weaponframe = WEAPON_SHOTGUN;

};

void () player_tax2 = [ 120.000, player_tax3 ] {

   self.weaponframe = WEAPON_ROCKET;

};

void () player_tax3 = [ 121.000, player_tax4 ] {

   self.weaponframe = AS_MELEE;
   W_ThrowAxe ();

};

void () player_tax4 = [ 122.000, player_run ] {

   self.weaponframe = WEAPON_SPIKES;

};

void () player_axe1 = [ 119.000, player_axe2 ] {

   self.weaponframe = WEAPON_SHOTGUN;

};

void () player_axe2 = [ 120.000, player_axe3 ] {

   self.weaponframe = WEAPON_ROCKET;

};

void () player_axe3 = [ 121.000, player_axe4 ] {

   self.weaponframe = AS_MELEE;
   W_FireAxe ();

};

void () player_axe4 = [ 122.000, player_run ] {

   self.weaponframe = WEAPON_SPIKES;

};

void () player_axeb1 = [ 125.000, player_axeb2 ] {

   self.weaponframe = TE_LIGHTNING1;

};

void () player_axeb2 = [ 126.000, player_axeb3 ] {

   self.weaponframe = TE_LIGHTNING2;

};

void () player_axeb3 = [ 127.000, player_axeb4 ] {

   self.weaponframe = TE_WIZSPIKE;
   W_FireAxe ();

};

void () player_axeb4 = [ 128.000, player_run ] {

   self.weaponframe = WEAPON_BIG;

};

void () player_axec1 = [ 131.000, player_axec2 ] {

   self.weaponframe = WEAPON_SHOTGUN;

};

void () player_axec2 = [ 132.000, player_axec3 ] {

   self.weaponframe = WEAPON_ROCKET;

};

void () player_axec3 = [ 133.000, player_axec4 ] {

   self.weaponframe = AS_MELEE;
   W_FireAxe ();

};

void () player_axec4 = [ 134.000, player_run ] {

   self.weaponframe = WEAPON_SPIKES;

};

void () player_axed1 = [ 137.000, player_axed2 ] {

   self.weaponframe = TE_LIGHTNING1;

};

void () player_axed2 = [ 138.000, player_axed3 ] {

   self.weaponframe = TE_LIGHTNING2;

};

void () player_axed3 = [ 139.000, player_axed4 ] {

   self.weaponframe = TE_WIZSPIKE;
   W_FireAxe ();

};

void () player_axed4 = [ 140.000, player_run ] {

   self.weaponframe = WEAPON_BIG;

};

void () player_chainsaw1 = [ 119.000, player_chainsaw2 ] {

   player_chainsound ();

};

void () player_chainsaw2 = [ 120.000, player_run ] {

   player_chainsound ();

};

void () player_chain1 = [ 137.000, player_chain2 ] {

   self.weaponframe = WEAPON_ROCKET;

};

void () player_chain2 = [ 138.000, player_chain3 ] {

   self.weaponframe = AS_MELEE;
   W_FireChain ();

};

void () player_chain3 = [ 139.000, player_chain3 ] {

   self.weaponframe = AS_MELEE;
   if ( !self.hook_out ) {

      player_chain5 ();
      return ;

   }
   if ( (vlen (self.velocity) >= 750.000) ) {

      player_chain4 ();
      return ;

   }

};

void () player_chain4 = [ 73.000, player_chain4 ] {

   self.weaponframe = WEAPON_SPIKES;
   if ( !self.hook_out ) {

      player_chain5 ();
      return ;

   }
   if ( (vlen (self.velocity) < 750.000) ) {

      player_chain3 ();
      return ;

   }

};

void () player_chain5 = [ 140.000, player_run ] {

   self.weaponframe = TE_LIGHTNING1;

};

void () player_nail1 = [ 103.000, player_nail2 ] {

   self.effects = (self.effects | EF_MUZZLEFLASH);
   if ( !self.button0 ) {

      player_run ();
      return ;

   }
   self.weaponframe = (self.weaponframe + WEAPON_SHOTGUN);
   if ( (self.weaponframe == TE_LIGHTNING3) ) {

      self.weaponframe = WEAPON_SHOTGUN;

   }
   SuperDamageSound ();
   W_FireSpikes (WEAPON_SPIKES);
               if (speedup == 1) self.attack_finished = time;
               else self.attack_finished = (time + 0.200);

};

void () player_nail2 = [ 104.000, player_nail1 ] {

   self.effects = (self.effects | EF_MUZZLEFLASH);
   if ( !self.button0 ) {

      player_run ();
      return ;

   }
   self.weaponframe = (self.weaponframe + WEAPON_SHOTGUN);
   if ( (self.weaponframe == TE_LIGHTNING3) ) {

      self.weaponframe = WEAPON_SHOTGUN;

   }
   SuperDamageSound ();
   W_FireSpikes (CONTENT_SLIME);
               if (speedup == 1) self.attack_finished = time;
               else self.attack_finished = (time + 0.200);

};

void () player_light1 = [ 105.000, player_light2 ] {

   self.effects = (self.effects | EF_MUZZLEFLASH);
   if ( !self.button0 ) {

      player_run ();
      return ;

   }
   self.weaponframe = (self.weaponframe + WEAPON_SHOTGUN);
   if ( (self.weaponframe == TE_LIGHTNING1) ) {

      self.weaponframe = WEAPON_SHOTGUN;

   }
   SuperDamageSound ();
   W_FireLightning ();
   self.attack_finished = (time + 0.200);

};

void () player_light2 = [ 106.000, player_light1 ] {

   self.effects = (self.effects | EF_MUZZLEFLASH);
   if ( !self.button0 ) {

      player_run ();
      return ;

   }
   self.weaponframe = (self.weaponframe + WEAPON_SHOTGUN);
   if ( (self.weaponframe == TE_LIGHTNING1) ) {

      self.weaponframe = WEAPON_SHOTGUN;

   }
   SuperDamageSound ();
   W_FireLightning ();
   self.attack_finished = (time + 0.200);

};

void () player_rocket1 = [ 107.000, player_rocket2 ] {

   self.weaponframe = WEAPON_SHOTGUN;
   self.effects = (self.effects | EF_MUZZLEFLASH);

};

void () player_rocket2 = [ 108.000, player_rocket3 ] {

   self.weaponframe = WEAPON_ROCKET;

};

void () player_rocket3 = [ 109.000, player_rocket4 ] {

   self.weaponframe = AS_MELEE;

};

void () player_rocket4 = [ 110.000, player_rocket5 ] {

   self.weaponframe = WEAPON_SPIKES;

};

void () player_rocket5 = [ 111.000, player_rocket6 ] {

   self.weaponframe = TE_LIGHTNING1;

};

void () player_rocket6 = [ 112.000, player_run ] {

   self.weaponframe = TE_LIGHTNING2;

};

void (float num_bubbles) DeathBubbles;

void () player_laser1 = [ 0.000, player_laser2 ] {

   self.effects = (self.effects | EF_MUZZLEFLASH);
   if ( !self.button0 ) {

      player_run ();
      return ;

   }
   self.weaponframe = WEAPON_SHOTGUN;
   if ( (self.weaponframe == TE_LIGHTNING1) ) {

      self.weaponframe = WEAPON_SHOTGUN;

   }
   SuperDamageSound ();
   W_FireLaser ();
   self.attack_finished = (time + 0.200);

};

void () player_laser2 = [ 0.000, player_laser1 ] {

   self.effects = (self.effects | EF_MUZZLEFLASH);
   if ( !self.button0 ) {

      player_run ();
      return ;

   }
   self.weaponframe = (self.weaponframe + WEAPON_SHOTGUN);
   if ( (self.weaponframe == TE_LIGHTNING1) ) {

      self.weaponframe = WEAPON_ROCKET;

   }
   SuperDamageSound ();
   W_FireLaser ();
   self.attack_finished = (time + 0.200);

};

void () PainSound = {

   local float rs;
   local float which_hit;

   if ( (self.health < Kick_em) ) {

      return ;

   }
   if ( (damage_attacker.classname == "teledeath") ) {

      sound (self,CHAN_VOICE,"player/teledth1.wav",WEAPON_SHOTGUN,ATTN_NONE);
      return ;

   }
   if ( ((self.watertype == CONTENT_WATER) && (self.waterlevel == AS_MELEE)) ) {

      DeathBubbles (WEAPON_SHOTGUN);
      if ( (random () > CAMPER_HEALTH_PERCENT) ) {

         sound (self,CHAN_VOICE,"player/drown1.wav",WEAPON_SHOTGUN,ATTN_NORM);

      } else {

         sound (self,CHAN_VOICE,"player/drown2.wav",WEAPON_SHOTGUN,ATTN_NORM);

      }
      return ;

   }
   if ( (self.watertype == CONTENT_SLIME) ) {

      if ( (random () > CAMPER_HEALTH_PERCENT) ) {

         sound (self,CHAN_VOICE,"player/lburn1.wav",WEAPON_SHOTGUN,ATTN_NORM);

      } else {

         sound (self,CHAN_VOICE,"player/lburn2.wav",WEAPON_SHOTGUN,ATTN_NORM);

      }
      return ;

   }
   if ( (self.watertype == CONTENT_LAVA) ) {

      if ( (random () > CAMPER_HEALTH_PERCENT) ) {

         sound (self,CHAN_VOICE,"player/lburn1.wav",WEAPON_SHOTGUN,ATTN_NORM);

      } else {

         sound (self,CHAN_VOICE,"player/lburn2.wav",WEAPON_SHOTGUN,ATTN_NORM);

      }
      return ;

   }
   if ( (self.pain_finished > time) ) {

      self.axhitme = Kick_em;
      return ;

   }
   self.pain_finished = (time + CAMPER_HEALTH_PERCENT);
   if ( (self.axhitme == WEAPON_SHOTGUN) ) {

      self.axhitme = Kick_em;
      which_hit = random ();
      if ( (which_hit < 0.330) ) {

         sound (self,CHAN_VOICE,"weapons/taxhit1.wav",WEAPON_SHOTGUN,ATTN_NORM);

      } else {

         if ( (which_hit < 0.660) ) {

            sound (self,CHAN_VOICE,"weapons/taxhit2.wav",WEAPON_SHOTGUN,ATTN_NORM);

         } else {

            sound (self,CHAN_VOICE,"weapons/taxhit3.wav",WEAPON_SHOTGUN,ATTN_NORM);

         }

      }
      return ;

   }
   rs = rint (((random () * TE_LIGHTNING1) + WEAPON_SHOTGUN));
   self.noise = "";
   if ( (rs == WEAPON_SHOTGUN) ) {

      self.noise = "player/pain1.wav";

   } else {

      if ( (rs == WEAPON_ROCKET) ) {

         self.noise = "player/pain2.wav";

      } else {

         if ( (rs == AS_MELEE) ) {

            self.noise = "player/pain3.wav";

         } else {

            if ( (rs == WEAPON_SPIKES) ) {

               self.noise = "player/pain4.wav";

            } else {

               if ( (rs == TE_LIGHTNING1) ) {

                  self.noise = "player/pain5.wav";

               } else {

                  self.noise = "player/pain6.wav";

               }

            }

         }

      }

   }
   sound (self,CHAN_VOICE,self.noise,WEAPON_SHOTGUN,ATTN_NORM);
   return ;

};

void () player_pain1 = [ 35.000, player_pain2 ] {

   PainSound ();
   self.weaponframe = Kick_em;

};

void () player_pain2 = [ 36.000, player_pain3 ] {


};

void () player_pain3 = [ 37.000, player_pain4 ] {


};

void () player_pain4 = [ 38.000, player_pain5 ] {


};

void () player_pain5 = [ 39.000, player_pain6 ] {


};

void () player_pain6 = [ 40.000, player_run ] {


};

void () player_axpain1 = [ 29.000, player_axpain2 ] {

   PainSound ();
   self.weaponframe = Kick_em;

};

void () player_axpain2 = [ 30.000, player_axpain3 ] {


};

void () player_axpain3 = [ 31.000, player_axpain4 ] {


};

void () player_axpain4 = [ 32.000, player_axpain5 ] {


};

void () player_axpain5 = [ 33.000, player_axpain6 ] {


};

void () player_axpain6 = [ 34.000, player_run ] {


};

void () player_pain = {

   if ( self.weaponframe ) {

      return ;

   }
   if ( (self.invisible_finished > time) ) {

      return ;

   }
   if ( (extra_goodies == WEAPON_SHOTGUN) ) {

      CorpsePain ();

   }
   if ( ((self.weapon == IT_AXE) || (self.weapon == IT_MORNINGSTAR)) ) {

      player_axpain1 ();

   } else {

      player_pain1 ();

   }

};

void () player_diea1;

void () player_dieb1;

void () player_diec1;

void () player_died1;

void () player_diee1;

void () player_die_ax1;

void () DeathBubblesSpawn = {

   local entity bubble;

   if ( (self.owner.waterlevel != AS_MELEE) ) {

      return ;

   }
   bubble = spawn ();
   setmodel (bubble,"progs/s_bubble.spr");
   setorigin (bubble,(self.owner.origin + '0.000 0.000 24.000'));
   bubble.movetype = MOVETYPE_NOCLIP;
   bubble.solid = SOLID_NOT;
   bubble.velocity = '0.000 0.000 15.000';
   bubble.nextthink = (time + CAMPER_HEALTH_PERCENT);
   bubble.think = bubble_bob;
   bubble.classname = "bubble";
   bubble.frame = Kick_em;
   bubble.cnt = Kick_em;
   setsize (bubble,'-8.000 -8.000 -8.000','8.000 8.000 8.000');
   self.nextthink = (time + 0.100);
   self.think = DeathBubblesSpawn;
   self.air_finished = (self.air_finished + WEAPON_SHOTGUN);
   if ( (self.air_finished >= self.bubble_count) ) {

      remove (self);

   }

};

void (float num_bubbles) DeathBubbles = {

   local entity bubble_spawner;

   bubble_spawner = spawn ();
   setorigin (bubble_spawner,self.origin);
   bubble_spawner.movetype = MOVETYPE_NONE;
   bubble_spawner.solid = SOLID_NOT;
   bubble_spawner.nextthink = (time + 0.100);
   bubble_spawner.think = DeathBubblesSpawn;
   bubble_spawner.air_finished = Kick_em;
   bubble_spawner.owner = self;
   bubble_spawner.bubble_count = num_bubbles;
   return ;

};

void () DeathSound = {

   local float rs;

   if ( (self.waterlevel == AS_MELEE) ) {

      DeathBubbles (20.000);
      sound (self,CHAN_VOICE,"player/h2odeath.wav",WEAPON_SHOTGUN,ATTN_NONE);
      return ;

   }
   rs = rint (((random () * TE_LIGHTNING2) + CAMPER_CHECK));
   if ( (rs == CAMPER_CHECK) ) {

      self.noise = "player/death1.wav";

   }
   if ( (rs == WEAPON_ROCKET) ) {

      self.noise = "player/death2.wav";

   }
   if ( (rs == AS_MELEE) ) {

      self.noise = "player/death3.wav";

   }
   if ( (rs == WEAPON_SPIKES) ) {

      self.noise = "player/death4.wav";

   }
   if ( (rs == TE_LIGHTNING1) ) {

      self.noise = "player/death5.wav";

   }
   if ( (rs == TE_LIGHTNING2) ) {

      self.noise = "player/death6.wav";

   }
   if ( (rs == TE_WIZSPIKE) ) {

      self.noise = "player/death7.wav";

   }
   sound (self,CHAN_VOICE,self.noise,WEAPON_SHOTGUN,ATTN_NONE);
   return ;

};

void () PlayerDead = {

   self.nextthink = CONTENT_EMPTY;
   self.deadflag = DEAD_DEAD;

};
vector (float dm) VelocityForDamage = {

   local vector v;

   v_x = (100.000 * crandom ());
   v_y = (100.000 * crandom ());
   v_z = (CAMPER_DISTANCE + (100.000 * random ()));
   if ( (dm > -50.000) ) {

      v = (v * 0.700);

   } else {

      if ( (dm > -200.000) ) {

         v = (v * WEAPON_ROCKET);

      } else {

         v = (v * TE_LAVASPLASH);

      }

   }
   return ( v );

};

void (string gibname, float dm) ThrowGib = {

   local entity new;

   new = spawn ();
   new.origin = self.origin;
   setmodel (new,gibname);
   setsize (new,VEC_ORIGIN,VEC_ORIGIN);
   new.velocity = VelocityForDamage (dm);
   new.movetype = MOVETYPE_BOUNCE;
   new.solid = SOLID_NOT;
   new.avelocity_x = (random () * 600.000);
   new.avelocity_y = (random () * 600.000);
   new.avelocity_z = (random () * 600.000);
   new.think = SUB_Remove;
   new.ltime = time;
   new.nextthink = ((time + TE_LAVASPLASH) + (random () * TE_LAVASPLASH));
   new.frame = Kick_em;
   new.flags = Kick_em;

};

void (string gibname, float dm) ThrowHead = {

   setmodel (self,gibname);
   self.frame = Kick_em;
   self.nextthink = CONTENT_EMPTY;
   self.movetype = MOVETYPE_BOUNCE;
   self.takedamage = DAMAGE_NO;
   if ( ((extra_goodies == Kick_em) || (self.classname != "player")) ) {

      self.solid = SOLID_NOT;

   }
   self.view_ofs = '0.000 0.000 8.000';
   setsize (self,'-16.000 -16.000 0.000','16.000 16.000 56.000');
   self.velocity = VelocityForDamage (dm);
   self.origin_z = (self.origin_z - 24.000);
   self.flags = (self.flags - (self.flags & FL_ONGROUND));
   self.avelocity = (crandom () * '0.000 600.000 0.000');

};

void () GibPlayer = {

   if ( !(mapname == "start") ) {

      ThrowHead ("progs/h_player.mdl",self.health);
      ThrowGib ("progs/eyes.mdl",self.health);
      ThrowGib ("progs/gib1.mdl",self.health);
      ThrowGib ("progs/bone.mdl",self.health);
      ThrowGib ("progs/gib2.mdl",self.health);
      ThrowGib ("progs/gib2.mdl",self.health);
      ThrowGib ("progs/gib4.mdl",self.health);
      ThrowGib ("progs/bone.mdl",self.health);
      ThrowGib ("progs/gib2.mdl",self.health);
      ThrowGib ("progs/gib4.mdl",self.health);
      ThrowGib ("progs/gib5.mdl",self.health);
      ThrowGib ("progs/gib6.mdl",self.health);
      ThrowGib ("progs/bone.mdl",self.health);
      ThrowGib ("progs/gib4.mdl",self.health);
      ThrowGib ("progs/bone.mdl",self.health);
      ThrowGib ("progs/gib6.mdl",self.health);
      ThrowGib ("progs/gib4.mdl",self.health);
      ThrowGib ("progs/gib5.mdl",self.health);
      ThrowGib ("progs/bone.mdl",self.health);
      ThrowGib ("progs/gib2.mdl",self.health);
      ThrowGib ("progs/bone.mdl",self.health);
      ThrowGib ("progs/gib3.mdl",self.health);
      ThrowGib ("progs/gib5.mdl",self.health);
      ThrowGib ("progs/gib3.mdl",self.health);
      ThrowGib ("progs/bone.mdl",self.health);
      ThrowGib ("progs/skull.mdl",self.health);
      ThrowGib ("progs/spine.mdl",self.health);
   }
   self.deadflag = DEAD_DEAD;
   if ( (damage_attacker.classname == "teledeath") ) {

      sound (self,CHAN_VOICE,"player/teledth1.wav",WEAPON_SHOTGUN,ATTN_NONE);
      return ;

   }
   if ( (damage_attacker.classname == "teledeath2") ) {

      sound (self,CHAN_VOICE,"player/teledth1.wav",WEAPON_SHOTGUN,ATTN_NONE);
      return ;

   }
   if ( (random () < CAMPER_HEALTH_PERCENT) ) {

      sound (self,CHAN_VOICE,"player/gib1.wav",WEAPON_SHOTGUN,ATTN_NONE);

   } else {

      sound (self,CHAN_VOICE,"player/gib2.wav",WEAPON_SHOTGUN,ATTN_NONE);

   }

};

void () PlayerDie = {

   local float i;
   local float bios;

   bios = Kick_em;
   if ( (self.radsuit_finished > Kick_em) ) {

      bios = WEAPON_SHOTGUN;

   }
   self.items = (self.items - (self.items & IT_INVISIBILITY));
   self.invisible_finished = Kick_em;
   self.invincible_finished = Kick_em;
   self.super_damage_finished = Kick_em;
   self.radsuit_finished = Kick_em;
   self.modelindex = modelindex_player;
   if ( (deathmatch || coop) ) {

      DropBackpack ();

   }
   self.weaponmodel = "";
   self.view_ofs = '0.000 0.000 -8.000';
   self.deadflag = DEAD_DYING;
   if ( (extra_goodies == Kick_em) ) {

      self.solid = SOLID_NOT;

   }
   self.flags = (self.flags - (self.flags & FL_ONGROUND));
   self.movetype = MOVETYPE_TOSS;
   if ( (self.velocity_z < TE_LAVASPLASH) ) {

      self.velocity_z = (self.velocity_z + (random () * 300.000));

   }
   if ( (self.health < -40.000) ) {

      if ( (bios == WEAPON_SHOTGUN) ) {

         self.skin = self.skin_tmp;
         bios = Kick_em;

      }
      GibPlayer ();
      return ;

   }
   DeathSound ();
   self.angles_x = Kick_em;
   self.angles_z = Kick_em;
   if ( ((self.weapon == IT_AXE) || (self.weapon == IT_MORNINGSTAR)) ) {

      player_die_ax1 ();
      return ;

   }
   i = cvar ("temp1");
   if ( !i ) {

      i = (WEAPON_SHOTGUN + floor ((random () * TE_LIGHTNING2)));

   }
   if ( (i == WEAPON_SHOTGUN) ) {

      player_diea1 ();

   } else {

      if ( (i == WEAPON_ROCKET) ) {

         player_dieb1 ();

      } else {

         if ( (i == AS_MELEE) ) {

            player_diec1 ();

         } else {

            if ( (i == WEAPON_SPIKES) ) {

               player_died1 ();

            } else {

               player_diee1 ();

            }

         }

      }

   }
   if ( (bios == WEAPON_SHOTGUN) ) {

      self.skin = self.skin_tmp;
      bios = Kick_em;

   }

};

void () set_suicide_frame = {

   if ( (self.model != "progs/player.mdl") ) {

      return ;

   }
   self.frame = VOTEEXIT_TIME_LIMIT;
   self.solid = SOLID_NOT;
   self.movetype = MOVETYPE_TOSS;
   self.deadflag = DEAD_DEAD;
   self.nextthink = CONTENT_EMPTY;

};

void () player_diea1 = [ 50.000, player_diea2 ] {


};

void () player_diea2 = [ 51.000, player_diea3 ] {


};

void () player_diea3 = [ 52.000, player_diea4 ] {


};

void () player_diea4 = [ 53.000, player_diea5 ] {


};

void () player_diea5 = [ 54.000, player_diea6 ] {


};

void () player_diea6 = [ 55.000, player_diea7 ] {


};

void () player_diea7 = [ 56.000, player_diea8 ] {


};

void () player_diea8 = [ 57.000, player_diea9 ] {


};

void () player_diea9 = [ 58.000, player_diea10 ] {


};

void () player_diea10 = [ 59.000, player_diea11 ] {


};

void () player_diea11 = [ 60.000, player_diea11 ] {

   PlayerDead ();

};

void () player_dieb1 = [ 61.000, player_dieb2 ] {


};

void () player_dieb2 = [ 62.000, player_dieb3 ] {


};

void () player_dieb3 = [ 63.000, player_dieb4 ] {


};

void () player_dieb4 = [ 64.000, player_dieb5 ] {


};

void () player_dieb5 = [ 65.000, player_dieb6 ] {


};

void () player_dieb6 = [ 66.000, player_dieb7 ] {


};

void () player_dieb7 = [ 67.000, player_dieb8 ] {


};

void () player_dieb8 = [ 68.000, player_dieb9 ] {


};

void () player_dieb9 = [ 69.000, player_dieb9 ] {

   PlayerDead ();

};

void () player_diec1 = [ 70.000, player_diec2 ] {


};

void () player_diec2 = [ 71.000, player_diec3 ] {


};

void () player_diec3 = [ 72.000, player_diec4 ] {


};

void () player_diec4 = [ 73.000, player_diec5 ] {


};

void () player_diec5 = [ 74.000, player_diec6 ] {


};

void () player_diec6 = [ 75.000, player_diec7 ] {


};

void () player_diec7 = [ 76.000, player_diec8 ] {


};

void () player_diec8 = [ 77.000, player_diec9 ] {


};

void () player_diec9 = [ 78.000, player_diec10 ] {


};

void () player_diec10 = [ 79.000, player_diec11 ] {


};

void () player_diec11 = [ 80.000, player_diec12 ] {


};

void () player_diec12 = [ 81.000, player_diec13 ] {


};

void () player_diec13 = [ 82.000, player_diec14 ] {


};

void () player_diec14 = [ 83.000, player_diec15 ] {


};

void () player_diec15 = [ 84.000, player_diec15 ] {

   PlayerDead ();

};

void () player_died1 = [ 85.000, player_died2 ] {


};

void () player_died2 = [ 86.000, player_died3 ] {


};

void () player_died3 = [ 87.000, player_died4 ] {


};

void () player_died4 = [ 88.000, player_died5 ] {


};

void () player_died5 = [ 89.000, player_died6 ] {


};

void () player_died6 = [ 90.000, player_died7 ] {


};

void () player_died7 = [ 91.000, player_died8 ] {


};

void () player_died8 = [ 92.000, player_died9 ] {


};

void () player_died9 = [ 93.000, player_died9 ] {

   PlayerDead ();

};

void () player_diee1 = [ 94.000, player_diee2 ] {


};

void () player_diee2 = [ 95.000, player_diee3 ] {


};

void () player_diee3 = [ 96.000, player_diee4 ] {


};

void () player_diee4 = [ 97.000, player_diee5 ] {


};

void () player_diee5 = [ 98.000, player_diee6 ] {


};

void () player_diee6 = [ 99.000, player_diee7 ] {


};

void () player_diee7 = [ 100.000, player_diee8 ] {


};

void () player_diee8 = [ 101.000, player_diee9 ] {


};

void () player_diee9 = [ 102.000, player_diee9 ] {

   PlayerDead ();

};

void () player_die_ax1 = [ 41.000, player_die_ax2 ] {


};

void () player_die_ax2 = [ 42.000, player_die_ax3 ] {


};

void () player_die_ax3 = [ 43.000, player_die_ax4 ] {


};

void () player_die_ax4 = [ 44.000, player_die_ax5 ] {


};

void () player_die_ax5 = [ 45.000, player_die_ax6 ] {


};

void () player_die_ax6 = [ 46.000, player_die_ax7 ] {


};

void () player_die_ax7 = [ 47.000, player_die_ax8 ] {


};

void () player_die_ax8 = [ 48.000, player_die_ax9 ] {


};

void () player_die_ax9 = [ 49.000, player_die_ax9 ] {

   PlayerDead ();

};
