
ENT.Base = "lvs_tank_wheeldrive"

ENT.PrintName = "Cromwell V"
ENT.Author = "Digger"
ENT.Information = "Luna's Vehicle Script"
ENT.Category = "[LVS] - Tanks"

ENT.VehicleCategory = "Tanks"
ENT.VehicleSubCategory = "Medium"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/diggercars/cromwell/cromwell.mdl"
ENT.MDL_DESTROYED = "models/diggercars/cromwell/dead.mdl"

ENT.GibModels = {
	"models/diggercars/cromwell/turret.mdl",
}

ENT.AITEAM = 2

ENT.MaxHealth = 1200

--damage system
ENT.DSArmorIgnoreForce = 1300
ENT.CannonArmorPenetration = 9100
ENT.CannonArmorPenetration1km = 4800
ENT.FrontArmor = 4400
ENT.SideArmor = 3100
ENT.FrontArmorPlate = 5500
ENT.TurretArmor = 6300
ENT.RearArmor = 1900
ENT.RoofArmor = 700

-- ballistics
ENT.ProjectileVelocityCoaxial = 15000
ENT.ProjectileVelocityHighExplosive = 13000
ENT.ProjectileVelocityArmorPiercing = 16000

ENT.SteerSpeed = 1
ENT.SteerReturnSpeed = 2

ENT.PhysicsWeightScale = 2
ENT.PhysicsDampingSpeed = 1000
ENT.PhysicsInertia = Vector(6000,6000,1500)

ENT.MaxVelocity = 600
ENT.MaxVelocityReverse = 150

ENT.EngineCurve = 0.1
ENT.EngineTorque = 250

ENT.TransMinGearHoldTime = 0.1
ENT.TransShiftSpeed = 0

ENT.TransGears = 3
ENT.TransGearsReverse = 1

ENT.MouseSteerAngle = 45

ENT.lvsShowInSpawner = true

ENT.EngineSounds = {
	{
		sound = "lvs/vehicles/sherman/eng_idle_loop.wav",
		Volume = 1,
		Pitch = 70,
		PitchMul = 30,
		SoundLevel = 75,
		SoundType = LVS.SOUNDTYPE_IDLE_ONLY,
	},
	{
		sound = "lvs/vehicles/cromwell/eng_loop.wav",
		Volume = 1,
		Pitch = 20,
		PitchMul = 90,
		SoundLevel = 85,
		SoundType = LVS.SOUNDTYPE_NONE,
		UseDoppler = true,
	},
}

ENT.ExhaustPositions = {
	{
		pos = Vector(-119.27,-10,60.41),
		ang = Angle(-120,0,0)
	},
	{
		pos = Vector(-119.27,10,60.41),
		ang = Angle(-120,0,0)
	},
	{
		pos = Vector(-119.27,0,60.41),
		ang = Angle(-120,0,0)
	},
	{
		pos = Vector(-119.27,-30,60.41),
		ang = Angle(-120,0,0)
	},
	{
		pos = Vector(-119.27,20,60.41),
		ang = Angle(-120,0,0)
	},
	{
		pos = Vector(-119.27,-20,60.41),
		ang = Angle(-120,0,0)
	},
	{
		pos = Vector(-119.27,30,60.41),
		ang = Angle(-120,0,0)
	},
}

function ENT:OnSetupDataTables()
	self:AddDT( "Entity", "GunnerSeat" )
	self:AddDT( "Bool", "UseHighExplosive" )
end

