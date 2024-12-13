
include("entities/lvs_tank_wheeldrive/modules/sh_turret.lua")
include("entities/lvs_tank_wheeldrive/modules/sh_turret_ballistics.lua")

ENT.TurretBallisticsPredicted = false -- sherman optics are not adjustable

ENT.TurretBallisticsProjectileVelocity = ENT.ProjectileVelocityArmorPiercing
ENT.TurretBallisticsMuzzleAttachment = "muzzle"
ENT.TurretBallisticsViewAttachment = "sight"

ENT.TurretAimRate = 25

ENT.TurretRotationSound = "vehicles/tank_turret_loop1.wav"

ENT.TurretPitchPoseParameterName = "turret_pitch"
ENT.TurretPitchMin = -20
ENT.TurretPitchMax = 10
ENT.TurretPitchMul = -1
ENT.TurretPitchOffset = 0

ENT.TurretYawPoseParameterName = "turret_yaw"
ENT.TurretYawMul = 1
ENT.TurretYawOffset = 0