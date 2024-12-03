
include("entities/lvs_tank_wheeldrive/modules/sh_turret.lua")
include("entities/lvs_tank_wheeldrive/modules/sh_turret_ballistics.lua")

ENT.TurretBallisticsProjectileVelocity = ENT.ProjectileVelocityCoaxial
ENT.TurretBallisticsMuzzleAttachment = "muzzle_mg1"
ENT.TurretBallisticsViewAttachment = "muzzle_cannon"

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

function ENT:GetTurretViewOrigin()
	local ID = self:LookupAttachment( self.TurretBallisticsViewAttachment )

	local Att = self:GetAttachment( ID )

	if not Att then return self:GetPos(), false end

	local Pos = Att.Pos - Att.Ang:Forward() * 30 - Att.Ang:Right() * 3 - Att.Ang:Up() * 10

	return Pos, true
end
