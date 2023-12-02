
ENT.Base = "lvs_wheeldrive_t34_base"

ENT.PrintName = "T34 [Shielded]"
ENT.Author = "Digger"
ENT.Information = "Luna's Vehicle Script"
ENT.Category = "[LVS] - Tanks"

ENT.VehicleCategory = "Tanks"
ENT.VehicleSubCategory = "Medium"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.MDL = "models/diggercars/t34/t34e.mdl"
ENT.MDL_DESTROYED = "models/diggercars/t34/t34_dead.mdl"

ENT.CannonArmorPenetration = 8600

ENT.DSArmorIgnoreForce = 3000
ENT.FrontArmor = 1500
ENT.SideArmor = 2600
ENT.TurretArmor = 3100
ENT.RearArmor = 100

ENT.MaxVelocity = 300
ENT.MaxVelocityReverse = 100

ENT.TransGears = 3

ENT.lvsShowInSpawner = true

function ENT:InitWeapons()
	local COLOR_WHITE = Color(255,255,255,255)

	-- coaxial machinegun
	local weapon = {}
	weapon.Icon = Material("lvs/weapons/mg.png")
	weapon.Ammo = 1000
	weapon.Delay = 0.1
	weapon.HeatRateUp = 0.2
	weapon.HeatRateDown = 0.25
	weapon.Attack = function( ent )
		local ID = ent:LookupAttachment( "muzzle_turret" )

		local Muzzle = ent:GetAttachment( ID )

		if not Muzzle then return end

		local bullet = {}
		bullet.Src 	= Muzzle.Pos
		bullet.Dir 	= Muzzle.Ang:Up()
		bullet.Spread 	= Vector(0.015,0.015,0.015)
		bullet.TracerName = "lvs_tracer_yellow"
		bullet.Force	= 10
		bullet.HullSize 	= 0
		bullet.Damage	= 25
		bullet.Velocity = 30000
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
		local ID = ent:LookupAttachment(  "muzzle_turret" )

		local Muzzle = ent:GetAttachment( ID )

		if Muzzle then
			local traceTurret = util.TraceLine( {
				start = Muzzle.Pos,
				endpos = Muzzle.Pos + Muzzle.Ang:Up() * 50000,
				filter = ent:GetCrosshairFilterEnts()
			} )

			local MuzzlePos2D = traceTurret.HitPos:ToScreen() 

			ent:PaintCrosshairCenter( MuzzlePos2D, COLOR_WHITE )
			ent:LVSPaintHitMarker( MuzzlePos2D )
		end
	end
	self:AddWeapon( weapon )



	local weapon = {}
	weapon.Icon = true
	weapon.Ammo = 80
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
				ent:EmitSound("lvs/vehicles/t34/cannon_unload.wav", 75, 100, 1, CHAN_WEAPON )
				ent:SetHeat( 1 )
				ent:SetOverheated( true )
			end
		end
	end
	weapon.Attack = function( ent )
		local ID = ent:LookupAttachment( "muzzle" )

		local Muzzle = ent:GetAttachment( ID )

		if not Muzzle then return end

		local bullet = {}
		bullet.Src 	= Muzzle.Pos
		bullet.Dir 	= Muzzle.Ang:Up()
		bullet.Spread = Vector(0,0,0)

		if ent:GetUseHighExplosive() then
			bullet.Force	= 500
			bullet.HullSize 	= 15
			bullet.Damage	= 250
			bullet.SplashDamage = 750
			bullet.SplashDamageRadius = 200
			bullet.SplashDamageEffect = "lvs_bullet_impact_explosive"
			bullet.SplashDamageType = DMG_BLAST
			bullet.Velocity = 13000
		else
			bullet.Force	= ent.CannonArmorPenetration
			bullet.HullSize 	= 0
			bullet.Damage	= 1000
			bullet.Velocity = 16000
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

		ent:PlayAnimation( "turret_fire" )

		ent:TakeAmmo( 1 )

		if not IsValid( ent.SNDTurret ) then return end

		ent.SNDTurret:PlayOnce( 100 + math.cos( CurTime() + ent:EntIndex() * 1337 ) * 5 + math.Rand(-1,1), 1 )

		ent:EmitSound("lvs/vehicles/t34/cannon_reload.wav", 75, 100, 1, CHAN_WEAPON )
	end
	weapon.HudPaint = function( ent, X, Y, ply )
		local ID = ent:LookupAttachment(  "muzzle" )

		local Muzzle = ent:GetAttachment( ID )

		if Muzzle then
			local traceTurret = util.TraceLine( {
				start = Muzzle.Pos,
				endpos = Muzzle.Pos + Muzzle.Ang:Up() * 50000,
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

	self:AddGunnerWeapons()
end

function ENT:GunnerInRange( Dir )
	return self:AngleBetweenNormal( self:GetForward(), Dir ) < 30
end

function ENT:AddGunnerWeapons()
	local COLOR_RED = Color(255,0,0,255)
	local COLOR_WHITE = Color(255,255,255,255)

	local weapon = {}
	weapon.Icon = Material("lvs/weapons/mg.png")
	weapon.Ammo = 1000
	weapon.Delay = 0.1
	weapon.HeatRateUp = 0.2
	weapon.HeatRateDown = 0.25
	weapon.Icon = Material("lvs/weapons/mg.png")
	weapon.Ammo = 1000
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
		bullet.Spread 	= Vector(0.015,0.015,0.015)
		bullet.TracerName = "lvs_tracer_yellow"
		bullet.Force	= 10
		bullet.HullSize 	= 0
		bullet.Damage	= 25
		bullet.Velocity = 30000
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