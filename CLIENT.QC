void () player_pain;
void () player_stand1;
void (vector org) spawn_tfog;
void (vector org, entity death_owner) spawn_tdeath;
float modelindex_eyes /* = 0.000 */;
float modelindex_player /* = 0.000 */;
float intermission_running /* = 0.000 */;
float intermission_exittime /* = 0.000 */;
void () info_intermission = {
};

void () SetChangeParms = {

   self.items = (self.items - (self.items & (((((IT_KEY1 | IT_KEY2) | IT_INVISIBILITY) | IT_INVULNERABILITY) | IT_SUIT) | IT_QUAD)));
   if ( (self.health > 100.000) ) {

      self.health = 100.000;

   }
   if ( (self.health < COST) ) {

      self.health = COST;

   }
   parm1 = self.items;
   parm2 = self.health;
   parm3 = self.armorvalue;
   if ( (self.ammo_shells < 25.000) ) {

      parm4 = 25.000;

   } else {

      parm4 = self.ammo_shells;

   }
   parm5 = self.ammo_nails;
   parm6 = self.ammo_rockets;
   parm7 = self.ammo_cells;
   parm8 = self.weapon;
   parm9 = (self.armortype * 100.000);
   parm10 = self.skin_tmp;
   parm11 = WEAPON_SHOTGUN;
};

void () SetNewParms = {

   local string tmp;

   parm1 = IT_SHOTGUN | IT_AXE | IT_THROWING_AXE | IT_MORNINGSTAR | IT_CHAINSAW;
   parm2 = 100.000;
   parm3 = 0;
   parm4 = 25.000;
   parm5 = 0;
   parm6 = 0;
   parm6 = 0;
   parm8 = WEAPON_SHOTGUN;
   parm9 = 0;
   parm10 = self.skin;
   parm11 = 0;
};

void () DecodeLevelParms = {

   local string tmp;

   if ( serverflags ) {

      if ( (world.model == "maps/start.bsp") ) {

         SetNewParms ();

      }

   }
   self.items = parm1;
   self.health = parm2;
   self.armorvalue = parm3;
   self.ammo_shells = parm4;
   self.ammo_nails = parm5;
   self.ammo_rockets = parm6;
   self.ammo_cells = parm7;
   self.weapon = parm8;
   self.armortype = (parm9 * 0.010);
   if ( ((parm11 == WEAPON_SHOTGUN) || (self.player_dead == WEAPON_SHOTGUN)) ) {

      self.skin = parm10;
      self.skin_tmp = self.skin;

   } else {

      self.skin = 0;
      self.skin_tmp = 0;

   }
   self.player_dead = 0;

};
entity () FindIntermission = {

   local entity spot;
   local float cyc;

   spot = find (world,classname,"info_intermission");
   if ( spot ) {

      cyc = (random () * WEAPON_SPIKES);
      while ( (cyc > WEAPON_SHOTGUN) ) {

         spot = find (spot,classname,"info_intermission");
         if ( !spot ) {

            spot = find (spot,classname,"info_intermission");

         }
         cyc = (cyc - WEAPON_SHOTGUN);

      }
      return ( spot );

   }
   spot = find (world,classname,"info_player_start");
   if ( spot ) {

      return ( spot );

   }
   spot = find (world,classname,"testplayerstart");
   if ( spot ) {

      return ( spot );

   }
   objerror ("FindIntermission: no spot");

};
string nextmap /* = "" */;

void () GotoNextMap = {

   if ( cvar ("samelevel") ) {

      changelevel (mapname);

   } else {

      changelevel (nextmap);

   }

};

void () ExitIntermission = {

   if ( deathmatch ) {

      GotoNextMap ();
      return ;

   }
   intermission_exittime = (time + WEAPON_SHOTGUN);
   intermission_running = (intermission_running + WEAPON_SHOTGUN);
   if ( (intermission_running == WEAPON_ROCKET) ) {

      if ( (world.model == "maps/e1m7.bsp") ) {

         WriteByte (MSG_ALL,SVC_CDTRACK);
         WriteByte (MSG_ALL,WEAPON_ROCKET);
         WriteByte (MSG_ALL,AS_MELEE);
         if ( !cvar ("registered") ) {

            WriteByte (MSG_ALL,SVC_FINALE);
            WriteString (MSG_ALL,"As the corpse of the monstrous entity\nChthon sinks back into the lava whence\nit rose, you grip the Rune of Earth\nMagic tightly. Now that you have\nconquered the Dimension of the Doomed,\nrealm of Earth Magic, you are ready to\ncomplete your task in...");

         } else {

            WriteByte (MSG_ALL,SVC_FINALE);
            WriteString (MSG_ALL,"As the corpse of the monstrous entity\nChthon sinks back into the lava whence\nit rose, you grip the Rune of Earth\nMagic tightly. Now that you have\nconquered the Dimension of the Doomed,\nrealm of Earth Magic, you are ready to\ncomplete your task. A...");

         }
         return ;

      } else {

         if ( (world.model == "maps/e2m6.bsp") ) {

            WriteByte (MSG_ALL,SVC_CDTRACK);
            WriteByte (MSG_ALL,WEAPON_ROCKET);
            WriteByte (MSG_ALL,AS_MELEE);
            WriteByte (MSG_ALL,SVC_FINALE);
            WriteString (MSG_ALL,"The Rune of Black Magic throbs evilly in\nyour hand and whispers dark thoughts\ninto your brain. You learn the inmost\nlore of the Hell-Mother; Shub-Niggurath!\nYou now know that she is behind all the\nterrible plotting which has led to so\nmuch death...");
            return ;

         } else {

            if ( (world.model == "maps/e3m6.bsp") ) {

               WriteByte (MSG_ALL,SVC_CDTRACK);
               WriteByte (MSG_ALL,WEAPON_ROCKET);
               WriteByte (MSG_ALL,AS_MELEE);
               WriteByte (MSG_ALL,SVC_FINALE);
               WriteString (MSG_ALL,"The charred viscera of diabolic horrors\nbubble viscously as you seize the Rune\nof Hell Magic. Its heat scorches your\nhand, and its terrible secrets blight\nyour mind. Gathering the shreds of your\ncourage, you shake the devil's shackles\nfrom your ...");
               return ;

            } else {

               if ( (world.model == "maps/e4m7.bsp") ) {

                  WriteByte (MSG_ALL,SVC_CDTRACK);
                  WriteByte (MSG_ALL,WEAPON_ROCKET);
                  WriteByte (MSG_ALL,AS_MELEE);
                  WriteByte (MSG_ALL,SVC_FINALE);
                  WriteString (MSG_ALL,"Despite the awful might of the Elder\nWorld, you have achieved the Rune of\nElder Magic, capstone of all types of\narcane wisdom. Beyond good and evil,\nbeyond life and death, the Rune\npulsates, heavy with import. Patient and\npotent, the Elder Being...");
                  return ;

               }

            }

         }

      }
      GotoNextMap ();

   }
   if ( (intermission_running == AS_MELEE) ) {

      if ( !cvar ("registered") ) {

         WriteByte (MSG_ALL,SVC_SELLSCREEN);
         return ;

      }
      if ( ((serverflags & SEC) == SEC) ) {

         WriteByte (MSG_ALL,SVC_FINALE);
         WriteString (MSG_ALL,"Now, you have all four Runes. You sense\ntremendous invisible forces moving to\nunseal ancient barriers. Shub-Niggurath\nhad hoped to use the Runes Herself to\nclear off the Earth, but now instead,\nyou will use them to enter her home and\nconfront he...");
         return ;

      }

   }
   GotoNextMap ();

};

