
void () T_MissileTouch;

void () info_player_start;

void (entity targ, entity attacker) ClientObituary;

void () monster_death_use;

void () DeathBubblesSpawn;
float (entity targ, entity inflictor) CanDamage = {

   if ( (targ.movetype == MOVETYPE_PUSH) ) {

      traceline (inflictor.origin,(0.500 * (targ.absmin + targ.absmax)),TRUE,self);
      if ( (trace_fraction == AS_STRAIGHT) ) {

         return ( TRUE );

      }
      if ( (trace_ent == targ) ) {

         return ( TRUE );

      }
      return ( FALSE );

   }
   traceline (inflictor.origin,targ.origin,TRUE,self);
   if ( (trace_fraction == AS_STRAIGHT) ) {

      return ( TRUE );

   }
   traceline (inflictor.origin,(targ.origin + '15.000 15.000 0.000'),TRUE,self);
   if ( (trace_fraction == AS_STRAIGHT) ) {

      return ( TRUE );

   }
   traceline (inflictor.origin,(targ.origin + '-15.000 -15.000 0.000'),TRUE,self);
   if ( (trace_fraction == AS_STRAIGHT) ) {

      return ( TRUE );

   }
   traceline (inflictor.origin,(targ.origin + '-15.000 15.000 0.000'),TRUE,self);
   if ( (trace_fraction == AS_STRAIGHT) ) {

      return ( TRUE );

   }
   traceline (inflictor.origin,(targ.origin + '15.000 -15.000 0.000'),TRUE,self);
   if ( (trace_fraction == AS_STRAIGHT) ) {

      return ( TRUE );

   }
   return ( FALSE );

};

void (entity targ, entity attacker) Killed = {

   local entity oself;

   oself = self;
   self = targ;
   if ( (self.health < -99.000) ) {

      self.health = -99.000;

   }
   if ( ((self.movetype == MOVETYPE_PUSH) || (self.movetype == MOVETYPE_NONE)) ) {

      self.th_die ();
      self = oself;
      return ;

   }
   self.enemy = attacker;
   if ( (self.flags & FL_MONSTER) ) {

      killed_monsters = (killed_monsters + AS_STRAIGHT);
      WriteByte (MSG_ALL,SVC_KILLEDMONSTER);

   }
   ClientObituary (self,attacker);
   self.takedamage = DAMAGE_NO;
   self.touch = SUB_Null;
   monster_death_use ();
   self.th_die ();
   self = oself;

};

void (entity targ, entity inflictor, entity attacker, float damage) T_Damage = {

   local vector dir;
   local entity oldself;
   local float save;
   local float take;

   if ( ((targ.skin == MSG_BROADCAST) && (targ.classname == "player")) ) {

      return ;

   }
   if ( ((targ.obs == AS_STRAIGHT) && (targ.classname == "player")) ) {

      return ;

   }
   if ( !targ.takedamage ) {

      return ;

   }
   damage_attacker = attacker;
   if ( (attacker.super_damage_finished > time) ) {

      damage = (damage * AS_MISSILE);

   }
   save = ceil ((targ.armortype * damage));
   if ( (save >= targ.armorvalue) ) {

      save = targ.armorvalue;
      targ.armortype = MSG_BROADCAST;
      targ.items = (targ.items - (targ.items & ((IT_ARMOR1 | IT_ARMOR2) | IT_ARMOR3)));

   }
   targ.armorvalue = (targ.armorvalue - save);
   take = ceil ((damage - save));
   if ( (targ.flags & FL_CLIENT) ) {

      targ.dmg_take = (targ.dmg_take + take);
      targ.dmg_save = (targ.dmg_save + save);
      targ.dmg_inflictor = inflictor;

   }
   if ( ((inflictor != world) && (targ.movetype == MOVETYPE_WALK)) ) {

      dir = (targ.origin - ((inflictor.absmin + inflictor.absmax) * 0.500));
      dir = normalize (dir);
      targ.velocity = (targ.velocity + ((dir * damage) * EF_DIMLIGHT));

   }
   if ( (targ.flags & FL_GODMODE) ) {

      return ;

   }
   if ( (targ.invincible_finished >= time) ) {

      if ( (self.invincible_sound < time) ) {

         sound (targ,CHAN_ITEM,"items/protect3.wav",AS_STRAIGHT,ATTN_NORM);
         self.invincible_sound = (time + AS_SLIDING);

      }
      return ;

   }
   if ( (((teamplay == AS_STRAIGHT) && (targ.team > MSG_BROADCAST)) && (targ.team == attacker.team)) ) {

      return ;

   }
   targ.health = (targ.health - take);
   if ( (targ.health <= MSG_BROADCAST) ) {

      Killed (targ,attacker);
      return ;

   }
   oldself = self;
   self = targ;
   if ( ((self.flags & FL_MONSTER) && (attacker != world)) ) {

      if ( ((self != attacker) && (attacker != self.enemy)) ) {

         if ( ((self.classname != attacker.classname) || (self.classname == "monster_army")) ) {

            if ( (self.enemy.classname == "player") ) {

               self.oldenemy = self.enemy;

            }
            self.enemy = attacker;
            FoundTarget ();

         }

      }

   }
   if ( self.th_pain ) {

      self.th_pain (attacker,take);
      if ( (skill == AS_MELEE) ) {

         self.pain_finished = (time + TE_LIGHTNING1);

      }

   }
   self = oldself;

};

