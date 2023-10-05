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
	self:MakeTopGunnerSeat()
	self:MakeDoors()
	self:MakeArmor()
	self:MakeWeakSpots()
	self:MakeSoundEmitters()

	self:AddEngine( Vector(-55.66,-10,50), Angle(0,180,0) )
end

function ENT:MakeDriverSeat()
	local DriverSeat = self:AddDriverSeat( Vector(0,0,60), Angle(0,-90,0) )
	DriverSeat.HidePlayer = true

	local DoorHandler = self:AddDoorHandler( "hatch5", Vector(85,14,40), Angle(5,0,0), Vector(-10,-10,-10), Vector(10,15,10), Vector(-10,-10,-10), Vector(10,15,10) )
	DoorHandler:SetSoundOpen( "lvs/vehicles/generic/car_hood_open.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/generic/car_hood_close.wav" )
	DoorHandler:LinkToSeat( DriverSeat )
end

function ENT:MakeTopGunnerSeat()
	local TopGunnerSeat = self:AddPassengerSeat( Vector(8,0,60), Angle(0,-90,0) )
	TopGunnerSeat.HidePlayer = true

	self:SetTopGunnerSeat( TopGunnerSeat )

	local DoorHandler = self:AddDoorHandler( "hatch7", Vector(20,0,80), Angle(0,0,0), Vector(-50,-40,-10), Vector(40,40,10), Vector(-50,-40,-10), Vector(40,40,10) )
	DoorHandler:SetSoundOpen( "lvs/vehicles/generic/car_hood_open.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/generic/car_hood_close.wav" )
	DoorHandler:LinkToSeat( TopGunnerSeat )

	self.TopGunnerDoorHandler = DoorHandler
end

function ENT:MakeGunnerSeat()
	local GunnerSeat = self:AddPassengerSeat( Vector(77,-23,26), Angle(0,-90,0) )
	GunnerSeat.HidePlayer = true

	self:SetGunnerSeat( GunnerSeat )

	local DoorHandler = self:AddDoorHandler( "hatch6", Vector(85,-14,40), Angle(5,0,0), Vector(-10,-15,-10), Vector(10,10,10), Vector(-10,-15,-10), Vector(10,10,10) )
	DoorHandler:SetSoundOpen( "lvs/vehicles/generic/car_hood_open.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/generic/car_hood_close.wav" )
	DoorHandler:LinkToSeat( GunnerSeat )
end

function ENT:MakeDoors()
	local DoorHandler = self:AddDoorHandler( "hatch2", Vector(-42.12,18.8,63.94), Angle(0,0,0), Vector(-15,-15,-15), Vector(15,15,0), Vector(-15,-15,-15), Vector(15,15,0) )
	DoorHandler:SetSoundOpen( "lvs/vehicles/generic/car_hood_open.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/generic/car_hood_close.wav" )

	local DoorHandler = self:AddDoorHandler( "hatch1", Vector(-42.12,-18.8,63.94), Angle(0,0,0), Vector(-15,-15,-15), Vector(15,15,0), Vector(-15,-15,-15), Vector(15,15,0) )
	DoorHandler:SetSoundOpen( "lvs/vehicles/generic/car_hood_open.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/generic/car_hood_close.wav" )
end

function ENT:MakeArmor()
	-- front upper wedge center
	self:AddArmor( Vector(60,0,79), Angle(80,0,0), Vector(17,-40,-10), Vector(50,40,10), 1300, self.FrontArmor )

	self:AddArmor( Vector(55,0,42), Angle(5,0,0), Vector(0,-39,0), Vector(44,39,10), 800, self.SideArmor )
	self:AddArmor( Vector(93,0,40), Angle(40,0,0), Vector(0,-39,0), Vector(15,39,10), 1300, self.FrontArmor )
	self:AddArmor( Vector(100,0,37), Angle(112,0,0), Vector(-5,-39,0), Vector(22,39,10), 1300, self.FrontArmor )

	-- side armor left
	self:AddArmor( Vector(20,24,51), Angle(0,0,0), Vector(-82,5,-20), Vector(50,15,13), 800, self.SideArmor )

	-- side armor right
	self:AddArmor( Vector(20,-24,51), Angle(0,0,0), Vector(-82,-15,-20), Vector(50,-5,13), 800, self.SideArmor )

	-- top armor
	self:AddArmor( Vector(20,0,51), Angle(0,0,0), Vector(-82,-30,-20), Vector(50,30,13), 600, self.RearArmor )

	-- turret
	local TurretArmor = self:AddArmor( Vector(25,0,60), Angle(0,0,0), Vector(-45,-40,0), Vector(32,40,30), 1200, self.TurretArmor )
	TurretArmor.OnDestroyed = function( ent, dmginfo ) if not IsValid( self ) then return end self:SetTurretDestroyed( true ) end
	TurretArmor.OnRepaired = function( ent ) if not IsValid( self ) then return end self:SetTurretDestroyed( false ) end
	TurretArmor:SetLabel( "Turret" )
	self:SetTurretArmor( TurretArmor )

	-- rear up
	self:AddArmor( Vector(-80,0,44), Angle(-15,0,0), Vector(-8,-40,0), Vector(23,40,15), 300, self.SideArmor )

	-- rear mid
	self:AddArmor( Vector(-90,0,43), Angle(-60,0,0), Vector(-5,-40,-5), Vector(8,40,6), 800, self.SideArmor )

	-- rear down
	self:AddArmor( Vector(-80,0,23), Angle(-10,0,0), Vector(-5,-40,0), Vector(5,40,20), 1200, self.FrontArmor )

	-- rear very down
	self:AddArmor( Vector(-80,0,26), Angle(-66,0,0), Vector(-5,-40,-25), Vector(5,40,3), 1200, self.FrontArmor )
end

function ENT:MakeWeakSpots()
	-- fuel tank
	self:AddFuelTank( Vector(-70,0,20), Angle(0,0,0), 600, LVS.FUELTYPE_PETROL, Vector(-5,-30,0),Vector(5,30,35) )

	-- ammo rack weakspot
	self:AddAmmoRack( Vector(23.38,-29.13,30.32), Vector(10,0,62.5), Angle(90,90,0), Vector(-9.25,-12.25,-6.25), Vector(9.25,12.25,6.25) )
	self:AddAmmoRack( Vector(-3.78,-17.2,30.4), Vector(10,0,62.5), Angle(90,12.5,0), Vector(-9.25,-12.25,-6.25), Vector(9.25,12.25,6.25) )

	self:AddAmmoRack( Vector(23.38,29.13,30.32), Vector(10,0,62.5), Angle(90,90,0), Vector(-9.25,-12.25,-6.25), Vector(9.25,12.25,6.25) )
	self:AddAmmoRack( Vector(-3.78,17.2,30.4), Vector(10,0,62.5), Angle(90,-12.5,0), Vector(-9.25,-12.25,-6.25), Vector(9.25,12.25,6.25) )
end

function ENT:MakeSoundEmitters()
end