void () IntermissionThink = {

   if ( (time < intermission_exittime) ) {

      return ;

   }
   if ( ((!self.button0 && !self.button1) && !self.button2) ) {

      return ;

   }
   ExitIntermission ();

};

void () execute_changelevel = {

   local entity pos;

   intermission_running = WEAPON_SHOTGUN;
   if ( deathmatch ) {

      intermission_exittime = (time + TE_LIGHTNING1);

   } else {

      intermission_exittime = (time + WEAPON_ROCKET);

   }
   WriteByte (MSG_ALL,SVC_CDTRACK);
   WriteByte (MSG_ALL,AS_MELEE);
   WriteByte (MSG_ALL,AS_MELEE);
   pos = FindIntermission ();
   other = find (world,classname,"player");
   while ( (other != world) ) {

      other.view_ofs = VEC_ORIGIN;
      other.v_angle = pos.mangle;
      other.angles = pos.mangle;
      other.fixangle = TRUE;
      other.nextthink = (time + 0.500);
      other.takedamage = DAMAGE_NO;
      other.solid = SOLID_NOT;
      other.movetype = MOVETYPE_NONE;
      other.modelindex = 0;
      setorigin (other,pos.origin);
      other = find (other,classname,"player");

   }
   WriteByte (MSG_ALL,SVC_INTERMISSION);

};

void () changelevel_touch = {

   local entity pos;

   if ( (other.classname != "player") ) {

      return ;

   }
   if ( cvar ("noexit") ) {

      T_Damage (other,self,self,50000.000);
      return ;

   }
   bprint (other.netname);
   bprint (" exited the level\n");
   nextmap = self.map;
   SUB_UseTargets ();
   if ( ((self.spawnflags & WEAPON_SHOTGUN) && (deathmatch == 0)) ) {

      GotoNextMap ();
      return ;

   }
   self.touch = SUB_Null;
   self.think = execute_changelevel;
   self.nextthink = (time + 0.100);

};

void () trigger_changelevel = {

   if ( !self.map ) {

      objerror ("chagnelevel trigger doesn't have map");

   }
   InitTrigger ();
   self.touch = changelevel_touch;

};

void () set_suicide_frame;

void () respawn = {

   if ( coop ) {

      CopyToBodyQue (self);
      setspawnparms (self);
      PutClientInServer ();

   } else {

      if ( deathmatch ) {

         CopyToBodyQue (self);
         SetNewParms ();
         PutClientInServer ();

      } else {

         localcmd ("restart\n");

      }

   }

};

void () ClientKill = {

   if ( (self.frags < 0) ) {
      bprint (self.netname);
      bprint (" is a lamer and was kicked!!\n");
      sprint (self,"Only lamers kill themselves, fuck off\n");
      stuffcmd (self,"disconnect");
   } else {
      bprint (self.netname);
      bprint (" suicides\n");
      set_suicide_frame ();
      self.modelindex = modelindex_player;
      self.frags = (self.frags - WEAPON_ROCKET);
      respawn ();
   }
};
float (vector v) CheckSpawnPoint = {
   return ( FALSE );
};
entity () SelectSpawnPoint = {

   local entity spot;

   spot = find (world,classname,"testplayerstart");
   if ( spot ) {

      return ( spot );

   }
   if ( coop ) {

      lastspawn = find (lastspawn,classname,"info_player_coop");
      if ( (lastspawn == world) ) {

         lastspawn = find (lastspawn,classname,"info_player_start");

      }
      if ( (lastspawn != world) ) {

         return ( lastspawn );

      }

   } else {

      if ( deathmatch ) {

         lastspawn = find (lastspawn,classname,"info_player_deathmatch");
         if ( (lastspawn == world) ) {

            lastspawn = find (lastspawn,classname,"info_player_deathmatch");

         }
         if ( (lastspawn != world) ) {

            return ( lastspawn );

         }

      }

   }
   if ( serverflags ) {

      spot = find (world,classname,"info_player_start2");
      if ( spot ) {

         return ( spot );

      }

   }
   spot = find (world,classname,"info_player_start");
   if ( !spot ) {

      error ("PutClientInServer: no info_player_start on level");

   }
   return ( spot );

};

void () PlayerDie;

void () PutClientInServer = {

   local entity spot;
   local vector head_pos;

   self.classname = "player";
   self.health = 100.000;
   self.takedamage = DAMAGE_AIM;
   self.solid = SOLID_SLIDEBOX;
   self.movetype = MOVETYPE_WALK;
   self.show_hostile = 0;
   self.max_health = 100.000;
   if (deathmatch || coop)
        {
        self.ammo_shells = 25;
        self.ammo_rockets = 0;
        self.ammo_cells = 0;
        self.ammo_nails = 0;
        self.rocket = 0;
        self.grenade = 0;
        self.supershot = 0;
        self.lightning = 0;
        self.bananas = 5;
        self.nailgun = 0;
        self.supernailgun = 0;
        self.items = IT_AXE | IT_SHOTGUN;
        self.voted = 0;
        self.bomb = 0;
        self.bounce = 0;
        self.mines = 0;
        }
   self.flags = FL_CLIENT;
   self.help = 0;
   self.say = 0;
   self.air_finished = (time + 12.000);
   self.dmg = WEAPON_ROCKET;
   self.super_damage_finished = 0;
   self.radsuit_finished = 0;
   self.invisible_finished = 0;
   self.invincible_finished = 0;
   self.effects = 0;
   self.invincible_time = 0;
   self.onfire = FALSE;
   self.throwaxe = SEC;
   self.obs = 0;
   self.pipes = TE_LIGHTNING1;
   DecodeLevelParms ();
   self.skin_tmp = self.skin;
   self.skin = self.skin_tmp;
   self.player_dead = 0;
   W_SetCurrentAmmo ();
   self.attack_finished = time;
   self.th_pain = player_pain;
   self.th_die = PlayerDie;
   self.deadflag = DEAD_NO;
   self.pausetime = 0;
   spot = SelectSpawnPoint ();
   self.origin = (spot.origin + '0.000 0.000 1.000');
   self.angles = spot.angles;
   self.fixangle = TRUE;
   if ( (extra_goodies == WEAPON_SHOTGUN) ) {

      setmodel (self,"progs/h_player.mdl");

   } else {

      setmodel (self,"progs/eyes.mdl");

   }
   modelindex_eyes = self.modelindex;
   setmodel (self,"progs/player.mdl");
   modelindex_player = self.modelindex;
   setsize (self,VEC_HULL_MIN,VEC_HULL_MAX);
   self.view_ofs = '0.000 0.000 22.000';
   player_stand1 ();
   if ( (deathmatch || coop) ) {

      makevectors (self.angles);
      spawn_tfog ((self.origin + (v_forward * 20.000)));

   }
   spawn_tdeath (self.origin,self);
   set_skin ();

};

void () info_player_start = {


};

void () info_player_start2 = {


};

void () testplayerstart = {


};

void () info_player_deathmatch = {


};

void () info_player_coop = {


};

void (entity c) PrintClientScore = {

   if ( ((c.frags > -10.000) && (c.frags < Kick_em)) ) {

      bprint (" ");

   } else {

      if ( (c.frags >= 0) ) {

         if ( (c.frags < 100.000) ) {

            bprint (" ");

         }
         if ( (c.frags < TE_LAVASPLASH) ) {

            bprint (" ");

         }

      }

   }
   bprint (ftos (c.frags));
   bprint (" ");
   bprint (c.netname);
   bprint ("\n");

};

