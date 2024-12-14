
ENT.Base = "lvs_wheeldrive_crusader"

ENT.PrintName = "Crusader AA Mk.I"
ENT.Author = "Digger"
ENT.Information = "Luna's Vehicle Script"
ENT.Category = "[LVS] - Tanks"

ENT.VehicleCategory = "Tanks"
ENT.VehicleSubCategory = "Light"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/diggercars/crusader/crusader_aa_mk1.mdl"

-- ballistics
ENT.ProjectileVelocityHighExplosive = 35000
ENT.ProjectileVelocityArmorPiercing = 30000

ENT.CannonArmorPenetration = 7200
ENT.CannonArmorPenetration1km = 2900

function ENT:InitWeapons()
	local COLOR_WHITE = Color(255,255,255,255)



	local weapon = {}
	weapon.Icon = true
	weapon.Ammo = 150
	weapon.Delay = 0.4
	weapon.HeatRateUp = 0.5
	weapon.HeatRateDown = 0.4
	weapon.OnThink = function( ent )
		if ent:GetSelectedWeapon() ~= 1 then return end

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
			bullet.SplashDamage = 400
			bullet.SplashDamageRadius = 120
			bullet.SplashDamageEffect = "lvs_bullet_impact_explosive"
			bullet.SplashDamageType = DMG_BLAST
			bullet.Velocity = ent.ProjectileVelocityHighExplosive
		else
			bullet.Force	= ent.CannonArmorPenetration
			bullet.HullSize 	= 0
			bullet.Damage	= 800
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
			PhysObj:ApplyForceOffset( -bullet.Dir * 100000, bullet.Src )
		end

		ent:TakeAmmo( 1 )

		if not IsValid( ent.SNDTurret ) then return end

		ent:PlayAnimation( "turret_fire" )

		ent.SNDTurret:PlayOnce( 100 + math.cos( CurTime() + ent:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )
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