void () W_SetCurrentAmmo;

void () SUB_regen = {

   self.model = self.mdl;
   self.solid = SOLID_TRIGGER;
   sound (self,CHAN_VOICE,"items/itembk2.wav",AS_STRAIGHT,ATTN_NORM);
   setorigin (self,self.origin);

};

void () noclass = {

   dprint ("noclass spawned at");
   dprint (vtos (self.origin));
   dprint ("\n");
   remove (self);

};

void () PlaceItem = {

   local float oldz;

   self.mdl = self.model;
   self.flags = FL_ITEM;
   self.solid = SOLID_TRIGGER;
   self.movetype = MOVETYPE_TOSS;
   self.velocity = VEC_ORIGIN;
   self.origin_z = (self.origin_z + TE_LIGHTNING2);
   oldz = self.origin_z;
   if ( !droptofloor () ) {

      dprint ("Bonus item fell out of level at ");
      dprint (vtos (self.origin));
      dprint ("\n");
      remove (self);
      return ;

   }

};

void () StartItem = {

   self.nextthink = (time + 0.200);
   self.think = PlaceItem;

};
float (entity e, float healamount, float ignore) T_Heal = {

   if ( (e.health <= MSG_BROADCAST) ) {

      return ( MSG_BROADCAST );

   }
   if ( (!ignore && (e.health >= other.max_health)) ) {

      return ( MSG_BROADCAST );

   }
   healamount = ceil (healamount);
   e.health = (e.health + healamount);
   if ( (!ignore && (e.health >= other.max_health)) ) {

      e.health = other.max_health;

   }
   if ( (e.health > 250.000) ) {

      e.health = 250.000;

   }
   return ( AS_STRAIGHT );

};
float H_ROTTEN    = 1.000;
float H_MEGA    = 2.000;
.float healamount;
.float healtype;

void () health_touch;

void () item_megahealth_rot;

void () item_health = {

   self.touch = health_touch;
   if ( (self.spawnflags & H_ROTTEN) ) {

      precache_model ("maps/b_bh10.bsp");
      precache_sound ("items/r_item1.wav");
      setmodel (self,"maps/b_bh10.bsp");
      self.noise = "items/r_item1.wav";
      self.healamount = 15.000;
      self.healtype = MSG_BROADCAST;

   } else {

      if ( (self.spawnflags & H_MEGA) ) {

         precache_model ("maps/b_bh100.bsp");
         precache_sound ("items/r_item2.wav");
         setmodel (self,"maps/b_bh100.bsp");
         self.noise = "items/r_item2.wav";
         self.healamount = 100.000;
         self.healtype = AS_SLIDING;

      } else {

         precache_model ("maps/b_bh25.bsp");
         precache_sound ("items/health1.wav");
         setmodel (self,"maps/b_bh25.bsp");
         self.noise = "items/health1.wav";
         self.healamount = 25.000;
         self.healtype = AS_STRAIGHT;

      }

   }
   setsize (self,VEC_ORIGIN,'32.000 32.000 56.000');
   StartItem ();

};

void () health_touch = {

   local float amount;
   local string s;

   if ( (other.classname != "player") ) {

      return ;

   }
   if ( (other.skin == MSG_BROADCAST) ) {

      return ;

   }
   if ( (other.obs == AS_STRAIGHT) ) {

      return ;

   }
   if ( (self.healtype == AS_SLIDING) ) {

      if ( (other.health >= 250.000) ) {

         return ;

      }
      if ( !T_Heal (other,self.healamount,AS_STRAIGHT) ) {

         return ;

      }

   } else {

      if ( !T_Heal (other,self.healamount,MSG_BROADCAST) ) {

         return ;

      }

   }
   sound (other,CHAN_ITEM,self.noise,AS_STRAIGHT,ATTN_NORM);
   stuffcmd (other,"bf\n");
   self.model = string_null;
   self.solid = SOLID_NOT;
   if ( (self.healtype == AS_SLIDING) ) {

      other.items = (other.items | IT_SUPERHEALTH);
      self.nextthink = (time + TE_LIGHTNING1);
      self.think = item_megahealth_rot;
      self.owner = other;

   } else {

      if ( (deathmatch != AS_SLIDING) ) {

         if ( deathmatch ) {

      if (speedup == 0) self.nextthink = (time + 30);
      else self.nextthink = (time + 5);

         }
         self.think = SUB_regen;

      }

   }
   activator = other;
   SUB_UseTargets ();

};

