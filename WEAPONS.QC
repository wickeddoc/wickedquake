void () ThrowPeel;
void() W_FireBomb;
void() BombTouch;
void() BombExplode;
void() BombExplosion;
void() ShrapnelExplode;
void() BombTime;
void() W_FireGIBGUN;
void() T_GIBTouch;
void() GIBExplode;
void() W_FireFLASH;
void() T_FlashTouch;
void() SelfDestruct;
void () new_spike_touch;

void () superspike_touch;

void () GibPlayer;

void () player_run;

void (vector org, vector vel, float damage) SpawnBlood;

void () SuperDamageSound;

void () W_ThrowAxe;

void () player_tax1;

void () W_FireFlame;

void () BurnSelf;
float Kick_em /* = 0.000 */;

void () W_Precache = {

   precache_sound ("weapons/r_exp3.wav");
   precache_sound ("weapons/rocket1i.wav");
   precache_sound ("weapons/sgun1.wav");
   precache_sound ("weapons/guncock.wav");
   precache_sound ("weapons/ric1.wav");
   precache_sound ("weapons/ric2.wav");
   precache_sound ("weapons/ric3.wav");
   precache_sound ("weapons/spike2.wav");
   precache_sound ("weapons/tink1.wav");
   precache_sound ("weapons/grenade.wav");
   precache_sound ("weapons/bounce.wav");
   precache_sound ("weapons/shotgn2.wav");

};
float /* ERROR: Could not determine return type */ () crandom = {

   return ( (AS_SLIDING * (random () - 0.500)) );

};

void () W_FireAxe = {

   local vector source;
   local vector org;

   source = (self.origin + '0.000 0.000 16.000');
   traceline (source,(source + (v_forward * IT_LIGHTNING)),FALSE,self);
   if ( (trace_fraction == 1) ) {

      return ;

   }
   org = (trace_endpos - (v_forward * WEAPON_SPIKES));
   if ( trace_ent.takedamage ) {

      trace_ent.axhitme = 1;
      SpawnBlood (org,VEC_ORIGIN,20.000);
      T_Damage (trace_ent,self,self,85.000);

   } else {

      sound (self,CHAN_WEAPON,"player/axhit2.wav",1,ATTN_NORM);
      WriteByte (MSG_BROADCAST,SVC_TEMPENTITY);
      WriteByte (MSG_BROADCAST,TE_GUNSHOT);
      WriteCoord (MSG_BROADCAST,org_x);
      WriteCoord (MSG_BROADCAST,org_y);
      WriteCoord (MSG_BROADCAST,org_z);

   }

};

void () W_FireChainsaw = {

   local vector source;
   local vector org;
   local vector dir;
   local float dam;
   local entity meat;
   local float meatcnt;

   makevectors (self.v_angle);
   source = (self.origin + '0.000 0.000 16.000');
   traceline (source,(source + (v_forward * FL_GODMODE)),FALSE,self);
   if ( (trace_fraction == TRUE) ) {

      return ;

   }
   sound (self,CHAN_WEAPON,"weapons/saw3.wav",TRUE,ATTN_NORM);
   org = (trace_endpos - (v_forward * MOVETYPE_STEP));
   self.punchangle_x = (MOVETYPE_WALK - (random () * MOVETYPE_TOSS));
   if ( trace_ent.takedamage ) {

      trace_ent.axhitme = TRUE;
      SpawnBlood (org,VEC_ORIGIN,MOVETYPE_FLY);
      meatcnt = ((random () * MOVETYPE_BOUNCE) - MOVETYPE_FLY);
      if ( (meatcnt > MOVETYPE_WALK) ) {

         self.weaponmodel = "progs/v_chainb.mdl";

      }
      while ( (meatcnt > MSG_BROADCAST) ) {

         meatcnt = (meatcnt - TRUE);
         meat = spawn ();
         meat.owner = self;
         meat.movetype = MOVETYPE_TOSS;
         meat.solid = SOLID_NOT;
         meat.velocity = ((v_up * (85.000 + (random () * 50.000))) + (v_right * ((random () * SVC_INTERMISSION) - 15.000)));
         meat.avelocity = (((v_up * ((random () * 5000.000) - 2500.000)) + (v_right * ((random () * 5000.000) - 2500.000))) + (v_forward * ((random () * 5000.000) - 2500.000)));
         meat.nextthink = (time + TRUE);
         meat.think = SUB_Remove;
         setmodel (meat,"progs/zom_gib.mdl");
         meat.frame = (random () * MOVETYPE_WALK);
         meat.frame = floor (meat.frame);
         setsize (meat,VEC_ORIGIN,VEC_ORIGIN);
         setorigin (meat,org);

      }
      dir = (trace_ent.origin - self.origin);
      dam = (40.000 - (MOVETYPE_BOUNCE * (vlen (dir) / FL_GODMODE)));
      if ( (dam < MOVETYPE_BOUNCE) ) {

         dam = MOVETYPE_BOUNCE;

      }
      if ( (self.super_damage_finished > time) ) {

         if ( (trace_ent.health < (dam * MOVETYPE_STEP)) ) {

            dam = 1000.000;

         }

      }
      T_Damage (trace_ent,self,self,dam);
      dir = normalize (dir);
      if ( (trace_ent != world) ) {

         self.velocity = (self.velocity + (dir * 300.000));

      }
      if ( (trace_ent.classname == "player") ) {

         trace_ent.velocity = (trace_ent.velocity - (dir * 300.000));

      }

   } else {

      WriteByte (MSG_BROADCAST,SVC_TEMPENTITY);
      WriteByte (MSG_BROADCAST,TE_GUNSHOT);
      WriteCoord (MSG_BROADCAST,org_x);
      WriteCoord (MSG_BROADCAST,org_y);
      WriteCoord (MSG_BROADCAST,org_z);

   }

};
vector () wall_velocity = {

   local vector vel;

   vel = normalize (self.velocity);
   vel = normalize (((vel + (v_up * (random () - 0.500))) + (v_right * (random () - 0.500))));
   vel = (vel + (AS_SLIDING * trace_plane_normal));
   vel = (vel * 200.000);
   return ( vel );

};

void (vector org, vector vel) SpawnMeatSpray = {

   local entity missile;
   local entity mpuff;

   missile = spawn ();
   missile.owner = self;
   missile.movetype = MOVETYPE_BOUNCE;
   missile.solid = SOLID_NOT;
   makevectors (self.angles);
   missile.velocity = vel;
   missile.velocity_z = ((missile.velocity_z + 250.000) + (50.000 * random ()));
   missile.avelocity = '3000.000 1000.000 2000.000';
   missile.nextthink = (time + 1);
   missile.think = SUB_Remove;
   setmodel (missile,"progs/zom_gib.mdl");
   setsize (missile,VEC_ORIGIN,VEC_ORIGIN);
   setorigin (missile,org);

};

void (vector org, vector vel, float damage) SpawnBlood = {

   particle (org,(vel * 0.200),73.000,(damage * 250000.000));
   particle (org,(vel * 0.100),73.000,(damage * 500000.000));
   particle (org,(vel * 0.300),73.000,(damage * 750000.000));

};

void (float damage) spawn_touchblood = {

   local vector vel;

   vel = (wall_velocity () * 0.200);
   SpawnBlood ((self.origin + (vel * 0.010)),vel,damage);

};

void (vector org, vector vel) SpawnChunk = {

   particle (org,(vel * 0.020),Kick_em,TE_LAVASPLASH);

};
entity multi_ent;
float multi_damage /* = 0.000 */;

void () ClearMultiDamage = {

   multi_ent = world;
   multi_damage = MSG_BROADCAST;

};

void () ApplyMultiDamage = {

   if ( !multi_ent ) {

      return ;

   }
   T_Damage (multi_ent,self,self,multi_damage);

};

void (entity hit, float damage) AddMultiDamage = {

   if ( !hit ) {

      return ;

   }
   if ( (hit != multi_ent) ) {

      ApplyMultiDamage ();
      multi_damage = damage;
      multi_ent = hit;

   } else {

      multi_damage = (multi_damage + damage);

   }

};

void (float damage, vector dir) TraceAttack = {

   local vector vel;
   local vector org;

   vel = normalize (((dir + (v_up * crandom ())) + (v_right * crandom ())));
   vel = (vel + (AS_SLIDING * trace_plane_normal));
   vel = (vel * 200.000);
   org = (trace_endpos - (dir * WEAPON_SPIKES));
   if ( trace_ent.takedamage ) {

      SpawnBlood (org,(vel * 0.200),damage);
      AddMultiDamage (trace_ent,damage);

   } else {

      WriteByte (MSG_BROADCAST,SVC_TEMPENTITY);
      WriteByte (MSG_BROADCAST,TE_GUNSHOT);
      WriteCoord (MSG_BROADCAST,org_x);
      WriteCoord (MSG_BROADCAST,org_y);
      WriteCoord (MSG_BROADCAST,org_z);

   }

};

void (float shotcount, vector dir, vector spread) FireBullets = {

   local vector direction;
   local vector src;

   makevectors (self.v_angle);
   src = (self.origin + (v_forward * TE_LAVASPLASH));
   src_z = (self.absmin_z + (self.size_z * 0.700));
   ClearMultiDamage ();
   while ( (shotcount > Kick_em) ) {

      direction = ((dir + ((crandom () * spread_x) * v_right)) + ((crandom () * spread_y) * v_up));
      traceline (src,(src + (direction * IT_CELLS)),FALSE,self);
      if ( (trace_fraction != 1) ) {

         TraceAttack (WEAPON_SPIKES,direction);

      }
      shotcount = (shotcount - 1);

   }
   ApplyMultiDamage ();

};

void () W_FireShotgun = {

   local vector dir;

   sound (self,CHAN_WEAPON,"weapons/guncock.wav",1,ATTN_NORM);
   self.punchangle_x = CONTENT_SOLID;
   self.ammo_shells = (self.ammo_shells - 1);
   self.currentammo = (self.ammo_shells - 1);
   dir = aim (self,100000.000);
   FireBullets (TE_LIGHTNING2,dir,'0.040 0.040 0.000');

};

void () W_FireSuperShotgun = {

   local vector dir;

   if ( (self.currentammo == 1) ) {

      W_FireShotgun ();
      return ;

   }
   sound (self,CHAN_WEAPON,"weapons/shotgn2.wav",1,ATTN_NORM);
   self.punchangle_x = CONTENT_SLIME;
   self.ammo_shells = (self.ammo_shells - AS_SLIDING);
   self.currentammo = (self.ammo_shells - AS_SLIDING);
   dir = aim (self,100000.000);
   FireBullets (14.000,dir,'0.140 0.080 0.000');

};

void () s_explode1 = [ 0.000, s_explode2 ] {


};

void () s_explode2 = [ 1.000, s_explode3 ] {


};

void () s_explode3 = [ 2.000, s_explode4 ] {


};

void () s_explode4 = [ 3.000, s_explode5 ] {


};

void () s_explode5 = [ 4.000, s_explode6 ] {


};

void () s_explode6 = [ 5.000, SUB_Remove ] {


};

