AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "sh_tracks.lua" )
AddCSLuaFile( "sh_turret.lua" )
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "cl_tankview.lua" )
include("shared.lua")
include("sh_tracks.lua")
include("sh_turret.lua")

function ENT:OnSpawn( PObj )

	local DoorHandler = self:AddDoorHandler( "engine", Vector(-95.21,0.15,53.98), Angle(0,0,0), Vector(-10,-10,-10), Vector(10,10,10), Vector(-10,-10,-10), Vector(10,10,10) )
	DoorHandler:SetSoundOpen( "lvs/vehicles/generic/car_hood_open.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/generic/car_hood_close.wav" )
	local Engine = self:AddEngine( Vector(-60,0,50), Angle(0,180,0) )
	Engine:SetDoorHandler( DoorHandler )

	self:AddFuelTank( Vector(-38,0,31), Angle(0,0,0), 600, LVS.FUELTYPE_PETROL, Vector(-19,-30,-9),Vector(19,30,9) )

	-- turret
	local TurretArmor = self:AddArmor( Vector(20,0,80), Angle(0,0,0), Vector(-65,-65,-25), Vector(65,65,25), 1000, self.TurretArmor )
	TurretArmor.OnDestroyed = function( ent, dmginfo ) if not IsValid( self ) then return end self:SetTurretDestroyed( true ) end
	TurretArmor.OnRepaired = function( ent ) if not IsValid( self ) then return end self:SetTurretDestroyed( false ) end
	TurretArmor:SetLabel( "Turret" )
	self:SetTurretArmor( TurretArmor )


	-- front up
	self:AddArmor( Vector(54,0,51), Angle(60,0,0), Vector(-4,-32,-1), Vector(4,32,1), 800, self.FrontArmor )
	-- front
	self:AddArmor( Vector(102,0,27), Angle(10,0,0), Vector(-14,-38,-16), Vector(14,38,16), 1200, self.FrontArmor )
	-- front top
	self:AddArmor( Vector(73,0,46), Angle(5,0,0), Vector(-18,-38,-1), Vector(18,38,1), 400, self.RearArmor )

	-- screen r1
	local R1 = self:AddArmor( Vector(70,-39,34), Angle(0,0,0), Vector(-41,-1,-21), Vector(41,1,21), 1000, self.FrontArmor )
	R1.OnDestroyed = function( ent, dmginfo ) self:SetBodygroup(3,1) end
	R1.OnRepaired = function( ent ) self:SetBodygroup(3,0) end
	R1:SetLabel( "R1" )

	-- screen r2
	local R2 = self:AddArmor( Vector(-4,-39,34), Angle(0,0,0), Vector(-33,-1,-21), Vector(33,1,21), 1000, self.FrontArmor )
	R2.OnDestroyed = function( ent, dmginfo ) self:SetBodygroup(4,1) end
	R2.OnRepaired = function( ent ) self:SetBodygroup(4,0) end
	R2:SetLabel( "R2" )

	-- screen r3
	local R3 = self:AddArmor( Vector(-76,-39,34), Angle(0,0,0), Vector(-39,-1,-21), Vector(39,1,21), 1000, self.FrontArmor )
	R3.OnDestroyed = function( ent, dmginfo ) self:SetBodygroup(5,1) end
	R3.OnRepaired = function( ent ) self:SetBodygroup(5,0) end
	R3:SetLabel( "R3" )

	-- screen l1
	local L1 = self:AddArmor( Vector(70,39,34), Angle(0,0,0), Vector(-41,-1,-21), Vector(41,1,21), 1000, self.FrontArmor )
	L1.OnDestroyed = function( ent, dmginfo ) self:SetBodygroup(6,1) end
	L1.OnRepaired = function( ent ) self:SetBodygroup(6,0) end
	L1:SetLabel( "L1" )

	-- screen l2
	local L2 = self:AddArmor( Vector(-4,39,34), Angle(0,0,0), Vector(-33,-1,-21), Vector(33,1,21), 1000, self.FrontArmor )
	L2.OnDestroyed = function( ent, dmginfo ) self:SetBodygroup(7,1) end
	L2.OnRepaired = function( ent ) self:SetBodygroup(7,0) end
	L2:SetLabel( "L2" )

	-- screen l3
	local L3 = self:AddArmor( Vector(-76,39,34), Angle(0,0,0), Vector(-39,-1,-21), Vector(39,1,21), 1000, self.FrontArmor )
	L3.OnDestroyed = function( ent, dmginfo ) self:SetBodygroup(8,1) end
	L3.OnRepaired = function( ent ) self:SetBodygroup(8,0) end
	L3:SetLabel( "L3" )

	-- roof rear
	self:AddArmor( Vector(-13,0,52), Angle(0,0,0), Vector(-1,-32,-3), Vector(1,32,3), 800, self.SideArmor )

	-- rear
	self:AddArmor( Vector(-107,0,34), Angle(0,0,0), Vector(-9,-32,-21), Vector(9,32,21), 600, self.SideArmor )

	-- roof front
	self:AddArmor( Vector(19,0,54), Angle(0,0,0), Vector(-33,-32,-1), Vector(33,32,1), 300, self.RearArmor )
	-- roof rear
	self:AddArmor( Vector(-56,0,52), Angle(0,0,0), Vector(-42,-32,-3), Vector(42,32,3), 400, self.RearArmor )

	-- bottom
	self:AddArmor( Vector(-11,0,15), Angle(0,0,0), Vector(-97,-38,-1), Vector(97,38,1), 400, self.RearArmor )

	-- driver box
	self:AddArmor( Vector(63,-18,51), Angle(0,0,0), Vector(-10,-15,-7), Vector(10,15,7), 800, self.FrontArmor )

	-- driver box front
	self:AddArmor( Vector(74,-18,51), Angle(0,0,0), Vector(-1,-15,-7), Vector(1,15,7), 1000, self.TurretArmor )

	-- left
	self:AddArmor( Vector(-20,35,34), Angle(0,0,0), Vector(-95,-3,-21), Vector(95,3,21), 600, self.SideArmor )
	-- right
	self:AddArmor( Vector(-20,-35,34), Angle(0,0,0), Vector(-95,-3,-21), Vector(95,3,21), 600, self.SideArmor )

	-- ammo rack weakspot
	self:AddAmmoRack( Vector(3,0,32), Vector(20,0,56), Angle(0,0,0), Vector(-8,-26,-9), Vector(8,26,9) )

	-- trailer hitch
	self:AddTrailerHitch( Vector(-120,0,26.5), LVS.HITCHTYPE_MALE )

	self:MakeSoundEmitters()
	self:MakeDriverSeat()
	self:MakeTurretPhysics()
