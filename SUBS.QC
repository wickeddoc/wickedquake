
void () SUB_Null = {


};

void () SUB_Remove = {

   remove (self);

};

void () SetMovedir = {

   if ( (self.angles == '0.000 -1.000 0.000') ) {

      self.movedir = '0.000 0.000 1.000';

   } else {

      if ( (self.angles == '0.000 -2.000 0.000') ) {

         self.movedir = '0.000 0.000 -1.000';

      } else {

         makevectors (self.angles);
         self.movedir = v_forward;

      }

   }
   self.angles = VEC_ORIGIN;

};

void () InitTrigger = {

   if ( (self.angles != VEC_ORIGIN) ) {

      SetMovedir ();

   }
   self.solid = SOLID_TRIGGER;
   setmodel (self,self.model);
   self.movetype = MOVETYPE_NONE;
   self.modelindex = MSG_BROADCAST;
   self.model = "";

};

void (entity ent, vector tdest, float tspeed, void() func) SUB_CalcMoveEnt = {

   local entity stemp;

   stemp = self;
   self = ent;
   SUB_CalcMove (tdest,tspeed,func);
   self = stemp;

};

void (vector tdest, float tspeed, void() func) SUB_CalcMove = {

   local vector vdestdelta;
   local float len;
   local float traveltime;

   if ( !tspeed ) {

      objerror ("No speed is defined!");

   }
   self.think1 = func;
   self.finaldest = tdest;
   self.think = SUB_CalcMoveDone;
   if ( (tdest == self.origin) ) {

      self.velocity = VEC_ORIGIN;
      self.nextthink = (self.ltime + 0.100);
      return ;

   }
   vdestdelta = (tdest - self.origin);
   len = vlen (vdestdelta);
   traveltime = (len / tspeed);
   if ( (traveltime < 0.100) ) {

      self.velocity = VEC_ORIGIN;
      self.nextthink = (self.ltime + 0.100);
      return ;

   }
   self.nextthink = (self.ltime + traveltime);
   self.velocity = (vdestdelta * (AS_STRAIGHT / traveltime));

};

void () SUB_CalcMoveDone = {

   setorigin (self,self.finaldest);
   self.velocity = VEC_ORIGIN;
   self.nextthink = CONTENT_EMPTY;
   if ( self.think1 ) {

      self.think1 ();

   }

};

void (entity ent, vector destangle, float tspeed, void() func) SUB_CalcAngleMoveEnt = {

   local entity stemp;

   stemp = self;
   self = ent;
   SUB_CalcAngleMove (destangle,tspeed,func);
   self = stemp;

};

void (vector destangle, float tspeed, void() func) SUB_CalcAngleMove = {

   local vector destdelta;
   local float len;
   local float traveltime;

   if ( !tspeed ) {

      objerror ("No speed is defined!");

   }
   destdelta = (destangle - self.angles);
   len = vlen (destdelta);
   traveltime = (len / tspeed);
   self.nextthink = (self.ltime + traveltime);
   self.avelocity = (destdelta * (AS_STRAIGHT / traveltime));
   self.think1 = func;
   self.finalangle = destangle;
   self.think = SUB_CalcAngleMoveDone;

};

void () SUB_CalcAngleMoveDone = {

   self.angles = self.finalangle;
   self.avelocity = VEC_ORIGIN;
   self.nextthink = CONTENT_EMPTY;
   if ( self.think1 ) {

      self.think1 ();

   }

};

void () DelayThink = {

   activator = self.enemy;
   SUB_UseTargets ();
   remove (self);

};

void () SUB_UseTargets = {

   local entity t;
   local entity stemp;
   local entity otemp;
   local entity act;

   if ( self.delay ) {

      t = spawn ();
      t.classname = "DelayedUse";
      t.nextthink = (time + self.delay);
      t.think = DelayThink;
      t.enemy = activator;
      t.message = self.message;
      t.killtarget = self.killtarget;
      t.target = self.target;
      return ;

   }
   if ( ((activator.classname == "player") && (self.message != "")) ) {

      centerprint (activator,self.message);
      if ( !self.noise ) {

         sound (activator,CHAN_VOICE,"misc/talk.wav",AS_STRAIGHT,ATTN_NORM);

      }

   }
   if ( self.killtarget ) {

      t = world;
      do {

         t = find (t,targetname,self.killtarget);
         if ( !t ) {

            return ;

         }
         remove (t);

      } while ( AS_STRAIGHT );

   }
   if ( self.target ) {

      act = activator;
      t = world;
      do {

         t = find (t,targetname,self.target);
         if ( !t ) {

            return ;

         }
         stemp = self;
         otemp = other;
         self = t;
         other = stemp;
         if ( (self.use != SUB_Null) ) {

            if ( self.use ) {

               self.use ();

            }

         }
         self = stemp;
         other = otemp;
         activator = act;

      } while ( AS_STRAIGHT );

   }

};

void (float normal) SUB_AttackFinished = {

   self.cnt = MSG_BROADCAST;
   if ( (skill != AS_MELEE) ) {

      self.attack_finished = (time + normal);

   }

};
float (entity targ) visible;

void (void() thinkst) SUB_CheckRefire = {

   if ( (skill != AS_MELEE) ) {

      return ;

   }
   if ( (self.cnt == AS_STRAIGHT) ) {

      return ;

   }
   if ( !visible (self.enemy) ) {

      return ;

   }
   self.cnt = AS_STRAIGHT;
   self.think = thinkst;

};