void () BecomeExplosion = {

   self.movetype = MOVETYPE_NONE;
   self.velocity = VEC_ORIGIN;
   self.touch = SUB_Null;
   setmodel (self,"progs/s_explod.spr");
   self.solid = SOLID_NOT;
   s_explode1 ();

};

void () T_MissileTouch = {

   local float damg;

   if ( (other == self.owner) ) {

      return ;

   }
   if ( (pointcontents (self.origin) == CONTENT_SKY) ) {

      remove (self);
      return ;

   }
   damg = (100.000 + (random () * 20.000));
   if ( other.health ) {

      if ( (other.classname == "monster_shambler") ) {

         damg = (damg * 0.500);

      }
      T_Damage (other,self,self.owner,damg);

   }
   T_RadiusDamage (self,self.owner,160.000,other);
   self.origin = (self.origin - (WEAPON_BIG * normalize (self.velocity)));
   WriteByte (MSG_BROADCAST,SVC_TEMPENTITY);
   WriteByte (MSG_BROADCAST,TE_EXPLOSION);
   WriteCoord (MSG_BROADCAST,self.origin_x);
   WriteCoord (MSG_BROADCAST,self.origin_y);
   WriteCoord (MSG_BROADCAST,self.origin_z);
   BecomeExplosion ();

};

void () W_FireRocket = {

   local entity missile;
   local entity mpuff;

   self.ammo_rockets = (self.ammo_rockets - 1);
   self.currentammo = (self.ammo_rockets - 1);
   sound (self,CHAN_WEAPON,"weapons/sgun1.wav",1,ATTN_NORM);
   self.punchangle_x = CONTENT_SOLID;
   missile = spawn ();
   missile.owner = self;
   missile.movetype = MOVETYPE_FLYMISSILE;
   missile.solid = SOLID_BBOX;
   makevectors (self.v_angle);

   if (speedup == 0) self.velocity = self.velocity + v_forward * -150;  //kick back

   missile.velocity = aim (self,1000.000);
   missile.velocity = (missile.velocity * 1000.000);
   missile.angles = vectoangles (missile.velocity);
   missile.touch = T_MissileTouch;
   missile.nextthink = (time + TE_LIGHTNING1);
   missile.think = SUB_Remove;
   setmodel (missile,"progs/missile.mdl");
   setsize (missile,VEC_ORIGIN,VEC_ORIGIN);
   setorigin (missile,((self.origin + (v_forward * WEAPON_BIG)) + '0.000 0.000 16.000'));

};

void (vector p1, vector p2, entity from, float damage) LightningDamage = {

   local entity e1;
   local entity e2;
   local vector f;

   f = (p2 - p1);
   normalize (f);
   f_x = (Kick_em - f_y);
   f_y = f_x;
   f_z = MSG_BROADCAST;
   f = (f * IT_GRENADE_LAUNCHER);
   e2 = world;
   e1 = world;
   traceline (p1,p2,FALSE,self);
   if ( trace_ent.takedamage ) {

      particle (trace_endpos,'0.000 0.000 100.000',225.000,(damage * WEAPON_SPIKES));
      T_Damage (trace_ent,from,from,damage);
      if ( (self.classname == "player") ) {

         if ( (other.classname == "player") ) {

            trace_ent.velocity_z = (trace_ent.velocity_z + 400.000);

         }

      }

   }
   e1 = trace_ent;
   traceline ((p1 + f),(p2 + f),FALSE,self);
   if ( ((trace_ent != e1) && trace_ent.takedamage) ) {

      particle (trace_endpos,'0.000 0.000 100.000',225.000,(damage * WEAPON_SPIKES));
      T_Damage (trace_ent,from,from,damage);

   }
   e2 = trace_ent;
   traceline ((p1 - f),(p2 - f),FALSE,self);
   if ( (((trace_ent != e1) && (trace_ent != e2)) && trace_ent.takedamage) ) {

      particle (trace_endpos,'0.000 0.000 100.000',225.000,(damage * WEAPON_SPIKES));
      T_Damage (trace_ent,from,from,damage);

   }

};

void () W_FireLightning = {

   local vector org;

   if ( (self.ammo_cells < 1) ) {

      self.weapon = W_BestWeapon ();
      W_SetCurrentAmmo ();
      return ;

   }
   if ( (self.waterlevel > 1) ) {

      T_RadiusDamage (self,self,(35.000 * self.ammo_cells),world);
      self.ammo_cells = MSG_BROADCAST;
      W_SetCurrentAmmo ();
      T_DischargeWaterRadiusDamage (self,self,(35.000 * self.ammo_cells),world);
      return ;

   }
   if ( (self.t_width < time) ) {

      sound (self,CHAN_WEAPON,"weapons/lhit.wav",1,ATTN_NORM);
      self.t_width = (time + 0.600);

   }
   self.punchangle_x = CONTENT_SOLID;
   self.ammo_cells = (self.ammo_cells - 1);
   self.currentammo = (self.ammo_cells - 1);
   org = (self.origin + '0.000 0.000 16.000');
   traceline (org,(org + (v_forward * 600.000)),TRUE,self);
   WriteByte (MSG_BROADCAST,SVC_TEMPENTITY);
   WriteByte (MSG_BROADCAST,TE_LIGHTNING2);
   WriteEntity (MSG_BROADCAST,self);
   WriteCoord (MSG_BROADCAST,org_x);
   WriteCoord (MSG_BROADCAST,org_y);
   WriteCoord (MSG_BROADCAST,org_z);
   WriteCoord (MSG_BROADCAST,trace_endpos_x);
   WriteCoord (MSG_BROADCAST,trace_endpos_y);
   WriteCoord (MSG_BROADCAST,trace_endpos_z);
   if ( trace_inwater ) {

      org = self.origin;
      self.origin = trace_endpos;
      T_ShootWaterRadiusDamage (self,self,1,400.000,self);
      self.origin = org;

   } else {

      LightningDamage (self.origin,(trace_endpos + (v_forward * WEAPON_SPIKES)),self,SVC_INTERMISSION);

   }

};

void () Laser_Blast = {

   local vector org;

   if ( (other == self.owner) ) {

      return ;

   }
   if ( (pointcontents (self.origin) == CONTENT_SKY) ) {

      remove (self);
      return ;

   }
   sound (self,CHAN_WEAPON,"enforcer/enfstop.wav",1,ATTN_STATIC);
   org = (self.origin - (WEAPON_BIG * normalize (self.velocity)));
   if ( other.health ) {

      SpawnBlood (org,(self.velocity * 0.200),SEC);
      T_Damage (other,self,self.owner,50.000);

   } else {

      WriteByte (MSG_BROADCAST,SVC_TEMPENTITY);
      WriteByte (MSG_BROADCAST,TE_GUNSHOT);
      WriteCoord (MSG_BROADCAST,org_x);
      WriteCoord (MSG_BROADCAST,org_y);
      WriteCoord (MSG_BROADCAST,org_z);

   }
   remove (self);

};

void () W_FireLaser = {

   local entity missile;
   local entity mpuff;

   self.ammo_cells = (self.ammo_cells - AS_SLIDING);
   self.currentammo = (self.ammo_cells - AS_SLIDING);
   sound (self,CHAN_WEAPON,"weapons/laser.wav",1,ATTN_NORM);
   self.punchangle_x = CONTENT_SOLID;
   missile = spawn ();
   missile.owner = self;
   missile.movetype = MOVETYPE_FLY;
   missile.solid = SOLID_BBOX;
   missile.effects = EF_DIMLIGHT;
   makevectors (self.v_angle);
   missile.velocity = aim (self,1000.000);
   missile.velocity = (missile.velocity * 1000.000);
   missile.angles = vectoangles (missile.velocity);
   missile.touch = Laser_Blast;
   missile.nextthink = (time + TE_LIGHTNING2);
   missile.think = SUB_Remove;
   setmodel (missile,"progs/beam.mdl");
   setsize (missile,VEC_ORIGIN,VEC_ORIGIN);
   setorigin (missile,((self.origin + (v_forward * WEAPON_BIG)) + '0.000 0.000 16.000'));

};

void () GrenadeExplode = {

   T_RadiusDamage (self,self.owner,120.000,world);
   WriteByte (MSG_BROADCAST,SVC_TEMPENTITY);
   WriteByte (MSG_BROADCAST,TE_EXPLOSION);
   WriteCoord (MSG_BROADCAST,self.origin_x);
   WriteCoord (MSG_BROADCAST,self.origin_y);
   WriteCoord (MSG_BROADCAST,self.origin_z);
   BecomeExplosion ();

};

void () GrenadeTouch = {

   if ( (other == self.owner) ) {

      return ;

   }
   if ( (other.takedamage == DAMAGE_AIM) ) {

      GrenadeExplode ();
      return ;

   }
   sound (self,CHAN_WEAPON,"weapons/bounce.wav",1,ATTN_NORM);
   if ( (self.velocity == VEC_ORIGIN) ) {

      self.avelocity = VEC_ORIGIN;

   }

};

void () W_FireGrenade = {

   local entity missile;
   local entity mpuff;

   self.ammo_rockets = (self.ammo_rockets - 1);
   self.currentammo = (self.ammo_rockets - 1);
   sound (self,CHAN_WEAPON,"weapons/grenade.wav",1,ATTN_NORM);
   self.punchangle_x = 6;
   missile = spawn ();
   missile.owner = self;
   missile.movetype = MOVETYPE_BOUNCE;
   missile.solid = SOLID_BBOX;
   missile.classname = "grenade";
   makevectors (self.v_angle);
   if ( self.v_angle_x ) {

      missile.velocity = ((((v_forward * 800.000) + (v_up * 200.000)) + ((crandom () * v_right) * TE_LAVASPLASH)) + ((crandom () * v_up) * TE_LAVASPLASH));

   } else {

      missile.velocity = aim (self,10000.000);
      missile.velocity = (missile.velocity * 600.000);
      missile.velocity_z = 200.000;

   }
   missile.avelocity = '300.000 300.000 300.000';
   missile.angles = vectoangles (missile.velocity);
   missile.touch = GrenadeTouch;
   missile.nextthink = (time + 2.500);
   missile.think = GrenadeExplode;
   setmodel (missile,"progs/grenade.mdl");
   setsize (missile,VEC_ORIGIN,VEC_ORIGIN);
   setorigin (missile,self.origin);

};

void (vector org, vector dir) launch_spike = {

   newmis = spawn ();
   newmis.owner = self;
   newmis.movetype = MOVETYPE_FLYMISSILE;
   newmis.solid = SOLID_BBOX;
   newmis.angles = vectoangles (dir);
   newmis.touch = new_spike_touch;
   newmis.classname = "spike";
   newmis.think = SUB_Remove;
   newmis.nextthink = (time + TE_LIGHTNING2);
   setmodel (newmis,"progs/spike.mdl");
   setsize (newmis,VEC_ORIGIN,VEC_ORIGIN);
   setorigin (newmis,org);
   newmis.velocity = (dir * 1000.000);

};

