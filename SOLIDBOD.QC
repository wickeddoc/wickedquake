
void () CorpsePain = {

   local float t;

   SpawnMeatSpray (self.origin,((crandom () * 100.000) * v_right));
   t = (random () * 25.000);
   SpawnBlood (self.origin,((crandom () * 100.000) * v_right),t);
   t = (random () * 25.000);
   SpawnBlood (self.origin,((crandom () * -150.000) * v_right),t);
   t = (random () * 25.000);
   SpawnBlood (self.origin,((crandom () * 70.000) * v_right),t);
   t = (random () * 25.000);
   SpawnBlood (self.origin,((crandom () * -50.000) * v_right),t);

};

void () CMove = {

   local float dir;

   if ( (other.takedamage != DAMAGE_AIM) ) {

      return ;

   }
   self.velocity_x = (other.velocity_x / AS_MELEE);
   self.velocity_y = (other.velocity_y / AS_MELEE);
   if ( (self.flags & FL_ONGROUND) ) {

      self.flags = (self.flags - FL_ONGROUND);

   }

};

void (string gibname, float dm) ThrowGib;

void () CorpseDie = {

   local float i;
   local float j;
   local float num_gibs;

   sound (self,CHAN_VOICE,"player/udeath.wav",AS_STRAIGHT,ATTN_NORM);
   if ( (self.model != "progs/h_player.mdl") ) {

      ThrowGib ("progs/gib1.mdl",self.health);
      ThrowGib ("progs/gib2.mdl",self.health);
      ThrowGib ("progs/gib3.mdl",self.health);

   } else {

      CorpsePain ();
      CorpsePain ();

   }
   self.model = string_null;
   self.solid = SOLID_NOT;
   self.skin = empty_float;

};

void (entity tmp_bodyque_head) SetSolidBody = {

   tmp_bodyque_head.takedamage = DAMAGE_AIM;
   tmp_bodyque_head.solid = SOLID_BBOX;
   tmp_bodyque_head.movetype = MOVETYPE_STEP;
   tmp_bodyque_head.flags = (tmp_bodyque_head.flags & !FL_MONSTER);
   tmp_bodyque_head.th_stand = SUB_Null;
   tmp_bodyque_head.th_walk = SUB_Null;
   tmp_bodyque_head.th_run = SUB_Null;
   tmp_bodyque_head.th_pain = CorpsePain;
   tmp_bodyque_head.th_melee = SUB_Null;
   tmp_bodyque_head.th_missile = SUB_Null;
   tmp_bodyque_head.touch = CMove;
   tmp_bodyque_head.th_die = CorpseDie;
   if ( (tmp_bodyque_head.model != "progs/h_player.mdl") ) {

      tmp_bodyque_head.health = COST;
      setsize (tmp_bodyque_head,VEC_HULL2_MIN,'32.000 32.000 4.000');

   } else {

      tmp_bodyque_head.health = TE_LAVASPLASH;
      tmp_bodyque_head.nextthink = CONTENT_EMPTY;
      setsize (tmp_bodyque_head,'-16.000 -16.000 0.000','16.000 16.000 24.000');

   }

};