void () item_megahealth_rot = {

   other = self.owner;
   if ( (other.health > other.max_health) ) {

      other.health = (other.health - AS_STRAIGHT);
      self.nextthink = (time + AS_STRAIGHT);
      return ;

   }
   other.items = (other.items - (other.items & IT_SUPERHEALTH));
   if ( (deathmatch == AS_STRAIGHT) ) {

      if (speedup == 0) self.nextthink = (time + 30);
      else self.nextthink = (time + 10);
      self.think = SUB_regen;

   }

};

void () armor_touch = {

   local float type;
   local float value;
   local float bit;

   if ( (other.health <= MSG_BROADCAST) ) {

      return ;

   }
   if ( (other.classname != "player") ) {

      return ;

   }
   if ( (other.skin == MSG_BROADCAST) ) {

      return ;

   }
   if ( (other.obs == AS_STRAIGHT) ) {

      return ;

   }
   if ( (self.classname == "item_armor1") ) {

      type = 0.300;
      value = 100.000;
      bit = IT_ARMOR1;

   }
   if ( (self.classname == "item_armor2") ) {

      type = 0.600;
      value = 150.000;
      bit = IT_ARMOR2;

   }
   if ( (self.classname == "item_armorInv") ) {

      type = 0.800;
      value = 200.000;
      bit = IT_ARMOR3;

   }
   if ( ((other.armortype * other.armorvalue) >= (type * value)) ) {

      return ;

   }
   other.armortype = type;
   other.armorvalue = value;
   other.items = ((other.items - (other.items & ((IT_ARMOR1 | IT_ARMOR2) | IT_ARMOR3))) + bit);
   self.solid = SOLID_NOT;
   self.model = string_null;
   if ( (deathmatch == AS_STRAIGHT) ) {

      if (speedup == 0) self.nextthink = (time + 30);
      else self.nextthink = (time + 5);

   }
   self.think = SUB_regen;
   stuffcmd (other,"bf\n");
   activator = other;
   SUB_UseTargets ();

};

void () item_armor1 = {

   self.touch = armor_touch;
   precache_model ("progs/armor.mdl");
   setmodel (self,"progs/armor.mdl");
   self.skin = MSG_BROADCAST;
   setsize (self,'-16.000 -16.000 0.000','16.000 16.000 56.000');
   StartItem ();

};

void () item_armor2 = {

   self.touch = armor_touch;
   precache_model ("progs/armor.mdl");
   setmodel (self,"progs/armor.mdl");
   self.skin = AS_STRAIGHT;
   setsize (self,'-16.000 -16.000 0.000','16.000 16.000 56.000');
   StartItem ();

};

void () item_armorInv = {

   self.touch = armor_touch;
   precache_model ("progs/armor.mdl");
   setmodel (self,"progs/armor.mdl");
   self.skin = AS_SLIDING;
   setsize (self,'-16.000 -16.000 0.000','16.000 16.000 56.000');
   StartItem ();

};

void () bound_other_ammo = {

   if ( (other.ammo_shells > 250.000) ) {

      other.ammo_shells = 250.000;

   }
   if ( (other.ammo_nails > 250.000) ) {

      other.ammo_nails = 250.000;

   }
   if ( (other.ammo_rockets > 250.000) ) {

      other.ammo_rockets = 250.000;

   }
   if ( (other.ammo_cells > 250.000) ) {

      other.ammo_cells = 250.000;

   }

};
float (float w) RankForWeapon = {

   if ( (w == IT_LIGHTNING) ) {

      return ( AS_STRAIGHT );

   }
   if ( (w == IT_ROCKET_LAUNCHER) ) {

      return ( AS_SLIDING );

   }
   if ( (w == IT_SUPER_NAILGUN) ) {

      return ( AS_MELEE );

   }
   if ( (w == IT_GRENADE_LAUNCHER) ) {

      return ( AS_MISSILE );

   }
   if ( (w == IT_SUPER_SHOTGUN) ) {

      return ( TE_LIGHTNING1 );

   }
   if ( (w == IT_NAILGUN) ) {

      return ( TE_LIGHTNING2 );

   }
   return ( TE_WIZSPIKE );

};

void (float old, float new) Deathmatch_Weapon = {

   local float or;
   local float nr;

   or = RankForWeapon (self.weapon);
   nr = RankForWeapon (new);
   if ( (nr < or) ) {

      self.weapon = new;

   }

};
float () W_BestWeapon;

