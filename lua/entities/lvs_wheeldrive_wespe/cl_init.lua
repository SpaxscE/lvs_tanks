include("shared.lua")
include("sh_tracks.lua")
include("cl_attached_playermodels.lua")

include("entities/lvs_tank_wheeldrive/modules/cl_tankview.lua")
function ENT:TankViewOverride( ply, pos, angles, fov, pod )
	if ply == self:GetDriver() and not pod:GetThirdPersonMode() then
		local ID = self:LookupAttachment( "muzzle" )

		local Muzzle = self:GetAttachment( ID )

		if Muzzle then
			pos =  Muzzle.Pos - Muzzle.Ang:Up() * 20 - Muzzle.Ang:Forward() * 60 - Muzzle.Ang:Right() * 12
		end

	end

	return pos, angles, fov
end

function ENT:OnEngineActiveChanged( Active )
	if Active then
		self:EmitSound( "lvs/vehicles/pz2/engine_start.wav", 75, 100,  LVS.EngineVolume )
	else
		self:EmitSound( "lvs/vehicles/pz2/engine_stop.wav", 75, 100,  LVS.EngineVolume )
	end
end
