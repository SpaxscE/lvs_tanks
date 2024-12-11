AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "cl_tankview.lua" )
AddCSLuaFile( "sh_turret.lua" )
AddCSLuaFile( "sh_tracks.lua" )
include("shared.lua")
include("sh_turret.lua")
include("sh_tracks.lua")

function ENT:OnSpawn( PObj )
	self:MakeDriverSeat()
	self:MakeArmor()
	self:MakeWeakSpots()

	local ID = self:LookupAttachment( "muzzle" )
	local Muzzle = self:GetAttachment( ID )
	self.SNDTurret = self:AddSoundEmitter( self:WorldToLocal( Muzzle.Pos ), "lvs/vehicles/pak40/cannon_fire.wav", "lvs/vehicles/pak40/cannon_fire.wav" )
	self.SNDTurret:SetSoundLevel( 95 )
	self.SNDTurret:SetParent( self, ID )

	local DoorHandler = self:AddDoorHandler( "hatch7", Vector(-58,0,53), Angle(0,0,0), Vector(-29,-33,-15), Vector(29,33,15), Vector(-29,-33,-15), Vector(29,33,15) )
	DoorHandler:SetSoundOpen( "lvs/vehicles/generic/car_hood_open.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/generic/car_hood_close.wav" )
	local Engine = self:AddEngine( Vector(-40,0,53), Angle(0,180,0) )
	Engine:SetDoorHandler( DoorHandler )

	self:AddTrailerHitch( Vector(-101,0,30), LVS.HITCHTYPE_MALE )
end


function ENT:MakeDriverSeat()
	local DriverSeat = self:AddDriverSeat( Vector(10,0,50), Angle(0,-90,0) )
	DriverSeat.HidePlayer = true

	local DoorHandler = self:AddDoorHandler( "hatch1", Vector(85,14,40), Angle(5,0,0), Vector(-10,-10,-10), Vector(10,15,10), Vector(-10,-10,-10), Vector(10,15,10) )
	DoorHandler:SetSoundOpen( "lvs/vehicles/generic/car_hood_open.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/generic/car_hood_close.wav" )
	DoorHandler:LinkToSeat( DriverSeat )

	local DoorHandler = self:AddDoorHandler( "hatch5", Vector(-7.64,25.1,72.77), Angle(5,0,0), Vector(-10,-10,-10), Vector(10,15,10), Vector(-10,-10,-10), Vector(10,15,10) )
	DoorHandler:SetSoundOpen( "lvs/vehicles/generic/car_hood_open.wav" )
	DoorHandler:SetSoundClose( "lvs/vehicles/generic/car_hood_close.wav" )
	DoorHandler:LinkToSeat( DriverSeat )
end

function ENT:MakeArmor()

	-- viewport armor weakspot
	self:AddArmor( Vector(71,23,52.5), Angle(0,0,0), Vector(-1,-6,-0.3), Vector(1,6,0.3), 200, self.RoofArmor )
	self:AddDriverViewPort( Vector(71,23,52.5), Angle(0,0,0), Vector(-1,-6,-0.3), Vector(1,6,0.3) )

	-- front top
	self:AddArmor( Vector(85,0,49), Angle(-85,0,0), Vector(-1,-36,-15), Vector(1,36,15), 600, self.SideArmor )
	-- front mid up
	self:AddArmor( Vector(105,0,43), Angle(-50,0,0), Vector(-1,-38,-8), Vector(1,38,8), 1000, self.FrontArmor )
	-- front mid down
	self:AddArmor( Vector(106,0,29), Angle(25,0,0), Vector(-1,-38,-11), Vector(1,38,11), 1000, self.FrontArmor )
	-- front bottom
	self:AddArmor( Vector(95,0,17), Angle(80,0,0), Vector(-1,-36,-8), Vector(1,36,8), 600, self.SideArmor )

	-- gun mask
	self:AddArmor( Vector(51,-5,64), Angle(-10,0,0), Vector(-2,-15.1,-14), Vector(2,15.1,14), 2000, self.TurretArmor )

	-- front up
	self:AddArmor( Vector(70,0,56), Angle(-10,0,0), Vector(-2,-38,-8), Vector(2,38,8), 1000, self.FrontArmor )


	-- rear bottom
	self:AddArmor( Vector(-75,0,20), Angle(-65,0,0), Vector(-1,-38,-8), Vector(1,38,8), 600, self.SideArmor )
	-- rear mid
	self:AddArmor( Vector(-84,0,32), Angle(-10,0,0), Vector(-1,-38,-10), Vector(1,38,10), 600, self.SideArmor )
	-- rear top
	self:AddArmor( Vector(-92,0,47), Angle(0,0,0), Vector(-6,-36,-8), Vector(6,36,8), 600, self.SideArmor )

	-- engine top
	self:AddArmor( Vector(-55,0,56), Angle(0,0,0), Vector(-31,-36,-8), Vector(31,36,8), 500, self.RoofArmor )

	-- radio right
	self:AddArmor( Vector(11,-43,61), Angle(0,0,0), Vector(-25,-5,-9), Vector(25,5,9), 1000, self.SidetArmor )
	-- radio left
	self:AddArmor( Vector(11,-43,61), Angle(0,0,0), Vector(-25,-5,-9), Vector(25,5,9), 1000, self.SideArmor )

	-- right low
	self:AddArmor( Vector(7,-37,32), Angle(0,0,0), Vector(-105,-1,-17), Vector(105,1,18), 700, self.SideArmor )
	-- right up
	self:AddArmor( Vector(-13,-37,66), Angle(0,0,0), Vector(-83,-1,-17), Vector(83,1,17), 900, self.SideArmor )

	-- left low
	self:AddArmor( Vector(7,37,32), Angle(0,0,0), Vector(-105,-1,-17), Vector(105,1,18), 700, self.SideArmor )
	-- left up
	self:AddArmor( Vector(-13,37,66), Angle(0,0,0), Vector(-83,-1,-17), Vector(83,1,17), 900, self.SideArmor )

	-- front cabin
	self:AddArmor( Vector(54,0,62), Angle(0,0,0), Vector(-16,-36,-16), Vector(16,36,16), 1000, self.FrontArmor )
	-- roof cabin
	self:AddArmor( Vector(11,0,74), Angle(0,0,0), Vector(-27,-36,-6), Vector(27,36,6), 500, self.RoofArmor )
	-- roof cabin
	self:AddArmor( Vector(-20,0,62), Angle(0,0,0), Vector(-4,-36,-16), Vector(4,36,16), 800, self.SideArmor )

	-- bottom
	self:AddArmor( Vector(-7,0,15), Angle(0,0,0), Vector(-80,-36,-1), Vector(80,36,1), 500, self.RoofArmor )

	-- viewport armor
	self:AddArmor( Vector(74,23,56), Angle(-10,0,0), Vector(-2,-10,-4), Vector(2,10,4), 1000, self.FrontArmor )
end

function ENT:MakeWeakSpots()
	-- fuel tank
	self:AddFuelTank( Vector(-70,0,20), Angle(0,0,0), 600, LVS.FUELTYPE_PETROL, Vector(-5,-30,0),Vector(5,30,35) )

	-- ammo rack weakspot
	self:AddAmmoRack( Vector(54,-29,41), Vector(10,0,62.5), Angle(0,0,0), Vector(-6,-5,-19), Vector(6,5,19) )
	self:AddAmmoRack( Vector(-39,23,28), Vector(10,0,62.5), Angle(0,0,0), Vector(-10,-7,-7), Vector(10,7,7) )
end

