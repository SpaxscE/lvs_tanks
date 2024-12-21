
ENT.Base = "lvs_wheeldrive_crusader_base"

ENT.PrintName = "Crusader AA Mk.II"
ENT.Author = "Digger"
ENT.Information = "Luna's Vehicle Script"
ENT.Category = "[LVS] - Tanks"

ENT.VehicleCategory = "Tanks"
ENT.VehicleSubCategory = "Light"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/diggercars/crusader/crusader_aa_mk2.mdl"

-- ballistics
ENT.ProjectileVelocityArmorPiercing = 40000

ENT.CannonArmorPenetration = 3800
ENT.CannonArmorPenetration1km = 500

function ENT:OnSetupDataTables()
end

function ENT:InitWeapons()
	local COLOR_WHITE = Color(255,255,255,255)

	local weapon = {}
	weapon.Icon = Material("lvs/weapons/flak_ap.png")
	weapon.Ammo = 1200
	weapon.Delay = 0.13
	weapon.HeatRateUp = 0.13
	weapon.HeatRateDown = 0.5
	weapon.Attack = function( ent )
		ent._swapMuzzle = not ent._swapMuzzle

		local MuzzleID = ent._swapMuzzle and 1 or 2

		local ID = ent:LookupAttachment( "muzzle_"..MuzzleID )

		local Muzzle = ent:GetAttachment( ID )

		if not Muzzle then return end

		local bullet = {}
		bullet.Src 	= Muzzle.Pos
		bullet.Dir 	= Muzzle.Ang:Forward()
		bullet.Spread = Vector(0,0,0)
		bullet.Force	= ent.CannonArmorPenetration
		bullet.Force1km = ent.CannonArmorPenetration1km
		bullet.HullSize	= 15 * math.max( bullet.Dir.z, 0 )
		bullet.Damage	= 35
		bullet.EnableBallistics = true
		bullet.SplashDamage = 100
		bullet.SplashDamageRadius = 150
		bullet.SplashDamageEffect = ""
		bullet.SplashDamageType = DMG_SONIC
		bullet.Velocity = ent.ProjectileVelocityArmorPiercing
		bullet.TracerName = "lvs_tracer_autocannon"
		bullet.Attacker 	= ent:GetDriver()
		ent:LVSFireBullet( bullet )

		local effectdata = EffectData()
		effectdata:SetOrigin( bullet.Src )
		effectdata:SetNormal( bullet.Dir )
		effectdata:SetEntity( ent )
		util.Effect( "lvs_muzzle", effectdata )

		ent:TakeAmmo( 1 )

		ent:PlayAnimation( "turret_fire_"..MuzzleID )

		if not IsValid( ent.SNDTurret ) then return end

		ent.SNDTurret:Play()
	end

	weapon.StartAttack = function( ent )
		if not IsValid( ent.SNDTurret ) then return end
		ent.SNDTurret:Play()
	end
	weapon.FinishAttack = function( ent )
		if not IsValid( ent.SNDTurret ) then return end
		if not ent.SNDTurret:GetActive() then return end

		ent.SNDTurret:Stop()
		ent.SNDTurret:EmitSound( "^lvs/vehicles/crusader/mk2/cannon_fire_lastshot.wav" )
	end
	weapon.OnOverheat = function( ent )
		ent:EmitSound("lvs/vehicles/222/cannon_overheat.wav")
	end

	weapon.HudPaint = function( ent, X, Y, ply )
		local ID = ent:LookupAttachment(  "muzzle_1" )

		local Muzzle = ent:GetAttachment( ID )

		if Muzzle then
			local traceTurret = util.TraceLine( {
				start = Muzzle.Pos,
				endpos = Muzzle.Pos + Muzzle.Ang:Forward() * 50000,
				filter = ent:GetCrosshairFilterEnts()
			} )

			local MuzzlePos2D = traceTurret.HitPos:ToScreen() 

			ent:PaintCrosshairCenter( MuzzlePos2D, COLOR_WHITE )
			ent:PaintCrosshairOuter( MuzzlePos2D, COLOR_WHITE )

			ent:LVSPaintHitMarker( MuzzlePos2D )
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
		SubMaterialID = 1,
		SubMaterialBrightness = 20,
		Sprites = {
			{ pos = "h", colorB = 200, colorA = 150 },
		},
		ProjectedTextures = {
			{ pos = "h", ang = Angle(0,0,0), colorB = 200, colorA = 150, shadows = true },
		},
	},
}