end

function ENT:MakeSoundEmitters()
	local ID = self:LookupAttachment( "muzzle_coax" )
	local Muzzle = self:GetAttachment( ID )
	self.SNDTurretMG = self:AddSoundEmitter( self:WorldToLocal( Muzzle.Pos ), "lvs/vehicles/sherman/mg_loop.wav", "lvs/vehicles/sherman/mg_loop_interior.wav" )
	self.SNDTurretMG:SetSoundLevel( 95 )
	self.SNDTurretMG:SetParent( self, ID )

	local ID = self:LookupAttachment( "muzzle" )
	local Muzzle = self:GetAttachment( ID )
	self.SNDTurret = self:AddSoundEmitter( self:WorldToLocal( Muzzle.Pos ), "lvs/vehicles/sherman/cannon_fire.wav", "lvs/vehicles/sherman/cannon_fire.wav" )
	self.SNDTurret:SetSoundLevel( 95 )
	self.SNDTurret:SetParent( self, ID )
end

function ENT:MakeDriverSeat()
	local DriverSeat = self:AddDriverSeat( Vector(0,0,60), Angle(0,-90,0) )
	DriverSeat.HidePlayer = true

	local DoorHandler = self:AddDoorHandler( "hatch5", Vector(63.91,-19.07,56.74), Angle(15,0,0), Vector(-10,-10,-10), Vector(10,10,10), Vector(-10,-10,-10), Vector(10,10,10) )
	DoorHandler:SetSoundOpen( "lvs/vehicles/generic/car_hood_open.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/generic/car_hood_close.wav" )
	DoorHandler:LinkToSeat( DriverSeat )

	local DoorHandler = self:AddDoorHandler( "hatch6", Vector(-6,0,82.56), Angle(0,0,0), Vector(-10,-10,-10), Vector(10,10,10), Vector(-10,-10,-10), Vector(10,10,10) )
	DoorHandler:SetSoundOpen( "lvs/vehicles/generic/car_hood_open.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/generic/car_hood_close.wav" )
	DoorHandler:LinkToSeat( DriverSeat )
	DoorHandler:SetParent( self, self:LookupAttachment( "turret_att" ) )

end

function ENT:MakeTurretPhysics()
	self:CreateTurretPhysics( {
		start = "root_att",
		follow = "turret_att",
		mdl = "models/diggercars/crusader/turret_col.mdl",
	} )

end