void () DumpScore = {

   local entity e;
   local entity sort;
   local entity walk;

   if ( world.chain ) {

      error ("DumpScore: world.chain is set");

   }
   e = find (world,classname,"player");
   sort = world;
   while ( e ) {

      if ( !sort ) {

         sort = e;
         e.chain = world;

      } else {

         if ( (e.frags > sort.frags) ) {

            e.chain = sort;
            sort = e;

         } else {

            walk = sort;
            do {

               if ( !walk.chain ) {

                  e.chain = world;
                  walk.chain = e;

               } else {

                  if ( (walk.chain.frags < e.frags) ) {

                     e.chain = walk.chain;
                     walk.chain = e;

                  } else {

                     walk = walk.chain;

                  }

               }

            } while ( (walk.chain != e) );

         }

      }
      e = find (e,classname,"player");

   }
   bprint ("\n");
   while ( sort ) {

      PrintClientScore (sort);
      sort = sort.chain;

   }
   bprint ("\n");

};

void () NextLevel = {

   local entity   o;
   local float    rs;

   o = find (world,classname,"trigger_changelevel");
   if ( (!o || (mapname == "start")) ) {

      o = spawn ();
      o.map = mapname;

   }
   if (cvar("temp1") == 0){

   if ( (mapname == "dm1") ) {

      o.map = "dm2";

   }
   if ( (mapname == "dm2") ) {

      o.map = "dm3";

   }
   if ( (mapname == "dm3") ) {

      o.map = "dm4";

   }
   if ( (mapname == "dm4") ) {

      o.map = "dm5";

   }
   if ( (mapname == "dm5") ) {

      o.map = "dm6";

   }
   if ( (mapname == "dm6") ) {

      o.map = "dm7";

   }
   if ( (mapname == "dm7") ) {

      o.map = "dm8";

   }
   if ( (mapname == "dm8") ) {

      {
      o.map = "dm9";
      }
   }
   if ( (mapname == "dm9") ) {

      {
      o.map = "start";
      }
   }
   if ( (mapname == "dimen1") ) {

      o.map = "dimen2";

   }
   if ( (mapname == "dimen2") ) {

      o.map = "dimen3";

   }
   if ( (mapname == "dimen3") ) {

      o.map = "dimen4";

   }
   if ( (mapname == "dimen4") ) {

      o.map = "dimen5";

   }
   if ( (mapname == "dimen5") ) {

      o.map = "dimen6";

   }
   if ( (mapname == "dimen6") ) {

      o.map = "dimen7";

   }
   if ( (mapname == "dimen7") ) {

      o.map = "dimen8";

   }
   if ( (mapname == "dimen8") ) {

      o.map = "dimen9";

   }
   if ( (mapname == "dimen9") ) {

      o.map = "start";

   }
   if ( (mapname == "death1") ) {

      o.map = "death2";

   }
   if ( (mapname == "death2") ) {

      o.map = "death3";

   }
   if ( (mapname == "death3") ) {

      o.map = "death4";

   }
   if ( (mapname == "death4") ) {

      o.map = "death5";

   }
   if ( (mapname == "death5") ) {

      o.map = "death6";

   }
   if ( (mapname == "death6") ) {

      o.map = "death7";

   }
   if ( (mapname == "death7") ) {

      o.map = "death8";

   }
   if ( (mapname == "death8") ) {

      o.map = "death9";

   }
   if ( (mapname == "death9") ) {

      o.map = "death10";

   }
   if ( (mapname == "death10") ) {

      o.map = "death11";

   }
   if ( (mapname == "death11") ) {

      o.map = "death12";

   }
   if ( (mapname == "death12") ) {

      o.map = "death13";

   }
   if ( (mapname == "death13") ) {

      o.map = "death14";

   }
   if ( (mapname == "death14") ) {

      o.map = "death15";

   }
   if ( (mapname == "death15") ) {

      o.map = "death16";

   }
   if ( (mapname == "death16") ) {

      o.map = "death17";

   }
   if ( (mapname == "death17") ) {

      o.map = "death18";

   }
   if ( (mapname == "death18") ) {

      o.map = "death19";

   }
   if ( (mapname == "death19") ) {

      o.map = "death20";

   }
   if ( (mapname == "death20") ) {

      o.map = "death21";

   }
   if ( (mapname == "death21") ) {

      o.map = "death22";

   }
   if ( (mapname == "death22") ) {

      o.map = "death23";

   }
   if ( (mapname == "death23") ) {

      o.map = "death24";

   }
   if ( (mapname == "death24") ) {

      o.map = "death25";

   }
   if ( (mapname == "death25") ) {

      o.map = "death26";

   }
   if ( (mapname == "death26") ) {

      o.map = "death27";

   }
   if ( (mapname == "death27") ) {

      o.map = "death28";

   }
   if ( (mapname == "death28") ) {

      o.map = "death29";

   }
   if ( (mapname == "death29") ) {

      o.map = "death30";

   }
   if ( (mapname == "death30") ) {

      o.map = "death31";

   }
   if ( (mapname == "death31") ) {

      o.map = "death32";

   }
   if ( (mapname == "death32") ) {

      o.map = "death33";

   }
   if ( (mapname == "death33") ) {

      o.map = "death34";

   }
   if ( (mapname == "death34") ) {

      o.map = "death35";

   }
   if ( (mapname == "death35") ) {

      o.map = "death36";

   }
   if ( (mapname == "death36") ) {

      o.map = "death37";

   }
   if ( (mapname == "death37") ) {

      o.map = "death38";

   }
   if ( (mapname == "death38") ) {

      o.map = "death39";

   }
   if ( (mapname == "death39") ) {

      o.map = "death40";

   }
   if ( (mapname == "death40") ) {

      o.map = "death41";

   }
   if ( (mapname == "death41") ) {

      o.map = "death42";

   }
   if ( (mapname == "death42") ) {

      o.map = "death43";

   }
   if ( (mapname == "death43") ) {

      o.map = "start";
   }
   if ( (mapname == "wicked1") ) {

      o.map = "wicked2";

   }
   if ( (mapname == "wicked2") ) {

      o.map = "wicked3";

   }
   if ( (mapname == "wicked3") ) {

      o.map = "wicked4";

   }
   if ( (mapname == "wicked4") ) {

      o.map = "wicked5";

   }
   if ( (mapname == "wicked5") ) {

      o.map = "wicked6";

   }
   if ( (mapname == "wicked6") ) {

      o.map = "wicked7";

   }
   if ( (mapname == "wicked7") ) {

      o.map = "wicked8";

   }
   if ( (mapname == "wicked8") ) {

      o.map = "wicked9";

   }
   if ( (mapname == "wicked9") ) {

      o.map = "wicked10";

   }
   if ( (mapname == "wicked10") ) {

      o.map = "wicked11";

   }
   if ( (mapname == "wicked11") ) {

      o.map = "wicked12";

   }
   if ( (mapname == "wicked12") ) {

      o.map = "wicked13";

   }
   if ( (mapname == "wicked13") ) {

      o.map = "wicked14";

   }
   if ( (mapname == "wicked14") ) {

      o.map = "wicked15";

   }
   if ( (mapname == "wicked15") ) {

      o.map = "wicked16";

   }
   if ( (mapname == "wicked16") ) {

      o.map = "wicked17";

   }
   if ( (mapname == "wicked17") ) {

      o.map = "wicked18";

   }
   if ( (mapname == "wicked18") ) {

      o.map = "wicked19";

   }
   if ( (mapname == "wicked19") ) {

      o.map = "wicked20";

   }
   if ( (mapname == "wicked20") ) {

      o.map = "wicked21";

   }
   if ( (mapname == "wicked21") ) {

      o.map = "wicked22";

   }
   if ( (mapname == "wicked22") ) {

      o.map = "wicked23";

   }
   if ( (mapname == "wicked23") ) {

      o.map = "wicked24";

   }
   if ( (mapname == "wicked24") ) {

      o.map = "wicked25";

   }
   if ( (mapname == "wicked25") ) {

      o.map = "wicked26";

   }
   if ( (mapname == "wicked26") ) {

      o.map = "wicked27";

   }
   if ( (mapname == "wicked27") ) {

      o.map = "wicked28";
   }
   if ( (mapname == "wicked28") ) {

      o.map = "start";
   }
   if ( (mapname == "1bsp1") ) {

      o.map = "1bsp2";

   }
   if ( (mapname == "1bsp2") ) {

      o.map = "1bsp3";

   }
   if ( (mapname == "1bsp3") ) {

      o.map = "1bsp4";

   }
   if ( (mapname == "1bsp4") ) {

      o.map = "1bsp5";

   }
   if ( (mapname == "1bsp5") ) {

      o.map = "1bsp6";

   }
   if ( (mapname == "1bsp6") ) {

      o.map = "1bsp7";

   }
   if ( (mapname == "1bsp7") ) {

      o.map = "1bsp8";

   }
   if ( (mapname == "1bsp8") ) {

      o.map = "1bsp9";

   }
   if ( (mapname == "1bsp9") ) {

      o.map = "1bsp10";

   }
   if ( (mapname == "1bsp10") ) {

      o.map = "start";
   }
   }
   else if (cvar("temp1") == 1)
   {
        if ((mapname == "dm1") | (mapname == "dm2") | (mapname == "dm3") | (mapname == "dm4") | (mapname == "dm5") | (mapname == "dm6"))
        {
        rs = rint ((random() * 5) + 1);
        if (rs == 1) o.map = "dm1";
        if (rs == 2) o.map = "dm2";
        if (rs == 3) o.map = "dm3";
        if (rs == 4) o.map = "dm4";
        if (rs == 5) o.map = "dm5";
        if (rs == 6) o.map = "dm6";
        }
        else if ((mapname == "death1") | (mapname == "death2") | (mapname == "death3") | (mapname == "death4") | (mapname == "death5") | (mapname == "death6") | (mapname == "death7") | (mapname == "death8") | (mapname == "death9") | (mapname == "death10") | (mapname == "death11") | (mapname == "death12") | (mapname == "death13") | (mapname == "death14") | (mapname == "death15") | (mapname == "death16") | (mapname == "death17") | (mapname == "death18") | (mapname == "death19") | (mapname == "death20") | (mapname == "death21") | (mapname == "death22") | (mapname == "death23") |
        (mapname == "death24") | (mapname == "death25") | (mapname == "death26") | (mapname == "death27") | (mapname == "death28") | (mapname == "death29") | (mapname == "death30") | (mapname == "death31") | (mapname == "death32") | (mapname == "death33") | (mapname == "death34") | (mapname == "death35") | (mapname == "death36") | (mapname == "death37") | (mapname == "death38") | (mapname == "death39") | (mapname == "death40") | (mapname == "death41") | (mapname == "death42") | (mapname == "death43"))
        {
        rs = rint ((random() * 42) + 1);
        if (rs == 1) o.map = "death1";
        if (rs == 2) o.map = "death2";
        if (rs == 3) o.map = "death3";
        if (rs == 4) o.map = "death4";
        if (rs == 5) o.map = "death5";
        if (rs == 6) o.map = "death6";
        if (rs == 7) o.map = "death7";
        if (rs == 8) o.map = "death8";
        if (rs == 9) o.map = "death9";
        if (rs == 10) o.map = "death10";
        if (rs == 11) o.map = "death11";
        if (rs == 12) o.map = "death12";
        if (rs == 13) o.map = "death13";
        if (rs == 14) o.map = "death14";
        if (rs == 15) o.map = "death15";
        if (rs == 16) o.map = "death16";
        if (rs == 17) o.map = "death17";
        if (rs == 18) o.map = "death18";
        if (rs == 19) o.map = "death19";
        if (rs == 20) o.map = "death20";
        if (rs == 21) o.map = "death21";
        if (rs == 22) o.map = "death22";
        if (rs == 23) o.map = "death23";
        if (rs == 24) o.map = "death24";
        if (rs == 25) o.map = "death25";
        if (rs == 26) o.map = "death26";
        if (rs == 27) o.map = "death27";
        if (rs == 28) o.map = "death28";
        if (rs == 29) o.map = "death29";
        if (rs == 30) o.map = "death30";
        if (rs == 31) o.map = "death31";
        if (rs == 32) o.map = "death32";
        if (rs == 33) o.map = "death33";
        if (rs == 34) o.map = "death34";
        if (rs == 35) o.map = "death35";
        if (rs == 36) o.map = "death36";
        if (rs == 37) o.map = "death37";
        if (rs == 38) o.map = "death38";
        if (rs == 39) o.map = "death39";
        if (rs == 40) o.map = "death40";
        if (rs == 41) o.map = "death41";
        if (rs == 42) o.map = "death42";
        if (rs == 43) o.map = "death43";
        }
        else if ((mapname == "1bsp1") | (mapname == "1bsp2") | (mapname == "1bsp3") | (mapname == "1bsp4") | (mapname == "1bsp5") | (mapname == "1bsp6") | (mapname == "1bsp7") | (mapname == "1bsp8") | (mapname == "1bsp9") | (mapname == "1bsp10"))
        {
        rs = rint ((random() * 9) + 1);
        if (rs == 1) o.map = "1bsp1";
        if (rs == 2) o.map = "1bsp2";
        if (rs == 3) o.map = "1bsp3";
        if (rs == 4) o.map = "1bsp4";
        if (rs == 5) o.map = "1bsp5";
        if (rs == 6) o.map = "1bsp6";
        if (rs == 7) o.map = "1bsp7";
        if (rs == 8) o.map = "1bsp8";
        if (rs == 9) o.map = "1bsp9";
        if (rs == 0) o.map = "1bsp10";
        }
        else if ((mapname == "dimen1") | (mapname == "dimen2") | (mapname == "dimen3") | (mapname == "dimen4") | (mapname == "dimen5") | (mapname == "dimen6") | (mapname == "dimen7") | (mapname == "dimen8") | (mapname == "dimen9"))
        {
        rs = rint ((random() * 8) + 1);
        if (rs == 1) o.map = "dimen1";
        if (rs == 2) o.map = "dimen2";
        if (rs == 3) o.map = "dimen3";
        if (rs == 4) o.map = "dimen4";
        if (rs == 5) o.map = "dimen5";
        if (rs == 6) o.map = "dimen6";
        if (rs == 7) o.map = "dimen7";
        if (rs == 8) o.map = "dimen8";
        if (rs == 9) o.map = "dimen9";
        }
        else if ((mapname == "wicked1") | (mapname == "wicked2") | (mapname == "wicked3") | (mapname == "wicked4") | (mapname == "wicked5") | (mapname == "wicked6") | (mapname == "wicked7") | (mapname == "wicked8") | (mapname == "wicked9") | (mapname == "wicked10") | (mapname == "wicked11") | (mapname == "wicked12") | (mapname == "wicked13") | (mapname == "wicked14") | (mapname == "wicked15") | (mapname == "wicked16") | (mapname == "wicked17") | (mapname == "wicked18") | (mapname == "wicked19") | (mapname == "wicked20") | (mapname == "wicked21") | (mapname == "wicked22") | (mapname == "wicked23") | (mapname == "wicked24") | (mapname == "wicked25") | (mapname == "wicked26"))
        {
        rs = rint ((random() * 25) + 1);
        if (rs == 1) o.map = "wicked1";
        if (rs == 2) o.map = "wicked2";
        if (rs == 3) o.map = "wicked3";
        if (rs == 4) o.map = "wicked4";
        if (rs == 5) o.map = "wicked5";
        if (rs == 6) o.map = "wicked6";
        if (rs == 7) o.map = "wicked7";
        if (rs == 8) o.map = "wicked8";
        if (rs == 9) o.map = "wicked9";
        if (rs == 10) o.map = "wicked10";
        if (rs == 11) o.map = "wicked11";
        if (rs == 12) o.map = "wicked12";
        if (rs == 13) o.map = "wicked13";
        if (rs == 14) o.map = "wicked14";
        if (rs == 15) o.map = "wicked15";
        if (rs == 16) o.map = "wicked16";
        if (rs == 17) o.map = "wicked17";
        if (rs == 18) o.map = "wicked18";
        if (rs == 19) o.map = "wicked19";
        if (rs == 20) o.map = "wicked20";
        if (rs == 21) o.map = "wicked21";
        if (rs == 22) o.map = "wicked22";
        if (rs == 23) o.map = "wicked23";
        if (rs == 24) o.map = "wicked24";
        if (rs == 25) o.map = "wicked25";
        if (rs == 26) o.map = "wicked26";
        }
   }
   else if (cvar("temp1") == 2)
   {
   o.map = "start";
   }
   nextmap = o.map;
   if ( (o.nextthink < time) ) {

      o.think = execute_changelevel;
      o.nextthink = (time + 0.100);

   }

};

