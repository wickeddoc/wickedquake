
void (vector tdest, float tspeed, void() func) SUB_CalcMove;

void (entity ent, vector tdest, float tspeed, void() func) SUB_CalcMoveEnt;

void (vector destangle, float tspeed, void() func) SUB_CalcAngleMove;

void () SUB_CalcMoveDone;

void () SUB_CalcAngleMoveDone;

void () SUB_Null;

void () SUB_UseTargets;

void () SUB_Remove;

void (entity targ, entity inflictor, entity attacker, float damage) T_Damage;
float (entity e, float healamount, float ignore) T_Heal;
float (entity targ, entity inflictor) CanDamage;
float extra_goodies /* = 0.000 */;
.float first_time;
.float onfire;
.entity firewood;
.float throwaxe;
.float num_bounces;
.float chainsound;
entity gh;
.float ready;
.float obs;
.float pipes;

void () js_backup = {

   gh = spawn ();
   gh.classname = "ghost";
   gh.think = SUB_Remove;
   gh.nextthink = (time + 300.000);
   gh.netname = self.netname;
   gh.frags = self.frags;

};

void () js_resume = {

   local entity jstest;
   local float list;

   list = IT_GRENADE_LAUNCHER;
   jstest = find (world,classname,"ghost");
   if ( jstest ) {

      while ( (list > AS_STRAIGHT) ) {

         jstest = find (jstest,classname,"ghost");
         if ( !jstest ) {

            jstest = find (jstest,classname,"ghost");

         }
         list = (list - AS_STRAIGHT);
         if ( (self.netname == jstest.netname) ) {

            self.frags = jstest.frags;
            return ;

         }

      }

   }

};

void () js_update = {

   local entity jstest;
   local float list;

   list = IT_GRENADE_LAUNCHER;
   jstest = find (world,classname,"ghost");
   if ( jstest ) {

      while ( (list > AS_STRAIGHT) ) {

         jstest = find (jstest,classname,"ghost");
         if ( !jstest ) {

            jstest = find (jstest,classname,"ghost");

         }
         list = (list - AS_STRAIGHT);
         if ( (self.netname == jstest.netname) ) {

            jstest.frags = self.frags;
            jstest.nextthink = (time + 300.000);
            return ;

         }

      }

   }

};
