include("shared.lua")
include("sh_turret.lua")
include("cl_optics.lua")

ENT.TrackLeftSubMaterialID = 5
ENT.TrackRightSubMaterialID = 6

ENT.IconSlot1 = Material("lvs/weapons/flak.png")

function ENT:OnFrame()
	local Heat = 0
	if self:GetSelectedWeapon() == 1 then
		Heat = self:QuickLerp( "cannon_heat", self:GetNWHeat(), 10 )
	else
		Heat = self:QuickLerp( "cannon_heat", 0, 0.25 )
	end

	local name = "crusader_mk2_cannonglow_"..self:EntIndex()

	if not self.TurretGlow then
		self.TurretGlow = self:CreateSubMaterial( 3, name )

		return
	end

	if self._oldGunHeat ~= Heat then
		self._oldGunHeat = Heat

		self.TurretGlow:SetFloat("$detailblendfactor", Heat ^ 7 )

		self:SetSubMaterial(3, "!"..name)
	end
end