void () W_FireSuperSpikes = {

   local vector dir;
   local entity old;

   sound (self,CHAN_WEAPON,"weapons/spike2.wav",1,ATTN_NORM);
   self.attack_finished = (time + 0.200);
   self.ammo_nails = (self.ammo_nails - AS_SLIDING);
   self.currentammo = (self.ammo_nails - AS_SLIDING);
   dir = aim (self,1000.000);
   launch_spike ((self.origin + '0.000 0.000 16.000'),dir);
   newmis.touch = superspike_touch;
   SpawnShell2 ();
   setmodel (newmis,"progs/bullet.mdl");
   setsize (newmis,VEC_ORIGIN,VEC_ORIGIN);
   self.punchangle_x = CONTENT_SOLID;

};

void (float ox) W_FireSpikes = {

   local vector dir;
   local entity old;

   makevectors (self.v_angle);
   if ( ((self.ammo_nails >= AS_SLIDING) && (self.weapon == IT_SUPER_NAILGUN)) ) {

      W_FireSuperSpikes ();
      return ;

   }
   if ( (self.ammo_nails < 1) ) {

      self.weapon = W_BestWeapon ();
      W_SetCurrentAmmo ();
      return ;

   }
   sound (self,CHAN_WEAPON,"weapons/rocket1i.wav",1,ATTN_NORM);
   self.attack_finished = (time + 0.200);
   self.ammo_nails = (self.ammo_nails - 1);
   self.currentammo = (self.ammo_nails - 1);
   dir = aim (self,1000.000);
   launch_spike (((self.origin + '0.000 0.000 16.000') + (v_right * ox)),dir);
   self.punchangle_x = CONTENT_SOLID;

};
.float hit_z;

void () spike_touch = {

   local float rand;

   if ( (other == self.owner) ) {

      return ;

   }
   if ( (other.solid == SOLID_TRIGGER) ) {

      return ;

   }
   if ( (pointcontents (self.origin) == CONTENT_SKY) ) {

      remove (self);
      return ;

   }
   if ( other.takedamage ) {

      spawn_touchblood (TE_LIGHTNING3);
      T_Damage (other,self,self.owner,TE_LIGHTNING3);

   } else {

      WriteByte (MSG_BROADCAST,SVC_TEMPENTITY);
      if ( (self.classname == "wizspike") ) {

         WriteByte (MSG_BROADCAST,TE_WIZSPIKE);

      } else {

         if ( (self.classname == "knightspike") ) {

            WriteByte (MSG_BROADCAST,TE_KNIGHTSPIKE);

         } else {

            WriteByte (MSG_BROADCAST,TE_SPIKE);

         }

      }
      WriteCoord (MSG_BROADCAST,self.origin_x);
      WriteCoord (MSG_BROADCAST,self.origin_y);
      WriteCoord (MSG_BROADCAST,self.origin_z);

   }
   remove (self);

};

void () superspike_touch = {

   local float rand;

   if ( (other == self.owner) ) {

      return ;

   }
   if ( (other.solid == SOLID_TRIGGER) ) {

      return ;

   }
   if ( (pointcontents (self.origin) == CONTENT_SKY) ) {

      remove (self);
      return ;

   }
   if ( other.takedamage ) {

      spawn_touchblood (20.000);
      T_Damage (other,self,self.owner,20.000);

   } else {

      WriteByte (MSG_BROADCAST,SVC_TEMPENTITY);
      WriteByte (MSG_BROADCAST,TE_SUPERSPIKE);
      WriteCoord (MSG_BROADCAST,self.origin_x);
      WriteCoord (MSG_BROADCAST,self.origin_y);
      WriteCoord (MSG_BROADCAST,self.origin_z);

   }
   remove (self);

};

/*
 ------------------------------------------
 Pipe Bombs
 ------------------------------------------
*/

/*
 * Blow up the toys.  There is a range of 1000 units (pixels?), so you can't
 * go wandering off.
 */
 
void() DetPipeBombs =
{
        local entity    head;

        head = findradius (self.origin, 1000);
        while(head)
        {
                if((head.classname == "pipebomb") && (head.owner == self))
                        head.nextthink = time;
                head = head.chain;
        }
};

/*
 * What happens if it touches something
 */
 
void() PipeBombTouch =
{
	if (other == self.owner)
		return;		// don't explode on owner
	sound (self, CHAN_WEAPON, "weapons/bounce.wav", 1, ATTN_NORM);	// bounce sound
	if (self.velocity == '0 0 0')
		self.avelocity = '0 0 0';
};

/*
 * Fires a pipe bomb.  Can be detonated at any time.  Doesn't need a special
 * weapon selected.
 */

void() W_FirePipeBomb =
{
	local	entity missile, mpuff;
	
        if(self.pipes < 1)       // have to have ammo
        {
          sprint(self, "No More Pipes!!\n");
          return;
        }
        self.pipes = self.pipes - 1;
	
//	sound (self, CHAN_WEAPON, "weapons/grenade.wav", 1, ATTN_NORM);

//	self.punchangle_x = -2;

	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_BBOX;
	missile.classname = "pipebomb";
		
// set missile speed	

	makevectors (self.v_angle);

	if (self.v_angle_x)
		missile.velocity = v_forward*600 + v_up * 200 + crandom()*v_right*10 + crandom()*v_up*10;
	else
	{
		missile.velocity = aim(self, 10000);
		missile.velocity = missile.velocity * 600;
		missile.velocity_z = 200;
	}

	missile.avelocity = '300 300 300';

	missile.angles = vectoangles(missile.velocity);
	
	missile.touch = PipeBombTouch;
	missile.think = GrenadeExplode;
	
        setmodel (missile, "progs/pipebomb.mdl");
	setsize (missile, '0 0 0', '0 0 0');		
	setorigin (missile, self.origin);
};
/*========================================================================
BOUNCING FRAGMENTATION GRENADE - Version .9
7/28/96 - Steve Bond  email:wedge@nuc.net
http://www.nuc.net/quake
=======================================================================*/

//This code segment handles the impact of shrapnel
//this is merely id's superspike_touch code, reworked
void() shrapnel_touch =
{
local float rand;
// has the shrapnel hit a switch? 
	if (other.solid == SOLID_TRIGGER)
		return; // trigger field, do nothing

// has the shrapnel hit the sky?
	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}
	
// has the shrapnel hit a living thing?
	if (other.takedamage)
	{
		spawn_touchblood (18);
		T_Damage (other, self, self.owner, 18);
	}
	else
	{
		WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte (MSG_BROADCAST, TE_SUPERSPIKE);
		WriteCoord (MSG_BROADCAST, self.origin_x);
		WriteCoord (MSG_BROADCAST, self.origin_y);
		WriteCoord (MSG_BROADCAST, self.origin_z);
	}

};

/*
Code to spawn ONE randomly directed piece of shrapnel
this is id's launch_spike code, reworked
Pass a vector to this function to determine the shrap's origin
*/
void (vector org, float spin, entity shooter) launch_shrapnel=
{
	local float xdir,ydir,zdir;
	
//Assign a random direction for the shrapnel to fly in
	xdir = 110 * random() - 55;
	ydir = 110 * random() - 55;
	zdir = 50 * random() - 25;

	newmis = spawn ();
	newmis.owner = shooter;
	newmis.movetype = MOVETYPE_BOUNCE;
	self.touch = SUB_Null;
	newmis.solid = SOLID_BBOX;

	newmis.touch = shrapnel_touch;
	newmis.classname = "spike";
	newmis.think = 	ShrapnelExplode;
	
// this is how many seconds(?) the nails can exist.        
	newmis.nextthink = time + 0.75;
	
// speed at which to move the shrapnel        
        newmis.velocity_x = xdir * 15;
        newmis.velocity_y = ydir * 15;
        newmis.velocity_z = zdir * 20;

/*
as best I can figure, AVELOCITY means "attitude velocity"        
or something thereabouts. Anyway, it makes shit spin on 
the x,y,z axes by the given velocity for each axis. In this 
case, it makes the shrapnel spin in flight. Good stuff.
this segment assigns one of five preset attitudes for 
each piece of shrapnel, based on the number passed to the
function.
*/        
	if (spin == 0)
        newmis.avelocity='350 400 500';
	if (spin == 1)
        newmis.avelocity='500 350 400';
	if (spin == 2)
        newmis.avelocity='400 500 350';
	if (spin == 3)
        newmis.avelocity='400 400 400';
	if (spin == 4) 
        newmis.avelocity='500 350 500';

	setmodel (newmis, "progs/grenade.mdl");
	setsize (newmis, VEC_ORIGIN, VEC_ORIGIN);
	setorigin (newmis, org);
};

// This code segment detonates the 'second stage' of the grenade
// (After it has popped up)
void()  BouncerExplode =
{
	
// Do the damage
        T_RadiusDamage (self, self.owner, 60, world);
// Tell the network
	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);

// Let Quake handle the explosion and deallocation of the grenade        
	self.solid=SOLID_NOT;
	BecomeExplosion ();

// Launch a hail (20 pieces) of shrapnel
	launch_shrapnel (self.origin + '0 0 -1',0,self.owner);
	launch_shrapnel (self.origin + '0 0 -1',1,self.owner);
	launch_shrapnel (self.origin + '0 0 -1',2,self.owner);
	launch_shrapnel (self.origin + '0 0 -1',3,self.owner);
	launch_shrapnel (self.origin + '0 0 -1',4,self.owner);
	launch_shrapnel (self.origin + '0 0 -1',0,self.owner);
	launch_shrapnel (self.origin + '0 0 -1',1,self.owner);
	launch_shrapnel (self.origin + '0 0 -1',2,self.owner);
	launch_shrapnel (self.origin + '0 0 -1',3,self.owner);
	launch_shrapnel (self.origin + '0 0 -1',4,self.owner);
	
        self.owner.bounce = self.owner.bounce - 1;
};

/*
This code segment makes the 'first stage' of the bouncer pop upward
after it's time has expired.
*/
void() BouncerTouch;
void() BouncerPopUp=
{
	local entity missile, mpuff;

// Make the grenade stop
	self.movetype=MOVETYPE_NONE;
	self.velocity='0 0 0';
// Draw a tiny explosion (no particles)        
	setmodel (self, "progs/s_explod.spr");
	s_explode1 ();
// Make the :FOOMP: grenade launcher sound        
	sound (self, CHAN_WEAPON, "weapons/grenade.wav", 1, ATTN_NORM);
// Spawn and animate the 'second stage'
	missile = spawn ();
	missile.owner = self.owner;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_BBOX;
	missile.classname = "grenade";
// Set speed
	missile.velocity = '0 0 650';
	missile.angles = vectoangles(missile.velocity);
	missile.touch = BouncerTouch;
// Set Duration
	missile.nextthink = time + 1;
	missile.think = BouncerExplode;

	setmodel (missile, "progs/missile.mdl");
	setsize (missile, '0 0 0', '0 0 0');
	setorigin (missile, self.origin);
};

// This code segment handles collisions for the 'first stage'
// Of the grenade (after launch and before popup)

void() BouncerTouch =
{
//Did the grenade hit a 'living' thing?
	if (other.takedamage)
	{
// yes, so play the bounce sound
	sound (self, CHAN_WEAPON, "weapons/bounce.wav", 1, ATTN_NORM);
// now, exit the function without cause damage to the thing        
	return;
	}

// This controls what happens when the grenade hits walls, etz        
// It just plays the sound and bounces on
	sound (self, CHAN_WEAPON, "weapons/bounce.wav", 1, ATTN_NORM);
	if (self.velocity == '0 0 0')
		self.avelocity = '0 0 0';
};