void () CheckRules = {

   local float timelimit;
   local float fraglimit;
   local entity o;

   if ( gameover ) {

      return ;

   }
        if (mapname == "start") {
		if ((vote_leader != world) && voteexit_time && (time > voteexit_time)) {
//                        pregameover = 1;
			o = spawn();
                        self.skin = 0;
			nextmap = vote_leader.map;
			o.map = nextmap;
			o.think = execute_changelevel;
                        o.nextthink = time + 0.1;
			return;
		}
		return;
	}

   timelimit = (cvar ("timelimit") * 60.000);
   fraglimit = cvar ("fraglimit");
  if ( (timelimit && (time >= timelimit)) ) {

      NextLevel ();
      return ;

   }
   if ( (fraglimit && (self.frags >= fraglimit)) ) {

      NextLevel ();
      return ;

   }

};

void () PlayerDeathThink = {

   local entity old_self;
   local float forward;

   if ( (self.flags & FL_ONGROUND) ) {

      forward = vlen (self.velocity);
      forward = (forward - 20.000);
      if ( (forward <= 0) ) {

         self.velocity = VEC_ORIGIN;

      } else {

         self.velocity = (forward * normalize (self.velocity));

      }

   }
   if ( (self.deadflag == DEAD_DEAD) ) {

      if ( ((self.button2 || self.button1) || self.button0) ) {

         return ;

      }
      self.deadflag = DEAD_RESPAWNABLE;
      return ;

   }
   if ( ((!self.button2 && !self.button1) && !self.button0) ) {

      return ;

   }
   self.button0 = 0;
   self.button1 = 0;
   self.button2 = 0;
   respawn ();

};

