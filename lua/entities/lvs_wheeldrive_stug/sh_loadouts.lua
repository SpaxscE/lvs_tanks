
local CannonBodyGroup = 1 -- the bodygroup we are watching

-- values get merged with entity table
local LoadoutsMember = {
	[0] = {
		CannonReloadSound = "lvs/vehicles/tiger/cannon_reload.wav",
		CannonArmorPenetration = 13700,
		CannonArmorPenetration1km = 8000,
		CannonExplosivePenetration = 500,
		ProjectileVelocityHighExplosive = 16000,
		ProjectileVelocityArmorPiercing = 20000,
		OpticsProjectileSize = 7.5,
	},
	[1] = {
		CannonReloadSound = "lvs/vehicles/pz3/cannon_reload.wav",
		CannonArmorPenetration = 5400,
		CannonArmorPenetration1km = 3000,
		CannonExplosivePenetration = 500,
		ProjectileVelocityHighExplosive = 16000,
		ProjectileVelocityArmorPiercing = 20000,
		OpticsProjectileSize = 7.5,
	},
	[2] = {
		CannonReloadSound = "lvs/vehicles/wespe/cannon_reload.wav",
		CannonArmorPenetration = 8000,
		CannonArmorPenetration1km = 2000,
		CannonExplosivePenetration = 4000,
		ProjectileVelocityHighExplosive = 6000,
		ProjectileVelocityArmorPiercing = 8000,
		OpticsProjectileSize = 7.5,
	},
}

local LoadoutsWeapons = {
	[0] = { -- loadout bodygroup 0
		[1] = { -- pod #1 (driver)
			[1] = { -- weapon #1
				Ammo = 44,
				Delay = 3.3,
				HeatRateUp = 1,
				HeatRateDown = 0.22,
			},
		},
	},
	[1] = {
		[1] = {
			[1] = {
				Ammo = 52,
				Delay = 2.25,
				HeatRateUp = 1,
				HeatRateDown = 0.6,
			},
		},
	},
	[2] = {
		[1] = {
			[1] = {
				Ammo = 20,
				Delay = 3.3,
				HeatRateUp = 1,
				HeatRateDown = 0.25,
			},
		},
	},
}

-- function that gets called once when the loadout is activated
local LoadoutsFunctions = {
	[0] = function( ent )
		ent:ChangeTurretSound( ent.SNDTurret, "lvs/vehicles/pak40/cannon_fire.wav", "lvs/vehicles/pak40/cannon_fire.wav" )
	end,

	[1] = function( ent )
		ent:ChangeTurretSound( ent.SNDTurret, "lvs/vehicles/pz3/cannon_fire2.wav", "lvs/vehicles/pz3/cannon_fire2.wav" )
	end,

	[2] = function( ent )
		ent:ChangeTurretSound( ent.SNDTurret, "lvs/vehicles/wespe/cannon_fire.wav", "lvs/vehicles/wespe/cannon_fire.wav" )
	end,
}

function ENT:OnCannonBodyGroupChanged( oldvalue, newvalue )
	local CurLoadout = LoadoutsMember[ newvalue ]

	if CurLoadout then table.Merge( self, CurLoadout ) end

	if self:GetUseHighExplosive() then
		self:TurretUpdateBallistics( self.ProjectileVelocityHighExplosive )
	else
		self:TurretUpdateBallistics( self.ProjectileVelocityArmorPiercing )
	end

	local UpdateWeapon = LoadoutsWeapons[ newvalue ]

	if istable( UpdateWeapon ) then
		for PodID, data in pairs( UpdateWeapon ) do

			for WeaponID, weaponData in pairs( data ) do

				self:UpdateWeapon( PodID, WeaponID, weaponData )
			end
		end

		if SERVER then
			self:WeaponRestoreAmmo()
		end
	end

	if isfunction( LoadoutsFunctions[ newvalue ] ) then LoadoutsFunctions[ newvalue ]( self ) end
end

function ENT:ChangeTurretSound( Emitter, snd, snd_interior )
	if CLIENT then return end

	if not IsValid( Emitter ) then return end

	if snd and not snd_interior then
		Emitter:SetSound( snd )
		Emitter:SetSoundInterior( snd )
	else
		Emitter:SetSound( snd or "" )
		Emitter:SetSoundInterior( snd_interior )
	end
end

if CLIENT then
	function ENT:OnFrame()
		self:HandleCannonLoadout()
	end
else
	function ENT:OnTick()
		self:AimTurret() -- this is required for sh_turret.lua
		self:HandleCannonLoadout()
	end
end

local NextCheck = 0
local CheckInterval = 1
function ENT:HandleCannonLoadout()
	local T = CurTime()

	if T < NextCheck then return end

	NextCheck = T + CheckInterval

	local bodygroup = self:GetBodygroup( CannonBodyGroup )

	if bodygroup == self._oldCannonBodyGroup then return end

	local oldvalue = self._oldCannonBodyGroup or 0

	self:OnCannonBodyGroupChanged( oldvalue, bodygroup )

	self._oldCannonBodyGroup = bodygroup
end