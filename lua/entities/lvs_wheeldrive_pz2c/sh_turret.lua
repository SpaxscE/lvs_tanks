
include("entities/lvs_tank_wheeldrive/modules/sh_turret.lua")
include("entities/lvs_tank_wheeldrive/modules/sh_turret_ballistics.lua")

ENT.TurretBallisticsProjectileVelocity = ENT.ProjectileVelocityCoaxial
ENT.TurretBallisticsMuzzleAttachment = "muzzle_3"
ENT.TurretBallisticsViewAttachment = "muzzle_4"

ENT.TurretAimRate = 25

ENT.TurretRotationSound = "vehicles/tank_turret_loop1.wav"

ENT.TurretPitchPoseParameterName = "turret_pitch"
ENT.TurretPitchMin = -15
ENT.TurretPitchMax = 15
ENT.TurretPitchMul = -1
ENT.TurretPitchOffset = 0

ENT.TurretYawPoseParameterName = "turret_yaw"
ENT.TurretYawMul = 1
ENT.TurretYawOffset = 0

function ENT:GetTurretViewOrigin()
	local ID = self:LookupAttachment( self.TurretBallisticsViewAttachment )

	local Att = self:GetAttachment( ID )

	if not Att then return self:GetPos(), false end

	local Pos = Att.Pos + Att.Ang:Up() * 5 - Att.Ang:Forward() * 32 - Att.Ang:Right() * 5

	return Pos, true
end
