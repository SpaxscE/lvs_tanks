
if SERVER then
	ENT.PivotSteerEnable = true
	ENT.PivotSteerByBrake = true
	ENT.PivotSteerWheelRPM = 40

	function ENT:OnLeftTrackRepaired()
		self:SetBodygroup(2,0)
	end

	function ENT:OnLeftTrackDestroyed()
		self:SetBodygroup(2,1)
	end

	function ENT:OnRightTrackRepaired()
		self:SetBodygroup(3,0)
	end

	function ENT:OnRightTrackDestroyed()
		self:SetBodygroup(3,1)
	end

	function ENT:TracksCreate( PObj )
		self:CreateTrackPhysics( "models/diggercars/t34/tracks_col.mdl" )

		local WheelModel = "models/props_vehicles/tire001b_truck.mdl"

		local L1 = self:AddWheel( { hide = true, wheeltype = LVS.WHEELTYPE_LEFT, pos = Vector(90,50,38), mdl = WheelModel } )
		local L2 = self:AddWheel( { hide = true, wheeltype = LVS.WHEELTYPE_LEFT, pos = Vector(60,50,38), mdl = WheelModel } )
		local L3 = self:AddWheel( { hide = true, wheeltype = LVS.WHEELTYPE_LEFT, pos = Vector(20,50,38), mdl = WheelModel } )
		local L4 = self:AddWheel( { hide = true, wheeltype = LVS.WHEELTYPE_LEFT, pos = Vector(-20,50,38), mdl = WheelModel } )
		local L5 = self:AddWheel( { hide = true, wheeltype = LVS.WHEELTYPE_LEFT, pos = Vector(-60,50,38), mdl = WheelModel } )
		local L6 = self:AddWheel( { hide = true, wheeltype = LVS.WHEELTYPE_LEFT, pos = Vector(-90,50,38), mdl = WheelModel } )
		local LeftWheelChain = self:CreateWheelChain( {L1, L2, L3, L4, L5, L6} )
		self:SetTrackDriveWheelLeft( L4 )

		local R1 = self:AddWheel( { hide = true, wheeltype = LVS.WHEELTYPE_RIGHT, pos = Vector(90,-50,38), mdl = WheelModel } )
		local R2 = self:AddWheel( { hide = true, wheeltype = LVS.WHEELTYPE_RIGHT, pos = Vector(60,-50,38), mdl = WheelModel } )
		local R3 = self:AddWheel( { hide = true, wheeltype = LVS.WHEELTYPE_RIGHT, pos = Vector(20,-50,38), mdl = WheelModel } )
		local R4 = self:AddWheel( { hide = true, wheeltype = LVS.WHEELTYPE_RIGHT, pos = Vector(-20,-50,38), mdl = WheelModel } )
		local R5 = self:AddWheel( { hide = true, wheeltype = LVS.WHEELTYPE_RIGHT, pos = Vector(-60,-50,38), mdl = WheelModel } )
		local R6 = self:AddWheel( { hide = true, wheeltype = LVS.WHEELTYPE_RIGHT, pos = Vector(-90,-50,38), mdl = WheelModel } )
		local RightWheelChain = self:CreateWheelChain( {R1, R2, R3, R4, R5, R6} )
		self:SetTrackDriveWheelRight( R4 )

		local LeftTracksArmor = self:AddArmor( Vector(0,50,40), Angle(0,0,0), Vector(-120,-15,-60), Vector(120,25,10), 600, self.FrontArmor )
		self:SetTrackArmorLeft( LeftTracksArmor, LeftWheelChain )

		local RightTracksArmor = self:AddArmor( Vector(0,-50,40), Angle(0,0,0), Vector(-120,-25,-60), Vector(120,15,10), 600, self.FrontArmor )
		self:SetTrackArmorRight( RightTracksArmor, RightWheelChain )

		self:DefineAxle( {
			Axle = {
				ForwardAngle = Angle(0,0,0),
				SteerType = LVS.WHEEL_STEER_FRONT,
				SteerAngle = 30,
				TorqueFactor = 0,
				BrakeFactor = 1,
				UseHandbrake = true,
			},
			Wheels = { R1, L1, R2, L2 },
			Suspension = {
				Height = 20,
				MaxTravel = 15,
				ControlArmLength = 150,
				SpringConstant = 20000,
				SpringDamping = 1000,
				SpringRelativeDamping = 2000,
			},
		} )

		self:DefineAxle( {
			Axle = {
				ForwardAngle = Angle(0,0,0),
				SteerType = LVS.WHEEL_STEER_NONE,
				TorqueFactor = 1,
				BrakeFactor = 1,
				UseHandbrake = true,
			},
			Wheels = { R3, L3, L4, R4 },
			Suspension = {
				Height = 20,
				MaxTravel = 15,
				ControlArmLength = 150,
				SpringConstant = 20000,
				SpringDamping = 1000,
				SpringRelativeDamping = 2000,
			},
		} )

		self:DefineAxle( {
			Axle = {
				ForwardAngle = Angle(0,0,0),
				SteerType = LVS.WHEEL_STEER_REAR,
				SteerAngle = 30,
				TorqueFactor = 0,
				BrakeFactor = 1,
				UseHandbrake = true,
			},
			Wheels = { R5, L5, R6, L6 },
			Suspension = {
				Height = 20,
				MaxTravel = 15,
				ControlArmLength = 150,
				SpringConstant = 20000,
				SpringDamping = 1000,
				SpringRelativeDamping = 2000,
			},
		} )
	end
