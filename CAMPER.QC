/* CAMPER.QC - Proximity Monitoring Version!

Based on Original code by: James Starling <starling@mgl.ca>

*/


/* -------------------------------------------------------------------------
Changes outside of this file to original Quake source...
 
1) add these fields to the defs.qc in the "player only" section
.float  camp_time;			// next camping check
.float  camp_count;			// number of camping warnings
.vector	camp_origin;		// location of last check

2) add this line to "PlayerPreThink" function in client.qc
CheckForCamper();

3) add camper.qc before client.qc in the progs.src file

-------------------------------------------------------------------------- */

// functional prototypes of existing Quake functions
entity () SelectSpawnPoint;
void (vector org) spawn_tfog;

void() GibPlayer;		//MRB to kill camper
void() DeathSound;

// internal definitions of camping times warnings
float CAMPER_CHECK 				= 1;
float CAMPER_DISTANCE	 			= 200;
float CAMPER_HEALTH_PERCENT			= 0.5;

// resets the camper fields in the player entity
void() ResetCamperFields =
{
	// reset the player's next camper check
	self.camp_count = 0;
	self.camp_time = time + CAMPER_CHECK;
	self.camp_origin = self.origin;
};

// Executes the teleportation of the camper - NOT CALLED ANYMORE
void () TeleportCamper = 
{
	local entity spawn_point;

	// get a spawn point to teleport to
	spawn_point = SelectSpawnPoint ();

	// set the new spawn_point as the player's origin
	self.origin = spawn_point.origin + '0 0 1';
	self.angles = spawn_point.angles;
	self.fixangle = TRUE;		// turn this way immediately

	// decrement the players health to teach them a lesson
	self.health = ( self.health * CAMPER_HEALTH_PERCENT ) + 0.5;

	ResetCamperFields();

	// make it look like the player was teleported
	self.teleport_time = time + 5;
	spawn_tfog ( self.origin );

};

void () scream_like_a_pig =
{
	local float rs;		//random-sound

	rs = rint((random() * 5) + 1);		// If he's ill scream!
	self.noise = "";
	if (rs == 1) self.noise = "player/pain1.wav";
	else if (rs == 2) self.noise = "player/pain2.wav";
	else if (rs == 3) self.noise = "player/pain3.wav";
	else if (rs == 4) self.noise = "player/pain4.wav";
	else if (rs == 5) self.noise = "player/pain5.wav";
	else self.noise = "player/pain6.wav";
	sound (self, CHAN_VOICE, self.noise, 1, ATTN_NORM);
	stuffcmd(self, "bf");
};

// get current location of player and compare to the location of the last check
void() CheckForCamper =
{
	// this code will only executes in multiplayer modes
	if( deathmatch || coop )
	{
		if( ( vlen( self.camp_origin - self.origin ) >= CAMPER_DISTANCE ) ||
			( self.health <= 0 ) || !self.camp_time )
		{
			ResetCamperFields();
		}
		// see if the player has exceeded their camping permit
		else if( time >= self.camp_time )
		{
			// increase the camping count
			self.camp_count = self.camp_count + 1;
			self.camp_time = time + CAMPER_CHECK;

			// first warning
			if( self.camp_count == 7 )
			{
				// warn the player
				centerprint ( self, "You're not camping, are you?\n" );
				scream_like_a_pig();
				bprint(self.netname);        
				bprint(" is camping! \n");
			}
			// second warning
			else if( self.camp_count == 10 )	//Was=11
			{
				// warn the player
				centerprint ( self, "Still camping, eh?\n" );
				scream_like_a_pig();
				bprint(self.netname);        
				bprint(" is STILL camping! \n");
//				TeleportCamper();	//inclusion of this resets all?
				// decrement the players health to teach them a lesson
				self.health = ( self.health * CAMPER_HEALTH_PERCENT ) + 0.5;
			}
			// exceeded camping time for the last time
			else if( self.camp_count > 15 )
			{
				centerprint ( self, "I bet that hurt!  :-) \n" );
				// tell the other players
				bprint(self.netname);
				bprint(" was Gibbed for being a WussBoy Camper!\n"); 
				DeathSound();
				self.health = 0;	//KILL
	        		GibPlayer();
                                self.frags = self.frags - 5;    // extra penalty on frags though!
			}
		}
	}
};