function ENT:InitWeapons()
	local COLOR_WHITE = Color(255,255,255,255)

	-- coaxial machinegun
	local weapon = {}
	weapon.Icon = Material("lvs/weapons/mg.png")
	weapon.Ammo = 2000
	weapon.Delay = 0.1
	weapon.HeatRateUp = 0.2
	weapon.HeatRateDown = 0.25
	weapon.Attack = function( ent )
		local ID = ent:LookupAttachment( "muzzle_coax" )

		local Muzzle = ent:GetAttachment( ID )

		if not Muzzle then return end

		local bullet = {}
		bullet.Src 	= Muzzle.Pos
		bullet.Dir 	= Muzzle.Ang:Forward()
		bullet.Spread = Vector(0.01,0.01,0.01)
		bullet.TracerName = "lvs_tracer_yellow_small"
		bullet.Force	= 10
		bullet.EnableBallistics = true
		bullet.HullSize 	= 0
		bullet.Damage	= 25
		bullet.Velocity = ent.ProjectileVelocityCoaxial
		bullet.Attacker 	= ent:GetDriver()
		ent:LVSFireBullet( bullet )

		local effectdata = EffectData()
		effectdata:SetOrigin( bullet.Src )
		effectdata:SetNormal( bullet.Dir )
		effectdata:SetEntity( ent )
		util.Effect( "lvs_muzzle", effectdata )

		ent:TakeAmmo( 1 )
	end
	weapon.StartAttack = function( ent )
		if not IsValid( ent.SNDTurretMG ) then return end
		ent.SNDTurretMG:Play()
	end
	weapon.FinishAttack = function( ent )
		if not IsValid( ent.SNDTurretMG ) then return end
		ent.SNDTurretMG:Stop()
	end
	weapon.OnOverheat = function( ent ) ent:EmitSound("lvs/overheat.wav") end
	weapon.HudPaint = function( ent, X, Y, ply )
		local ID = ent:LookupAttachment(  "muzzle_coax" )

		local Muzzle = ent:GetAttachment( ID )

		if Muzzle then
			local traceTurret = util.TraceLine( {
				start = Muzzle.Pos,
				endpos = Muzzle.Pos + Muzzle.Ang:Forward() * 50000,
				filter = ent:GetCrosshairFilterEnts()
			} )

			local MuzzlePos2D = traceTurret.HitPos:ToScreen() 

			ent:PaintCrosshairCenter( MuzzlePos2D, COLOR_WHITE )
			ent:LVSPaintHitMarker( MuzzlePos2D )
		end
	end
	weapon.OnSelect = function( ent )
		ent:TurretUpdateBallistics( ent.ProjectileVelocityCoaxial, "muzzle_coax" )
	end
	self:AddWeapon( weapon )



	local weapon = {}
	weapon.Icon = true
	weapon.Ammo = 64
	weapon.Delay = 2.5
	weapon.HeatRateUp = 1
	weapon.HeatRateDown = 0.4
	weapon.OnThink = function( ent )
		if ent:GetSelectedWeapon() ~= 2 then return end

		local ply = ent:GetDriver()

		if not IsValid( ply ) then return end

		local SwitchType = ply:lvsKeyDown( "CAR_SWAP_AMMO" )

		if ent._oldSwitchType ~= SwitchType then
			ent._oldSwitchType = SwitchType

			if SwitchType then
				ent:SetUseHighExplosive( not ent:GetUseHighExplosive() )
				ent:EmitSound("lvs/vehicles/sherman/cannon_unload.wav", 75, 100, 1, CHAN_WEAPON )
				ent:SetHeat( 1 )
				ent:SetOverheated( true )

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

		ent.SNDTurret:PlayOnce( math.random(98,102), 1 )

		ent:EmitSound("lvs/vehicles/sherman/cannon_reload.wav", 75, 100, 1, CHAN_WEAPON )
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
	weapon.OnSelect = function( ent )
		if ent:GetUseHighExplosive() then
			ent:TurretUpdateBallistics( ent.ProjectileVelocityHighExplosive, "muzzle" )
		else
			ent:TurretUpdateBallistics( ent.ProjectileVelocityArmorPiercing, "muzzle" )
		end
	end
	self:AddWeapon( weapon )




	-- turret rotation disabler
	local weapon = {}
	weapon.Icon = Material("lvs/weapons/tank_noturret.png")
	weapon.Ammo = -1
	weapon.Delay = 0
	weapon.HeatRateUp = 0
	weapon.HeatRateDown = 0
	weapon.OnSelect = function( ent, old, new  )
		if ent.SetTurretEnabled then
			ent:SetTurretEnabled( false )
		end
	end
	weapon.OnDeselect = function( ent, old, new  )
		if ent.SetTurretEnabled then
			ent:SetTurretEnabled( true )
		end
	end
	self:AddWeapon( weapon )

	self:AddGunnerWeapons()
