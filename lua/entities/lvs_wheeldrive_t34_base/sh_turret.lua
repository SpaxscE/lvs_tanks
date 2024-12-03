
include("entities/lvs_tank_wheeldrive/modules/sh_turret.lua")
include("entities/lvs_tank_wheeldrive/modules/sh_turret_ballistics.lua")

ENT.TurretBallisticsProjectileVelocity = ENT.ProjectileVelocityCoaxial
ENT.TurretBallisticsMuzzleAttachment = "muzzle_turret"
ENT.TurretBallisticsViewAttachment = "muzzle"

ENT.TurretAimRate = 25

ENT.TurretRotationSound = "vehicles/tank_turret_loop1.wav"

ENT.TurretPitchPoseParameterName = "turret_pitch"
ENT.TurretPitchMin = -10
ENT.TurretPitchMax = 10
ENT.TurretPitchMul = -1
ENT.TurretPitchOffset = 0

ENT.TurretYawPoseParameterName = "turret_yaw"
ENT.TurretYawMul = 1
ENT.TurretYawOffset = 0

ENT.TurretViewOffsetX = 0
ENT.TurretViewOffsetY = 0
ENT.TurretViewOffsetZ = 0

function ENT:GetTurretViewOrigin()
	local ID = self:LookupAttachment( self.TurretBallisticsViewAttachment )

	local Att = self:GetAttachment( ID )

	if not Att then return self:GetPos(), false end

	local Pos = Att.Pos + Att.Ang:Forward() * self.TurretViewOffsetX + Att.Ang:Right() * self.TurretViewOffsetY + Att.Ang:Up() * self.TurretViewOffsetZ

	return Pos, true
end
