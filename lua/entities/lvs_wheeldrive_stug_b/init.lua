AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

function ENT:OnSpawn( PObj )
	self:MakeDriverSeat()
	self:MakeArmor()
	self:MakeWeakSpots()

	local ID = self:LookupAttachment( "muzzle" )
	local Muzzle = self:GetAttachment( ID )
	self.SNDTurret = self:AddSoundEmitter( self:WorldToLocal( Muzzle.Pos ), "lvs/vehicles/pak40/cannon_fire.wav", "lvs/vehicles/pak40/cannon_fire.wav" )
	self.SNDTurret:SetSoundLevel( 95 )
	self.SNDTurret:SetParent( self, ID )

	local DoorHandler = self:AddDoorHandler( "hatch7", Vector(-58,0,53), Angle(0,0,0), Vector(-29,-33,-15), Vector(29,33,15), Vector(-29,-33,-15), Vector(29,33,15) )
	DoorHandler:SetSoundOpen( "lvs/vehicles/generic/car_hood_open.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/generic/car_hood_close.wav" )
	local Engine = self:AddEngine( Vector(-40,0,53), Angle(0,180,0) )
	Engine:SetDoorHandler( DoorHandler )

	self:AddTrailerHitch( Vector(-101,0,30), LVS.HITCHTYPE_MALE )
end
