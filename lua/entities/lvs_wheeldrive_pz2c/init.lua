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
	local ID = self:LookupAttachment( "muzzle_3" )
	local Muzzle = self:GetAttachment( ID )
	self.SNDTurretMG = self:AddSoundEmitter( self:WorldToLocal( Muzzle.Pos ), "lvs/vehicles/sherman/mg_loop.wav", "lvs/vehicles/sherman/mg_loop_interior.wav" )
	self.SNDTurretMG:SetSoundLevel( 95 )
	self.SNDTurretMG:SetParent( self, ID )

	local ID = self:LookupAttachment( "muzzle_4" )
	local Muzzle = self:GetAttachment( ID )
	self.SNDTurret = self:AddSoundEmitter( self:WorldToLocal( Muzzle.Pos ), "lvs/vehicles/222/cannon_fire.wav", "lvs/vehicles/222/cannon_fire_interior.wav" )
	self.SNDTurret:SetSoundLevel( 95 )
	self.SNDTurret:SetParent( self, ID )

	local DriverSeat = self:AddDriverSeat( Vector(33,10,13), Angle(0,-90,0) )
	DriverSeat.HidePlayer = true

	local DoorHandler = self:AddDoorHandler( "hatch8", Vector(65,10,35), Angle(15,0,0), Vector(-17,-16,-12), Vector(10,16,12), Vector(-17,-16,-12), Vector(10,16,12) )
	DoorHandler:SetSoundOpen( "lvs/vehicles/generic/car_hood_open.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/generic/car_hood_close.wav" )
	DoorHandler:LinkToSeat( DriverSeat )

	local DoorHandler = self:AddDoorHandler( "hatch7", Vector(8,0,78), Angle(0,0,0), Vector(-10,-10,-10), Vector(10,10,10), Vector(-10,-10,-10), Vector(10,10,10) )
	DoorHandler:SetSoundOpen( "lvs/vehicles/generic/car_hood_open.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/generic/car_hood_close.wav" )
	DoorHandler:LinkToSeat( DriverSeat )

	local DoorHandler = self:AddDoorHandler( "hatch6", Vector(-40,18,41), Angle(0,0,0), Vector(-10,-15,-14), Vector(20,15,10), Vector(-10,-15,-14), Vector(20,15,10) )
	DoorHandler:SetSoundOpen( "lvs/vehicles/generic/car_hood_open.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/generic/car_hood_close.wav" )

	local DoorHandler = self:AddDoorHandler( "hatch1", Vector(-40,-15,48), Angle(-10,0,0), Vector(-30,-12,-14), Vector(20,12,10), Vector(-30,-12,-14), Vector(20,12,10) )
	DoorHandler:SetSoundOpen( "lvs/vehicles/generic/car_hood_open.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/generic/car_hood_close.wav" )

	self:AddEngine( Vector(-55.66,-10,50), Angle(0,180,0) )
	self:AddFuelTank( Vector(8,-14,35), Angle(0,0,0), 600, LVS.FUELTYPE_PETROL, Vector(-21,-6,-12),Vector(21,6,12) )

	-- front upper wedge center
	self:AddArmor( Vector(57,0,50), Angle(80,0,0), Vector(-10,-10,-15), Vector(5,30,5), 600, self.FrontArmor )

	-- front upper wedge right
	self:AddArmor( Vector(45,-20,50), Angle(80,-45,0), Vector(-10,-15,-15), Vector(5,22,5), 600, self.FrontArmor )

	-- front upper wedge left
	self:AddArmor( Vector(35,35,50), Angle(80,80,0), Vector(-10,-25,-15), Vector(5,22,5), 300, self.SideArmor )

	-- front lower wedge
	self:AddArmor( Vector(78,0,33), Angle(17,0,0), Vector(-40,-32,-15), Vector(15,32,10), 600, self.FrontArmor )

	-- side armor left
	self:AddArmor( Vector(20,28,50), Angle(0,0,0), Vector(-50,-30,-14), Vector(0,15,10), 300, self.SideArmor )

	-- side armor right
	self:AddArmor( Vector(20,-16,50), Angle(0,0,0), Vector(-50,-15,-14), Vector(20,15,10), 300, self.SideArmor )

	-- side armor right rear
	self:AddArmor( Vector(-40,-16,47), Angle(-10,0,0), Vector(-50,-15,-14), Vector(20,20,10), 200, self.RearArmor )

	-- side armor left rear
	self:AddArmor( Vector(-40,22,40), Angle(0,0,0), Vector(-50,-19,-14), Vector(20,15,10), 300, self.SideArmor )

	-- turret
	local TurretArmor = self:AddArmor( Vector(15,5,60), Angle(0,0,0), Vector(-40,-30,0), Vector(34,34,24), 500, self.TurretArmor )
	TurretArmor.OnDestroyed = function( ent, dmginfo ) if not IsValid( self ) then return end self:SetTurretDestroyed( true ) end
	TurretArmor.OnRepaired = function( ent ) if not IsValid( self ) then return end self:SetTurretDestroyed( false ) end
	TurretArmor:SetLabel( "Turret" )
	self:SetTurretArmor( TurretArmor )

	-- rear
	self:AddArmor( Vector(-73,0,20), Angle(-15,0,0), Vector(-10,-30,-5),Vector(10,30,30), 200, self.RearArmor )

	-- driver viewport weakstop
	self:AddDriverViewPort( Vector(61.3,9.63,51.14), Angle(0,0,0), Vector(-2,-7,-2), Vector(2,7,2) )

	-- ammo rack weakspot
	self:AddAmmoRack( Vector(8.5,-15,52), Vector(12,0,60), Angle(0,0,0), Vector(-21,-6,-3), Vector(21,6,3) )
	self:AddAmmoRack( Vector(-3,33,52), Vector(12,0,60), Angle(0,0,0), Vector(-21,-6,-3), Vector(21,6,3) )
end
