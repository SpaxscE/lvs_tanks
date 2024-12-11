
local CannonBodyGroup = 1 -- the bodygroup we are watching

local Loadouts = {
	[0] = {
		CannonArmorPenetration = 13700,
		CannonArmorPenetration1km = 8000,
		ProjectileVelocityHighExplosive = 16000,
		ProjectileVelocityArmorPiercing = 20000,
	},
	[1] = {
		CannonArmorPenetration = 5400,
		CannonArmorPenetration1km = 3000,
		ProjectileVelocityHighExplosive = 16000,
		ProjectileVelocityArmorPiercing = 20000,
	},
	[2] = {
		CannonArmorPenetration = 5400,
		CannonArmorPenetration1km = 3000,
		ProjectileVelocityHighExplosive = 6000,
		ProjectileVelocityArmorPiercing = 8000,
	},
}

local LoadoutsFunction = {
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
	local CurLoadout = Loadouts[ newvalue ]

	table.Merge( self, CurLoadout )

	if self:GetUseHighExplosive() then
		self:TurretUpdateBallistics( self.ProjectileVelocityHighExplosive )
	else
		self:TurretUpdateBallistics( self.ProjectileVelocityArmorPiercing )
	end

	if not isfunction( LoadoutsFunction[ newvalue ] ) then return end

	LoadoutsFunction[ newvalue ]( self )
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