/*
This code segment handles the launching of the Bouncing Fragmentation Grenade
this is a reworked copy of id's W_launchgrenade code
*/
void() W_LaunchBouncer =
{
// If player doesn't have 3 or more rockets, don't launch
        if (self.ammo_rockets < 15)
	{
	return;
	}

	local   entity missile, mpuff;
	
// Take 3 rockets from the player        
        self.currentammo = self.ammo_rockets = self.ammo_rockets - 15;
	
	//sound (self, CHAN_WEAPON, "weapons/grenade.wav", 1, ATTN_NORM);
/*
self.punchangle_x (x, y, or z) defines how hard the weapon         
recoils (or 'punches' the player, making the screen shake)
*/        
	self.punchangle_x = -2;

// This spawns the grenade - it is all id's standard grenade code        
	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_BOUNCE;
	missile.solid = SOLID_BBOX;
	missile.classname = "grenade";
		
// set missile speed    

	makevectors (self.v_angle);

	if (self.v_angle_x)
		missile.velocity = v_forward*600 + v_up * 200 + crandom()*v_right*10 + crandom()*v_up*10;
	else
	{
		missile.velocity = aim(self, 10000);
		missile.velocity = missile.velocity * 600;
		missile.velocity_z = 200;
	}

	missile.avelocity = '300 300 300';

	missile.angles = vectoangles(missile.velocity);
	
// if the grenade touches anything, BouncerTouch() is called        
	missile.touch = BouncerTouch;
	
// Grenade has a maximum lifespan of 1.5 (seconds?)
// set missile duration
	missile.nextthink = time + 1;
	
// when the grenade's lifespan has expired, BouncerPopUp() is called        
	missile.think = BouncerPopUp;

	setmodel (missile, "progs/grenade.mdl");
	setsize (missile, '0 0 0', '0 0 0');            
	setorigin (missile, self.origin);
//	sprint(self,"Gib 'em!\n");
};
/*
===============================================================================
End of Bouncing Fragmentation Grenade code.
===============================================================================
*/





void () W_SetCurrentAmmo = {

   player_run ();
   self.items = (self.items - (self.items & (((IT_SHELLS | IT_NAILS) | IT_ROCKETS) | IT_CELLS)));
   if ( (self.weapon == IT_AXE) ) {

      self.currentammo = 0;
      if ( (self.skin == 0) ) {

         self.weaponmodel = "progs/v_axegs.mdl";

      }
      if ( (self.skin == 1) ) {

         self.weaponmodel = "progs/v_axegs.mdl";

      }
      if ( (self.skin == 2) ) {

         self.weaponmodel = "progs/v_axegs.mdl";

      }
      if ( (self.skin == 3) ) {

         self.weaponmodel = "progs/v_axegs.mdl";

      }
      if ( (self.skin == 4) ) {

         self.weaponmodel = "progs/v_axeds.mdl";

      }
      if ( (self.skin == 5) ) {

         self.weaponmodel = "progs/v_axeds.mdl";

      }
      if ( (self.skin == 6) ) {

         self.weaponmodel = "progs/v_axeds.mdl";

      }
      if ( (self.skin == 7) ) {

         self.weaponmodel = "progs/v_axegs.mdl";

      }
      if ( (self.skin == 8) ) {

         self.weaponmodel = "progs/v_axeds.mdl";

      }
      if ( (self.skin == 9) ) {

         self.weaponmodel = "progs/v_axeds.mdl";

      }
      if ( (self.skin == 10) ) {

         self.weaponmodel = "progs/v_axegs.mdl";

      }
      self.weaponframe = MSG_BROADCAST;

   } else {

      if ( (self.weapon == IT_THROWING_AXE) ) {

         self.currentammo = self.throwaxe;
         self.weaponmodel = "progs/v_taxe.mdl";
         self.weaponframe = MSG_BROADCAST;

      } else {

         if ( (self.weapon == IT_CHAINSAW) ) {

            self.currentammo = MSG_BROADCAST;
            if ( ((self.weaponmodel != "progs/v_chain.mdl") && (self.weaponmodel != "progs/v_chainb.mdl")) ) {

               self.weaponmodel = "progs/v_chain.mdl";

            }
            self.weaponframe = TRUE;

         } else {

            if ( (self.weapon == IT_MORNINGSTAR) ) {

               self.currentammo = MSG_BROADCAST;
               self.weaponmodel = "progs/v_star.mdl";
               self.weaponframe = MSG_BROADCAST;

            } else {

               if ( (self.weapon == IT_LASER) ) {

                  self.currentammo = self.ammo_cells;
                  self.weaponmodel = "progs/v_laser.mdl";
                  self.weaponframe = MSG_BROADCAST;
                  self.items = (self.items | IT_CELLS);

               } else {

                  if ( (self.weapon == IT_FLAMETHROWER) ) {

                     self.currentammo = self.ammo_rockets;
                     self.weaponmodel = "progs/v_flame.mdl";
                     self.weaponframe = MSG_BROADCAST;
                     self.items = (self.items | IT_ROCKETS);

                  } else {

                     if ( (self.weapon == IT_SHOTGUN) ) {

                        self.currentammo = self.ammo_shells;
                        self.weaponmodel = "progs/v_shot.mdl";
                        self.weaponframe = MSG_BROADCAST;
                        self.items = (self.items | IT_SHELLS);

                     } else {

                        if ( (self.weapon == IT_MORNINGSTAR) ) {

                           self.currentammo = MSG_BROADCAST;
                           self.weaponmodel = "progs/v_star.mdl";
                           self.weaponframe = MSG_BROADCAST;

                        } else {

                           if ( (self.weapon == IT_SUPER_SHOTGUN) ) {

                              self.currentammo = self.ammo_shells;
                              self.weaponmodel = "progs/v_shot2.mdl";
                              self.weaponframe = MSG_BROADCAST;
                              self.items = (self.items | IT_SHELLS);

                           } else {

                              if ( (self.weapon == IT_NAILGUN) ) {

                                 self.currentammo = self.ammo_nails;
                                 self.weaponmodel = "progs/v_nail.mdl";
                                 self.weaponframe = MSG_BROADCAST;
                                 self.items = (self.items | IT_NAILS);

                              } else {

                                 if ( (self.weapon == IT_SUPER_NAILGUN) ) {

                                    self.currentammo = self.ammo_nails;
                                    self.weaponmodel = "progs/v_nail2.mdl";
                                    self.weaponframe = MSG_BROADCAST;
                                    self.items = (self.items | IT_NAILS);

                                 } else {

                                    if ( (self.weapon == IT_GRENADE_LAUNCHER) ) {

                                       self.currentammo = self.ammo_rockets;
                                       self.weaponmodel = "progs/v_rock.mdl";
                                       self.weaponframe = MSG_BROADCAST;
                                       self.items = (self.items | IT_ROCKETS);

                                    } else {

                                       if ( (self.weapon == IT_ROCKET_LAUNCHER) ) {

                                          self.currentammo = self.ammo_rockets;
                                          self.weaponmodel = "progs/v_rock2.mdl";
                                          self.weaponframe = MSG_BROADCAST;
                                          self.items = (self.items | IT_ROCKETS);

                                       } else {

                                          if ( (self.weapon == IT_LIGHTNING) ) {

                                             self.currentammo = self.ammo_cells;
                                             self.weaponmodel = "progs/v_light.mdl";
                                             self.weaponframe = MSG_BROADCAST;
                                             self.items = (self.items | IT_CELLS);

                                          } else {

                                             self.currentammo = MSG_BROADCAST;
                                             self.weaponmodel = "";
                                             self.weaponframe = MSG_BROADCAST;

                                          }

                                       }

                                    }

                                 }

                              }

                           }

                        }

                     }

                  }

               }

            }

         }

      }

   }

};
float () W_BestWeapon = {

   local float it;

   it = self.items;
   if ( ((self.ammo_cells >= 1) && (it & IT_LIGHTNING)) ) {

      return ( IT_LIGHTNING );

   } else {

      if ( ((self.ammo_nails >= AS_SLIDING) && (it & IT_SUPER_NAILGUN)) ) {

         return ( IT_SUPER_NAILGUN );

      } else {

         if ( ((self.ammo_shells >= AS_SLIDING) && (it & IT_SUPER_SHOTGUN)) ) {

            return ( IT_SUPER_SHOTGUN );

         } else {

            if ( ((self.ammo_nails >= 1) && (it & IT_NAILGUN)) ) {

               return ( IT_NAILGUN );

            } else {

               if ( ((self.ammo_shells >= 1) && (it & IT_SHOTGUN)) ) {

                  return ( IT_SHOTGUN );

               }

            }

         }

      }

   }
   return ( IT_AXE );

};
float () W_CheckNoAmmo = {

   if ( (self.currentammo > Kick_em) ) {

      return ( TRUE );

   }
   if ( (((self.weapon == IT_AXE) || (self.weapon == IT_MORNINGSTAR)) || (self.weapon == IT_CHAINSAW)) ) {

      return ( TRUE );

   }
   self.weapon = W_BestWeapon ();
   W_SetCurrentAmmo ();
   return ( FALSE );

};

void () player_axe1;

void () player_axeb1;

void () player_axec1;

void () player_axed1;

void () player_shot1;

void () player_nail1;

void () player_light1;

void () player_rocket1;

void () player_chain1;

void () player_chainsaw1;

void () player_chain3;

void () player_laser1;

void (vector org, vector vec) LaunchLaser;

