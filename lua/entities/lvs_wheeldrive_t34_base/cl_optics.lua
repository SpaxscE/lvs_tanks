
ENT.OpticsFov = 30
ENT.OpticsEnable = true
ENT.OpticsZoomOnly = true
ENT.OpticsFirstPerson = true
ENT.OpticsThirdPerson = false
ENT.OpticsPodIndex = {
	[1] = true,
}

local axis = Material( "lvs/axis.png" )
local tri1 = Material( "lvs/triangle1.png" )
local tri2 = Material( "lvs/triangle2.png" )
local scope = Material( "lvs/scope.png" )

function ENT:PaintOptics( Pos2D, Col, PodIndex, Type )
	surface.SetDrawColor( 255, 255, 255, 5 )
	surface.SetMaterial( tri2 )
	surface.DrawTexturedRect( Pos2D.x - 17, Pos2D.y - 1, 32, 32 )
	surface.DrawRect(Pos2D.x - 2, Pos2D.y + 5, 2, 200)

	surface.SetDrawColor( 0, 0, 0, 255 )
	surface.DrawTexturedRect( Pos2D.x - 16, Pos2D.y, 32, 32 )
	surface.DrawRect(Pos2D.x - 1, Pos2D.y + 5, 2, 200)

	for i = -4, 4, 1 do
		if i == 0 then continue end

		surface.SetMaterial( tri2 )
		surface.SetDrawColor( 255, 255, 255, 5 )
		surface.DrawTexturedRect( Pos2D.x - 9 + i * 32, Pos2D.y - 1, 16, 16 )
		surface.SetDrawColor( 0, 0, 0, 255 )
		surface.DrawTexturedRect( Pos2D.x - 8 + i * 32, Pos2D.y, 16, 16 )
	end

	for i = -4, 4, 1 do
		if i == 0 then continue end

		local X = Pos2D.x + i * 32 - self:Sign( i ) * 16

		surface.DrawLine( X, Pos2D.y,  X, Pos2D.y + 5 )
	end

	if Type == 1 then
		self:DrawRotatedText( "ДТ", Pos2D.x + 30, Pos2D.y + 30, "LVS_FONT_PANEL", Color(0,0,0,220), 0)
	else
		self:DrawRotatedText( Type == 3 and "ОФ" or "БР", Pos2D.x + 30, Pos2D.y + 30, "LVS_FONT_PANEL", Color(0,0,0,220), 0)
	end

	local H05 = ScrH() * 0.5

	local diameter = ScrH()
	local radius = H05

	surface.SetMaterial( scope )
	surface.SetDrawColor( 0, 0, 0, 50 )
	surface.DrawTexturedRect( Pos2D.x - radius, Pos2D.y - radius, diameter, diameter )

	local Ro = math.min(self:WorldToLocal( self:GetEyeTrace().HitPos ):Length() / 50000,1) * 90

	local R1 = math.rad( 100 + Ro )
	local R2 = math.rad( 260 - Ro )

	local X1 = math.sin( R1 ) * H05
	local Y1 = math.cos( R1 ) * H05
	local X2 = math.sin( R2 ) * H05

	surface.SetDrawColor( 0, 0, 0, 100 )
	surface.DrawLine( Pos2D.x + X1, Pos2D.y + Y1, Pos2D.x + X2, Pos2D.y + Y1 )

	local Cstart = Pos2D.x - H05 * 0.4
	local Ystart = Pos2D.y - H05 * 0.15
	local xSwap = true

	self:DrawRotatedText( "БРОГ", Cstart, Ystart + H05 * 0.025, "LVS_FONT_PANEL", Color(0,0,0,200), 0)

	for i = 0, 46 do
		local Y = Ystart - i * H05 * 0.014

		local Xa = xSwap and 12 or 6
		local Xb = xSwap and 6 or 12

		surface.DrawLine( Cstart - Xa, Y, Cstart + Xb, Y )

		local textX = Cstart + (xSwap and -1 or 1) * 20

		self:DrawRotatedText( i, textX, Y, "LVS_FONT_PANEL", Color(0,0,0,200), 0)

		xSwap = not xSwap
	end

	Cstart = Pos2D.x + H05 * 0.4

	self:DrawRotatedText( "ДТ", Cstart, Ystart + H05 * 0.025, "LVS_FONT_PANEL", Color(0,0,0,200), 0)

	for i = 0, 16 do
		local Y = Ystart - i * H05 * 0.016

		local Xa = xSwap and 12 or 6
		local Xb = xSwap and 6 or 12

		surface.DrawLine( Cstart - Xa, Y, Cstart + Xb, Y )

		local textX = Cstart + (xSwap and -1 or 1) * 20

		self:DrawRotatedText( i, textX, Y, "LVS_FONT_PANEL", Color(0,0,0,200), 0)

		xSwap = not xSwap
	end
end