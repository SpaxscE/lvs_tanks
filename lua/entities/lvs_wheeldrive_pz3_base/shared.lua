
ENT.Base = "lvs_tank_wheeldrive"

ENT.Spawnable			= false
ENT.AdminSpawnable		= false

ENT.AITEAM = 1

ENT.MaxHealth = 1100

ENT.EngineCurveBoostLow = 2

--damage system
ENT.DSArmorIgnoreForce = 1000
ENT.FrontArmor = 2000
ENT.SideArmor = 1000
ENT.TurretArmor = 2000
ENT.RearArmor = 500

ENT.SteerSpeed = 1
ENT.SteerReturnSpeed = 2

ENT.PhysicsWeightScale = 2
ENT.PhysicsDampingSpeed = 1000
ENT.PhysicsInertia = Vector(6000,6000,1500)

ENT.MaxVelocity = 700
ENT.MaxVelocityReverse = 200

ENT.EngineCurve = 0.1
ENT.EngineTorque = 210

ENT.TransMinGearHoldTime = 0.1
ENT.TransShiftSpeed = 0

ENT.TransGears = 4
ENT.TransGearsReverse = 1

ENT.MouseSteerAngle = 45

ENT.lvsShowInSpawner = true

ENT.EngineSounds = {
	{
		sound = "lvs/vehicles/pz2/eng_idle_loop.wav",
		Volume = 1,
		Pitch = 70,
		PitchMul = 30,
		SoundLevel = 75,
		SoundType = LVS.SOUNDTYPE_IDLE_ONLY,
	},
	{
		sound = "lvs/vehicles/pz2/eng_loop.wav",
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
		pos = Vector(-95.06,-27.42,26.92),
		ang = Angle(170,0,0)
	},
	{
		pos = Vector(-95.06,27.42,26.92),
		ang = Angle(170,0,0)
	},
}

function ENT:OnSetupDataTables()
	self:AddDT( "Entity", "GunnerSeat" )
	self:AddDT( "Entity", "TopGunnerSeat" )
	self:AddDT( "Bool", "UseHighExplosive" )
end
