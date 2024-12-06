AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include("shared.lua")

function ENT:MakeTurretPhysics()
	self:CreateTurretPhysics( {
		start = "root_att",
		follow = "turret_att",
		mdl = "models/diggercars/t34/stz_turret_col.mdl",
	} )

end

function ENT:MakeSoundEmitters()
	local ID = self:LookupAttachment( "muzzle_mg" )
	local Muzzle = self:GetAttachment( ID )
	self.SNDTurretMGf = self:AddSoundEmitter( self:WorldToLocal( Muzzle.Pos ), "lvs/vehicles/sherman/mg_loop.wav", "lvs/vehicles/sherman/mg_loop_interior.wav" )
	self.SNDTurretMGf:SetSoundLevel( 95 )
	self.SNDTurretMGf:SetParent( self, ID )

	local ID = self:LookupAttachment( "muzzle_turret" )
	local Muzzle = self:GetAttachment( ID )
	self.SNDTurretMG = self:AddSoundEmitter( self:WorldToLocal( Muzzle.Pos ), "lvs/vehicles/sherman/mg_loop.wav", "lvs/vehicles/sherman/mg_loop_interior.wav" )
	self.SNDTurretMG:SetSoundLevel( 95 )
	self.SNDTurretMG:SetParent( self, ID )

	local ID = self:LookupAttachment( "muzzle" )
	local Muzzle = self:GetAttachment( ID )
	self.SNDTurret = self:AddSoundEmitter( self:WorldToLocal( Muzzle.Pos ), "lvs/vehicles/t34/cannon_fire1.wav", "lvs/vehicles/t34/cannon_fire1.wav" )
	self.SNDTurret:SetSoundLevel( 95 )
	self.SNDTurret:SetParent( self, ID )
end

function ENT:MakeArmor()
	-- front center
	self:AddArmor( Vector(108,0,29), Angle(0,0,0), Vector(-3,-38,-3), Vector(3,38,3), 1500, self.FrontArmorCenter )

	-- front screen
	self:AddArmor( Vector(86,0,50), Angle(29.8,0,0), Vector(-32,-48,-4), Vector(32,48,4), 1500, self.FrontArmorScreen )

	-- front upper
	self:AddArmor( Vector(67,0,46), Angle(30,0,0), Vector(-16,-55,-10), Vector(50,55,10), 1100, self.FrontArmor )

	-- side armor left front
	self:AddArmor( Vector(20,31,50), Angle(0,0,45), Vector(-40,-15,-20), Vector(40,15,13), 600, self.SideArmor )

	-- side armor right front
	self:AddArmor( Vector(20,-31,50), Angle(0,0,-45), Vector(-40,-15,-20), Vector(40,15,13), 600, self.SideArmor )

	-- side armor left rear
	self:AddArmor( Vector(20,31,50), Angle(0,0,45), Vector(-120,-15,-20), Vector(-40,15,13), 600, self.SideArmor )

	-- side armor right rear
	self:AddArmor( Vector(20,-31,50), Angle(0,0,-45), Vector(-120,-15,-20), Vector(-40,15,13), 600, self.SideArmor )

	-- top armor
	self:AddArmor( Vector(-33,0,58), Angle(0,0,0), Vector(-50,-33,-14), Vector(20,33,10), 600, self.RearArmor )

	-- turret
	local TurretArmor = self:AddArmor( Vector(25,0,60), Angle(0,0,0), Vector(-40,-38,0), Vector(34,38,30), 1200, self.TurretArmor )
	TurretArmor.OnDestroyed = function( ent, dmginfo ) if not IsValid( self ) then return end self:SetTurretDestroyed( true ) end
	TurretArmor.OnRepaired = function( ent ) if not IsValid( self ) then return end self:SetTurretDestroyed( false ) end
	TurretArmor:SetLabel( "Turret" )
	self:SetTurretArmor( TurretArmor )

	-- rear up
	self:AddArmor( Vector(-100,0,40), Angle(50,0,0), Vector(-10,-45,7),Vector(20,45,34), 600, self.SideArmor )

	-- rear down
	self:AddArmor( Vector(-100,0,40), Angle(50,0,0), Vector(-10,-50,-17),Vector(20,50,7), 600, self.SideArmor )
end