
void () efx1_Attack;

void () efx2_spawn;

void (vector DropOrg) MakeDrop;

void () efx3_spawn;

void (vector FlakeOrg) MakeFlake;

void () FlakeFloat;
float (float min, float max) RandomRange;

void () event_lightning = {

   precache_sound ("weapons/lstart.wav");
   self.classname = "efx_lightning";
   self.nextthink = (time + RandomRange (WEAPON_ROCKET,TE_LIGHTNING1));
   self.think = efx1_Attack;

};

void () efx1_Attack = {

   local vector org;
   local vector targ;
   local vector org2;
   local entity BudLite;

   sound (self,CHAN_VOICE,"weapons/lstart.wav",AS_STRAIGHT,ATTN_NORM);
   org = self.origin;
   targ = (self.origin - '0.000 0.000 128.000');
   targ_x = (targ_x + RandomRange (-32.000,SVC_CDTRACK));
   targ_y = (targ_y + RandomRange (-32.000,SVC_CDTRACK));
   self.nextthink = (time + RandomRange (WEAPON_ROCKET,TE_LIGHTNING1));
   self.think = efx1_Attack;
   LightningDamage (org,targ,self,TE_LAVASPLASH);
   WriteByte (MSG_ALL,SVC_TEMPENTITY);
   WriteByte (MSG_ALL,TE_LIGHTNING2);
   WriteEntity (MSG_ALL,world);
   WriteCoord (MSG_ALL,org_x);
   WriteCoord (MSG_ALL,org_y);
   WriteCoord (MSG_ALL,org_z);
   WriteCoord (MSG_ALL,targ);
   WriteCoord (MSG_ALL,targ_y);
   WriteCoord (MSG_ALL,targ_z);

};

void () event_rain = {

   self.classname = "efx_rain";
   self.nextthink = (time + 0.200);
   self.think = efx2_spawn;

};

void () efx2_spawn = {

   local float n;
   local vector rainorg;

   n = Kick_em;
   while ( (n < TE_LAVASPLASH) ) {

      rainorg = self.origin;
      rainorg_x = (rainorg_x + RandomRange (-128.000,IT_FLAMETHROWER));
      rainorg_y = (rainorg_y + RandomRange (-128.000,IT_FLAMETHROWER));
      rainorg_z = (rainorg_z + RandomRange (Kick_em,IT_LIGHTNING));
      MakeDrop (rainorg);
      n = (n + AS_STRAIGHT);

   }
   self.nextthink = (time + 0.400);
   self.think = efx2_spawn;

};

void (vector DropOrg) MakeDrop = {

   local entity Drop;

   Drop = spawn ();
   setmodel (Drop,"progs/s_bubble.spr");
   setorigin (Drop,DropOrg);
   Drop.movetype = MOVETYPE_NOCLIP;
   Drop.solid = SOLID_NOT;
   Drop.velocity = '0.000 0.000 -252.000';
   Drop.classname = "RainDrop";
   Drop.frame = AS_STRAIGHT;
   Drop.think = SUB_Remove;
   Drop.nextthink = (time + 0.600);

};

void () event_snow = {

   self.classname = "efx_snow";
   self.nextthink = (time + 0.200);
   self.think = efx3_spawn;

};

void () efx3_spawn = {

   local float n;
   local vector snoworg;

   n = Kick_em;
   while ( (n < WEAPON_SPIKES) ) {

      snoworg = self.origin;
      snoworg_x = (snoworg_x + RandomRange (-128.000,IT_FLAMETHROWER));
      snoworg_y = (snoworg_y + RandomRange (-128.000,IT_FLAMETHROWER));
      snoworg_z = (snoworg_z + RandomRange (Kick_em,IT_LIGHTNING));
      MakeFlake (snoworg);
      n = (n + AS_STRAIGHT);

   }
   self.nextthink = (time + RandomRange (1.500,WEAPON_ROCKET));
   self.think = efx3_spawn;

};

void (vector FlakeOrg) MakeFlake = {

   local entity Flake;

   Flake = spawn ();
   setmodel (Flake,"progs/s_bubble.spr");
   setorigin (Flake,FlakeOrg);
   Flake.movetype = MOVETYPE_NOCLIP;
   Flake.solid = SOLID_NOT;
   Flake.classname = "SnowFlake";
   Flake.frame = AS_STRAIGHT;
   Flake.velocity_z = -64.000;
   Flake.think = FlakeFloat;
   Flake.touch = SUB_Remove;
   Flake.nextthink = (time + 0.500);
   Flake.cnt = Kick_em;

};

void () FlakeFloat = {

   local float rnd1;
   local float rnd2;

   self.cnt = (self.cnt + AS_STRAIGHT);
   if ( (self.cnt > 20.000) ) {

      remove (self);

   }
   rnd1 = (self.velocity_x + (-10.000 + (random () * 20.000)));
   rnd2 = (self.velocity_y + (-10.000 + (random () * 20.000)));
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
   self.velocity_x = rnd1;
   self.velocity_y = rnd2;
   self.nextthink = (time + 0.700);
   self.think = FlakeFloat;

};
float (float min, float max) RandomRange = {

   local float width;
   local float offset;
   local float result;

   width = (max - min);
   offset = (random () * width);
   result = (offset + min);
   return ( result );

};
