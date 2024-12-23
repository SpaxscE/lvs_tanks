
ENT.OpticsFov = 30
ENT.OpticsEnable = true
ENT.OpticsZoomOnly = true
ENT.OpticsFirstPerson = true
ENT.OpticsThirdPerson = false
ENT.OpticsPodIndex = {
	[1] = true,
}

ENT.OpticsCrosshairMaterial = Material( "lvs/circle_filled.png" )
ENT.OpticsCrosshairColor = Color(0,0,0,150)
ENT.OpticsCrosshairSize = 4

local axis = Material( "lvs/28pdr_aim.png" )
local sight = Material( "lvs/28pdr_sight.png" )
local scope = Material( "lvs/scope_viewblocked.png" )

function ENT:PaintOpticsCrosshair( Pos2D )
	local ScrW = ScrW()
	local ScrH = ScrH()

	local ScopeSize = ScrH

	surface.SetDrawColor( 0, 0, 0, 255 )

	surface.SetMaterial( axis )
	surface.DrawTexturedRect( Pos2D.x - ScopeSize * 0.5, Pos2D.y - ScopeSize * 0.5, ScopeSize, ScopeSize )

	surface.DrawLine( Pos2D.x - ScopeSize * 0.19, Pos2D.y, 0, Pos2D.y )
	surface.DrawLine( Pos2D.x + ScopeSize * 0.19, Pos2D.y, ScrW, Pos2D.y )
	surface.DrawLine( Pos2D.x - 1, Pos2D.y - ScopeSize * 0.21, Pos2D.x - 1, 0 )
	surface.DrawLine( Pos2D.x - 1, Pos2D.y + ScopeSize * 0.16, Pos2D.x - 1, ScrH )
end

function ENT:PaintOptics( Pos2D, Col, PodIndex, Type )
	local size = self.OpticsCrosshairSize

	surface.SetMaterial( self.OpticsCrosshairMaterial )
	surface.SetDrawColor( self.OpticsCrosshairColor )
	surface.DrawTexturedRect( Pos2D.x - size * 0.5, Pos2D.y - size * 0.5, size, size )

	if Type == 1 then
		self:DrawRotatedText( "BESA", Pos2D.x + 30, Pos2D.y + 15, "LVS_FONT_PANEL", Color(0,0,0,220), 0)
	else
		self:DrawRotatedText( Type == 3 and "HE" or "APC", Pos2D.x + 30, Pos2D.y + 15, "LVS_FONT_PANEL", Color(0,0,0,220), 0)
	end

	local ScrW = ScrW()
	local ScrH = ScrH()

	local diameter = ScrH + 64
	local radius = diameter * 0.5

	local TurretBallisticsValue = self:GetTurretCompensation()

	-- how much scope offsets
	local Offset = (TurretBallisticsValue / ScrH) * 40

	local ScopeSize = ScrH

	surface.SetMaterial( sight )
	surface.SetDrawColor( 0, 0, 0, 255 )
	surface.DrawTexturedRect( Pos2D.x - ScopeSize * 0.5, Pos2D.y - ScopeSize * 0.5 + Offset - radius * 0.08, ScopeSize, ScopeSize )

	surface.SetMaterial( scope )
	surface.DrawTexturedRect( Pos2D.x - radius, Pos2D.y - radius + Offset, diameter, diameter )

	-- black bar top + bottom
	surface.DrawRect( Pos2D.x - radius, Pos2D.y - radius - diameter + Offset, diameter, diameter )
	surface.DrawRect( Pos2D.x - radius, Pos2D.y - radius + diameter + Offset, diameter, diameter )

	-- black bar left + right
	surface.DrawRect( 0, 0, Pos2D.x - radius, ScrH )
	surface.DrawRect( Pos2D.x + radius, 0, Pos2D.x - radius, ScrH )
end
