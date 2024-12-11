include("shared.lua")
include("sh_turret.lua")
include("sh_tracks.lua")
include("cl_tankview.lua")
include("entities/lvs_trailer_pak40/cl_optics.lua")

local switch = Material("lvs/weapons/change_ammo.png")
local AP = Material("lvs/weapons/bullet_ap.png")
local HE = Material("lvs/weapons/tank_cannon.png")
function ENT:DrawWeaponIcon( PodID, ID, x, y, width, height, IsSelected, IconColor )
	local Icon = self:GetUseHighExplosive() and HE or AP

	surface.SetMaterial( Icon )
	surface.DrawTexturedRect( x, y, width, height )

	local ply = LocalPlayer()

	if not IsValid( ply ) or self:GetSelectedWeapon() ~= 1 then return end

	surface.SetMaterial( switch )
	surface.DrawTexturedRect( x + width + 5, y + 7, 24, 24 )

	local buttonCode = ply:lvsGetControls()[ "CAR_SWAP_AMMO" ]

	if not buttonCode then return end

	local KeyName = input.GetKeyName( buttonCode )

	if not KeyName then return end

	draw.DrawText( KeyName, "DermaDefault", x + width + 17, y + height * 0.5 + 7, Color(0,0,0,IconColor.a), TEXT_ALIGN_CENTER )
end

function ENT:OnEngineActiveChanged( Active )
	if Active then
		self:EmitSound( "lvs/vehicles/pz2/engine_start.wav", 75, 100,  LVS.EngineVolume )
	else
		self:EmitSound( "lvs/vehicles/pz2/engine_stop.wav", 75, 100,  LVS.EngineVolume )
	end
end