void () weapon_touch = {

   local float hadammo;
   local float best;
   local float new;
   local float old;
   local entity stemp;
   local float leave;

   if ( (other.skin == MSG_BROADCAST) ) {

      return ;

   }
   if ( (other.obs == AS_STRAIGHT) ) {

      return ;

   }
   if ( !(other.flags & FL_CLIENT) ) {

      return ;

   }
   stemp = self;
   self = other;
   best = W_BestWeapon ();
   self = stemp;
   if ( ((deathmatch == AS_SLIDING) || coop) ) {

      leave = AS_STRAIGHT;

   } else {

      leave = MSG_BROADCAST;

   }
   if ( (self.classname == "weapon_nailgun") ) {

      if ( (leave && (other.items & IT_NAILGUN)) ) {

         return ;

      }
      hadammo = other.ammo_nails;
      other.nailgun = 1;
      new = IT_NAILGUN;
            if (speedup == 0) other.ammo_nails = (other.ammo_nails + 30);
            else other.ammo_nails = (other.ammo_nails + 60);

   } else {

      if ( (self.classname == "weapon_supernailgun") ) {

         if ( (leave && (other.items & IT_SUPER_NAILGUN)) ) {

            return ;

         }
         hadammo = other.ammo_rockets;
         new = IT_SUPER_NAILGUN;
         other.supernailgun = 1;
            if (speedup == 0) other.ammo_nails = (other.ammo_nails + 30);
            else other.ammo_nails = (other.ammo_nails + 60);

      } else {

         if ( (self.classname == "weapon_supershotgun") ) {

            if ( (leave && (other.items & IT_SUPER_SHOTGUN)) ) {

               return ;

            }
            hadammo = other.ammo_rockets;
            other.supershot = 1;
            new = IT_SUPER_SHOTGUN;
            if (speedup == 0) other.ammo_shells = (other.ammo_shells + 5);
            else other.ammo_shells = (other.ammo_shells + 25);
         } else {

            if ( (self.classname == "weapon_rocketlauncher") ) {

               if ( (leave && (other.items & IT_ROCKET_LAUNCHER)) ) {

                  return ;

               }
               hadammo = other.ammo_rockets;
               other.rocket = 1;
               new = IT_ROCKET_LAUNCHER;
            if (speedup == 0) other.ammo_rockets = (other.ammo_rockets + 5);
            else other.ammo_rockets = (other.ammo_rockets + 25);

            } else {

               if ( (self.classname == "weapon_grenadelauncher") ) {

                  if ( (leave && (other.items & IT_GRENADE_LAUNCHER)) ) {

                     return ;

                  }
                  hadammo = other.ammo_rockets;
                  other.grenade = 1;
                  other.items = (other.items | IT_FLAMETHROWER);
                  new = IT_GRENADE_LAUNCHER;
            if (speedup == 0) other.ammo_rockets = (other.ammo_rockets + 5);
            else other.ammo_rockets = (other.ammo_rockets + 25);

               } else {

                  if ( (self.classname == "weapon_lightning") ) {

                     if ( (leave && (other.items & IT_LIGHTNING)) ) {

                        return ;

                     }
                     hadammo = other.ammo_rockets;
                     other.lightning = 1;
                     self.items = self.items | IT_LASER;
                     new = IT_LIGHTNING;
            if (speedup == 0) other.ammo_cells = (other.ammo_cells + 25);
            else other.ammo_cells = (other.ammo_cells + 50);

                  } else {

                     objerror ("weapon_touch: unknown classname");

                  }

               }

            }

         }

      }

   }
   sound (other,CHAN_ITEM,"weapons/pkup.wav",AS_STRAIGHT,ATTN_NORM);
   stuffcmd (other,"bf\n");
   bound_other_ammo ();
   old = other.items;
   other.items = (other.items | new);
   stemp = self;
   self = other;
   if ( !deathmatch ) {

      self.weapon = new;

   } else {

      Deathmatch_Weapon (old,new);

   }
   W_SetCurrentAmmo ();
   self = stemp;
   if ( leave ) {

      return ;

   }
   self.model = string_null;
   self.solid = SOLID_NOT;
   if ( (deathmatch == AS_STRAIGHT) ) {

      if (speedup == 0) self.nextthink = (time + 5);
      else self.nextthink = time;
   }
   self.think = SUB_regen;
   activator = other;
   SUB_UseTargets ();

};