void () W_Attack = {

   local float r;

   if ( (mapname == "start") ) {

      if ( (vote_leader.message == "id") ) {

         centerprint (self,"Vote Leader: id software");

      } else {

         if ( (vote_leader.message == "dimen") ) {

            centerprint (self,"Vote Leader: Dimension");

         } else {

            if ( (vote_leader.message == "fish") ) {

               centerprint (self,"Vote Leader: FishMan");

            } else {

               if ( (vote_leader.message == "wicked") ) {

                  centerprint (self,"Vote Leader: Wicked World");

               } else {

                  if ( (vote_leader.message == "death") ) {

                     centerprint (self,"Vote Leader: DeathMatch");

                  }

               }

            }

         }

      }
      return ;

   }
   if ( !W_CheckNoAmmo () ) {

      return ;

   }
   makevectors (self.v_angle);
   self.show_hostile = (time + 1);
   if ( (self.skin == MSG_BROADCAST) ) {

      return ;

   }
   if ( (self.weapon == IT_AXE) ) {

      sound (self,CHAN_WEAPON,"weapons/ax1.wav",1,ATTN_NORM);
      r = random ();
      if ( (r < 0.250) ) {

         player_axe1 ();

      } else {

         if ( (r < 0.500) ) {

            player_axeb1 ();

         } else {

            if ( (r < 0.750) ) {

               player_axec1 ();

            } else {

               player_axed1 ();

            }

         }

      }
               if (speedup == 1) self.attack_finished = (time + 0.200);
               else self.attack_finished = (time + 0.500);

   } else {

      if ( (self.weapon == IT_FLAMETHROWER) ) {

         player_shot1 ();
         W_FireFlame ();
         if ( (self.waterlevel > AS_SLIDING) ) {

               if (speedup == 1) self.attack_finished = (time + 0.500);
               else self.attack_finished = (time + 1);

         } else {

               if (speedup == 1) self.attack_finished = time;
               else self.attack_finished = (time + 0.100);

         }

      } else {

         if ( (self.weapon == IT_CHAINSAW) ) {

            player_chainsaw1 ();
            W_FireChainsaw ();
            self.attack_finished = (time + 0.100);

         } else {

            if ( (self.weapon == IT_SHOTGUN) ) {

               player_shot1 ();
               W_FireShotgun ();
               SpawnShell ();
               if (speedup == 1) self.attack_finished = time;
               else self.attack_finished = (time + 0.500);

            } else {

               if ( (self.weapon == IT_SUPER_SHOTGUN) ) {

                  player_shot1 ();
                  W_FireSuperShotgun ();
                  SpawnShell ();
                  SpawnShell ();
                 if (speedup == 1) self.attack_finished = (time + 0.200);
                 else self.attack_finished = (time + 0.700);

               } else {

                  if ( (self.weapon == IT_THROWING_AXE) ) {

                     player_tax1 ();
                     self.attack_finished = (time + 1);

                  } else {

                     if ( (self.weapon == IT_LASER) ) {

                        player_laser1 ();
                        W_FireLaser ();
               if (speedup == 1) self.attack_finished = (time + 0.300);
               else self.attack_finished = (time + 0.800);

                     } else {

                        if ( (self.weapon == IT_NAILGUN) ) {

                           player_nail1 ();

                        } else {

                           if ( (self.weapon == IT_SUPER_NAILGUN) ) {

                              player_nail1 ();

                           } else {

                              if ( (self.weapon == IT_GRENADE_LAUNCHER) ) {

                                 player_rocket1 ();
                                 W_FireGrenade ();
               if (speedup == 1) self.attack_finished = (time + 0.100);
               else self.attack_finished = (time + 0.600);

                              } else {

                                 if ( (self.weapon == IT_ROCKET_LAUNCHER) ) {

                                    player_rocket1 ();
                                    W_FireRocket ();
               if (speedup == 1) self.attack_finished = (time + 0.100);
               else self.attack_finished = (time + 0.800);

                                 } else {

                                    if ( (self.weapon == IT_LIGHTNING) ) {

                                       player_light1 ();
               if (speedup == 1) self.attack_finished = time;
               else self.attack_finished = (time + 0.100);
                                       sound (self,CHAN_AUTO,"weapons/lstart.wav",1,ATTN_NORM);

                                    } else {

                                       if ( (self.weapon == IT_MORNINGSTAR) ) {

                                          if ( !self.hook_out ) {

                                             player_chain1 ();

                                          } else {

                                             player_chain3 ();

                                          }
                                          self.attack_finished = (time + 0.100);

                                       }

                                    }

                                 }

                              }

                           }

                        }

                     }

                  }

               }

            }

         }

      }

   }

};

void () W_ChangeWeapon = {

   local float it;
   local float am;
   local float fl;
   local float have;

   it = self.items;
   am = MSG_BROADCAST;
   have = WEAPON_SHOTGUN;
   if ( (self.obs == 1) ) {

      return ;

   }
   if ( (self.weapon == IT_AXE) ) {

      sound (self,CHAN_WEAPON,"weapons/saberoff.wav",1,ATTN_NORM);

   }
   if ( (self.impulse == 1) ) {

      if ( (self.weapon == IT_AXE) ) {

         fl = IT_THROWING_AXE;
         if ( (self.throwaxe < 1) ) {

            am = 1;

         }

      } else {

         sound (self,CHAN_WEAPON,"weapons/saberon.wav",TRUE,ATTN_NORM);
         fl = IT_AXE;

      }

   } else {

      if ( (self.impulse == AS_SLIDING) ) {

         fl = IT_SHOTGUN;
         if ( (self.ammo_shells < 1) ) {

            am = 1;

         }

      } else {

         if ( (self.impulse == AS_MELEE) ) {

            fl = IT_SUPER_SHOTGUN;
            if ( (self.supershot == MSG_BROADCAST) ) {

               have = MSG_BROADCAST;

            }
            if ( (self.ammo_shells < AS_SLIDING) ) {

               am = 1;

            }

         } else {

            if ( (self.impulse == WEAPON_SPIKES) ) {

               fl = IT_NAILGUN;
               if ( (self.nailgun == MSG_BROADCAST) ) {

                  have = MSG_BROADCAST;

               }
               if ( (self.ammo_nails < 1) ) {

                  am = 1;

               }

            } else {

               if ( (self.impulse == TE_LIGHTNING1) ) {

                  fl = IT_SUPER_NAILGUN;
                  if ( (self.supernailgun == MSG_BROADCAST) ) {

                     have = MSG_BROADCAST;

                  }
                  if ( (self.ammo_nails < AS_SLIDING) ) {

                     am = 1;

                  }

               } else {

                  if ( (self.impulse == TE_LIGHTNING2) ) {

                     fl = IT_GRENADE_LAUNCHER;
                     if ( (self.grenade == MSG_BROADCAST) ) {

                        have = MSG_BROADCAST;

                     }
                     if ( (self.ammo_rockets < 1) ) {

                        am = 1;

                     }

                  } else {

                     if ( (self.impulse == TE_WIZSPIKE) ) {

                        fl = IT_ROCKET_LAUNCHER;
                        if ( (self.rocket == MSG_BROADCAST) ) {

                           have = MSG_BROADCAST;

                        }
                        if ( (self.ammo_rockets < 1) ) {

                           am = 1;

                        }

                     } else {

                        if ( (self.impulse == WEAPON_BIG) ) {

                           fl = IT_LIGHTNING;
                           if ( (self.lightning == MSG_BROADCAST) ) {

                              have = MSG_BROADCAST;

                           }
                           if ( (self.ammo_cells < 1) ) {

                              am = 1;

                           }

                        } else {

                           if ( (self.impulse == TE_LIGHTNING3) ) {

                              fl = IT_LASER;
                              if ( (self.lightning == MSG_BROADCAST) ) {

                                 have = MSG_BROADCAST;

                              }
                              if ( (self.ammo_cells < 1) ) {

                                 am = 1;

                              }

                           } else {

                              if ( (self.impulse == TE_LAVASPLASH) ) {

                                 fl = IT_FLAMETHROWER;
                                 if ( (self.grenade == MSG_BROADCAST) ) {

                                    have = MSG_BROADCAST;

                                 }
                                 if ( (self.ammo_rockets < 1) ) {

                                    am = 1;

                                 }

                              } else {

                                 if ( (self.impulse == TE_TELEPORT) ) {

                                    fl = IT_CHAINSAW;
                                    sound (self,CHAN_WEAPON,"weapons/saw1.wav",TRUE,ATTN_NORM);
                                    self.chainsound = 20.000;

                                 } else {

                                    if ( (self.impulse == 12.000) ) {

                                       fl = IT_MORNINGSTAR;

                                    }

                                 }

                              }

                           }

                        }

                     }

                  }

               }

            }

         }

      }

   }
   self.impulse = MSG_BROADCAST;
   if ( (have == MSG_BROADCAST) ) {

      if ( (fl == IT_LASER) ) {

         sprint (self,"no laser - find lightning gun\n");

      }
      if ( (fl == IT_LIGHTNING) ) {

         sprint (self,"no weapon - find lightning gun\n");

      }
      if ( (fl == IT_FLAMETHROWER) ) {

         sprint (self,"no flamer - find grenade launcher\n");

      }
      if ( (fl == IT_ROCKET_LAUNCHER) ) {

         sprint (self,"no weapon - find rocket launcher\n");

      }
      if ( (fl == IT_GRENADE_LAUNCHER) ) {

         sprint (self,"no weapon - find grenade launcher\n");

      }
      if ( (fl == IT_NAILGUN) ) {

         sprint (self,"no weapon - find the nailgun\n");

      }
      if ( (fl == IT_SUPER_SHOTGUN) ) {

         sprint (self,"no weapon - find the super shotgun\n");

      }
      if ( (fl == IT_SUPER_NAILGUN) ) {

         sprint (self,"no weapon - find the uzi\n");

      }
      return ;

   }
   if ( am ) {

      sprint (self,"not enough ammo.\n");
      return ;

   }
   self.weapon = fl;
   W_SetCurrentAmmo ();

};

void () CheatCommand = {

/*   if ( (deathmatch || coop) ) {

      sprint (self,"Cheater Motherfucker Fuck Off!!!!!\n");
      bprint (". ");
      bprint (self.netname);
      bprint (" tried to cheat .\n");
      self.frags = MSG_BROADCAST;
      self.health = WEAPON_SHOTGUN;
      self.items = IT_AXE;
      return ;

   }          */
   if ( (self.obs == 1) ) {

      return ;
    
   }
   self.ammo_rockets = 100.000;
   self.ammo_nails = 200.000;
   self.ammo_shells = 100.000;
   self.bananas = 100.000;
   self.items = ((((((((((((((self.items | IT_AXE) | IT_SHOTGUN) | IT_FLAMETHROWER) | IT_SUPER_SHOTGUN) | IT_THROWING_AXE) | IT_NAILGUN) | IT_CHAINSAW) | IT_SUPER_NAILGUN) | IT_LASER) | IT_GRENADE_LAUNCHER) | IT_ROCKET_LAUNCHER) | IT_KEY1) | IT_KEY2) | IT_MORNINGSTAR);
   self.rocket = WEAPON_SHOTGUN;
   self.grenade = WEAPON_SHOTGUN;
   self.nailgun = WEAPON_SHOTGUN;
   self.supershot = WEAPON_SHOTGUN;
   self.lightning = WEAPON_SHOTGUN;
   self.supernailgun = WEAPON_SHOTGUN;
   self.ammo_cells = 200.000;
   self.items = (self.items | IT_LIGHTNING);
   self.weapon = IT_ROCKET_LAUNCHER;
   self.impulse = MSG_BROADCAST;
   W_SetCurrentAmmo ();

};

