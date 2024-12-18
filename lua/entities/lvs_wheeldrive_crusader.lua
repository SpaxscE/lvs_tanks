AddCSLuaFile()

ENT.Base = "lvs_wheeldrive_crusader_base"

ENT.PrintName = "Crusader III"
ENT.Author = "Digger"
ENT.Information = "Luna's Vehicle Script"
ENT.Category = "[LVS] - Tanks"

ENT.VehicleCategory = "Tanks"
ENT.VehicleSubCategory = "Light"

ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.Lights = {
	{
		Trigger = "main",
		Sprites = {
			{ pos = "m", colorB = 200, colorA = 150, },
		},
		ProjectedTextures = {
			{ pos = "m", ang = Angle(0,0,0), colorB = 200, colorA = 150, shadows = true },
		},
	},
	{
		Trigger = "high",
		SubMaterialID = 5,
		SubMaterialBrightness = 20,
		Sprites = {
			{ pos = "h", colorB = 200, colorA = 150 },
		},
		ProjectedTextures = {
			{ pos = "h", ang = Angle(0,0,0), colorB = 200, colorA = 150, shadows = true },
		},
	},


}
