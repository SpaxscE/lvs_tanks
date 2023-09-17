
ENT.Base = "lvs_tank_wheeldrive"

ENT.PrintName = "Pz.Kpfw. II Ausf. C"
ENT.Author = "Luna"
ENT.Information = "Luna's Vehicle Script"
ENT.Category = "[LVS] - Cars"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/diggercars/pz2/pz2_ausf_c.mdl"

ENT.AITEAM = 1

ENT.MaxHealth = 1000

--damage system
ENT.DSArmorIgnoreForce = 1000
ENT.CannonArmorPenetration = 3900
ENT.FrontArmor = 2500
ENT.SideArmor = 1000
ENT.TurretArmor = 2000
ENT.RearArmor = 500

ENT.SteerSpeed = 1
ENT.SteerReturnSpeed = 2

ENT.PhysicsWeightScale = 2
ENT.PhysicsDampingSpeed = 1000
ENT.PhysicsInertia = Vector(6000,6000,1500)

ENT.MaxVelocity = 450
ENT.MaxVelocityReverse = 150

ENT.EngineCurve = 0.1
ENT.EngineTorque = 200

ENT.TransMinGearHoldTime = 0.1
ENT.TransShiftSpeed = 0

ENT.TransGears = 3
ENT.TransGearsReverse = 1

ENT.MouseSteerAngle = 45

ENT.WheelBrakeAutoLockup = true
ENT.WheelBrakeLockupRPM = 15

ENT.lvsShowInSpawner = true