void () weapon_supershotgun = {

   precache_model ("progs/g_shot.mdl");
   setmodel (self,"progs/g_shot.mdl");
   self.weapon = IT_SUPER_SHOTGUN;
   self.netname = "Double-barrelled Shotgun";
   self.touch = weapon_touch;
   setsize (self,'-16.000 -16.000 0.000','16.000 16.000 56.000');
   StartItem ();

};

void () weapon_nailgun = {

   precache_model ("progs/g_nail.mdl");
   setmodel (self,"progs/g_nail.mdl");
   self.weapon = IT_NAILGUN;
   self.netname = "nailgun";
   self.touch = weapon_touch;
   setsize (self,'-16.000 -16.000 0.000','16.000 16.000 56.000');
   StartItem ();

};

void () weapon_supernailgun = {

   precache_model ("progs/g_nail2.mdl");
   setmodel (self,"progs/g_nail2.mdl");
   self.weapon = IT_SUPER_NAILGUN;
   self.netname = "Super Nailgun";
   self.touch = weapon_touch;
   setsize (self,'-16.000 -16.000 0.000','16.000 16.000 56.000');
   StartItem ();

};

void () weapon_chainsaw = {

   setmodel (self,"progs/v_chain.mdl");
   self.frame = MOVETYPE_FLY;
   self.weapon = IT_NAILGUN;
   self.netname = "chainsaw!";
   self.touch = weapon_touch;
   setsize (self,'-16.000 -16.000 0.000','16.000 16.000 56.000');
   StartItem ();

};

void () weapon_grenadelauncher = {

   precache_model ("progs/g_rock.mdl");
   setmodel (self,"progs/g_rock.mdl");
   self.weapon = AS_MELEE;
   self.netname = "Grenade Launcher";
   self.touch = weapon_touch;
   setsize (self,'-16.000 -16.000 0.000','16.000 16.000 56.000');
   StartItem ();

};

void () weapon_rocketlauncher = {

   precache_model ("progs/g_rock2.mdl");
   setmodel (self,"progs/g_rock2.mdl");
   self.weapon = AS_MELEE;
   self.netname = "Rocket Launcher";
   self.touch = weapon_touch;
   setsize (self,'-16.000 -16.000 0.000','16.000 16.000 56.000');
   StartItem ();

};

void () weapon_lightning = {

   precache_model ("progs/g_light.mdl");
   setmodel (self,"progs/g_light.mdl");
   self.weapon = AS_MELEE;
   self.netname = "Thunderbolt";
   self.touch = weapon_touch;
   setsize (self,'-16.000 -16.000 0.000','16.000 16.000 56.000');
   StartItem ();

};

void () ammo_touch = {

   local entity stemp;
   local float best;

   if ( (other.classname != "player") ) {

      return ;

   }
   if ( (other.skin == MSG_BROADCAST) ) {

      return ;

   }
   if ( (other.obs == AS_STRAIGHT) ) {

      return ;

   }
   if ( (other.health <= MSG_BROADCAST) ) {

      return ;

   }
   stemp = self;
   self = other;
   best = W_BestWeapon ();
   self = stemp;
   if ( (self.weapon == AS_STRAIGHT) ) {

      if ( (other.ammo_shells >= 100.000) ) {

         return ;

      }
      other.ammo_shells = (other.ammo_shells + self.aflag);

   }
   if ( (self.weapon == AS_SLIDING) ) {

      if ( (other.ammo_nails >= 200.000) ) {

         return ;

      }
      other.ammo_nails = (other.ammo_nails + self.aflag);

   }
   if ( (self.weapon == AS_MELEE) ) {

      if ( (other.ammo_rockets >= 100.000) ) {

         return ;

      }
      other.ammo_rockets = (other.ammo_rockets + self.aflag);

   }
   if ( (self.weapon == AS_MISSILE) ) {

      if ( (other.ammo_cells >= 200.000) ) {

         return ;

      }
      other.ammo_cells = (other.ammo_cells + self.aflag);

   }
   bound_other_ammo ();
   sound (other,CHAN_ITEM,"weapons/lock4.wav",AS_STRAIGHT,ATTN_NORM);
   stuffcmd (other,"bf\n");
   if ( (other.weapon == best) ) {

      stemp = self;
      self = other;
      self.weapon = W_BestWeapon ();
      W_SetCurrentAmmo ();
      self = stemp;

   }
   stemp = self;
   self = other;
   W_SetCurrentAmmo ();
   self = stemp;
   self.model = string_null;
   self.solid = SOLID_NOT;
   if ( (deathmatch == AS_STRAIGHT) ) {

      if (speedup == 0) self.nextthink = (time + 5);
      else self.nextthink = time;

   }
   self.think = SUB_regen;
   activator = other;
   SUB_UseTargets ();

};
float WEAPON_BIG2    = 1.000;

