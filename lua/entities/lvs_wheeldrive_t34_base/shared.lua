
ENT.Base = "lvs_tank_wheeldrive"

ENT.PrintName = "T34 (1941)"
ENT.Author = "Digger"
ENT.Information = "Luna's Vehicle Script"
ENT.Category = "[LVS] - Cars"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/diggercars/t34/t34_1941.mdl"
ENT.MDL_DESTROYED = "models/diggercars/t34/t34_dead.mdl"

--ENT.Spawnable			= false
--ENT.AdminSpawnable		= false

ENT.AITEAM = 2

ENT.MaxHealth = 1200

--damage system
ENT.DSArmorIgnoreForce = 2000
ENT.FrontArmor = 2500
ENT.SideArmor = 2000
ENT.TurretArmor = 2500
ENT.RearArmor = 500

ENT.SteerSpeed = 1
ENT.SteerReturnSpeed = 2

ENT.PhysicsWeightScale = 2
ENT.PhysicsDampingSpeed = 1000
ENT.PhysicsInertia = Vector(6000,6000,1500)

ENT.MaxVelocity = 600
ENT.MaxVelocityReverse = 150

ENT.EngineCurve = 0.1
ENT.EngineTorque = 210

ENT.TransMinGearHoldTime = 0.1
ENT.TransShiftSpeed = 0

ENT.TransGears = 4
ENT.TransGearsReverse = 1

ENT.MouseSteerAngle = 45

ENT.WheelBrakeAutoLockup = true
ENT.WheelBrakeLockupRPM = 15

ENT.lvsShowInSpawner = true

ENT.EngineSounds = {
	{
		sound = "lvs/vehicles/t34/eng_idle_loop.wav",
		Volume = 1,
		Pitch = 100,
		PitchMul = 30,
		SoundLevel = 75,
		SoundType = LVS.SOUNDTYPE_IDLE_ONLY,
	},
	{
		sound = "lvs/vehicles/t34/eng_loop.wav",
		Volume = 1,
		Pitch = 20,
		PitchMul = 100,
		SoundLevel = 85,
		SoundType = LVS.SOUNDTYPE_NONE,
		UseDoppler = true,
	}
}

ENT.ExhaustPositions = {
	{
		pos = Vector(-111.82,-19.36,44.17),
		ang = Angle(180,0,0)
	},
	{
		pos = Vector(-111.82,19.36,44.17),
		ang = Angle(180,0,0)
	},
}

function ENT:OnSetupDataTables()
	self:AddDT( "Entity", "GunnerSeat" )
	self:AddDT( "Entity", "TopGunnerSeat" )
	self:AddDT( "Bool", "UseHighExplosive" )
end