void () PlayerJump = {

   local vector start;
   local vector end;

   if ( (self.flags & FL_WATERJUMP) ) {

      return ;

   }
   if ( (self.waterlevel >= WEAPON_ROCKET) ) {

      if ( (self.watertype == CONTENT_WATER) ) {

         self.velocity_z = 100.000;

      } else {

         if ( (self.watertype == CONTENT_SLIME) ) {

            self.velocity_z = 80.000;

         } else {

            self.velocity_z = COST;

         }

      }
      if ( (self.swim_flag < time) ) {

         self.swim_flag = (time + WEAPON_SHOTGUN);
         if ( (random () < 0.500) ) {

            sound (self,CHAN_BODY,"misc/water1.wav",WEAPON_SHOTGUN,ATTN_NORM);

         } else {

            sound (self,CHAN_BODY,"misc/water2.wav",WEAPON_SHOTGUN,ATTN_NORM);

         }

      }
      return ;

   }
   if ( !(self.flags & FL_ONGROUND) ) {

      return ;

   }
   if ( !(self.flags & FL_JUMPRELEASED) ) {

      return ;

   }
   self.flags = (self.flags - (self.flags & FL_JUMPRELEASED));
   self.flags = (self.flags - FL_ONGROUND);
   self.button2 = 0;
   sound (self,CHAN_BODY,"player/plyrjmp8.wav",WEAPON_SHOTGUN,ATTN_NORM);
   self.velocity_z = (self.velocity_z + 270.000);

};
.float dmgtime;

void () WaterMove = {

   if ( (self.movetype == MOVETYPE_NOCLIP) ) {

      return ;

   }
   if ( (self.health < Kick_em) ) {

      return ;

   }
   if ( (self.waterlevel != AS_MELEE) ) {

      if ( (self.air_finished < time) ) {

         sound (self,CHAN_VOICE,"player/gasp2.wav",WEAPON_SHOTGUN,ATTN_NORM);

      } else {

         if ( (self.air_finished < (time + TE_LIGHTNING3)) ) {

            sound (self,CHAN_VOICE,"player/gasp1.wav",WEAPON_SHOTGUN,ATTN_NORM);

         }

      }
      self.air_finished = (time + 12.000);
      self.dmg = WEAPON_ROCKET;

   } else {

      if ( (self.air_finished < time) ) {

         if ( (self.pain_finished < time) ) {

            self.dmg = (self.dmg + WEAPON_ROCKET);
            if ( (self.dmg > SEC) ) {

               self.dmg = TE_LAVASPLASH;

            }
            T_Damage (self,world,world,self.dmg);
            self.pain_finished = (time + WEAPON_SHOTGUN);

         }

      }

   }
   if ( !self.waterlevel ) {

      if ( (self.flags & FL_INWATER) ) {

         sound (self,CHAN_BODY,"misc/outwater.wav",WEAPON_SHOTGUN,ATTN_NORM);
         self.flags = (self.flags - FL_INWATER);

      }
      return ;

   }
   if ( (self.watertype == CONTENT_LAVA) ) {

      if ( (self.dmgtime < time) ) {

         if ( (self.radsuit_finished > time) ) {

            self.dmgtime = (time + WEAPON_SHOTGUN);

         } else {

            self.dmgtime = (time + 0.200);

         }
         T_Damage (self,world,world,(TE_LAVASPLASH * self.waterlevel));

      }

   } else {

      if ( (self.watertype == CONTENT_SLIME) ) {

         if ( ((self.dmgtime < time) && (self.radsuit_finished < time)) ) {

            self.dmgtime = (time + WEAPON_SHOTGUN);
            T_Damage (self,world,world,(WEAPON_SPIKES * self.waterlevel));

         }

      }

   }
   if ( !(self.flags & FL_INWATER) ) {

      if ( (self.watertype == CONTENT_LAVA) ) {

         sound (self,CHAN_BODY,"player/inlava.wav",WEAPON_SHOTGUN,ATTN_NORM);

      }
      if ( (self.watertype == CONTENT_WATER) ) {

         sound (self,CHAN_BODY,"player/inh2o.wav",WEAPON_SHOTGUN,ATTN_NORM);

      }
      if ( (self.watertype == CONTENT_SLIME) ) {

         sound (self,CHAN_BODY,"player/slimbrn2.wav",WEAPON_SHOTGUN,ATTN_NORM);

      }
      self.flags = (self.flags + FL_INWATER);
      self.dmgtime = 0;

   }
   if ( !(self.flags & FL_WATERJUMP) ) {

      self.velocity = (self.velocity - (((0.800 * self.waterlevel) * frametime) * self.velocity));

   }

};