void () item_shells = {

   self.touch = ammo_touch;
   if ( (self.spawnflags & WEAPON_BIG2) ) {

      precache_model ("maps/b_shell1.bsp");
      setmodel (self,"maps/b_shell1.bsp");
      self.aflag = 40.000;

   } else {

      precache_model ("maps/b_shell0.bsp");
      setmodel (self,"maps/b_shell0.bsp");
      self.aflag = 20.000;

   }
   self.weapon = AS_STRAIGHT;
   self.netname = "shells";
   setsize (self,VEC_ORIGIN,'32.000 32.000 56.000');
   StartItem ();

};

void () item_spikes = {

   self.touch = ammo_touch;
   if ( (self.spawnflags & WEAPON_BIG2) ) {

      precache_model ("maps/b_nail1.bsp");
      setmodel (self,"maps/b_nail1.bsp");
      self.aflag = 50.000;

   } else {

      precache_model ("maps/b_nail0.bsp");
      setmodel (self,"maps/b_nail0.bsp");
      self.aflag = 25.000;

   }
   self.weapon = AS_SLIDING;
   self.netname = "nails";
   setsize (self,VEC_ORIGIN,'32.000 32.000 56.000');
   StartItem ();

};

void () item_rockets = {

   self.touch = ammo_touch;
   if ( (self.spawnflags & WEAPON_BIG2) ) {

      precache_model ("maps/b_rock1.bsp");
      setmodel (self,"maps/b_rock1.bsp");
      self.aflag = TE_LAVASPLASH;

   } else {

      precache_model ("maps/b_rock0.bsp");
      setmodel (self,"maps/b_rock0.bsp");
      self.aflag = TE_LIGHTNING1;

   }
   self.weapon = AS_MELEE;
   self.netname = "rockets";
   setsize (self,VEC_ORIGIN,'32.000 32.000 56.000');
   StartItem ();

};

void () item_cells = {

   self.touch = ammo_touch;
   if ( (self.spawnflags & WEAPON_BIG2) ) {

      precache_model ("maps/b_batt1.bsp");
      setmodel (self,"maps/b_batt1.bsp");
      self.aflag = 12.000;

   } else {

      precache_model ("maps/b_batt0.bsp");
      setmodel (self,"maps/b_batt0.bsp");
      self.aflag = TE_LIGHTNING2;

   }
   self.weapon = AS_MISSILE;
   self.netname = "cells";
   setsize (self,VEC_ORIGIN,'32.000 32.000 56.000');
   StartItem ();

};
float WEAPON_SHOTGUN    = 1.000;
float WEAPON_ROCKET    = 2.000;
float WEAPON_SPIKES    = 4.000;
float WEAPON_BIG    = 8.000;

void () item_weapon = {

   self.touch = ammo_touch;
   if ( (self.spawnflags & WEAPON_SHOTGUN) ) {

      if ( (self.spawnflags & WEAPON_BIG) ) {

         precache_model ("maps/b_shell1.bsp");
         setmodel (self,"maps/b_shell1.bsp");
         self.aflag = 40.000;

      } else {

         precache_model ("maps/b_shell0.bsp");
         setmodel (self,"maps/b_shell0.bsp");
         self.aflag = 20.000;

      }
      self.weapon = AS_STRAIGHT;
      self.netname = "shells";

   }
   if ( (self.spawnflags & WEAPON_SPIKES) ) {

      if ( (self.spawnflags & WEAPON_BIG) ) {

         precache_model ("maps/b_nail1.bsp");
         setmodel (self,"maps/b_nail1.bsp");
         self.aflag = 40.000;

      } else {

         precache_model ("maps/b_nail0.bsp");
         setmodel (self,"maps/b_nail0.bsp");
         self.aflag = 20.000;

      }
      self.weapon = AS_SLIDING;
      self.netname = "spikes";

   }
   if ( (self.spawnflags & WEAPON_ROCKET) ) {

      if ( (self.spawnflags & WEAPON_BIG) ) {

         precache_model ("maps/b_rock1.bsp");
         setmodel (self,"maps/b_rock1.bsp");
         self.aflag = TE_LAVASPLASH;

      } else {

         precache_model ("maps/b_rock0.bsp");
         setmodel (self,"maps/b_rock0.bsp");
         self.aflag = TE_LIGHTNING1;

      }
      self.weapon = AS_MELEE;
      self.netname = "rockets";

   }
   setsize (self,VEC_ORIGIN,'32.000 32.000 56.000');
   StartItem ();

};