end

function ENT:GunnerInRange( Dir )
	return self:AngleBetweenNormal( self:GetForward(), Dir ) < 40
end

function ENT:AddGunnerWeapons()
	local COLOR_RED = Color(255,0,0,255)
	local COLOR_WHITE = Color(255,255,255,255)

	local weapon = {}
	weapon.Icon = Material("lvs/weapons/mg.png")
	weapon.Ammo = 2000
	weapon.Delay = 0.1
	weapon.HeatRateUp = 0.2
	weapon.HeatRateDown = 0.25
	weapon.Attack = function( ent )
		local base = ent:GetVehicle()

		if not IsValid( base ) then return end

		if not base:GunnerInRange( ent:GetAimVector() ) then

			if not IsValid( base.SNDTurretMGf ) then return true end

			base.SNDTurretMGf:Stop()
	
			return true
		end

		local ID = base:LookupAttachment( "muzzle_mg" )

		local Muzzle = base:GetAttachment( ID )

		if not Muzzle then return end

		local bullet = {}
		bullet.Src 	= Muzzle.Pos
		bullet.Dir 	= (ent:GetEyeTrace().HitPos - bullet.Src):GetNormalized()
		bullet.Spread = Vector(0.01,0.01,0.01)
		bullet.TracerName = "lvs_tracer_yellow_small"
		bullet.Force	= 10
		bullet.EnableBallistics = true
		bullet.HullSize 	= 0
		bullet.Damage	= 25
		bullet.Velocity = 15000
		bullet.Attacker 	= ent:GetDriver()
		ent:LVSFireBullet( bullet )

		local effectdata = EffectData()
		effectdata:SetOrigin( bullet.Src )
		effectdata:SetNormal( Muzzle.Ang:Forward() )
		effectdata:SetEntity( ent )
		util.Effect( "lvs_muzzle", effectdata )

		ent:TakeAmmo( 1 )

		if not IsValid( base.SNDTurretMGf ) then return end

		base.SNDTurretMGf:Play()
	end
	weapon.StartAttack = function( ent )
		local base = ent:GetVehicle()

		if not IsValid( base ) or not IsValid( base.SNDTurretMGf ) then return end

		base.SNDTurretMGf:Play()
	end
	weapon.FinishAttack = function( ent )
		local base = ent:GetVehicle()

		if not IsValid( base ) or not IsValid( base.SNDTurretMGf ) then return end

		base.SNDTurretMGf:Stop()
	end
	weapon.OnThink = function( ent, active )
		local base = ent:GetVehicle()

		if not IsValid( base ) then return end

		local Angles = base:WorldToLocalAngles( ent:GetAimVector():Angle() )
		Angles:Normalize()

		base:SetPoseParameter("mg_yaw", -Angles.y )
		base:SetPoseParameter("mg_pitch",  -Angles.p )
	end
	weapon.HudPaint = function( ent, X, Y, ply )
		local base = ent:GetVehicle()

		if not IsValid( base ) then return end

		local Pos2D = ent:GetEyeTrace().HitPos:ToScreen()

		local Col =  base:GunnerInRange( ent:GetAimVector() ) and COLOR_WHITE or COLOR_RED

		base:PaintCrosshairCenter( Pos2D, Col )
		base:LVSPaintHitMarker( Pos2D )
	end
	self:AddWeapon( weapon, 2 )
end

ENT.Lights = {
	{
		Trigger = "main",
		Sprites = {
			{ pos = "m", colorB = 200, colorA = 150, },
		},
		ProjectedTextures = {
			{ pos = "m", ang = Angle(0,0,0), colorB = 200, colorA = 150, shadows = true },
		},
	},
	{
		Trigger = "high",
		SubMaterialID = 2,
		SubMaterialBrightness = 20,
		Sprites = {
			{ pos = "h", colorB = 200, colorA = 150 },
		},
		ProjectedTextures = {
			{ pos = "h", ang = Angle(0,0,0), colorB = 200, colorA = 150, shadows = true },
		},
	},
}
