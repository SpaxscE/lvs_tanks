AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

function ENT:MakeSoundEmitters()
	local ID = self:LookupAttachment( "muzzle_mg3" )
	local Muzzle = self:GetAttachment( ID )
	self.SNDTurretMGf = self:AddSoundEmitter( self:WorldToLocal( Muzzle.Pos ), "lvs/vehicles/sherman/mg_loop.wav", "lvs/vehicles/sherman/mg_loop_interior.wav" )
	self.SNDTurretMGf:SetSoundLevel( 95 )
	self.SNDTurretMGf:SetParent( self, ID )

	local ID = self:LookupAttachment( "muzzle_mg1" )
	local Muzzle = self:GetAttachment( ID )
	self.SNDTurretMG = self:AddSoundEmitter( self:WorldToLocal( Muzzle.Pos ), "lvs/vehicles/sherman/mg_loop.wav", "lvs/vehicles/sherman/mg_loop_interior.wav" )
	self.SNDTurretMG:SetSoundLevel( 95 )
	self.SNDTurretMG:SetParent( self, ID )

	local ID = self:LookupAttachment( "muzzle_cannon" )
	local Muzzle = self:GetAttachment( ID )
	self.SNDTurret = self:AddSoundEmitter( self:WorldToLocal( Muzzle.Pos ), "lvs/vehicles/pz3/cannon_fire1.wav", "lvs/vehicles/pz3/cannon_fire1.wav" )
	self.SNDTurret:SetSoundLevel( 95 )
	self.SNDTurret:SetParent( self, ID )
end

function ENT:OnLeftTrackRepaired()
	self:SetBodygroup(2,0)
end

function ENT:OnLeftTrackDestroyed()
	self:SetBodygroup(2,1)
end

function ENT:OnRightTrackRepaired()
	self:SetBodygroup(3,0)
end

function ENT:OnRightTrackDestroyed()
	self:SetBodygroup(3,1)
end