void () key_touch = {

   local entity stemp;
   local float best;

   if ( (other.classname != "player") ) {

      return ;

   }
   if ( (other.skin == MSG_BROADCAST) ) {

      return ;

   }
   if ( (other.obs == AS_STRAIGHT) ) {

      return ;

   }
   if ( (other.health <= MSG_BROADCAST) ) {

      return ;

   }
   if ( (other.items & self.items) ) {

      return ;

   }
   sprint (other,"You got the ");
   sprint (other,self.netname);
   sprint (other,"\n");
   sound (other,CHAN_ITEM,self.noise,AS_STRAIGHT,ATTN_NORM);
   stuffcmd (other,"bf\n");
   other.items = (other.items | self.items);
   if ( !coop ) {

      self.solid = SOLID_NOT;
      self.model = string_null;

   }
   activator = other;
   SUB_UseTargets ();

};

void () key_setsounds = {

   if ( (world.worldtype == MSG_BROADCAST) ) {

      precache_sound ("misc/medkey.wav");
      self.noise = "misc/medkey.wav";

   }
   if ( (world.worldtype == AS_STRAIGHT) ) {

      precache_sound ("misc/runekey.wav");
      self.noise = "misc/runekey.wav";

   }
   if ( (world.worldtype == AS_SLIDING) ) {

      precache_sound2 ("misc/basekey.wav");
      self.noise = "misc/basekey.wav";

   }

};

void () item_key1 = {

   if ( (world.worldtype == MSG_BROADCAST) ) {

      precache_model ("progs/w_s_key.mdl");
      setmodel (self,"progs/w_s_key.mdl");
      self.netname = "silver key";

   } else {

      if ( (world.worldtype == AS_STRAIGHT) ) {

         precache_model ("progs/m_s_key.mdl");
         setmodel (self,"progs/m_s_key.mdl");
         self.netname = "silver runekey";

      } else {

         if ( (world.worldtype == AS_SLIDING) ) {

            precache_model2 ("progs/b_s_key.mdl");
            setmodel (self,"progs/b_s_key.mdl");
            self.netname = "silver keycard";

         }

      }

   }
   key_setsounds ();
   self.touch = key_touch;
   self.items = IT_KEY1;
   setsize (self,VEC_HULL_MIN,VEC_HULL_MAX);
   StartItem ();

};

void () item_key2 = {

   if ( (world.worldtype == MSG_BROADCAST) ) {

      precache_model ("progs/w_g_key.mdl");
      setmodel (self,"progs/w_g_key.mdl");
      self.netname = "gold key";

   }
   if ( (world.worldtype == AS_STRAIGHT) ) {

      precache_model ("progs/m_g_key.mdl");
      setmodel (self,"progs/m_g_key.mdl");
      self.netname = "gold runekey";

   }
   if ( (world.worldtype == AS_SLIDING) ) {

      precache_model2 ("progs/b_g_key.mdl");
      setmodel (self,"progs/b_g_key.mdl");
      self.netname = "gold keycard";

   }
   key_setsounds ();
   self.touch = key_touch;
   self.items = IT_KEY2;
   setsize (self,VEC_HULL_MIN,VEC_HULL_MAX);
   StartItem ();

};

void () sigil_touch = {

   local entity stemp;
   local float best;

   if ( (other.classname != "player") ) {

      return ;

   }
   if ( (other.skin == MSG_BROADCAST) ) {

      return ;

   }
   if ( (other.obs == AS_STRAIGHT) ) {

      return ;

   }
   if ( (other.health <= MSG_BROADCAST) ) {

      return ;

   }
   centerprint (other,"You got the rune!");
   sound (other,CHAN_ITEM,self.noise,AS_STRAIGHT,ATTN_NORM);
   stuffcmd (other,"bf\n");
   self.solid = SOLID_NOT;
   self.model = string_null;
   serverflags = (serverflags | (self.spawnflags & 15.000));
   self.classname = "";
   activator = other;
   SUB_UseTargets ();

};