void () CheckWaterJump = {

   local vector start;
   local vector end;

   makevectors (self.angles);
   start = self.origin;
   start_z = (start_z + WEAPON_BIG);
   v_forward_z = 0;
   normalize (v_forward);
   end = (start + (v_forward * 24.000));
   traceline (start,end,TRUE,self);
   if ( (trace_fraction < WEAPON_SHOTGUN) ) {

      start_z = ((start_z + self.maxs_z) - WEAPON_BIG);
      end = (start + (v_forward * 24.000));
      self.movedir = (trace_plane_normal * -50.000);
      traceline (start,end,TRUE,self);
      if ( (trace_fraction == WEAPON_SHOTGUN) ) {

         self.flags = (self.flags | FL_WATERJUMP);
         self.velocity_z = 225.000;
         self.flags = (self.flags - (self.flags & FL_JUMPRELEASED));
         self.teleport_time = (time + WEAPON_ROCKET);
         return ;

      }

   }

};

void () PlayerPreThink = {

   local float mspeed;
   local float aspeed;
   local float r;

   if ( (self.deadflag < DEAD_DEAD) ) {

      self.player_dead = WEAPON_SHOTGUN;

   }
   if ( intermission_running ) {

      self.player_dead = WEAPON_SHOTGUN;
      IntermissionThink ();
      return ;

   }
   if ( (self.view_ofs == VEC_ORIGIN) ) {

      return ;

   }
   makevectors (self.v_angle);
   CheckRules ();
   WaterMove ();
   if (mapname == "start") self.skin = 11;
   if ( (self.waterlevel == WEAPON_ROCKET) ) {

      CheckWaterJump ();

   }
        if (self.obs == 1)
        {
        self.currentammo = 0;
        self.weaponmodel = "progs/v_star.mdl";
        self.weaponframe = 0;
        self.health = 666;
        self.items = IT_MORNINGSTAR;
        self.ammo_shells = 0;
        self.ammo_rockets = 0;
        self.ammo_cells = 0;
        self.ammo_nails = 0;
        self.armortype = 0;
        self.armorvalue = 0;
        }
        if (((self.skin == 0) || (self.skin == 11)) && (self.obs == 0) && (!(mapname == "start")))
        {
                        centerprint (self, ". Welcome to Wicked Quake 1.3 .\nùûûûûûûûûûûûûûûûûûûûûûûûûûûûûûûûûûûûü\n\n  .  CHOOSE YOUR CHARACTER : .      \n\n\n1: Doc Holliday   6: The Lord       \n2: Wotan          7: Syndrome       \n3: Scavenger      8: Darth Vader    \n4: Bad Blood      9: Peedee         \n5: Moses          0: Buzzer         \n\nùûûûûûûûûûûûûûûûûûûûûûûûûûûûûûü\n");
                        if (self.ready == 0) self.health = 999;
                        self.currentammo = 0;
                        self.weaponmodel = "";
                        if (self.impulse >= 1 && self.impulse <= 10)
                        {
                        self.skin = self.impulse;
                        self.skin_tmp = self.skin;
                        parm10 = self.skin_tmp;
                        put_on_skin(self.skin);
                        if (self.ready == 0) self.impulse = 2;
                        if (self.ready == 0) self.health = 100;
                        self.ready = 1;
                        self.obs = 0;
                        }
        }
   if ( (self.deadflag >= DEAD_DEAD) ) {

      PlayerDeathThink ();
      return ;

   }
   if ( (self.deadflag == DEAD_DYING) ) {

      return ;

   }
   if ( self.button2 ) {

      PlayerJump ();

   } else {

      self.flags = (self.flags | FL_JUMPRELEASED);

   }
   if ( (time < self.pausetime) ) {

      self.velocity = VEC_ORIGIN;

   }
   if (self.bomb == 1)
   {
                           self.currentammo = 0;
                           self.weaponmodel = "progs/v_star.mdl";
                           self.weaponframe = 0;
   }
   if (camping == 1) CheckForCamper();
};

void () CheckPowerups = {

   local string s;

   if ( (self.health <= 0) ) {

      return ;

   }
   if ( self.invisible_finished ) {

      if ( (self.invisible_sound < time) ) {

         sound (self,CHAN_AUTO,"items/inv3.wav",0.500,ATTN_IDLE);
         self.invisible_sound = (time + ((random () * AS_MELEE) + WEAPON_SHOTGUN));

      }
      if ( (self.invisible_finished < (time + AS_MELEE)) ) {

         if ( (self.invisible_time == WEAPON_SHOTGUN) ) {

            sprint (self,"Holy Belt magic is fading\n");
            stuffcmd (self,"bf\n");
            sound (self,CHAN_AUTO,"items/inv2.wav",WEAPON_SHOTGUN,ATTN_NORM);
            self.invisible_time = (time + WEAPON_SHOTGUN);

         }
         if ( (self.invisible_time < time) ) {

            self.invisible_time = (time + WEAPON_SHOTGUN);
            stuffcmd (self,"bf\n");

         }

      }
      if ( (self.invisible_finished < time) ) {

         self.items = (self.items - IT_INVISIBILITY);
         self.invisible_finished = 0;
         self.invisible_time = 0;

      }
      if ( (extra_goodies == WEAPON_SHOTGUN) ) {

         self.frame = WEAPON_SHOTGUN;

      } else {

         self.frame = 0;

      }
      self.modelindex = modelindex_eyes;

   } else {

      self.modelindex = modelindex_player;

   }
   if ( self.invincible_finished ) {

      if ( (self.invincible_finished < (time + AS_MELEE)) ) {

         if ( (self.invincible_time == WEAPON_SHOTGUN) ) {

            sprint (self,"Protection is almost burned out\n");
            stuffcmd (self,"bf\n");
            sound (self,CHAN_AUTO,"items/protect2.wav",WEAPON_SHOTGUN,ATTN_NORM);
            self.invincible_time = (time + WEAPON_SHOTGUN);

         }
         if ( (self.invincible_time < time) ) {

            self.invincible_time = (time + WEAPON_SHOTGUN);
            stuffcmd (self,"bf\n");

         }

      }
      if ( (self.invincible_finished < time) ) {

         self.items = (self.items - IT_INVULNERABILITY);
         self.invincible_time = 0;
         self.invincible_finished = 0;

      }
      if ( (self.invincible_finished > time) ) {

         self.effects = (self.effects | EF_DIMLIGHT);

      } else {

         self.effects = (self.effects - (self.effects & EF_DIMLIGHT));

      }

   }
   if ( self.super_damage_finished ) {

      if ( (self.super_damage_finished < (time + AS_MELEE)) ) {

         if ( (self.super_time == WEAPON_SHOTGUN) ) {

            sprint (self,"Holy Damage is wearing off\n");
            stuffcmd (self,"bf\n");
            sound (self,CHAN_AUTO,"items/damage2.wav",WEAPON_SHOTGUN,ATTN_NORM);
            self.super_time = (time + WEAPON_SHOTGUN);

         }
         if ( (self.super_time < time) ) {

            self.super_time = (time + WEAPON_SHOTGUN);
            stuffcmd (self,"bf\n");

         }

      }
      if ( (self.super_damage_finished < time) ) {

         self.items = (self.items - IT_QUAD);
         self.super_damage_finished = 0;
         self.super_time = 0;

      }
      if ( (self.super_damage_finished > time) ) {

         self.effects = (self.effects | EF_DIMLIGHT);

      } else {

         self.effects = (self.effects - (self.effects & EF_DIMLIGHT));

      }

   }
   if ( self.radsuit_finished ) {

      self.air_finished = (time + 12.000);
      if ( (self.radsuit_finished < (time + AS_MELEE)) ) {

         if ( (self.rad_time == WEAPON_SHOTGUN) ) {

            sprint (self,"Air supply in Biosuit expiring\n");
            stuffcmd (self,"bf\n");
            sound (self,CHAN_AUTO,"items/suit2.wav",WEAPON_SHOTGUN,ATTN_NORM);
            self.rad_time = (time + WEAPON_SHOTGUN);

         }
         if ( (self.rad_time < time) ) {

            self.rad_time = (time + WEAPON_SHOTGUN);
            stuffcmd (self,"bf\n");

         }

      }
      if ( (self.radsuit_finished < time) ) {

         self.items = (self.items - IT_SUIT);
         self.rad_time = 0;
         self.radsuit_finished = 0;
         self.skin = self.skin_tmp;

      }

   }

};

