include("shared.lua")
include("sh_tracks.lua")
include("sh_turret.lua")
include("entities/lvs_wheeldrive_cromwell/cl_optics.lua")
include("cl_tankview.lua")

ENT.TrackLeftSubMaterialID = 7
ENT.TrackRightSubMaterialID = 8

ENT.IconSwitch = Material("lvs/weapons/change_ammo.png")
ENT.IconSlot1 = Material("lvs/weapons/bullet_ap.png")
ENT.IconSlot2 = Material("lvs/weapons/tank_cannon.png")

function ENT:DrawWeaponIcon( PodID, ID, x, y, width, height, IsSelected, IconColor )
	local Icon = self:GetUseHighExplosive() and self.IconSlot2 or self.IconSlot1

	surface.SetMaterial( Icon )
	surface.DrawTexturedRect( x, y, width, height )

	local ply = LocalPlayer()

	if not IsValid( ply ) or self:GetSelectedWeapon() ~= 2 then return end

	surface.SetMaterial( self.IconSwitch )
	surface.DrawTexturedRect( x + width + 5, y + 7, 24, 24 )

	local buttonCode = ply:lvsGetControls()[ "CAR_SWAP_AMMO" ]

	if not buttonCode then return end

	local KeyName = input.GetKeyName( buttonCode )

	if not KeyName then return end

	draw.DrawText( KeyName, "DermaDefault", x + width + 17, y + height * 0.5 + 7, Color(0,0,0,IconColor.a), TEXT_ALIGN_CENTER )
end

function ENT:OnEngineActiveChanged( Active )
	if Active then
		self:EmitSound( "lvs/vehicles/crusader/engine_start.wav", 75, 100,  LVS.EngineVolume )
	else
		self:EmitSound( "lvs/vehicles/crusader/engine_stop.wav", 75, 100,  LVS.EngineVolume )
	end
end