void () item_sigil = {

   if ( !self.spawnflags ) {

      objerror ("no spawnflags");

   }
   precache_sound ("misc/runekey.wav");
   self.noise = "misc/runekey.wav";
   if ( (self.spawnflags & AS_STRAIGHT) ) {

      precache_model ("progs/end1.mdl");
      setmodel (self,"progs/end1.mdl");

   }
   if ( (self.spawnflags & AS_SLIDING) ) {

      precache_model2 ("progs/end2.mdl");
      setmodel (self,"progs/end2.mdl");

   }
   if ( (self.spawnflags & AS_MISSILE) ) {

      precache_model2 ("progs/end3.mdl");
      setmodel (self,"progs/end3.mdl");

   }
   if ( (self.spawnflags & EF_DIMLIGHT) ) {

      precache_model2 ("progs/end4.mdl");
      setmodel (self,"progs/end4.mdl");

   }
   self.touch = sigil_touch;
   setsize (self,VEC_HULL_MIN,VEC_HULL_MAX);
   StartItem ();

};

void () powerup_touch = {

   local entity stemp;
   local float best;

   if ( (other.classname != "player") ) {

      return ;

   }
   if ( (other.skin == MSG_BROADCAST) ) {

      return ;

   }
   if ( (other.obs == AS_STRAIGHT) ) {

      return ;

   }
   if ( (other.health <= MSG_BROADCAST) ) {

      return ;

   }
   if ( deathmatch ) {

      self.mdl = self.model;
      if ( ((self.classname == "item_artifact_invulnerability") || (self.classname == "item_artifact_invisibility")) ) {

      if (speedup == 0) self.nextthink = (time + 30);
      else self.nextthink = (time + 15);

      } else {

      if (speedup == 0) self.nextthink = (time + 30);
      else self.nextthink = (time + 15);

      }
      self.think = SUB_regen;

   }
   sound (other,CHAN_VOICE,self.noise,AS_STRAIGHT,ATTN_NORM);
   stuffcmd (other,"bf\n");
   self.solid = SOLID_NOT;
   other.items = (other.items | self.items);
   self.model = string_null;
   if ( (self.classname == "item_artifact_envirosuit") ) {

      other.skin_tmp = other.skin;
      other.skin = 21.000;
      other.rad_time = AS_STRAIGHT;
      other.radsuit_finished = (time + SVC_INTERMISSION);

   }
   if ( (self.classname == "item_artifact_invulnerability") ) {

      other.invincible_time = AS_STRAIGHT;
      if (speedup == 0) other.invincible_finished = (time + 30);
      else other.invincible_finished = (time + 20);

   }
   if ( (self.classname == "item_artifact_invisibility") ) {

      other.invisible_time = AS_STRAIGHT;
      other.invisible_finished = (time + SVC_INTERMISSION);
      if (speedup == 0) other.invisible_finished = (time + 30);
      else other.invisible_finished = (time + 20);

   }
   if ( (self.classname == "item_artifact_super_damage") ) {

      sound (self,CHAN_WEAPON,"misc/holly.wav",AS_STRAIGHT,ATTN_NORM);
      bprint (other.netname);
      bprint(" got the Holy Damage\n");
      other.super_time = AS_STRAIGHT;
      if (speedup == 0) other.super_damage_finished = (time + 30);
      else other.super_damage_finished = (time + 15);
   }
   activator = other;
   SUB_UseTargets ();

};

void () item_artifact_invulnerability = {

   self.touch = powerup_touch;
   precache_model ("progs/invulner.mdl");
   precache_sound ("items/protect.wav");
   precache_sound ("items/protect2.wav");
   precache_sound ("items/protect3.wav");
   self.noise = "items/protect.wav";
   setmodel (self,"progs/invulner.mdl");
   self.netname = "Pentagram of Protection";
   self.items = IT_INVULNERABILITY;
   setsize (self,VEC_HULL_MIN,VEC_HULL_MAX);
   StartItem ();

};

void () item_artifact_envirosuit = {

   self.touch = powerup_touch;
   precache_model ("progs/suit.mdl");
   precache_sound ("items/suit.wav");
   precache_sound ("items/suit2.wav");
   self.noise = "items/suit.wav";
   setmodel (self,"progs/suit.mdl");
   self.netname = "Biosuit";
   self.items = IT_SUIT;
   setsize (self,VEC_HULL_MIN,VEC_HULL_MAX);
   StartItem ();

};

