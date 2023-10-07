
include("entities/lvs_tank_wheeldrive/modules/cl_tankview.lua")

function ENT:TankViewOverride( ply, pos, angles, fov, pod )
	if ply == self:GetDriver() and not pod:GetThirdPersonMode() then
		local ID = self:LookupAttachment( "muzzle_4" )

		local Muzzle = self:GetAttachment( ID )

		if Muzzle then
			pos =  Muzzle.Pos + Muzzle.Ang:Up() * 5 - Muzzle.Ang:Forward() * 32 - Muzzle.Ang:Right() * 5
		end
	end

	if pod ~= self:GetDriverSeat() and not pod:GetThirdPersonMode() then
		pod:SetThirdPersonMode( true )
	end

	return pos, angles, fov
end