else
	ENT.TrackSystemEnable = true

	ENT.TrackScrollTexture = "models/diggercars/t34/tracks"
	ENT.ScrollTextureData = {
		["$bumpmap"] = "models/diggercars/t34/tracks_nm",
		["$phong"] = "1",
		["$alphatest"] = "1",
		["$nocull"] = "1",
		["$phongboost"] = "0.02", 
		["$phongexponent"] = "3",
		["$phongexponenttexture"] = "models/diggercars/t34/tracks_exp",
		["$phongfresnelranges"] = "[1 1 1]",
		["$translate"] = "[0.0 0.0 0.0]",
		["$colorfix"] = "{255 255 255}",
		["Proxies"] = {
			["TextureTransform"] = {
				["translateVar"] = "$translate",
				["centerVar"]    = "$center",
				["resultVar"]    = "$basetexturetransform",
			},
			["Equals"] = {
				["srcVar1"] =  "$colorfix",
				["resultVar"] = "$color",
			}
		}
	}

	ENT.TrackLeftSubMaterialID = 6
	ENT.TrackLeftSubMaterialMul = Vector(0,-0.0145,0)

	ENT.TrackRightSubMaterialID = 7
	ENT.TrackRightSubMaterialMul = Vector(0,-0.0145,0)

	ENT.TrackPoseParameterLeft = "spin_wheels_left"
	ENT.TrackPoseParameterLeftMul = -1.252

	ENT.TrackPoseParameterRight = "spin_wheels_right"
	ENT.TrackPoseParameterRightMul = -1.252

	ENT.TrackSounds = "lvs/vehicles/t34/tracks_loop.wav"
	ENT.TrackHull = Vector(5,5,5)
	ENT.TrackData = {}
	for i = 1, 5 do
		for n = 0, 1 do
			local LR = n == 0 and "l" or "r"
			local LeftRight = n == 0 and "left" or "right"
			local data = {
				Attachment = {
					name = "vehicle_suspension_"..LR.."_"..i,
					toGroundDistance = 50,
					traceLength = 100,
				},
				PoseParameter = {
					name = "suspension_"..LeftRight.."_"..i,
					rangeMultiplier = -0.8,
					lerpSpeed = 25,
				}
			}
			table.insert( ENT.TrackData, data )
		end
	end
end