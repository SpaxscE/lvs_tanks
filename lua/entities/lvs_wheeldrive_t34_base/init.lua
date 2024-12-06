AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "cl_tankview.lua" )
AddCSLuaFile( "cl_optics.lua" )
AddCSLuaFile( "sh_turret.lua" )
AddCSLuaFile( "sh_tracks.lua" )
include("shared.lua")
include("sh_turret.lua")
include("sh_tracks.lua")

function ENT:OnSpawn( PObj )
	self:MakeDriverSeat()
	self:MakeGunnerSeat()
	self:MakeArmor()
	self:MakeWeakSpots()
	self:MakeSoundEmitters()
	self:MakeTurretPhysics()

	self:AddEngine( Vector(-55,0,60), Angle(0,180,0) )

	self:AddTrailerHitch( Vector(-112,0,26), LVS.HITCHTYPE_MALE )
end

function ENT:MakeDriverSeat()
	local DriverSeat = self:AddDriverSeat( Vector(0,0,60), Angle(0,-90,0) )
	DriverSeat.HidePlayer = true

	local DoorHandler = self:AddDoorHandler( "hatch1", Vector(75,10,45), Angle(30,0,0), Vector(-10,-10,-10), Vector(10,10,10), Vector(-10,-10,-10), Vector(10,10,10) )
	DoorHandler:SetSoundOpen( "lvs/vehicles/generic/car_hood_open.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/generic/car_hood_close.wav" )
	DoorHandler:LinkToSeat( DriverSeat )
end

function ENT:MakeGunnerSeat()
	local GunnerSeat = self:AddPassengerSeat( Vector(77,-21,28), Angle(0,-90,0) )
	GunnerSeat.HidePlayer = true

	self:SetGunnerSeat( GunnerSeat )

	local DoorHandler = self:AddDoorHandler( "hatch2", Vector(20,0,80), Angle(0,0,0), Vector(-20,-20,-10), Vector(20,20,10), Vector(-20,-20,-10), Vector(20,20,10) )
	DoorHandler:SetSoundOpen( "lvs/vehicles/generic/car_hood_open.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/generic/car_hood_close.wav" )
	DoorHandler:LinkToSeat( GunnerSeat )
end

function ENT:MakeArmor()
	-- front center
	self:AddArmor( Vector(109,0,28), Angle(0,0,0), Vector(-3,-38,-4), Vector(3,38,4), 1500, self.FrontArmorCenter )

	-- front upper
	self:AddArmor( Vector(67,0,46), Angle(30,0,0), Vector(-16,-55,-10), Vector(50,55,10), 1100, self.FrontArmor )

	-- side armor left front
	self:AddArmor( Vector(20,31,50), Angle(0,0,45), Vector(-40,-15,-20), Vector(40,15,13), 600, self.SideArmor )

	-- side armor right front
	self:AddArmor( Vector(20,-31,50), Angle(0,0,-45), Vector(-40,-15,-20), Vector(40,15,13), 600, self.SideArmor )

	-- side armor left rear
	self:AddArmor( Vector(20,31,50), Angle(0,0,45), Vector(-120,-15,-20), Vector(-40,15,13), 600, self.SideArmor )

	-- side armor right rear
	self:AddArmor( Vector(20,-31,50), Angle(0,0,-45), Vector(-120,-15,-20), Vector(-40,15,13), 600, self.SideArmor )

	-- top armor
	self:AddArmor( Vector(-33,0,58), Angle(0,0,0), Vector(-50,-33,-14), Vector(20,33,10), 600, self.RearArmor )

	-- turret
	local TurretArmor = self:AddArmor( Vector(25,0,60), Angle(0,0,0), Vector(-40,-38,0), Vector(34,38,30), 1200, self.TurretArmor )
	TurretArmor.OnDestroyed = function( ent, dmginfo ) if not IsValid( self ) then return end self:SetTurretDestroyed( true ) end
	TurretArmor.OnRepaired = function( ent ) if not IsValid( self ) then return end self:SetTurretDestroyed( false ) end
	TurretArmor:SetLabel( "Turret" )
	self:SetTurretArmor( TurretArmor )

	-- rear up
	self:AddArmor( Vector(-100,0,40), Angle(50,0,0), Vector(-10,-45,7),Vector(20,45,34), 600, self.SideArmor )

	-- rear down
	self:AddArmor( Vector(-100,0,40), Angle(50,0,0), Vector(-10,-50,-17),Vector(20,50,7), 600, self.SideArmor )
end

function ENT:MakeWeakSpots()
	-- fuel tank
	self:AddFuelTank( Vector(-85,0,15), Angle(0,0,0), 600, LVS.FUELTYPE_PETROL, Vector(-10,-30,0),Vector(10,30,35) )

	-- driver viewport weakstop
	self:AddDriverViewPort( Vector(71.52,18.44,54.3), Angle(0,0,0), Vector(-2,-7,-2), Vector(2,7,2) )

	-- ammo rack weakspot
	self:AddAmmoRack( Vector(25,0,30), Vector(21,0,65), Angle(0,0,0), Vector(-24.25,-24.25,-12.25), Vector(24.25,24.25,12.25) )
end

function ENT:MakeTurretPhysics()
end

function ENT:MakeSoundEmitters()
end