void () item_artifact_invisibility = {

   self.touch = powerup_touch;
   precache_model ("progs/invisibl.mdl");
   setmodel (self,"progs/invisibl.mdl");
   self.netname = "Ring of Shadows";
   precache_sound ("items/inv1.wav");
   precache_sound ("items/inv2.wav");
   precache_sound ("items/inv3.wav");
   self.noise = "items/inv1.wav";
   self.items = IT_INVISIBILITY;
   setsize (self,VEC_HULL_MIN,VEC_HULL_MAX);
   StartItem ();

};

void () item_artifact_super_damage = {

   self.touch = powerup_touch;
   precache_model ("progs/quaddama.mdl");
   precache_sound ("items/damage.wav");
   precache_sound ("items/damage2.wav");
   precache_sound ("items/damage3.wav");
   self.noise = "items/damage.wav";
   setmodel (self,"progs/quaddama.mdl");
   self.netname = "Quad Damage";
   self.items = IT_QUAD;
   setsize (self,VEC_HULL_MIN,VEC_HULL_MAX);
   StartItem ();

};

void () BackpackTouch = {

   local string s;
   local float best;
   local entity stemp;

   if ( (other.classname != "player") ) {

      return ;

   }
   if ( (other.skin == MSG_BROADCAST) ) {

      return ;

   }
   if ( (other.health <= MSG_BROADCAST) ) {

      return ;

   }
   stemp = self;
   self = other;
   best = W_BestWeapon ();
   self = stemp;
   other.ammo_shells = (other.ammo_shells + self.ammo_shells);
   other.ammo_nails = (other.ammo_nails + self.ammo_nails);
   other.ammo_rockets = (other.ammo_rockets + self.ammo_rockets);
   other.ammo_cells = (other.ammo_cells + self.ammo_cells);
   other.items = (other.items | self.items);
   if (self.items == IT_ROCKET_LAUNCHER) other.rocket = 1;
   if (self.items == IT_GRENADE_LAUNCHER) other.grenade = 1;
   if (self.items == IT_LIGHTNING) other.lightning = 1;
   if (self.items == IT_SUPER_SHOTGUN) other.supershot = 1;
   if (self.items == IT_SUPER_NAILGUN) other.supernailgun = 1;
   if (self.items == IT_NAILGUN) other.nailgun = 1;
   bound_other_ammo ();
   sprint (other,"You get ");
   if ( self.ammo_shells ) {

      s = ftos (self.ammo_shells);
      sprint (other,s);
      sprint (other," shells  ");

   }
   if ( self.ammo_nails ) {

      s = ftos (self.ammo_nails);
      sprint (other,s);
      sprint (other," nails ");

   }
   if ( self.ammo_rockets ) {

      s = ftos (self.ammo_rockets);
      sprint (other,s);
      sprint (other," rockets  ");

   }
   if ( self.ammo_cells ) {

      s = ftos (self.ammo_cells);
      sprint (other,s);
      sprint (other," cells  ");

   }
   sprint (other,"\n");
   sound (other,CHAN_ITEM,"weapons/lock4.wav",AS_STRAIGHT,ATTN_NORM);
   stuffcmd (other,"bf\n");
   if ( (other.weapon == best) ) {

      stemp = self;
      self = other;
      self.weapon = W_BestWeapon ();
      self = stemp;

   }
   remove (self);
   self = other;
   W_SetCurrentAmmo ();

};

void () DropBackpack = {

   local entity item;

   if ( !(((self.ammo_shells + self.ammo_nails) + self.ammo_rockets) + self.ammo_cells) ) {

      return ;

   }
   item = spawn ();
   item.origin = (self.origin - '0.000 0.000 24.000');
   if ( (self.weapon == IT_FLAMETHROWER) ) {

      self.weapon = IT_GRENADE_LAUNCHER;

   }
   item.items = self.weapon;
   item.ammo_shells = self.ammo_shells;
   item.ammo_nails = self.ammo_nails;
   item.ammo_rockets = self.ammo_rockets;
   item.ammo_cells = self.ammo_cells;
   item.velocity_z = 300.000;
   item.velocity_x = (-100.000 + (random () * 200.000));
   item.velocity_y = (-100.000 + (random () * 200.000));
   item.flags = FL_ITEM;
   item.solid = SOLID_TRIGGER;
   item.movetype = MOVETYPE_TOSS;
   setmodel (item,"progs/backpack.mdl");
   setsize (item,'-16.000 -16.000 0.000','16.000 16.000 56.000');
   item.touch = BackpackTouch;
   item.nextthink = (time + 120.000);
   item.think = SUB_Remove;

};