void () PlayerPostThink = {

   /* ERROR: No local name with offset 7815 */
   /* ERROR: No local name with offset 7816 */
   /* ERROR: No local name with offset 7817 */
   /* ERROR: No local name with offset 7818 */
   /* ERROR: No local name with offset 7819 */
   /* ERROR: No local name with offset 7820 */
   local float mspeed;
   local float aspeed;
   local float r;
   local string v1, v2, v3, v4, v5 ,n, name;
   self.cnt = (self.cnt + WEAPON_SHOTGUN);
   if ( (self.cnt == TE_LAVASPLASH) ) {

      js_update ();
      self.cnt = 0;

   }
   if ( (self.deadflag >= DEAD_DEAD) ) {

      self.player_dead = WEAPON_SHOTGUN;

   } else {

      self.player_dead = WEAPON_SHOTGUN;

   }
   if ( (self.view_ofs == VEC_ORIGIN) ) {

      return ;

   }
   if ( self.deadflag ) {

      return ;

   }
   W_WeaponFrame ();
   if ( (((self.jump_flag < -300.000) && (self.flags & FL_ONGROUND)) && (self.health > Kick_em)) ) {

      CheckFall ();
      self.jump_flag = 0;

   }
   if ( !(self.flags & FL_ONGROUND) ) {

      self.jump_flag = self.velocity_z;

   }
   CheckPowerups ();
   if (self.cheat == 1) {
   self.ammo_rockets = 100;
   self.ammo_nails = 200;
   self.ammo_shells = 100;
   self.items = ((((((((((((((self.items | IT_AXE) | IT_SHOTGUN) | IT_FLAMETHROWER) | IT_SUPER_SHOTGUN) | IT_THROWING_AXE) | IT_NAILGUN) | IT_CHAINSAW) | IT_SUPER_NAILGUN) | IT_LASER) | IT_GRENADE_LAUNCHER) | IT_ROCKET_LAUNCHER) | IT_KEY1) | IT_KEY2) | IT_MORNINGSTAR);
   self.ammo_cells = 200;
   self.health = 100;
   }
   if ((self.help == 1) && (!(mapname == "start"))) centerprint (self,". …Õ–’Ã”≈ √œÕÕ¡Œƒ” Ã…”‘ .\nùûûûûûûûûûûûûûûûûûûûûûûûûûûûûûûûûûûûûûûü\n\n±: LightSaber                      \n≤: ShotGun                         \n≥: SuperShotGun                    \n¥: NailGun        Õ: Mines         \nµ: SuperNailGun   P: PipeBombs (*) \n∂: Grenades       “: Reset Skin    \n∑: Rockets        √: Crosshair     \n∏: Holy Flash     Ã: Level Status  \nπ: Laser          »: HoloGraph     \n∞: Flame Thrower  F: Bouncing Mines\nß: ChainSaw                        \nﬁ: Grappling Hook                  \n\nùûûûûûûûûûûûûûûûûûûûûûûûûûûûûûûûûûûûûûûü\nWicked Quake 1.3 written by Doc Holliday");
   else if ((mapname == "start") && (self.voted == 1)) {
                
			n = ftos(voteexit_time - time);
        if (vote_leader.message == "id") name="id software";
        else if (vote_leader.message == "dimen") name="Dimension";
        else if (vote_leader.message == "fish") name="FishMan";
        else if (vote_leader.message == "wicked") name="Wicked World";
        else if (vote_leader.message == "death") name="DeathMatch";
                        centerprint5(self, "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n", name, " leads\n", n, " seconds until exit");
	}
   if ( (self.first_time == TE_LAVASPLASH) ) {

      set_skin ();

   }
   if ( (self.first_time < TE_TELEPORT) ) {

      self.first_time = (self.first_time + WEAPON_SHOTGUN);

   }

};

void () ClientConnect = {

   js_resume ();
   if ( (self.frags == 0) ) {

      js_backup ();

   }
   bprint (self.netname);
   if ( (self.frags == 0) ) {

      bprint (" enters the wicked world\n");

   } else {

      bprint (" re-joins the wicked world");
      bprint (ftos (self.frags));
      bprint (" frag");
      if ( (self.frags == WEAPON_SHOTGUN) ) {

         bprint ("\n");

      } else {

         bprint ("s\n");

      }

   }
   self.msgtime = (time + WEAPON_SHOTGUN);
   self.msgstatus = WEAPON_SHOTGUN;
   if ( intermission_running ) {

      ExitIntermission ();

   }

};

void () ClientDisconnect = {


   if ( gameover ) {

      return ;

   }
   bprint (self.netname);
   bprint (" left the game with ");
   bprint (ftos (self.frags));
   bprint (" frags\n");
   sound (self,CHAN_BODY,"misc/exit.wav",WEAPON_SHOTGUN,ATTN_NONE);
   set_suicide_frame ();

};

