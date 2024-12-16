
ENT.OpticsFov = 20
ENT.OpticsEnable = true
ENT.OpticsZoomOnly = true
ENT.OpticsFirstPerson = true
ENT.OpticsThirdPerson = false
ENT.OpticsPodIndex = {
	[1] = true,
}

local scope = Material( "lvs/scope_viewblocked.png" )
local aim = Material( "lvs/28pdr_aim.png" )
local rot = Material( "lvs/28pdr_sight.png" )

function ENT:PaintOptics( Pos2D, Col, PodIndex, Type )
	if Type == 1 then
		self:DrawRotatedText( "BESA", Pos2D.x + 30, Pos2D.y + 30, "LVS_FONT_PANEL", Color(0,0,0,220), 0)
	else
		self:DrawRotatedText( Type == 3 and "HE" or "APC", Pos2D.x + 30, Pos2D.y + 30, "LVS_FONT_PANEL", Color(0,0,0,220), 0)
	end

	local Width = ScrW()
	local Height = ScrH()

	local ScopeSize = Height

	local TurretBallisticsValue = self:GetTurretCompensation()

	-- how much scope offsets
	local Offset = (TurretBallisticsValue / Height) * 18

	-- changes default Y offset of 'rot'
	local OffsetRotator = -ScopeSize * 0.04

	surface.SetMaterial( scope )
	surface.SetDrawColor( 0, 0, 0, 255 )
	surface.DrawTexturedRect( Pos2D.x - ScopeSize * 0.5, Pos2D.y - ScopeSize * 0.5 + Offset, ScopeSize, ScopeSize )

	-- black bar top + bottom
	surface.DrawRect( Pos2D.x - ScopeSize * 0.5, Pos2D.y - ScopeSize * 0.5 - ScopeSize + Offset, ScopeSize, ScopeSize )
	surface.DrawRect( Pos2D.x - ScopeSize * 0.5, Pos2D.y - ScopeSize * 0.5 + ScopeSize + Offset, ScopeSize, ScopeSize )

	-- black bar left + right
	surface.DrawRect( 0, 0, Width * 0.5 - ScopeSize * 0.5, Height )
	surface.DrawRect( Width * 0.5 + ScopeSize * 0.5, 0, Width * 0.5 - ScopeSize * 0.5, Height )

	surface.SetMaterial( aim )
	surface.DrawTexturedRect( Pos2D.x - ScopeSize * 0.5, Pos2D.y - ScopeSize * 0.5, ScopeSize, ScopeSize )

	-- reduces 'rot' scaling
	ScopeSize = ScopeSize * 0.85

	surface.SetMaterial( rot )
	surface.DrawTexturedRect( Pos2D.x - ScopeSize * 0.5, Pos2D.y - ScopeSize * 0.5 + Offset + OffsetRotator, ScopeSize, ScopeSize )
end