AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "sh_turret.lua" )
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "cl_optics.lua" )
include("shared.lua")
include("sh_turret.lua")

function ENT:MakeSoundEmitters()
	local ID1 = self:LookupAttachment( "muzzle_1" )
	local Muzzle1 = self:GetAttachment( ID1 )

	local ID2 = self:LookupAttachment( "muzzle_2" )
	local Muzzle2 = self:GetAttachment( ID2 )

	self.SNDTurret = self:AddSoundEmitter( (self:WorldToLocal( Muzzle1.Pos ) + self:WorldToLocal( Muzzle2.Pos )) * 0.5, "^lvs/vehicles/crusader/mk2/cannon_fire_loop.wav" )
	self.SNDTurret:SetSoundLevel( 95 )
	self.SNDTurret:SetParent( self, ID1 )
end

function ENT:MakeDriverSeat()
	local DriverSeat = self:AddDriverSeat( Vector(0,0,60), Angle(0,-90,0) )
	DriverSeat.HidePlayer = true

	local DoorHandler = self:AddDoorHandler( "hatch5", Vector(63.91,-19.07,56.74), Angle(15,0,0), Vector(-10,-10,-10), Vector(10,10,10), Vector(-10,-10,-10), Vector(10,10,10) )
	DoorHandler:SetSoundOpen( "lvs/vehicles/generic/car_hood_open.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/generic/car_hood_close.wav" )
	DoorHandler:LinkToSeat( DriverSeat )

end

function ENT:MakeTurretPhysics()
	self:CreateTurretPhysics( {
		start = "root_att",
		follow = "turret_att",
		mdl = "models/diggercars/crusader/turret_mk2_col.mdl",
	} )

end