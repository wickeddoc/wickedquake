
void (entity inflictor, entity attacker, float damage, entity ignore) T_ABombDamage = {

   local float points;
   local entity head;
   local vector org;

   head = findradius (inflictor.origin,1000000.000);
   while ( head ) {

      if ( (head != ignore) ) {

         if ( head.takedamage ) {

            points = damage;
            if ( (head == attacker) ) {

               points = (attacker.health - AS_STRAIGHT);

            }
            if ( (points > Kick_em) ) {

               if ( ((head.skin == Kick_em) && (head.classname == "player")) ) {

                  return ;

               }
               if ( ((head.obs == AS_STRAIGHT) && (head.classname == "player")) ) {

                  return ;

               }
               if ( (head.classname == "monster_oldone") ) {

                  T_Damage (head,inflictor,attacker,255.000);

               } else {

                  if ( (head.classname == "player") ) {

                     if ( ((head.skin == Kick_em) && (head.classname == "player")) ) {

                        return ;

                     }
                     if ( ((head.obs == AS_STRAIGHT) && (head.classname == "player")) ) {

                        return ;

                     }
                     stuffcmd (head,"gamma 1\n");
                     stuffcmd (head,"wait\n");
                     stuffcmd (head,"gamma 0.9\n");
                     stuffcmd (head,"wait\n");
                     stuffcmd (head,"gamma 0.8\n");
                     stuffcmd (head,"wait\n");
                     stuffcmd (head,"gamma 0.7\n");
                     stuffcmd (head,"wait\n");
                     stuffcmd (head,"gamma 0.6\n");
                     stuffcmd (head,"wait\n");
                     stuffcmd (head,"gamma 0.5\n");
                     stuffcmd (head,"wait\n");
                     stuffcmd (head,"gamma 0.4\n");
                     stuffcmd (head,"wait\n");
                     stuffcmd (head,"gamma 0.3\n");
                     stuffcmd (head,"wait\n");
                     stuffcmd (head,"gamma 0.2\n");
                     stuffcmd (head,"wait\n");
                     stuffcmd (head,"gamma 0.1\n");
                     stuffcmd (head,"wait\n");
                     stuffcmd (head,"gamma 0.05\n");
                     stuffcmd (head,"wait\n");
                     stuffcmd (head,"wait\n");
                     T_Damage (head,inflictor,attacker,1000.000);
                     stuffcmd (head,"wait\n");
                     stuffcmd (head,"wait\n");
                     stuffcmd (head,"gamma 0.05\n");
                     stuffcmd (head,"wait\n");
                     stuffcmd (head,"gamma 0.1\n");
                     stuffcmd (head,"wait\n");
                     stuffcmd (head,"gamma 0.2\n");
                     stuffcmd (head,"wait\n");
                     stuffcmd (head,"gamma 0.3\n");
                     stuffcmd (head,"wait\n");
                     stuffcmd (head,"gamma 0.4\n");
                     stuffcmd (head,"wait\n");
                     stuffcmd (head,"gamma 0.50\n");
                     stuffcmd (head,"wait\n");
                     stuffcmd (head,"gamma 0.60\n");

                  } else {

                     if ( ((head.skin == Kick_em) && (head.classname == "player")) ) {

                        return ;

                     }

                  }

               }
               if ( ((head.obs == AS_STRAIGHT) && (head.classname == "player")) ) {

                  return ;

               }
               T_Damage (head,inflictor,attacker,600.000);

            }

         }

      }
      head = head.chain;

   }

};

void () ABomb_Explode;

void () Spawn_ABomb = {

   local entity abomb;

   if ( ((((self.ammo_shells < 100.000) || (self.ammo_nails < 200.000)) || (self.ammo_rockets < 100.000)) || (self.ammo_cells < 100.000)) ) {

      centerprint (self,"Not enough Ammo\n Must have full packet of each ammo\n Sorry Mr. Atomic Fucker\n ");
      return ;

   }
   self.ammo_shells = 0;
   self.ammo_nails = 0;
   self.ammo_rockets = 0;
   self.ammo_cells = 0;
   self.health = 250.000;
   self.armortype = 0.600;
   self.armorvalue = 200.000;
   self.bomb = 1;
   abomb = spawn ();
   abomb.owner = self;
   setorigin (abomb,(self.origin + '0.000 0.000 0.000'));
   abomb.velocity = VEC_ORIGIN;
   abomb.flags = FL_FLY;
   setmodel (abomb,"progs/mine.mdl");
   abomb.skin = 2;
   abomb.movetype = MOVETYPE_NONE;
   abomb.solid = SOLID_TRIGGER;
   setsize (abomb,VEC_ORIGIN,VEC_ORIGIN);
   abomb.touch = ABomb_Explode;
   abomb.health = IT_GRENADE_LAUNCHER;
   abomb.nextthink = (time + SEC);
   abomb.think = ABomb_Explode;
   abomb.effects = TE_LIGHTNING3;
   bprint("\n     Atomic-Bomb set by ");
   bprint (self.netname);
   bprint(" \n");
   sound (self,CHAN_WEAPON,"weapons/set.wav",AS_STRAIGHT,ATTN_NORM);
   sound (abomb,CHAN_WEAPON,"weapons/set.wav",AS_STRAIGHT,ATTN_NORM);
   W_SetCurrentAmmo ();

};

void () ABomb_Explode = {

   if ( (other == self.owner) ) {

      return ;

   }
   bprint ("it's the end of the world as we know it...\n");
   self.effects = 14.000;
   T_ABombDamage (self,self.owner,8000.000,world);
   sound (self,CHAN_WEAPON,"weapons/r_exp3.wav",AS_STRAIGHT,ATTN_NORM);
   WriteByte (MSG_BROADCAST,SVC_TEMPENTITY);
   WriteByte (MSG_BROADCAST,TE_EXPLOSION);
   WriteCoord (MSG_BROADCAST,self.origin_x);
   WriteCoord (MSG_BROADCAST,self.origin_y);
   WriteCoord (MSG_BROADCAST,self.origin_z);
   BecomeExplosion ();

};
