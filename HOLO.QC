float ACTIVATE_HOLO    = 99.000;
float SEC    = 25.000;
float COST    = 50.000;

void () RemoveHolo = {

   WriteByte (MSG_BROADCAST,SVC_TEMPENTITY);
   WriteByte (MSG_BROADCAST,TE_TELEPORT);
   WriteCoord (MSG_BROADCAST,self.origin_x);
   WriteCoord (MSG_BROADCAST,self.origin_y);
   WriteCoord (MSG_BROADCAST,self.origin_z);
   sound (self,CHAN_BODY,"misc/r_tele1.wav",AS_STRAIGHT,ATTN_NORM);
   SUB_Remove ();
   self.owner.holo = 0;

};

void () holo_stand1 = [ 12.000, holo_stand2 ] {


};

void () holo_stand2 = [ 13.000, holo_stand3 ] {


};

void () holo_stand3 = [ 14.000, holo_stand4 ] {


};

void () holo_stand4 = [ 15.000, holo_stand5 ] {


};

void () holo_stand5 = [ 16.000, holo_stand1 ] {

   self.health = (self.health - 0.500);
   if ( (self.health <= MSG_BROADCAST) ) {

      RemoveHolo ();

   }

};

void (entity myself) ActivateHolo = {

   local entity newholo;

   newholo = spawn ();
   newholo.solid = SOLID_NOT;
   newholo.movetype = MOVETYPE_NOCLIP;
   newholo.origin = myself.origin;
   newholo.angles = myself.angles;
   newholo.colormap = myself.colormap;
   newholo.skin = myself.skin;
   setmodel (newholo,"progs/player.mdl");
   newholo.classname = "holo";
   newholo.owner = myself;
   newholo.health = SEC;
   myself.ammo_cells = (myself.ammo_cells - COST);
   myself.currentammo = (myself.ammo_cells - COST);
   myself.holo = 1;
   stuffcmd (newholo.owner,"bf\n");
   newholo.nextthink = time;
   newholo.think = holo_stand1;

};

void () CheckHoloCommand = {

   if ( (self.impulse != ACTIVATE_HOLO) ) {

      return ;

   }
   if (self.holo == 1) {

      centerprint (self,"HoloGraph Active\n");
      return ;

   }
   if ( (self.ammo_cells < TE_LAVASPLASH) ) {

      centerprint (self,"Cells are low\n");
      return ;

   }
   ActivateHolo (self);

};
