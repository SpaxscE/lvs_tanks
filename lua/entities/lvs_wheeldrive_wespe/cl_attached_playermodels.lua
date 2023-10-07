
include("entities/lvs_tank_wheeldrive/modules/cl_attachable_playermodels.lua")

function ENT:DrawDriver()
	local pod = self:GetDriverSeat()

	if not IsValid( pod ) then self:RemovePlayerModel( "driver" ) return end

	local plyL = LocalPlayer()
	local ply = pod:GetDriver()

	if not IsValid( ply ) or (ply == plyL and not pod:GetThirdPersonMode()) then self:RemovePlayerModel( "driver" ) return end

	local Pos = self:LocalToWorld( Vector(-60,20,30) )
	local Ang = self:LocalToWorldAngles( Angle(0,0,0) )

	local model = self:CreatePlayerModel( ply, "driver" )

	model:SetSequence( "idle_physgun" )
	model:SetRenderOrigin( Pos )
	model:SetRenderAngles( Ang )
	model:DrawModel()
end

function ENT:DrawGunner()
	local pod = self:GetDriverSeat()

	if not IsValid( pod ) then self:RemovePlayerModel( "passenger" ) return end

	local plyL = LocalPlayer()
	local ply = pod:GetDriver()

	if not IsValid( ply ) or (ply == plyL and not pod:GetThirdPersonMode()) then self:RemovePlayerModel( "passenger" ) return end

	local Pos = self:LocalToWorld( Vector(-70,-20,30) )
	local Ang = self:LocalToWorldAngles( Angle(0,0,0) )

	local model = self:CreatePlayerModel( ply, "passenger" )

	model:SetSequence( "idle_slam" )
	model:SetRenderOrigin( Pos )
	model:SetRenderAngles( Ang )
	model:DrawModel()
end

function ENT:PreDraw()
	self:DrawDriver()
	self:DrawGunner()

	return true
end
