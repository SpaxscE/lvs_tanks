
include("entities/lvs_tank_wheeldrive/modules/cl_tankview.lua")

function ENT:TankGunnerViewOverride( ply, pos, angles, fov, pod )
	return pos, angles, fov
end

function ENT:TankViewOverride( ply, pos, angles, fov, pod )
	if ply == self:GetDriver() and not pod:GetThirdPersonMode() then
		local ID = self:LookupAttachment( "muzzle_cannon" )

		local Muzzle = self:GetAttachment( ID )

		if Muzzle then
			pos =  Muzzle.Pos - Muzzle.Ang:Up() * 30 + Muzzle.Ang:Forward() * 10 - Muzzle.Ang:Right() * 3
		end

	end

	return self:TankGunnerViewOverride( ply, pos, angles, fov, pod )
end