void (entity inflictor, entity attacker, float damage, entity ignore) T_RadiusDamage = {

   local float points;
   local entity head;
   local vector org;

   head = findradius (inflictor.origin,(damage + 40.000));
   while ( head ) {

      if ( (head != ignore) ) {

         if ( head.takedamage ) {

            org = (head.origin + ((head.mins + head.maxs) * 0.500));
            points = (0.500 * vlen ((inflictor.origin - org)));
            if ( (points < MSG_BROADCAST) ) {

               points = MSG_BROADCAST;

            }
            points = (damage - points);
            if ( (head == attacker) ) {

               points = (points * 0.500);

            }
            if ( (points > MSG_BROADCAST) ) {

               if ( CanDamage (head,inflictor) ) {

                  if ( ((head.skin == MSG_BROADCAST) && (head.classname == "player")) ) {

                     return ;

                  }
                  if ( ((head.obs == AS_STRAIGHT) && (head.classname == "player")) ) {

                     return ;

                  }
                  if ( (head.classname == "monster_shambler") ) {

                     T_Damage (head,inflictor,attacker,(points * 0.500));

                  } else {

                     T_Damage (head,inflictor,attacker,points);

                  }

               }

            }

         }

      }
      head = head.chain;

   }

};

void (entity inflictor, entity attacker, float damage, entity ignore) T_DischargeWaterRadiusDamage = {

   local float points;
   local entity head;
   local vector org;
   local entity bubble_spawner;

   head = findradius (inflictor.origin,(damage + 40.000));
   if ( ((head.skin == MSG_BROADCAST) && (head.classname == "player")) ) {

      return ;

   }
   if ( ((head.obs == AS_STRAIGHT) && (head.classname == "player")) ) {

      return ;

   }
   while ( head ) {

      if ( (head != ignore) ) {

         if ( (head.takedamage && (head.waterlevel > MSG_BROADCAST)) ) {

            org = (head.origin + ((head.mins + head.maxs) * 0.500));
            points = (0.500 * vlen ((inflictor.origin - org)));
            if ( (points < MSG_BROADCAST) ) {

               points = MSG_BROADCAST;

            }
            points = (damage - points);
            if ( (head == attacker) ) {

               points = (points * 0.500);

            }
            if ( (points > MSG_BROADCAST) ) {

               if ( CanDamage (head,inflictor) ) {

                  if ( ((head.skin == MSG_BROADCAST) && (head.classname == "player")) ) {

                     return ;

                  }
                  if ( ((head.obs == AS_STRAIGHT) && (head.classname == "player")) ) {

                     return ;

                  }
                  if ( (head.classname == "monster_shambler") ) {

                     T_Damage (head,inflictor,attacker,(points * 0.500));

                  } else {

                     T_Damage (head,inflictor,attacker,points);

                  }
                  bubble_spawner = spawn ();
                  setorigin (bubble_spawner,head.origin);
                  bubble_spawner.movetype = MOVETYPE_NONE;
                  bubble_spawner.solid = SOLID_NOT;
                  bubble_spawner.nextthink = (time + 0.100);
                  bubble_spawner.think = DeathBubblesSpawn;
                  bubble_spawner.air_finished = MSG_BROADCAST;
                  bubble_spawner.owner = head;
                  bubble_spawner.bubble_count = AS_STRAIGHT;

               }

            }

         }

      }
      head = head.chain;

   }

};

void (entity inflictor, entity attacker, float damage, float radius, entity ignore) T_ShootWaterRadiusDamage = {

   local float points;
   local entity head;
   local vector org;

   head = findradius (inflictor.origin,radius);
   while ( head ) {

      if ( (head != ignore) ) {

         if ( (head.takedamage && (head.waterlevel > MSG_BROADCAST)) ) {

            if ( CanDamage (head,inflictor) ) {

               if ( ((head.skin == MSG_BROADCAST) && (head.classname == "player")) ) {

                  return ;

               }
               if ( ((head.obs == AS_STRAIGHT) && (head.classname == "player")) ) {

                  return ;

               }
               if ( (head.classname == "monster_shambler") ) {

                  T_Damage (head,inflictor,attacker,(damage * 0.500));

               } else {

                  T_Damage (head,inflictor,attacker,damage);

               }

            }

         }

      }
      head = head.chain;

   }

};

void (entity attacker, float damage) T_BeamDamage = {

   local float points;
   local entity head;

   head = findradius (attacker.origin,(damage + 40.000));
   while ( head ) {

      if ( head.takedamage ) {

         points = (0.500 * vlen ((attacker.origin - head.origin)));
         if ( (points < MSG_BROADCAST) ) {

            points = MSG_BROADCAST;

         }
         points = (damage - points);
         if ( (head == attacker) ) {

            points = (points * 0.500);

         }
         if ( (points > MSG_BROADCAST) ) {

            if ( CanDamage (head,attacker) ) {

               if ( ((head.skin == MSG_BROADCAST) && (head.classname == "player")) ) {

                  return ;

               }
               if ( ((head.obs == AS_STRAIGHT) && (head.classname == "player")) ) {

                  return ;

               }
               if ( (head.classname == "monster_shambler") ) {

                  T_Damage (head,attacker,attacker,(points * 0.500));

               } else {

                  T_Damage (head,attacker,attacker,points);

               }

            }

         }

      }
      head = head.chain;

   }

};
