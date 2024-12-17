AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "cl_attached_playermodels.lua" )
include("shared.lua")

function ENT:MakeSoundEmitters()
	local ID = self:LookupAttachment( "muzzle_mg3" )
	local Muzzle = self:GetAttachment( ID )
	self.SNDTurretMGf = self:AddSoundEmitter( self:WorldToLocal( Muzzle.Pos ), "lvs/vehicles/sherman/mg_loop.wav", "lvs/vehicles/sherman/mg_loop_interior.wav" )
	self.SNDTurretMGf:SetSoundLevel( 95 )
	self.SNDTurretMGf:SetParent( self, ID )

	local ID = self:LookupAttachment( "topmg_muzzle" )
	local Muzzle = self:GetAttachment( ID )
	self.SNDTurretMGt = self:AddSoundEmitter( self:WorldToLocal( Muzzle.Pos ), "lvs/vehicles/pz3/mg_loop.wav" )
	self.SNDTurretMGt:SetSoundLevel( 95 )
	self.SNDTurretMGt:SetParent( self, ID )

	local ID = self:LookupAttachment( "muzzle_mg1" )
	local Muzzle = self:GetAttachment( ID )
	self.SNDTurretMG = self:AddSoundEmitter( self:WorldToLocal( Muzzle.Pos ), "lvs/vehicles/sherman/mg_loop.wav", "lvs/vehicles/sherman/mg_loop_interior.wav" )
	self.SNDTurretMG:SetSoundLevel( 95 )
	self.SNDTurretMG:SetParent( self, ID )

	local ID = self:LookupAttachment( "muzzle_cannon" )
	local Muzzle = self:GetAttachment( ID )
	self.SNDTurret = self:AddSoundEmitter( self:WorldToLocal( Muzzle.Pos ), "lvs/vehicles/pz3/cannon_fire2.wav", "lvs/vehicles/pz3/cannon_fire2.wav" )
	self.SNDTurret:SetSoundLevel( 95 )
	self.SNDTurret:SetParent( self, ID )
end

function ENT:OnTick()
	self:AimTurret()

	local TopGunnerSeat = self:GetTopGunnerSeat()
	local DoorHandler = self.TopGunnerDoorHandler

	if not IsValid( DoorHandler ) or not IsValid( TopGunnerSeat ) then return end

	local PoseValue = IsValid( TopGunnerSeat:GetDriver() ) and 1 or 0

	if PoseValue ~= DoorHandler:GetPoseMin() then
		DoorHandler:SetPoseMin( PoseValue )
	end
end

function ENT:OnLeftTrackRepaired()
	self:SetBodygroup(4,0)
end

function ENT:OnLeftTrackDestroyed()
	self:SetBodygroup(4,1)
end

function ENT:OnRightTrackRepaired()
	self:SetBodygroup(5,0)
end

function ENT:OnRightTrackDestroyed()
	self:SetBodygroup(5,1)
end