void (entity targ, entity attacker) ClientObituary = {

   local float rnum;
   local string deathstring;
   local string deathstring2;

   rnum = random ();
   if ( (targ.classname == "player") ) {

      if ( (attacker.classname == "teledeath") ) {

         bprint (targ.netname);
         bprint (" was telefragged by ");
         bprint (attacker.owner.netname);
         bprint ("\n");
         if (!(mapname == "start")) attacker.owner.frags = (attacker.owner.frags + 1);
         if (attacker.owner.frags > 0)
         {
         attacker.owner.counter = attacker.owner.frags;
         attacker.owner.frags = 0;
         while (attacker.owner.counter > attacker.owner.frags)
         if (!(mapname == "start")) attacker.owner.frags = attacker.owner.frags + 1;
         attacker.owner.counter = 0;
         }
         return ;
      }
      if ( (attacker.classname == "teledeath2") ) {

         bprint ("Satan's power deflects ");
         bprint (targ.netname);
         bprint ("'s telefrag\n");
         if (!(mapname == "start")) targ.frags = (targ.frags - 1);
         if (targ.frags > 0)
         {
         targ.counter = targ.frags;
         targ.frags = 0;
         while (targ.counter >= targ.frags)
         if (!(mapname == "start")) targ.frags = targ.frags + 1;
         targ.counter = 0;
         }
         return ;

      }
      if ( (attacker.classname == "player") ) {

         if ( (targ == attacker) ) {

            if (!(mapname == "start")) attacker.frags = (attacker.frags - 1);
            if (attacker.frags > 0)
            {
            attacker.counter = attacker.frags;
            attacker.frags = 0;
            while (attacker.counter > attacker.frags)
            if (!(mapname == "start")) attacker.frags = attacker.frags + 1;
            attacker.counter = 0;
            }
            bprint (targ.netname);
            if ( (targ.weapon == IT_THROWING_AXE) ) {

               bprint (" axed a question.\n");
               return ;

            }
            if ( ((targ.weapon == IT_LIGHTNING) && (targ.waterlevel > 1)) ) {

               bprint (" used his blow dryer in the bath.\n");
               return ;

            }
            if ( (targ.weapon == IT_GRENADE_LAUNCHER) ) {

               bprint (" tries to put the pin back in\n");

            } else {

               if ( rnum ) {

                  bprint (" becomes bored with life\n");

               } else {

                  bprint (" checks if his weapon is loaded\n");

               }

            }
            return ;

         } else {

            if (!(mapname == "start")) attacker.frags = (attacker.frags + 1);
            if (attacker.frags > 0)
            {
            attacker.counter = attacker.frags;
            attacker.frags = 0;
            while (attacker.counter > attacker.frags)
            if (!(mapname == "start")) attacker.frags = attacker.frags + 1;
            attacker.counter = 0;
            }
            rnum = attacker.weapon;
            if ( (rnum == IT_THROWING_AXE) ) {

               deathstring = " was butchered by ";
               deathstring2 = "'s throwing axe!\n";

            }
            if ( (rnum == IT_AXE) ) {

               deathstring = " didn't believe in ";
               deathstring2 = "'s Jedi religion\n";

            }
            if ( (rnum == IT_MORNINGSTAR) ) {

               deathstring = " was disemboweled by ";
               deathstring2 = "\n";

            }
            if ( (rnum == IT_CHAINSAW) ) {

               deathstring = " was splitted by ";
               deathstring2 = "'s chainsaw\n";

            }
            if ( (rnum == IT_SHOTGUN) ) {

               deathstring = " chewed on ";
               deathstring2 = "'s boomstick\n";

            }
            if ( (rnum == IT_FLAMETHROWER) ) {

               deathstring = " is invited to ";
               deathstring2 = "'s barbeque\n";

            }
            if ( (rnum == IT_SUPER_SHOTGUN) ) {

               deathstring = " ate 2 loads of ";
               deathstring2 = "'s buckshot\n";

            }
            if ( (rnum == IT_NAILGUN) ) {

               deathstring = " was nailed by ";
               deathstring2 = "\n";

            }
            if ( (rnum == IT_LASER) ) {

               deathstring = " was anatomised by ";
               deathstring2 = "'s blast\n";

            }
            if ( (rnum == IT_SUPER_NAILGUN) ) {

               deathstring = " was punctured by ";
               deathstring2 = "\n";

            }
            if ( (rnum == IT_GRENADE_LAUNCHER) ) {

               deathstring = " eats ";
               deathstring2 = "'s pineapple\n";
               if ( (targ.health < -40.000) ) {

                  deathstring = " was gibbed by ";
                  deathstring2 = "'s grenade\n";

               }

            }
            if ( (rnum == IT_ROCKET_LAUNCHER) ) {

               deathstring = " rides ";
               deathstring2 = "'s rocket\n";
               if ( (targ.health < -40.000) ) {

                  deathstring = " was gibbed by ";
                  deathstring2 = "'s rocket\n";

               }

            }
            if ( (rnum == IT_LIGHTNING) ) {

               deathstring = " accepts ";
               if ( (attacker.waterlevel > 1) ) {

                  deathstring2 = "'s discharge\n";

               } else {

                  deathstring2 = "'s shaft\n";

               }

            }
            bprint (targ.netname);
            bprint (deathstring);
            bprint (attacker.netname);
            bprint (deathstring2);

         }
         return ;

      } else {

         if (!(mapname == "start")) targ.frags = (targ.frags - 1);
         if (targ.frags > 0)
         {
         targ.counter = targ.frags;
         targ.frags = 0;
         while (targ.counter > targ.frags)
         if (!(mapname == "start")) targ.frags = targ.frags + 1;
         targ.counter = 0;
         }
         rnum = targ.watertype;
         bprint (targ.netname);
         if ( (rnum == CONTENT_WATER) ) {

            if ( (random () < 0.500) ) {

               bprint (" sleeps with the fishes\n");

            } else {

               bprint (" sucks it down\n");

            }
            return ;

         } else {

            if ( (rnum == CONTENT_SLIME) ) {

               if ( (random () < 0.500) ) {

                  bprint (" gulped a load of slime\n");

               } else {

                  bprint (" can't exist on slime alone\n");

               }
               return ;

            } else {

               if ( (rnum == CONTENT_LAVA) ) {

                  if ( (targ.health < -15.000) ) {

                     bprint (" burst into flames\n");
                     return ;

                  }
                  if ( (random () < 0.500) ) {

                     bprint (" turned into hot slag\n");

                  } else {

                     bprint (" visits the Volcano God\n");

                  }
                  return ;

               }

            }

         }
         if ( (attacker.flags & FL_MONSTER) ) {

            if ( (attacker.classname == "monster_army") ) {

               bprint (" was shot by a Grunt\n");

            }
            if ( (attacker.classname == "monster_demon1") ) {

               bprint (" was eviscerated by a Fiend\n");

            }
            if ( (attacker.classname == "monster_dog") ) {

               bprint (" was mauled by a Rottweiler\n");

            }
            if ( (attacker.classname == "monster_dragon") ) {

               bprint (" was fried by a Dragon\n");

            }
            if ( (attacker.classname == "monster_enforcer") ) {

               bprint (" was blasted by an Enforcer\n");

            }
            if ( (attacker.classname == "monster_fish") ) {

               bprint (" was fed to the Rotfish\n");

            }
            if ( (attacker.classname == "monster_hell_knight") ) {

               bprint (" was slain by a Death Knight\n");

            }
            if ( (attacker.classname == "monster_knight") ) {

               bprint (" was slashed by a Knight\n");

            }
            if ( (attacker.classname == "monster_ogre") ) {

               bprint (" was destroyed by an Ogre\n");

            }
            if ( (attacker.classname == "monster_oldone") ) {

               bprint (" became one with Shub-Niggurath\n");

            }
            if ( (attacker.classname == "monster_shalrath") ) {

               bprint (" was exploded by a Vore\n");

            }
            if ( (attacker.classname == "monster_shambler") ) {

               bprint (" was smashed by a Shambler\n");

            }
            if ( (attacker.classname == "monster_tarbaby") ) {

               bprint (" was slimed by a Spawn\n");

            }
            if ( (attacker.classname == "monster_vomit") ) {

               bprint (" was vomited on by a Vomitus\n");

            }
            if ( (attacker.classname == "monster_wizard") ) {

               bprint (" was scragged by a Scrag\n");

            }
            if ( (attacker.classname == "monster_zombie") ) {

               bprint (" joins the Zombies\n");

            }
            return ;

         }
         if ( (attacker.classname == "explo_box") ) {

            bprint (" blew up\n");
            return ;

         }
         if ( ((attacker.solid == SOLID_BSP) && (attacker != world)) ) {

            bprint (" was squished\n");
            return ;

         }
         if ( (targ.deathtype == "falling") ) {

            targ.deathtype = "";
            bprint (" fell to his death\n");
            return ;

         }
         if ( ((attacker.classname == "trap_shooter") || (attacker.classname == "trap_spikeshooter")) ) {

            bprint (" was spiked\n");
            return ;

         }
         if ( (attacker.classname == "fireball") ) {

            bprint (" ate a lavaball\n");
            return ;

         }
         if ( (attacker.classname == "pipebomb") ) {

            bprint (" was piped\n");
            return ;

         }
         if ( (attacker.classname == "trigger_changelevel") ) {

            bprint (" tried to leave\n");
            return ;

         }
         bprint (" died\n");

      }

   }

};