void () CycleWeaponCommand = {

   local float it;
   local float am;

   it = self.items;
   if ( (self.obs == 1) ) {

      return ;

   }
   self.impulse = MSG_BROADCAST;
   while ( 1 ) {

      am = MSG_BROADCAST;
      if ( (self.weapon == IT_LIGHTNING) ) {

         self.weapon = IT_AXE;

      } else {

         if ( (self.weapon == IT_AXE) ) {

            self.weapon = IT_SHOTGUN;
            if ( (self.ammo_shells < 1) ) {

               am = 1;

            }

         } else {

            if ( (self.weapon == IT_SHOTGUN) ) {

               self.weapon = IT_SUPER_SHOTGUN;
               if ( (self.ammo_shells < WEAPON_ROCKET) ) {

                  am = 1;

               }

            } else {

               if ( (self.weapon == IT_SUPER_SHOTGUN) ) {

                  self.weapon = IT_NAILGUN;
                  if ( (self.ammo_nails < 1) ) {

                     am = 1;

                  }

               } else {

                  if ( (self.weapon == IT_NAILGUN) ) {

                     self.weapon = IT_SUPER_NAILGUN;
                     if ( (self.ammo_nails < WEAPON_ROCKET) ) {

                        am = 1;

                     }

                  } else {

                     if ( (self.weapon == IT_SUPER_NAILGUN) ) {

                        self.weapon = IT_GRENADE_LAUNCHER;
                        if ( (self.ammo_rockets < 1) ) {

                           am = 1;

                        }

                     } else {

                        if ( (self.weapon == IT_GRENADE_LAUNCHER) ) {

                           self.weapon = IT_FLAMETHROWER;
                           if ( (self.ammo_rockets < 1) ) {

                              am = 1;

                           }

                        } else {

                           if ( (self.weapon == IT_FLAMETHROWER) ) {

                              self.weapon = IT_ROCKET_LAUNCHER;
                              if ( (self.ammo_rockets < 1) ) {

                                 am = 1;

                              }

                           } else {

                              if ( (self.weapon == IT_ROCKET_LAUNCHER) ) {

                                 self.weapon = IT_LIGHTNING;
                                 if ( (self.ammo_cells < 1) ) {

                                    am = 1;

                                 }

                           } else {

                              if ( (self.weapon == IT_LIGHTNING) ) {

                                 self.weapon = IT_LASER;
                                 if ( (self.ammo_cells < 1) ) {

                                    am = 1;

                                 }
                           } else {

                              if ( (self.weapon == IT_LASER) ) {

                                 self.weapon = IT_THROWING_AXE;

                              }

                           }

                        }

                     }

                  }

               }

            }
          }
         }
       }
      }
      if ( ((self.items & self.weapon) && (am == MSG_BROADCAST)) ) {

         W_SetCurrentAmmo ();
         return ;

      }

   }

};

void () ServerflagsCommand = {

   serverflags = ((serverflags * WEAPON_ROCKET) + 1);

};

void () QuadCheat = {

   if ( (deathmatch || coop) ) {

      return ;

   }
   if ( (self.obs == 1) ) {

      return ;

   }
   self.super_time = 1;
   self.super_damage_finished = (time + SVC_INTERMISSION);
   self.items = (self.items | IT_QUAD);
   dprint ("wicked cheat\n");

};

void () PrintLocation = {

   local string p;

   p = vtos (self.origin);
   sprint (self,"You are at ");
   sprint (self,p);
   sprint (self,"\n");

};

