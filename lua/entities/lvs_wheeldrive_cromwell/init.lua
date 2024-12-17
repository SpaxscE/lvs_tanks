AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "sh_tracks.lua" )
AddCSLuaFile( "sh_turret.lua" )
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "cl_optics.lua" )
AddCSLuaFile( "cl_tankview.lua" )
include("shared.lua")
include("sh_tracks.lua")
include("sh_turret.lua")

function ENT:OnSpawn( PObj )
	local ID = self:LookupAttachment( "muzzle_mg" )
	local Muzzle = self:GetAttachment( ID )
	self.SNDTurretMGf = self:AddSoundEmitter( self:WorldToLocal( Muzzle.Pos ), "lvs/vehicles/sherman/mg_loop.wav", "lvs/vehicles/sherman/mg_loop_interior.wav" )
	self.SNDTurretMGf:SetSoundLevel( 95 )
	self.SNDTurretMGf:SetParent( self, ID )

	local ID = self:LookupAttachment( "muzzle_coax" )
	local Muzzle = self:GetAttachment( ID )
	self.SNDTurretMG = self:AddSoundEmitter( self:WorldToLocal( Muzzle.Pos ), "lvs/vehicles/sherman/mg_loop.wav", "lvs/vehicles/sherman/mg_loop_interior.wav" )
	self.SNDTurretMG:SetSoundLevel( 95 )
	self.SNDTurretMG:SetParent( self, ID )

	local ID = self:LookupAttachment( "muzzle" )
	local Muzzle = self:GetAttachment( ID )
	self.SNDTurret = self:AddSoundEmitter( self:WorldToLocal( Muzzle.Pos ), "lvs/vehicles/cromwell/cannon_fire.wav", "lvs/vehicles/cromwell/cannon_fire_interior.wav" )
	self.SNDTurret:SetSoundLevel( 95 )
	self.SNDTurret:SetParent( self, ID )

	local DriverSeat = self:AddDriverSeat( Vector(0,0,60), Angle(0,-90,0) )
	DriverSeat.HidePlayer = true

	local GunnerSeat = self:AddPassengerSeat( Vector(88,10,32), Angle(0,-90,0) )
	GunnerSeat.HidePlayer = true
	self:SetGunnerSeat( GunnerSeat )

	local DoorHandler = self:AddDoorHandler( "hatch5", Vector(61.56,-16.93,62.52), Angle(15,0,0), Vector(-10,-10,-10), Vector(10,10,10), Vector(-10,-10,-10), Vector(10,10,10) )
	DoorHandler:SetSoundOpen( "lvs/vehicles/generic/car_hood_open.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/generic/car_hood_close.wav" )
	DoorHandler:LinkToSeat( DriverSeat )

	local DoorHandler = self:AddDoorHandler( "hatch1", Vector(62.38,34.46,59.7), Angle(0,0,0), Vector(-10,-10,-10), Vector(10,10,10), Vector(-10,-10,-10), Vector(10,10,10) )
	DoorHandler:SetSoundOpen( "lvs/vehicles/generic/car_hood_open.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/generic/car_hood_close.wav" )
	DoorHandler:LinkToSeat( GunnerSeat )

	local DoorHandler = self:AddDoorHandler( "hatch7", Vector(1.23,19.86,96.9), Angle(0,0,0), Vector(-10,-10,-10), Vector(10,10,10), Vector(-10,-10,-10), Vector(10,10,10) )
	DoorHandler:SetSoundOpen( "lvs/vehicles/generic/car_hood_open.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/generic/car_hood_close.wav" )
	DoorHandler:LinkToSeat( DriverSeat )
	DoorHandler:SetParent( self, self:LookupAttachment( "turret_att" ) )

	local DoorHandler = self:AddDoorHandler( "engine", Vector(-80,0,62), Angle(0,0,0), Vector(-10,-10,-10), Vector(10,10,10), Vector(-10,-10,-10), Vector(10,10,10) )
	DoorHandler:SetSoundOpen( "lvs/vehicles/generic/car_hood_open.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/generic/car_hood_close.wav" )
	local Engine = self:AddEngine( Vector(-90,0,50), Angle(0,180,0) )
	Engine:SetDoorHandler( DoorHandler )

	self:AddFuelTank( Vector(-75,0,40), Angle(0,0,0), 600, LVS.FUELTYPE_PETROL, Vector(-15,-30,-10),Vector(15,30,10) )



	-- turret
	local TurretArmor = self:AddArmor( Vector(15,0,79.5), Angle(0,0,0), Vector(-60,-60,-16), Vector(60,60,16), 1500, self.TurretArmor )
	TurretArmor.OnDestroyed = function( ent, dmginfo ) if not IsValid( self ) then return end self:SetTurretDestroyed( true ) end
	TurretArmor.OnRepaired = function( ent ) if not IsValid( self ) then return end self:SetTurretDestroyed( false ) end
	TurretArmor:SetLabel( "Turret" )
	self:SetTurretArmor( TurretArmor )

	-- neck
	self:AddArmor( Vector(15,0,62.5), Angle(0,0,0), Vector(-32,-32,-1), Vector(32,32,1), 900, self.SideArmor )

	-- front
	self:AddArmor( Vector(81,0,53), Angle(0,0,0), Vector(-4,-45,-9), Vector(4,45,9), 1200, self.TurretArmor )

	-- front up left
	self:AddArmor( Vector(28,40,53), Angle(0,0,0), Vector(-49,-5,-9), Vector(49,5,9), 1000, self.SideArmor )
	-- front up right
	self:AddArmor( Vector(28,-40,53), Angle(0,0,0), Vector(-49,-5,-9), Vector(49,5,9), 1000, self.SideArmor )

	-- front top
	self:AddArmor( Vector(28,0,61), Angle(0,0,0), Vector(-49,-35,-1), Vector(49,35,1), 500, self.RoofArmor )

	-- front mid
	self:AddArmor( Vector(97,0,39), Angle(-70,0,0), Vector(-1,-43,-14), Vector(1,43,14), 800, self.RearArmor )

	-- front down
	self:AddArmor( Vector(109,0,30), Angle(20,0,0), Vector(-2,-43,-6), Vector(2,43,6), 1200, self.FrontArmor )

	-- front bottom
	self:AddArmor( Vector(98,0,20), Angle(65,0,0), Vector(-1,-43,-12), Vector(1,43,12), 800, self.RearArmor )


	-- rear up left
	self:AddArmor( Vector(-74,40,53), Angle(0,0,0), Vector(-53,-5,-9), Vector(53,5,9), 800, self.RearArmor )
	-- rear up right
	self:AddArmor( Vector(-74,-40,53), Angle(0,0,0), Vector(-53,-5,-9), Vector(53,5,9), 800, self.RearArmor )

	-- rear top
	self:AddArmor( Vector(-66,0,61), Angle(0,0,0), Vector(-45,-35,-1), Vector(45,35,1), 500, self.RoofArmor )

	-- rear
	self:AddArmor( Vector(-119,0,38), Angle(0,0,0), Vector(-8,-35,-24), Vector(8,35,24), 900, self.RearArmor )

	-- left
	self:AddArmor( Vector(-8,39,29), Angle(0,0,0), Vector(-119,-6,-15), Vector(119,6,15), 800, self.RearArmor )
	-- right
	self:AddArmor( Vector(-8,-39,29), Angle(0,0,0), Vector(-119,-6,-15), Vector(119,6,15), 800, self.RearArmor )

	-- bottom
	self:AddArmor( Vector(-11,0,17), Angle(0,0,0), Vector(-100,-33,-3), Vector(100,33,3), 600, self.RoofArmor )



	-- ammo rack weakspot
	self:AddAmmoRack( Vector(-10,0,32), Vector(15,0,60), Angle(0,0,0), Vector(-4,-26,-9), Vector(4,26,9) )
	self:AddAmmoRack( Vector(40,0,32), Vector(15,0,60), Angle(0,0,0), Vector(-4,-26,-9), Vector(4,26,9) )

	-- trailer hitch
	self:AddTrailerHitch( Vector(-125,0,24), LVS.HITCHTYPE_MALE )

	self:MakeTurretPhysics()
	self:MakeTrackPhysics()
end

function ENT:MakeTurretPhysics()
	self:CreateTurretPhysics( {
		start = "root_att",
		follow = "turret_att",
		mdl = "models/diggercars/cromwell/turret_col.mdl",
	} )
end

function ENT:MakeTrackPhysics()
	self:CreateTrackPhysics( "models/diggercars/cromwell/tracks_col.mdl" )
end