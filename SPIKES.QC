
void () shrat_touch;

void () dspike_touch;

void (vector org, entity own) throw_a_shrat = {

   newmis = spawn ();
   newmis.classname = "spike";
   newmis.owner = own;
   newmis.movetype = MOVETYPE_BOUNCE;
   newmis.solid = SOLID_BBOX;
   newmis.angles = VEC_ORIGIN;
   newmis.touch = shrat_touch;
   if ( (random () > 0.900) ) {

      newmis.nextthink = (time + (random () * TE_LAVASPLASH));

   } else {

      newmis.nextthink = (time + (random () * AS_STRAIGHT));

   }
   newmis.think = SUB_Remove;
   setmodel (newmis,"progs/spike.mdl");
   setsize (newmis,VEC_ORIGIN,VEC_ORIGIN);
   setorigin (newmis,org);
   newmis.avelocity = ((((v_forward * crandom ()) * 600.000) + ((v_right * crandom ()) * 600.000)) + ((v_up * crandom ()) * 600.000));
   newmis.velocity = ((((v_forward * crandom ()) * 1000.000) + ((v_right * crandom ()) * 1000.000)) + ((v_up * crandom ()) * 1000.000));

};

void (vector org, entity own, float number) throw_shrat = {

   local float i;

   i = Kick_em;
   while ( (i < number) ) {

      throw_a_shrat (org,own);
      i = (i + AS_STRAIGHT);

   }

};

void () shrat_touch = {

   local float dam;

   if ( (other.solid == SOLID_TRIGGER) ) {

      return ;

   }
   if ( (pointcontents (self.origin) == CONTENT_SKY) ) {

      remove (self);
      return ;

   }
   if ( other.takedamage ) {

      dam = (random () * 25.000);
      spawn_touchblood (dam);
      T_Damage (other,self,self.owner,dam);
      remove (self);

   } else {

      WriteByte (MSG_BROADCAST,SVC_TEMPENTITY);
      WriteByte (MSG_BROADCAST,TE_SPIKE);
      WriteCoord (MSG_BROADCAST,self.origin_x);
      WriteCoord (MSG_BROADCAST,self.origin_y);
      WriteCoord (MSG_BROADCAST,self.origin_z);

   }

};

void (vector org, entity own, vector dir) throw_spike = {

   newmis = spawn ();
   newmis.classname = "spike";
   newmis.owner = own;
   newmis.movetype = MOVETYPE_BOUNCE;
   newmis.solid = SOLID_BBOX;
   newmis.angles = VEC_ORIGIN;
   newmis.touch = dspike_touch;
   if ( (random () > 0.900) ) {

      newmis.nextthink = (time + (random () * TE_LAVASPLASH));

   } else {

      newmis.nextthink = (time + (random () * AS_STRAIGHT));

   }
   newmis.think = SUB_Remove;
   setmodel (newmis,"progs/spike.mdl");
   setsize (newmis,VEC_ORIGIN,VEC_ORIGIN);
   setorigin (newmis,org);
   newmis.avelocity = ((((v_forward * crandom ()) * 600.000) + ((v_right * crandom ()) * 600.000)) + ((v_up * crandom ()) * 600.000));
   newmis.velocity = ((((dir * 0.750) + ((v_forward * crandom ()) * 200.000)) + ((v_right * crandom ()) * 200.000)) + ((v_up * crandom ()) * 200.000));

};

void () fall_spike = {

   self.movetype = MOVETYPE_BOUNCE;
   newmis.solid = SOLID_BBOX;
   newmis.touch = dspike_touch;
   self.think = SUB_Remove;
   self.nextthink = (time + AS_STRAIGHT);
   self.avelocity = ((((v_forward * crandom ()) * 600.000) + ((v_right * crandom ()) * 600.000)) + ((v_up * crandom ()) * 600.000));

};

void (vector org, vector dir) stick_spike = {

   local vector facing;
   local vector neworg;

   newmis = spawn ();
   newmis.classname = "spike";
   newmis.owner = world;
   newmis.movetype = MOVETYPE_NONE;
   newmis.solid = SOLID_NOT;
   newmis.angles = vectoangles (dir);
   facing = (-8.000 * normalize (dir));
   neworg = (org + facing);
   if ( (random () > 0.900) ) {

      newmis.nextthink = (time + (random () * TE_LAVASPLASH));

   } else {

      newmis.nextthink = (time + (random () * AS_STRAIGHT));

   }
   newmis.think = fall_spike;
   setmodel (newmis,"progs/spike.mdl");
   setsize (newmis,VEC_ORIGIN,VEC_ORIGIN);
   setorigin (newmis,neworg);
   newmis.avelocity = VEC_ORIGIN;
   newmis.velocity = VEC_ORIGIN;

};

void () dspike_touch = {

   local float rand;

   if ( (other.solid == SOLID_TRIGGER) ) {

      return ;

   }
   if ( (pointcontents (self.origin) == CONTENT_SKY) ) {

      remove (self);
      return ;

   }
   if ( other.takedamage ) {

      spawn_touchblood (WEAPON_SPIKES);
      T_Damage (other,self,self.owner,WEAPON_SPIKES);
      remove (self);

   } else {

      WriteByte (MSG_BROADCAST,SVC_TEMPENTITY);
      WriteByte (MSG_BROADCAST,TE_SPIKE);
      WriteCoord (MSG_BROADCAST,self.origin_x);
      WriteCoord (MSG_BROADCAST,self.origin_y);
      WriteCoord (MSG_BROADCAST,self.origin_z);

   }

};

void () NewGrenadeExplode = {

   T_RadiusDamage (self,self.owner,120.000,world);
   WriteByte (MSG_BROADCAST,SVC_TEMPENTITY);
   WriteByte (MSG_BROADCAST,TE_EXPLOSION);
   WriteCoord (MSG_BROADCAST,self.origin_x);
   WriteCoord (MSG_BROADCAST,self.origin_y);
   WriteCoord (MSG_BROADCAST,self.origin_z);
   throw_shrat (self.origin,self.owner,TE_LIGHTNING2);
   BecomeExplosion ();

};

void () new_spike_touch = {

   local float rand;
   local float bleeder;

   bleeder = Kick_em;
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

      spawn_touchblood (10);
      T_Damage (other,self,self.owner,12);
      bleeder = AS_STRAIGHT;

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
   if ( (bleeder == Kick_em) ) {

      if ( (crandom () < Kick_em) ) {

         throw_spike (self.origin,self.owner,self.velocity);

      } else {

         stick_spike (self.origin,self.velocity);

      }

   }
   remove (self);

};

void () new_superspike_touch = {

   local float rand;
   local float bleeder;

   bleeder = Kick_em;
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

      spawn_touchblood (18.000);
      T_Damage (other,self,self.owner,18.000);
      bleeder = AS_STRAIGHT;

   } else {

      WriteByte (MSG_BROADCAST,SVC_TEMPENTITY);
      WriteByte (MSG_BROADCAST,TE_SUPERSPIKE);
      WriteCoord (MSG_BROADCAST,self.origin_x);
      WriteCoord (MSG_BROADCAST,self.origin_y);
      WriteCoord (MSG_BROADCAST,self.origin_z);

   }
   if ( (bleeder == Kick_em) ) {

      if ( (crandom () < Kick_em) ) {

         throw_spike (self.origin,self.owner,self.velocity);

      } else {

         stick_spike (self.origin,self.velocity);

      }

   }
   remove (self);

};