void () ImpulseCommands = {

   local string s;
   local float skintype;
   local float t2;
   local float frag1;
   local float time1;
   local string v1,s1,s2,s3,s4,s5;
   if ( ((self.impulse >= 1) && (self.impulse <= 12)) ) {

      W_ChangeWeapon ();

   }
   if ( (self.impulse == 13) ) {

      CheatCommand ();

   }
   if ( (self.impulse == 14) ) {

      CycleWeaponCommand ();

   }

   if ( (self.impulse == SEC) ) {

      ServerflagsCommand ();

   }
   if ( (self.impulse == 20) ) {
      if (self.help == 0) self.help = 1;
      else self.help = 0;

   }

   if ( (self.impulse == 21) ) {
      if ((self.say == 0) && (self.help == 0)) self.say = 1;
      else if ((self.say == 0) && (self.help == 1))
        {
                self.say = 1;
                self.help = 2;
        }
     else if ((self.say == 1) && (self.help == 0)) self.say = 0;
     else if ((self.say == 1) && (self.help == 2))
        {
                self.say = 0;
                self.help = 1;
        }
   }

   if ( (self.impulse == 23) ) {
      if (camping == 0)
      {
      camping = 1;
      bprint ("Camping Check enabled\n");
      }
      else
      {
      camping = 0;
      bprint ("Camping Check disabled\n");
      }
   }
   if (self.impulse == 45) {

      ThrowPeel ();

   }

   if ( (self.impulse == 24) ) {
      if (speedup == 0)
      {
      speedup = 1;
      bprint ("Aah Red Bull gives you speed\n");
      }
      else
      {
      speedup = 0;
      bprint ("Fucking Milk slows you down\n");
      }
   }

   if ( (self.impulse == 25) ) {
      if (pipeson == 0)
      {
      pipeson = 1;
      bprint ("Pipe Bombs enabled\n");
      }
      else
      {
      pipeson = 0;
      bprint ("Pipe Bombs are now disabled\n");
      }
   }

   if (self.impulse == 99)
             PrintLocation();
   if (self.impulse == 111)
        {
        if (vote_leader.message == "id") centerprint(self, "Vote Leader: id software");
        else if (vote_leader.message == "dimen") centerprint(self, "Vote Leader: Dimension");
        else if (vote_leader.message == "fish") centerprint(self, "Vote Leader: FishMan");
        else if (vote_leader.message == "wicked") centerprint(self, "Vote Leader: Wicked World");
        else if (vote_leader.message == "death") centerprint(self, "Vote Leader: DeathMatch");
        }
   if ( (self.impulse == 66) )
   {
   frag1 = (cvar("fraglimit"));
   s1 = ftos(frag1);
   if (camping == 0) s5 = "\n\nNo Camping Checking";
   else s5 = "\n\nCamping Checking is enabled";
   if (cvar("temp1") == 0) s2="\n\nContinoues Levels\n";
   if (cvar("temp1") == 1) s2="\n\nRandom Levels\n";
   if (cvar("temp1") == 2) s2="\n\nExit after this Level\n";
   if ((mapname == "dm1") | (mapname == "dm2") | (mapname == "dm3") | (mapname == "dm4") | (mapname == "dm5") | (mapname == "dm6")) s3 ="id Software - 6 Maps";
   else if ((mapname == "death1") | (mapname == "death2") | (mapname == "death3") | (mapname == "death4") | (mapname == "death5") | (mapname == "death6") | (mapname == "death7") | (mapname == "death8") | (mapname == "death9") | (mapname == "death10") | (mapname == "death11") | (mapname == "death12") | (mapname == "death13") | (mapname == "death14") | (mapname == "death15") | (mapname == "death16") | (mapname == "death17") | (mapname == "death18") | (mapname == "death19") | (mapname == "death20") | (mapname == "death21") | (mapname == "death22") | (mapname == "death23") |
   (mapname == "death24") | (mapname == "death25") | (mapname == "death26") | (mapname == "death27") | (mapname == "death28") | (mapname == "death29") | (mapname == "death30") | (mapname == "death31") | (mapname == "death32") | (mapname == "death33") | (mapname == "death34") | (mapname == "death35") | (mapname == "death36") | (mapname == "death37") | (mapname == "death38") | (mapname == "death39") | (mapname == "death40") | (mapname == "death41") | (mapname == "death42") | (mapname == "death43")) s3="Death Match - 43 Maps";
   else if ((mapname == "1bsp1") | (mapname == "1bsp2") | (mapname == "1bsp3") | (mapname == "1bsp4") | (mapname == "1bsp5") | (mapname == "1bsp6") | (mapname == "1bsp7") | (mapname == "1bsp8") | (mapname == "1bsp9") | (mapname == "1bsp10")) s3="Fishman - 10 Maps";
   else if ((mapname == "dimen1") | (mapname == "dimen2") | (mapname == "dimen3") | (mapname == "dimen4") | (mapname == "dimen5") | (mapname == "dimen6") | (mapname == "dimen7") | (mapname == "dimen8") | (mapname == "dimen9")) s3 = "Dimensionality - 9 Maps";
   else if ((mapname == "wicked1") | (mapname == "wicked2") | (mapname == "wicked3") | (mapname == "wicked4") | (mapname == "wicked5") | (mapname == "wicked6") | (mapname == "wicked7") | (mapname == "wicked8") | (mapname == "wicked9") | (mapname == "wicked10") | (mapname == "wicked11") | (mapname == "wicked12") | (mapname == "wicked13") | (mapname == "wicked14") | (mapname == "wicked15") | (mapname == "wicked16") | (mapname == "wicked17") | (mapname == "wicked18") | (mapname == "wicked19") | (mapname == "wicked20") | (mapname == "wicked21") | (mapname == "wicked22") | (mapname == "wicked23")) s3="Wicked - 26 Maps";
   else s3="No Episode Selected";
   if (frag1 > 0) centerprint7(self, "ùûûûûûûûûûûûûûûûûûûûûûûûûûûûûûûûûûûûü\n\nFraglimit set to: ", s1, s2, "\nEpisode: ", s3, s5, "\n\nùûûûûûûûûûûûûûûûûûûûûûûûûûûûûûûûûûûûü");
   else if (frag1 == 0)  centerprint6(self, "ùûûûûûûûûûûûûûûûûûûûûûûûûûûûûûûûûûûûü\n\nNo Fraglimit set\n", s2, "\nEpisode: ", s3, s5, "\n\nùûûûûûûûûûûûûûûûûûûûûûûûûûûûûûûûûûûûü");
   }

   if ( (self.impulse == 50) ) {

      if (self.holo == 1) {

         sprint (self,"HoloGraph Active\n");
         self.impulse = 0;
         return ;

      }
      if ( (self.ammo_cells < COST) ) {

         sprint (self,"Cells are low - Get 50 cells\n");
         self.impulse = 0;
         return ;

      }
      ActivateHolo (self);

   }
        if(self.impulse == 61)
          if (pipeson == 1)
          W_FirePipeBomb();
          else sprint (self,"Pipebombs are disabled\n");
	if(self.impulse == 62)
	  DetPipeBombs();

        if (self.impulse == 71)
                if (self.bounce == 1)
                sprint(self,"Only one bouncer available\n");
                else
                {
                self.bounce = self.bounce + 1;
                W_LaunchBouncer();
                }

        if (self.impulse == 72)
                if (self.mines == 2)
                sprint(self,"Only two mines available\n");
                else
                {
                self.mines = self.mines + 1;
                W_FireBomb();
                }

        if (self.impulse == 75)
                SelfDestruct();

   if ( (self.impulse == 199) ) {

      ResetSkin ();

   }
   if ( (self.skin_tmp == 1) ) {

      if ( (self.impulse == 201) ) {

         sound (self,CHAN_VOICE,"say/01/01.wav",1,ATTN_NORM);

      }
      if ( (self.impulse == 202) ) {

         sound (self,CHAN_VOICE,"say/01/02.wav",1,ATTN_NORM);

      }
      if ( (self.impulse == 203) ) {

         sound (self,CHAN_VOICE,"say/01/03.wav",1,ATTN_NORM);

      }
      if ( (self.impulse == 204) ) {

         sound (self,CHAN_VOICE,"say/01/04.wav",1,ATTN_NORM);

      }
      if ( (self.impulse == 205) ) {

         sound (self,CHAN_VOICE,"say/01/05.wav",1,ATTN_NORM);

      }
      if ( (self.impulse == 206) ) {

         sound (self,CHAN_VOICE,"say/01/06.wav",1,ATTN_NORM);

      }
      if ( (self.impulse == 207) ) {

         sound (self,CHAN_VOICE,"say/01/07.wav",1,ATTN_NORM);

      }
      if ( (self.impulse == 208) ) {

         sound (self,CHAN_VOICE,"say/01/08.wav",1,ATTN_NORM);

      }
      if ( (self.impulse == 209) ) {

         sound (self,CHAN_VOICE,"say/01/09.wav",1,ATTN_NORM);

      }
      if ( (self.impulse == 210) ) {

         sound (self,CHAN_VOICE,"say/01/10.wav",1,ATTN_NORM);

      }
      if ( (self.impulse == 211) ) {

         sound (self,CHAN_VOICE,"say/01/11.wav",1,ATTN_NORM);

      }
      if ( (self.impulse == 212) ) {

         sound (self,CHAN_VOICE,"say/01/12.wav",1,ATTN_NORM);

      }

   }
   if ( (self.skin_tmp == WEAPON_ROCKET) ) {

      if ( (self.impulse == 201) ) {

         sound (self,CHAN_VOICE,"say/02/01.wav",1,ATTN_NORM);

      }
      if ( (self.impulse == 202) ) {

         sound (self,CHAN_VOICE,"say/02/02.wav",1,ATTN_NORM);

      }
      if ( (self.impulse == 203) ) {

         sound (self,CHAN_VOICE,"say/02/03.wav",1,ATTN_NORM);

      }
      if ( (self.impulse == 204) ) {

         sound (self,CHAN_VOICE,"say/02/04.wav",1,ATTN_NORM);

      }
      if ( (self.impulse == 205) ) {

         sound (self,CHAN_VOICE,"say/02/05.wav",1,ATTN_NORM);

      }
      if ( (self.impulse == 206) ) {

         sound (self,CHAN_VOICE,"say/02/06.wav",1,ATTN_NORM);

      }
      if ( (self.impulse == 207) ) {

         sound (self,CHAN_VOICE,"say/02/07.wav",1,ATTN_NORM);

      }
      if ( (self.impulse == 208) ) {

         sound (self,CHAN_VOICE,"say/02/08.wav",1,ATTN_NORM);

      }
      if ( (self.impulse == 209) ) {

         sound (self,CHAN_VOICE,"say/02/09.wav",1,ATTN_NORM);

      }
      if ( (self.impulse == 210) ) {

         sound (self,CHAN_VOICE,"say/02/10.wav",1,ATTN_NORM);

      }
      if ( (self.impulse == 211) ) {

         sound (self,CHAN_VOICE,"say/02/11.wav",1,ATTN_NORM);

      }
      if ( (self.impulse == 212) ) {

         sound (self,CHAN_VOICE,"say/02/12.wav",1,ATTN_NORM);

      }

   }
   if ( (self.skin_tmp == AS_MELEE) ) {

      if ( (self.impulse == 201) ) {

         sound (self,CHAN_VOICE,"say/03/01.wav",1,ATTN_NORM);

      }
      if ( (self.impulse == 202) ) {

         sound (self,CHAN_VOICE,"say/03/02.wav",1,ATTN_NORM);

      }
      if ( (self.impulse == 203) ) {

         sound (self,CHAN_VOICE,"say/03/03.wav",1,ATTN_NORM);

      }
      if ( (self.impulse == 204) ) {

         sound (self,CHAN_VOICE,"say/03/04.wav",1,ATTN_NORM);

      }
      if ( (self.impulse == 205) ) {

         sound (self,CHAN_VOICE,"say/03/05.wav",1,ATTN_NORM);

      }
      if ( (self.impulse == 206) ) {

         sound (self,CHAN_VOICE,"say/03/06.wav",1,ATTN_NORM);

      }
      if ( (self.impulse == 207) ) {

         sound (self,CHAN_VOICE,"say/03/07.wav",1,ATTN_NORM);

      }
      if ( (self.impulse == 208) ) {

         sound (self,CHAN_VOICE,"say/03/08.wav",1,ATTN_NORM);

      }
      if ( (self.impulse == 209) ) {

         sound (self,CHAN_VOICE,"say/03/09.wav",1,ATTN_NORM);

      }
      if ( (self.impulse == 210) ) {

         sound (self,CHAN_VOICE,"say/03/10.wav",1,ATTN_NORM);

      }
      if ( (self.impulse == 211) ) {

         sound (self,CHAN_VOICE,"say/03/11.wav",1,ATTN_NORM);

      }
      if ( (self.impulse == 212) ) {

         sound (self,CHAN_VOICE,"say/03/12.wav",1,ATTN_NORM);

      }

   }
   if ( (self.skin_tmp == WEAPON_SPIKES) ) {

      if ( (self.impulse == 201) ) {

         sound (self,CHAN_VOICE,"say/04/01.wav",1,ATTN_NORM);

      }
      if ( (self.impulse == 202) ) {

         sound (self,CHAN_VOICE,"say/04/02.wav",1,ATTN_NORM);

      }
      if ( (self.impulse == 203) ) {

         sound (self,CHAN_VOICE,"say/04/03.wav",1,ATTN_NORM);

      }
      if ( (self.impulse == 204) ) {

         sound (self,CHAN_VOICE,"say/04/04.wav",1,ATTN_NORM);

      }
      if ( (self.impulse == 205) ) {

         sound (self,CHAN_VOICE,"say/04/05.wav",1,ATTN_NORM);

      }
      if ( (self.impulse == 206) ) {

         sound (self,CHAN_VOICE,"say/04/06.wav",1,ATTN_NORM);

      }
      if ( (self.impulse == 207) ) {

         sound (self,CHAN_VOICE,"say/04/07.wav",1,ATTN_NORM);

      }
      if ( (self.impulse == 208) ) {

         sound (self,CHAN_VOICE,"say/04/08.wav",1,ATTN_NORM);

      }
      if ( (self.impulse == 209) ) {

         sound (self,CHAN_VOICE,"say/04/09.wav",1,ATTN_NORM);

      }
      if ( (self.impulse == 210) ) {

         sound (self,CHAN_VOICE,"say/04/10.wav",1,ATTN_NORM);

      }
      if ( (self.impulse == 211) ) {

         sound (self,CHAN_VOICE,"say/04/11.wav",1,ATTN_NORM);

      }
      if ( (self.impulse == 212) ) {

         sound (self,CHAN_VOICE,"say/04/12.wav",1,ATTN_NORM);

      }

   }
   if ( (self.skin_tmp == TE_LIGHTNING1) ) {

      if ( (self.impulse == 201) ) {

         sound (self,CHAN_VOICE,"say/05/01.wav",1,ATTN_NORM);

      }
      if ( (self.impulse == 202) ) {

         sound (self,CHAN_VOICE,"say/05/02.wav",1,ATTN_NORM);

      }
      if ( (self.impulse == 203) ) {

         sound (self,CHAN_VOICE,"say/05/03.wav",1,ATTN_NORM);

      }
      if ( (self.impulse == 204) ) {

         sound (self,CHAN_VOICE,"say/05/04.wav",1,ATTN_NORM);

      }
      if ( (self.impulse == 205) ) {

         sound (self,CHAN_VOICE,"say/05/05.wav",1,ATTN_NORM);

      }
      if ( (self.impulse == 206) ) {

         sound (self,CHAN_VOICE,"say/05/06.wav",1,ATTN_NORM);

      }
      if ( (self.impulse == 207) ) {

         sound (self,CHAN_VOICE,"say/05/07.wav",1,ATTN_NORM);

      }
      if ( (self.impulse == 208) ) {

         sound (self,CHAN_VOICE,"say/05/08.wav",1,ATTN_NORM);

      }
      if ( (self.impulse == 209) ) {

         sound (self,CHAN_VOICE,"say/05/09.wav",1,ATTN_NORM);

      }
      if ( (self.impulse == 210) ) {

         sound (self,CHAN_VOICE,"say/05/10.wav",1,ATTN_NORM);

      }
      if ( (self.impulse == 211) ) {

         sound (self,CHAN_VOICE,"say/05/11.wav",1,ATTN_NORM);

      }
      if ( (self.impulse == 212) ) {

         sound (self,CHAN_VOICE,"say/05/12.wav",1,ATTN_NORM);

      }

   }
   if ( (self.skin_tmp == TE_LIGHTNING2) ) {

      if ( (self.impulse == 201) ) {

         sound (self,CHAN_VOICE,"say/06/01.wav",1,ATTN_NORM);

      }
      if ( (self.impulse == 202) ) {

         sound (self,CHAN_VOICE,"say/06/02.wav",1,ATTN_NORM);

      }
      if ( (self.impulse == 203) ) {

         sound (self,CHAN_VOICE,"say/06/03.wav",1,ATTN_NORM);

      }
      if ( (self.impulse == 204) ) {

         sound (self,CHAN_VOICE,"say/06/04.wav",1,ATTN_NORM);

      }
      if ( (self.impulse == 205) ) {

         sound (self,CHAN_VOICE,"say/06/05.wav",1,ATTN_NORM);

      }
      if ( (self.impulse == 206) ) {

         sound (self,CHAN_VOICE,"say/06/06.wav",1,ATTN_NORM);

      }
      if ( (self.impulse == 207) ) {

         sound (self,CHAN_VOICE,"say/06/07.wav",1,ATTN_NORM);

      }
      if ( (self.impulse == 208) ) {

         sound (self,CHAN_VOICE,"say/06/08.wav",1,ATTN_NORM);

      }
      if ( (self.impulse == 209) ) {

         sound (self,CHAN_VOICE,"say/06/09.wav",1,ATTN_NORM);

      }
      if ( (self.impulse == 210) ) {

         sound (self,CHAN_VOICE,"say/06/10.wav",1,ATTN_NORM);

      }
      if ( (self.impulse == 211) ) {

         sound (self,CHAN_VOICE,"say/06/11.wav",1,ATTN_NORM);

      }
      if ( (self.impulse == 212) ) {

         sound (self,CHAN_VOICE,"say/06/12.wav",1,ATTN_NORM);

      }

   }
   if ( (self.skin_tmp == TE_WIZSPIKE) ) {

      if ( (self.impulse == 201) ) {

         sound (self,CHAN_VOICE,"say/07/01.wav",1,ATTN_NORM);

      }
      if ( (self.impulse == 202) ) {

         sound (self,CHAN_VOICE,"say/07/02.wav",1,ATTN_NORM);

      }
      if ( (self.impulse == 203) ) {

         sound (self,CHAN_VOICE,"say/07/03.wav",1,ATTN_NORM);

      }
      if ( (self.impulse == 204) ) {

         sound (self,CHAN_VOICE,"say/07/04.wav",1,ATTN_NORM);

      }
      if ( (self.impulse == 205) ) {

         sound (self,CHAN_VOICE,"say/07/05.wav",1,ATTN_NORM);

      }
      if ( (self.impulse == 206) ) {

         sound (self,CHAN_VOICE,"say/07/06.wav",1,ATTN_NORM);

      }
      if ( (self.impulse == 207) ) {

         sound (self,CHAN_VOICE,"say/07/07.wav",1,ATTN_NORM);

      }
      if ( (self.impulse == 208) ) {

         sound (self,CHAN_VOICE,"say/07/08.wav",1,ATTN_NORM);

      }
      if ( (self.impulse == 209) ) {

         sound (self,CHAN_VOICE,"say/07/09.wav",1,ATTN_NORM);

      }
      if ( (self.impulse == 210) ) {

         sound (self,CHAN_VOICE,"say/07/10.wav",1,ATTN_NORM);

      }
      if ( (self.impulse == 211) ) {

         sound (self,CHAN_VOICE,"say/07/11.wav",1,ATTN_NORM);

      }
      if ( (self.impulse == 212) ) {

         sound (self,CHAN_VOICE,"say/07/12.wav",1,ATTN_NORM);

      }

   }
   if ( (self.skin_tmp == WEAPON_BIG) ) {

      if ( (self.impulse == 201) ) {

         sound (self,CHAN_VOICE,"say/08/01.wav",1,ATTN_NORM);

      }
      if ( (self.impulse == 202) ) {

         sound (self,CHAN_VOICE,"say/08/02.wav",1,ATTN_NORM);

      }
      if ( (self.impulse == 203) ) {

         sound (self,CHAN_VOICE,"say/08/03.wav",1,ATTN_NORM);

      }
      if ( (self.impulse == 204) ) {

         sound (self,CHAN_VOICE,"say/08/04.wav",1,ATTN_NORM);

      }
      if ( (self.impulse == 205) ) {

         sound (self,CHAN_VOICE,"say/08/05.wav",1,ATTN_NORM);

      }
      if ( (self.impulse == 206) ) {

         sound (self,CHAN_VOICE,"say/08/06.wav",1,ATTN_NORM);

      }
      if ( (self.impulse == 207) ) {

         sound (self,CHAN_VOICE,"say/08/07.wav",1,ATTN_NORM);

      }
      if ( (self.impulse == 208) ) {

         sound (self,CHAN_VOICE,"say/08/08.wav",1,ATTN_NORM);

      }
      if ( (self.impulse == 209) ) {

         sound (self,CHAN_VOICE,"say/08/09.wav",1,ATTN_NORM);

      }
      if ( (self.impulse == 210) ) {

         sound (self,CHAN_VOICE,"say/08/10.wav",1,ATTN_NORM);

      }

      if ( (self.impulse == 211) ) {

         sound (self,CHAN_VOICE,"say/08/11.wav",1,ATTN_NORM);

      }
      if ( (self.impulse == 212) ) {

         sound (self,CHAN_VOICE,"say/08/12.wav",1,ATTN_NORM);

      }

   }
   if ( (self.impulse == 255) ) {

      self.cheat = 1;
      QuadCheat ();

   }
   self.impulse = 0;

};

