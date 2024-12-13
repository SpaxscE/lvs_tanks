AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "sh_turret.lua" )
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "cl_optics.lua" )
include("shared.lua")
include("sh_turret.lua")

function ENT:MakeSoundEmitters()
	self.SNDTurret = self:AddSoundEmitter( Vector(-63,0,85), "lvs/vehicles/halftrack/mc_loop.wav" )
	self.SNDTurret:SetSoundLevel( 95 )
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