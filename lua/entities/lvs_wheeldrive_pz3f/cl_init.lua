include("shared.lua")
include("cl_attached_playermodels.lua")

ENT.TrackLeftSubMaterialID = 11
ENT.TrackRightSubMaterialID = 12

ENT.OpticsProjectileSize = 5

local Zoom = 0

function ENT:TankGunnerViewOverride( ply, pos, angles, fov, pod )
	if pod == self:GetTopGunnerSeat() and not pod:GetThirdPersonMode() then
		local ID = self:LookupAttachment( "topmg_eye" )

		local EyeAttach = self:GetAttachment( ID )

		local TargetZoom = ply:lvsKeyDown( "ZOOM" ) and 1 or 0

		Zoom = Zoom + (TargetZoom - Zoom) * RealFrameTime() * 10

		if EyeAttach then
			local Z1 = (EyeAttach.Pos + EyeAttach.Ang:Up() * -0.8 + EyeAttach.Ang:Forward() * -15 + EyeAttach.Ang:Right() * -1.9) * (1 - Zoom)
			local Z2 = (EyeAttach.Pos + EyeAttach.Ang:Right() * -0.4 + EyeAttach.Ang:Forward() * -5) * Zoom
			pos = Z1 + Z2
		end
	end

	return pos, angles, fov
end
