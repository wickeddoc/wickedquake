
void () CheckFall = {

   local float hgt;
   local float BASE_DMG;
   local string s;

   BASE_DMG = AS_MELEE;
   if ( (self.obs == AS_STRAIGHT) ) {

      return ;

   }
   if ( (self.skin == Kick_em) ) {

      return ;

   }
   hgt = ((self.jump_flag + 300.000) / -11.000);
   sprint (self,"You fell ");
   s = ftos (hgt);
   sprint (self,s);
   sprint (self," FT\n");
   if ( (self.watertype == CONTENT_WATER) ) {

      sound (self,CHAN_BODY,"player/h2ojump.wav",AS_STRAIGHT,ATTN_NORM);
      if ( (hgt < 40.000) ) {

         T_Damage (self,world,world,BASE_DMG);
         sound (self,CHAN_VOICE,"player/land2.wav",AS_STRAIGHT,ATTN_NORM);
         self.deathtype = "falling";

      } else {

         if ( (hgt < COST) ) {

            T_Damage (self,world,world,(WEAPON_ROCKET * BASE_DMG));
            sound (self,CHAN_VOICE,"player/land2.wav",AS_STRAIGHT,ATTN_NORM);
            self.deathtype = "falling";

         } else {

            if ( (hgt < 60.000) ) {

               T_Damage (self,world,world,(WEAPON_SPIKES * BASE_DMG));
               sound (self,CHAN_VOICE,"player/land2.wav",AS_STRAIGHT,ATTN_NORM);
               self.deathtype = "falling";

            } else {

               if ( (hgt < 70.000) ) {

                  T_Damage (self,world,world,(WEAPON_BIG * BASE_DMG));
                  sound (self,CHAN_VOICE,"player/land2.wav",AS_STRAIGHT,ATTN_NORM);
                  self.deathtype = "falling";

               } else {

                  T_Damage (self,world,world,(IT_GRENADE_LAUNCHER * BASE_DMG));
                  sound (self,CHAN_VOICE,"player/land2.wav",AS_STRAIGHT,ATTN_NORM);
                  self.deathtype = "falling";

               }

            }

         }

      }

   } else {

      if ( (hgt < TE_LAVASPLASH) ) {

         sound (self,CHAN_VOICE,"player/land.wav",AS_STRAIGHT,ATTN_NORM);

      } else {

         if ( (hgt < 20.000) ) {

            T_Damage (self,world,world,BASE_DMG);
            sound (self,CHAN_VOICE,"player/land2.wav",AS_STRAIGHT,ATTN_NORM);
            self.deathtype = "falling";

         } else {

            if ( (hgt < SVC_INTERMISSION) ) {

               T_Damage (self,world,world,(WEAPON_ROCKET * BASE_DMG));
               sound (self,CHAN_VOICE,"player/land2.wav",AS_STRAIGHT,ATTN_NORM);
               self.deathtype = "falling";

            } else {

               if ( (hgt < 40.000) ) {

                  T_Damage (self,world,world,(WEAPON_SPIKES * BASE_DMG));
                  sound (self,CHAN_VOICE,"player/land2.wav",AS_STRAIGHT,ATTN_NORM);
                  self.deathtype = "falling";

               } else {

                  if ( (hgt < COST) ) {

                     T_Damage (self,world,world,(WEAPON_BIG * BASE_DMG));
                     sound (self,CHAN_VOICE,"player/land2.wav",AS_STRAIGHT,ATTN_NORM);
                     self.deathtype = "falling";

                  } else {

                     if ( (hgt < 60.000) ) {

                        T_Damage (self,world,world,(IT_GRENADE_LAUNCHER * BASE_DMG));
                        sound (self,CHAN_VOICE,"player/land2.wav",AS_STRAIGHT,ATTN_NORM);
                        self.deathtype = "falling";

                     } else {

                        if ( (hgt < 70.000) ) {

                           T_Damage (self,world,world,(SVC_CDTRACK * BASE_DMG));
                           sound (self,CHAN_VOICE,"player/land2.wav",AS_STRAIGHT,ATTN_NORM);
                           self.deathtype = "falling";

                        } else {

                           T_Damage (self,world,world,(IT_LIGHTNING * BASE_DMG));
                           sound (self,CHAN_VOICE,"player/land2.wav",AS_STRAIGHT,ATTN_NORM);
                           self.deathtype = "falling";

                        }

                     }

                  }

               }

            }

         }

      }

   }

};