void () W_WeaponFrame = {

   if ( (time < self.attack_finished) ) {

      return ;

   }
   ImpulseCommands ();
   if ( self.button0 ) {

      SuperDamageSound ();
      W_Attack ();

   }

};

void () SuperDamageSound = {

   if ( (self.super_damage_finished > time) ) {

      if ( (self.super_sound < time) ) {

         self.super_sound = (time + 1);
         sound (self,CHAN_BODY,"items/damage3.wav",1,ATTN_NORM);

      }

   }
   return ;

};
/***********************************************************************************
================
W_FireBomb
================
************************************************************************************/
void() W_FireBomb =
{
	local   entity missile, mpuff;

        if (self.ammo_rockets < 5)
	{
		return;
	}


	if (bombtimer >0 )
	{
		return;
	}
	else 	bombtimer=1.5;


	self.currentammo = self.ammo_rockets = self.ammo_rockets - 5;
	


	self.punchangle_x = -10;

	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_FLY;
	missile.solid = SOLID_TRIGGER;
	missile.classname = "Bomb";
		
// set missile speed    

	makevectors (self.v_angle);


	missile.velocity= '0 0 0';
	missile.avelocity= '0 0 0';
	
	missile.touch = BombTouch;
	
// set missile duration
	missile.nextthink = time + 0.25;
	missile.think = BombTime;

	setmodel (missile, "progs/grenade.mdl");
	setsize (missile, '-48 -48 -4', '48 48 4');            
	setorigin (missile, self.origin - '0 0 20');
//	sprint(self,"Better stay the hell clear now\n");
};

void() BombTime =
{
	bombtimer = bombtimer - 0.25;
	if (bombtimer)
		{
		if (bombtimer == 0.5) self.velocity='0 0 24';
		sound (self, CHAN_WEAPON, "weapons/bounce.wav", 1, ATTN_NORM);  // bounce sound
		self.nextthink = time + 0.25;
		self.think = BombTime;
		} 
	else
	{
		self.nextthink = time + 180;
		self.think = BecomeExplosion;
		self.classname = "ArmedBomb";
		self.velocity='0 0 0';
		self.avelocity='0 800 800';
		
		self.health = 20;
		self.th_die = BombExplode;
		self.takedamage = DAMAGE_AIM;

	}
};

void() BombTouch =
{
	if (other.takedamage && (self.classname == "ArmedBomb") && (other.classname != "ArmedBomb"))
	{
		BombExplode();
		return;
	}

};

void() BombExplode =
{
        T_RadiusDamage (self, self.owner, 100, world);

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);

	BombExplosion ();
};

void() BombExplosion =
{
	sound (self, CHAN_AUTO, "items/damage2.wav", 1, ATTN_NORM);
	self.movetype = MOVETYPE_NONE;
	self.velocity = '0 0 0';
	self.touch = SUB_Null;
	setmodel (self, "progs/s_explod.spr");
	self.solid = SOLID_NOT;
	s_explode1 ();
        self.owner.mines = self.owner.mines - 1;
};

void() ShrapnelExplode =
{
	T_RadiusDamage (self, self.owner, 120, world);

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);

	BecomeExplosion ();
};

void() GIBExplode =
{
	local entity loser;
	self.wait = self.wait - 1;
	loser = self.trigger_field;

	if ((self.wait == 30) || (self.wait == 20) || (self.wait == 10)) 	sound (self, CHAN_WEAPON, "player/tornoff2.wav", 1, ATTN_NORM);	
	if (((self.wait == 35) || (self.wait == 25) || (self.wait == 15)) && (loser.classname == "player")) 	sound (self, CHAN_WEAPON, "player/lburn1.wav", 1, ATTN_NORM);	

	if ((!self.wait) || (loser.health<=10))
	{
	T_RadiusDamage (self, self.owner, 120, world);

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);

	BecomeExplosion ();
	return;
	}

	
	T_Damage (loser, self, self.owner, 2.5 );
	spawn_touchblood (30);

	self.origin = loser.origin + '0 0 12';
	self.nextthink = time + 0.05;
	self.think = GIBExplode;
		
};

void() T_GIBTouch =
{
	local float     damg;

	if (other == self.owner)
		return;         // don't explode on owner

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}


	
	if (other.takedamage)
	{
		sound (self, CHAN_WEAPON, "player/tornoff2.wav", 1, ATTN_NORM);	
		self.trigger_field = other;
		self.origin = other.origin + '0 0 12';
		self.wait = 40;

		self.nextthink = time + 0.05;
		self.think = GIBExplode;
		self.movetype = MOVETYPE_NOCLIP;
		self.velocity = '0 0 0' ;
		self.avelocity = '0 0 1000';
		return;
	}
	sound (self, CHAN_WEAPON, "weapons/bounce.wav", 1, ATTN_NORM);  // bounce sound
//	remove(self);
	self.nextthink = time + 0.3;
	self.think = SUB_Remove;
	self.movetype = MOVETYPE_NOCLIP;
	self.velocity = ' 0 0 0';
	self.avelocity = '0 0 1000';
};



/*
================
W_FireGIBGUN
================
*/
void() W_FireGIBGUN =
{
        if ((self.ammo_rockets < 1))
	{
		return;
	}
	local   entity missile, mpuff;
	
	self.currentammo = self.ammo_rockets = self.ammo_rockets - 1;
	
	sound (self, CHAN_WEAPON, "weapons/sgun1.wav", 1, ATTN_NORM);

	self.punchangle_x = -2;

	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_FLYMISSILE;
	missile.solid = SOLID_BBOX;
	missile.classname = "GibGun";
	
// set missile speed    

	makevectors (self.v_angle);
	missile.velocity = aim(self, 1000);
	missile.velocity = missile.velocity * 1000;
	missile.angles = vectoangles(missile.velocity);
	
	missile.touch = T_GIBTouch;
	
// set missile duration
	missile.nextthink = time + 5;
	missile.think = SUB_Remove;
	setmodel (missile, "progs/missile.mdl");
	setsize (missile, '0 0 0', '0 0 0');            
	setorigin (missile, self.origin + v_forward*8 + '0 0 16');
};

/*
================
W_FireFlash
================
*/
void() W_FireFLASH =
{
        if (self.ammo_rockets < 5)
	{
		return;
	}
	local   entity missile, mpuff;
	
	self.currentammo = self.ammo_rockets = self.ammo_rockets - 5;
	
	sound (self, CHAN_WEAPON, "weapons/sgun1.wav", 1, ATTN_NORM);

	self.punchangle_x = -2;

	missile = spawn ();
	missile.owner = self;
	missile.movetype = MOVETYPE_FLYMISSILE;
	missile.solid = SOLID_BBOX;
	missile.classname = "Flash";
	
// set missile speed    

	makevectors (self.v_angle);
	missile.velocity = aim(self, 100000);
	missile.velocity = missile.velocity * 800;
	missile.angles = vectoangles(missile.velocity);
	
	missile.touch = T_FlashTouch;
	
// set missile duration
	missile.nextthink = time + 5;
	missile.think = SUB_Remove;

	setmodel (missile, "progs/missile.mdl");
	setsize (missile, '0 0 0', '0 0 0');            
	setorigin (missile, self.origin + v_forward*8 + '0 0 16');

};

void() T_FlashTouch =
{
	local float     damg;

	if (other == self.owner)
		return;         // don't explode on owner

	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		return;
	}
	
	self.effects = self.effects | EF_BRIGHTLIGHT;		
	damg = 20;
	
	if (other.health)
	{
		if (other.classname == "monster_shambler")
			damg = damg * 0.5;      // mostly immune
		T_Damage (other, self, self.owner, damg );
	}

	// don't do radius damage to the other, because all the damage
	// was done in the impact
	T_RadiusDamage (self, self.owner, 20, other);

        sound (self, CHAN_WEAPON, "doors/airdoor2.wav", 1, ATTN_NORM);
	self.origin = self.origin - 8*normalize(self.velocity);
	

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);

	BecomeExplosion ();
};

/*
============
SelfDestruct
============
*/
void() SelfDestruct =
{
         if (self.ammo_rockets >= 5)
         {
                      if (self.health >= 30)
                      {
                                      sprint (self, "Sorry, You Still Got A Little Life In Ya!\n");
                      }
                      else
                      {
                                      sprint (self, "Have A Nice Day!\n");
                                      T_RadiusDamage (self, self, 50*self.ammo_rockets, world);
                                      W_SetCurrentAmmo ();
                                      sound (self, CHAN_WEAPON, "weapons/r_exp3.wav", 1, ATTN_NORM);
                                      WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
                                      WriteByte (MSG_BROADCAST, TE_EXPLOSION);
                                      WriteCoord (MSG_BROADCAST, self.origin_x);
                                      WriteCoord (MSG_BROADCAST, self.origin_y);
                                      WriteCoord (MSG_BROADCAST, self.origin_z);

                                      return;
                      }

         }
         else
         {
                      sprint (self, "Sorry Mr. Suicide... Not Enough Ammo.\n");
         }
        
};

