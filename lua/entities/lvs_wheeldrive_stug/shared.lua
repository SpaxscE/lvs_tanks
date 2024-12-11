
ENT.Base = "lvs_tank_wheeldrive"

ENT.PrintName = "Sturmgeschütz III"
ENT.Author = "Diger"
ENT.Information = "Luna's Vehicle Script"
ENT.Category = "[LVS] - Tanks"

ENT.VehicleCategory = "Tanks"
ENT.VehicleSubCategory = "Medium"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/diggercars/stug_f/stug.mdl"
ENT.MDL_DESTROYED = "models/diggercars/pz2/pz2cdead.mdl"

ENT.AITEAM = 1

ENT.MaxHealth = 1200

ENT.CannonArmorPenetration = 13700
ENT.CannonArmorPenetration1km = 8000

--damage system
ENT.DSArmorIgnoreForce = 1000
ENT.FrontArmor = 4000
ENT.SideArmor = 2000
ENT.TurretArmor = 9000
ENT.RoofArmor = 500

-- ballistics
ENT.ProjectileVelocityCoaxial = 15000
ENT.ProjectileVelocityHighExplosive = 16000
ENT.ProjectileVelocityArmorPiercing = 20000

ENT.SteerSpeed = 1
ENT.SteerReturnSpeed = 2

ENT.PhysicsWeightScale = 2
ENT.PhysicsDampingSpeed = 1000
ENT.PhysicsInertia = Vector(6000,6000,1500)

ENT.MaxVelocity = 700
ENT.MaxVelocityReverse = 200

ENT.EngineCurve = 0.1
ENT.EngineCurveBoostLow = 1.5

ENT.EngineTorque = 210

ENT.TransMinGearHoldTime = 0.1
ENT.TransShiftSpeed = 0

ENT.TransGears = 4
ENT.TransGearsReverse = 1

ENT.MouseSteerAngle = 45

ENT.lvsShowInSpawner = true

ENT.RandomColor = {
	{
		BodyGroups = {
			[1] = 0,
		},
	},
	{
		BodyGroups = {
			[1] = 1,
		},
	},
	{
		BodyGroups = {
			[1] = 2,
		},
	},
}

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
	self:AddDT( "Bool", "UseHighExplosive" )
end

function ENT:InitWeapons()
	local COLOR_WHITE = Color(255,255,255,255)

	local weapon = {}
	weapon.Icon = true
	weapon.Ammo = 44
	weapon.Delay = 3.3
	weapon.HeatRateUp = 1
	weapon.HeatRateDown = 0.22
	weapon.OnThink = function( ent )
		local ply = ent:GetDriver()

		if not IsValid( ply ) then return end

		local SwitchType = ply:lvsKeyDown( "CAR_SWAP_AMMO" )

		if ent._oldSwitchType ~= SwitchType then
			ent._oldSwitchType = SwitchType

			if SwitchType then
				ent:SetUseHighExplosive( not ent:GetUseHighExplosive() )
				ent:SetHeat( 1 )
				ent:SetOverheated( true )
				ent:EmitSound("lvs/vehicles/tiger/cannon_unload.wav", 75, 100, 1, CHAN_WEAPON )

				if ent:GetUseHighExplosive() then
					ent:TurretUpdateBallistics( ent.ProjectileVelocityHighExplosive )
				else
					ent:TurretUpdateBallistics( ent.ProjectileVelocityArmorPiercing )
				end
			end
		end
	end
	weapon.Attack = function( ent )
		local ID = ent:LookupAttachment( "muzzle" )

		local Muzzle = ent:GetAttachment( ID )

		if not Muzzle then return end

		local bullet = {}
		bullet.Src 	= Muzzle.Pos
		bullet.Dir 	= Muzzle.Ang:Forward()
		bullet.Spread = Vector(0,0,0)
		bullet.EnableBallistics = true

		if ent:GetUseHighExplosive() then
			bullet.Force	= 500
			bullet.HullSize 	= 15
			bullet.Damage	= 250
			bullet.SplashDamage = 750
			bullet.SplashDamageRadius = 200
			bullet.SplashDamageEffect = "lvs_bullet_impact_explosive"
			bullet.SplashDamageType = DMG_BLAST
			bullet.Velocity = ent.ProjectileVelocityHighExplosive
		else
			bullet.Force	= ent.CannonArmorPenetration
			bullet.HullSize 	= 0
			bullet.Damage	= 1000
			bullet.Velocity = ent.ProjectileVelocityArmorPiercing
		end

		bullet.TracerName = "lvs_tracer_cannon"
		bullet.Attacker 	= ent:GetDriver()
		ent:LVSFireBullet( bullet )

		local effectdata = EffectData()
		effectdata:SetOrigin( bullet.Src )
		effectdata:SetNormal( bullet.Dir )
		effectdata:SetEntity( ent )
		util.Effect( "lvs_muzzle", effectdata )

		local PhysObj = ent:GetPhysicsObject()
		if IsValid( PhysObj ) then
			PhysObj:ApplyForceOffset( -bullet.Dir * 150000, bullet.Src )
		end

		ent:TakeAmmo( 1 )

		ent:PlayAnimation( "turret_fire" )

		if not IsValid( ent.SNDTurret ) then return end

		ent.SNDTurret:PlayOnce( 100 + math.cos( CurTime() + ent:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )
		ent:EmitSound("lvs/vehicles/tiger/cannon_reload.wav", 75, 100, 1, CHAN_WEAPON )
	end
	weapon.HudPaint = function( ent, X, Y, ply )
		local ID = ent:LookupAttachment(  "muzzle" )

		local Muzzle = ent:GetAttachment( ID )

		if Muzzle then
			local traceTurret = util.TraceLine( {
				start = Muzzle.Pos,
				endpos = Muzzle.Pos + Muzzle.Ang:Forward() * 50000,
				filter = ent:GetCrosshairFilterEnts()
			} )

			local MuzzlePos2D = traceTurret.HitPos:ToScreen() 

			if ent:GetUseHighExplosive() then
				ent:PaintCrosshairSquare( MuzzlePos2D, COLOR_WHITE )
			else
				ent:PaintCrosshairOuter( MuzzlePos2D, COLOR_WHITE )
			end

			ent:LVSPaintHitMarker( MuzzlePos2D )
		end
	end
	self:AddWeapon( weapon )
end