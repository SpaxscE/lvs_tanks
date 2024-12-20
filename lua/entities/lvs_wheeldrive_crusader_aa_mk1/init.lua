AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "sh_turret.lua" )
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "cl_optics.lua" )
include("shared.lua")
include("sh_turret.lua")

function ENT:MakeSoundEmitters()
	local ID = self:LookupAttachment( "muzzle" )
	local Muzzle = self:GetAttachment( ID )
	self.SNDTurret = self:AddSoundEmitter( self:WorldToLocal( Muzzle.Pos ), "^lvs/vehicles/crusader/mk1/cannon_fire_ext.wav", "lvs/vehicles/crusader/mk1/cannon_fire_int.wav" )
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

end

function ENT:MakeTurretPhysics()
	self:SetPoseParameter("clip", 6 )

	local Turret = self:CreateTurretPhysics( {
		follow = "turret_att",
		mdl = "models/diggercars/crusader/turret_mk1_col.mdl",
	} )

	-- turret
	local TurretArmor = self:AddArmor( Vector(0,0,25), Angle(0,0,0), Vector(-45,-45,-25), Vector(45,45,25), 1000, self.TurretArmor, Turret )
	TurretArmor:SetLabel( "Turret" )
	self:SetTurretArmor( TurretArmor )
end