AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.BogeyDistance = 650 -- Needed for gm trainspawner


---------------------------------------------------
-- Defined train information                      
-- Types of wagon(for wagon limit system):
-- 0 = Head or intherim                           
-- 1 = Only head                                     
-- 2 = Only intherim                                
---------------------------------------------------
ENT.SubwayTrain = {
	Type = "81",
	Name = "81-717.5m",
	Manufacturer = "LVZ",
	WagType = 1,
}

function ENT:Initialize()
	self.Plombs = {
		VAH = true,
		VAD = true,
		OtklAVU = true,
		OVT = true,
		RC1 = true,
		A5 = true,
		Init = true,
	}
	-- Set model and initialize
	self.MaskType = 1
	self.LampType = 1
	self.WorkingLights = 6
	self:SetModel("models/metrostroi_train/81/81-717.mdl")
	self.BaseClass.Initialize(self)
	self:SetPos(self:GetPos() + Vector(0,0,140))
	
	-- Create seat entities
	self.DriverSeat = self:CreateSeat("driver",Vector(421,0,-23+7.8))
	self.InstructorsSeat = self:CreateSeat("instructor",Vector(420,50,-28+3),Angle(0,270,0))
	self.ExtraSeat1 = self:CreateSeat("instructor",Vector(410,-40,-28+1))
	self.ExtraSeat2 = self:CreateSeat("instructor",Vector(430,-50,-43),Angle(0,180,0),"models/vehicles/prisoner_pod_inner.mdl")
	self.ExtraSeat3 = self:CreateSeat("instructor",Vector(402,50,-43),Angle(0,-40+90,0),"models/vehicles/prisoner_pod_inner.mdl")

	-- Hide seats
	self.DriverSeat:SetColor(Color(0,0,0,0))
	self.DriverSeat:SetRenderMode(RENDERMODE_TRANSALPHA)
	self.InstructorsSeat:SetColor(Color(0,0,0,0))
	self.InstructorsSeat:SetRenderMode(RENDERMODE_TRANSALPHA)
	self.ExtraSeat1:SetColor(Color(0,0,0,0))
	self.ExtraSeat1:SetRenderMode(RENDERMODE_TRANSALPHA)
	self.ExtraSeat2:SetColor(Color(0,0,0,0))
	self.ExtraSeat2:SetRenderMode(RENDERMODE_TRANSALPHA)
	self.ExtraSeat3:SetColor(Color(0,0,0,0))
	self.ExtraSeat3:SetRenderMode(RENDERMODE_TRANSALPHA)
	
	-- Create bogeys
	self.FrontBogey = self:CreateBogey(Vector( 317-5,0,-75),Angle(0,180,0),true)
	self.RearBogey  = self:CreateBogey(Vector(-317+0,0,-75),Angle(0,0,0),false)
	
	-- Initialize key mapping
		self.KeyMap = {
		[KEY_W] = "Drive",
		[KEY_S] = "Brake",
		[KEY_R] = "Reverse",
	}
	
	self.InteractionZones = {
		--{	Pos = Vector(460,-26,-47),
--			Radius = 16,
			--ID = "FrontBrakeLineIsolationToggle" },
		--{	Pos = Vector(460, 21, -49),
--			Radius = 16,
			--ID = "FrontTrainLineIsolationToggle" },
		--{	Pos = Vector(-482,30,-55),
--			Radius = 16,
			--ID = "RearTrainLineIsolationToggle" },
		--{	Pos = Vector(-469, -23, -48),
--			Radius = 16,
			--ID = "RearBrakeLineIsolationToggle" },
		--{	Pos = Vector(122, 61, -53),
--			Radius = 16,
			--ID = "GVToggle" },
		--{	Pos = Vector(405, -53, 21),
--			Radius = 30,
			--ID = "VBToggle" },
		--{	Pos = Vector(-180,61,-53),
--			Radius = 20,
			--ID = "AirDistributorDisconnectToggle" },
		{	Pos = Vector(-475, -25, 20),
			Radius = 32,
			ID = "1:RearDoor" },
		{	Pos = Vector(-475, -25, -11),
			Radius = 32,
			ID = "2:RearDoor" },
		{	Pos = Vector(391, 14, 10),
			Radius = 32,
			ID = "PassengerDoor" },
		{	Pos = Vector(415, 65, 30),
			Radius = 28,
			ID = "1:CabinDoor" },
		{	Pos = Vector(415, 65, -9),
			Radius = 28,
			ID = "2:CabinDoor" },
		{	Pos = Vector(441, 66, -48),
			Radius = 28,
			ID = "3:CabinDoor" },
	}

	local vX = Angle(0,-90-0.2,56.3):Forward() -- For ARS panel
	local vY = Angle(0,-90-0.2,56.3):Right()
	self.Lights = {
		-- Headlight glow
		[1] = { "headlight",		Vector(465,0,-20), Angle(0,0,0), Color(216,161,92), fov = 100 },
		
		-- Head (type 1)
		[2] = { "glow",				Vector(470,-51,-19), Angle(0,0,0), Color(255,220,180), brightness = 1, scale = 1.0 },
		[3] = { "glow",				Vector(472,-40, -19), Angle(0,0,0),Color(255,220,180), brightness = 1, scale = 1.0 },
		[4] = { "glow",				Vector(0,0, 0), Angle(0,0,0),  Color(255,220,180), brightness = 1, scale = 1.0 },
		[5] = { "glow",				Vector(0, 0, 0), Angle(0,0,0),  Color(255,220,180), brightness = 1, scale = 1.0 },
		[6] = { "glow",				Vector(472, 41, -19), Angle(0,0,0),Color(255,220,180), brightness = 1, scale = 1.0 },
		[7] = { "glow",				Vector(470, 53,-19), Angle(0,0,0), Color(255,220,180), brightness = 1, scale = 1.0 },

		-- Reverse
		[8] = { "light",			Vector(472,-41, 60), Angle(0,0,0), Color(255,0,0),     brightness = 10, scale = 1 },
		[9] = { "light",			Vector(472, 45, 60), Angle(0,0,0), Color(255,0,0),     brightness = 10, scale = 1 },
		
		-- Cabin
		[10] = { "dynamiclight",	Vector( 430, 0, 40), Angle(0,0,0), Color(255,255,255), brightness = 0.05, distance = 550 },
		
		-- Interior
		[11] = { "dynamiclight",	Vector( 200, 0, 10), Angle(0,0,0), Color(255,175,50), brightness = 3, distance = 400 , fov=180,farz = 128 },
		[12] = { "dynamiclight",	Vector(   0, 0, 10), Angle(0,0,0), Color(255,175,50), brightness = 3, distance = 400, fov=180,farz = 128 },
		[13] = { "dynamiclight",	Vector(-200, 0, 10), Angle(0,0,0), Color(255,175,50), brightness = 3, distance = 400 , fov=180,farz = 128 },
		
		-- Side lights
		[15] = { "light",			Vector(15,   69, 58.3), Angle(0,0,0), Color(150,255,255), brightness = 0.9, scale = 0.10, texture = "sprites/light_glow02.vmt" },
		[16] = { "light",			Vector(12,   69, 58.3), Angle(0,0,0), Color(50,255,0), brightness = 0.9, scale = 0.10, texture = "sprites/light_glow02.vmt" },
		[17] = { "light",			Vector(9,  69, 58.3), Angle(0,0,0), Color(255,255,0), brightness = 0.9, scale = 0.10, texture = "sprites/light_glow02.vmt" },
		
		[19] = { "light",			Vector(15,   -69, 58.3), Angle(0,0,0), Color(150,255,255), brightness = 0.9, scale = 0.10, texture = "sprites/light_glow02.vmt" },
		[20] = { "light",			Vector(12,   -69, 58.3), Angle(0,0,0), Color(50,255,0), brightness = 0.9, scale = 0.10, texture = "sprites/light_glow02.vmt" },
		[21] = { "light",			Vector(9,  -69, 58.3), Angle(0,0,0), Color(255,255,0), brightness = 0.9, scale = 0.10, texture = "sprites/light_glow02.vmt" },

	--self.Lights[22]
		--self.Lights[26]
	--self.Lights[23]

		-- Cabin texture light
		[30] = { "headlight", 		Vector(412.0,30,60), Angle(60,-50,0), Color(176,161,132), farz = 128, nearz = 1, shadows = 0, brightness = 0.20, fov = 140 },
		-- Manometers
		[31] = { "headlight", 		Vector(460.00,3,8.5), Angle(0,-90,0), Color(216,161,92), farz = 32, nearz = 1, shadows = 0, brightness = 0.4, fov = 30 },
		-- Voltmeter
		[32] = { "headlight", 		Vector(460.00,10,12.5), Angle(28,90,0), Color(216,161,92), farz = 16, nearz = 1, shadows = 0, brightness = 0.4, fov = 40 },
		-- Ampermeter
		[33] = { "headlight", 		Vector(458.05,-32.8+1.5,21.1), Angle(-90,0,0), Color(216,161,92), farz = 10, nearz = 1, shadows = 0, brightness = 4.0, fov = 60 },
		-- Voltmeter
		[34] = { "headlight", 		Vector(458.05,-32.8+1.5,24.85), Angle(-90,0,0), Color(216,161,92), farz = 10, nearz = 1, shadows = 0, brightness = 4.0, fov = 60 },

	
		-- ARS panel lights
		[40] = { "light", Vector(459.4,10.8,13.1)+vY*5.15+vX*3,				Angle(0,0,0), Color(160,255,0), brightness = 1.0, scale = 0.008 },
		[41] = { "light", Vector(459.4,10.8,13.1)+vY*5.15+vX*4.15,				Angle(0,0,0), Color(160,255,0), brightness = 1.0, scale = 0.008 },
		[42] = { "light", Vector(459.4,10.8,13.1)+vY*5.15+vX*5.4,				Angle(0,0,0), Color(255,190,0), brightness = 1.0, scale = 0.008 },
		[43] = { "light", Vector(459.4,10.8,13.1)+vY*5.17+vX*7.55,				Angle(0,0,0), Color(255,30, 0), brightness = 1.0, scale = 0.008 },
		[44] = { "light", Vector(459.4,10.8,13.1)+vY*5.19+vX*10.9,			Angle(0,0,0), Color(255,30, 0), brightness = 1.0, scale = 0.008 },
		[45] = { "light", Vector(459.4,10.8,13.1)+vY*2.61+vX*(5.42+1.09*0),	Angle(0,0,0), Color(255,30, 0), brightness = 1.0, scale = 0.008 },
		[46] = { "light", Vector(459.4,10.8,13.1)+vY*2.61+vX*(5.42+1.09*1),	Angle(0,0,0), Color(255,30, 0), brightness = 1.0, scale = 0.008 },
		[47] = { "light", Vector(459.4,10.8,13.1)+vY*2.61+vX*(5.42+1.09*2),	Angle(0,0,0), Color(255,190,0), brightness = 1.0, scale = 0.008 },
		[48] = { "light", Vector(459.4,10.8,13.1)+vY*2.61+vX*(5.42+1.09*3),	Angle(0,0,0), Color(160,255,0), brightness = 1.0, scale = 0.008 },
		[49] = { "light", Vector(459.4,10.8,13.1)+vY*2.61+vX*(5.42+1.09*4),	Angle(0,0,0), Color(160,255,0), brightness = 1.0, scale = 0.008 },
		[50] = { "light", Vector(459.4,10.8,13.1)+vY*2.61+vX*(5.42+1.09*5),	Angle(0,0,0), Color(160,255,0), brightness = 1.0, scale = 0.008 },
		[51] = { "light", Vector(459.4,10.8,13.1)+vY*(1.37+1.27*0)+vX*12.55,	Angle(0,0,0), Color(160,255,0), brightness = 1.0, scale = 0.008 },
		[52] = { "light", Vector(459.4,10.8,13.1)+vY*(1.37+1.27*1)+vX*12.56,	Angle(0,0,0), Color(160,255,0), brightness = 1.0, scale = 0.008 },
		[53] = { "light", Vector(459.4,10.8,13.1)+vY*(1.37+1.27*2)+vX*12.57,	Angle(0,0,0), Color(255,30, 0), brightness = 1.0, scale = 0.008 },
		[54] = { "light", Vector(459.4,10.8,13.1)+vY*(1.37+1.27*3)+vX*12.58,	Angle(0,0,0), Color(160,255,0), brightness = 1.0, scale = 0.008 },
		[55] = { "light", Vector(459.4,10.8,13.1)+vY*(1.37+1.27*0)+vX*15.85,	Angle(0,0,0), Color(255,30, 0), brightness = 1.0, scale = 0.008 },
		[56] = { "light", Vector(459.4,10.8,13.1)+vY*(1.37+1.27*1)+vX*15.86,	Angle(0,0,0), Color(160,255,0), brightness = 1.0, scale = 0.008 },
		[57] = { "light", Vector(459.4,10.8,13.1)+vY*(1.37+1.27*2)+vX*15.87,	Angle(0,0,0), Color(160,255,0), brightness = 1.0, scale = 0.008 },
		[58] = { "light", Vector(459.4,10.8,13.1)+vY*(1.37+1.27*3)+vX*15.88,	Angle(0,0,0), Color(160,255,0), brightness = 1.0, scale = 0.008 },		
		
		-- Interior lights
		[60+0] = { "headlight", Vector(290-130*0,0,70), Angle(90,0,0),  Color(255,255,255), farz = 150, nearz = 1, shadows = 0, brightness = 0.1, fov = 160 },
		[60+1] = { "headlight", Vector(290-130*1,0,70), Angle(90,0,0),  Color(255,255,255), farz = 150, nearz = 1, shadows = 0, brightness = 0.1, fov = 160 },
		[60+2] = { "headlight", Vector(290-130*2,0,70), Angle(90,0,0),  Color(255,255,255), farz = 150, nearz = 1, shadows = 0, brightness = 0.1, fov = 160 },
		[60+3] = { "headlight", Vector(290-130*3,0,70), Angle(90,0,0),  Color(255,255,255), farz = 150, nearz = 1, shadows = 0, brightness = 0.1, fov = 160 },
		[60+4] = { "headlight", Vector(290-130*4,0,70), Angle(90,0,0),  Color(255,255,255), farz = 150, nearz = 1, shadows = 0, brightness = 0.1, fov = 160 },
		[60+5] = { "headlight", Vector(290-130*5,0,70), Angle(90,0,0),  Color(255,255,255), farz = 150, nearz = 1, shadows = 0, brightness = 0.1, fov = 160 },
		[60+6] = { "headlight", Vector(270-230*0,0,20), Angle(-90,0,0), Color(255,255,255), farz = 120, nearz = 1, shadows = 0, brightness = 0.1, fov = 170 },
		[60+7] = { "headlight", Vector(270-230*1,0,20), Angle(-90,0,0), Color(255,255,255), farz = 120, nearz = 1, shadows = 0, brightness = 0.1, fov = 170 },
		[60+8] = { "headlight", Vector(270-230*2,0,20), Angle(-90,0,0), Color(255,255,255), farz = 120, nearz = 1, shadows = 0, brightness = 0.1, fov = 170 },
		[60+9] = { "headlight", Vector(270-230*3,0,20), Angle(-90,0,0), Color(255,255,255), farz = 120, nearz = 1, shadows = 0, brightness = 0.1, fov = 170 },
		[70    ] = { "headlight",	Vector( 430, -60, -47), Angle(45,-90,0), Color(255,255,255), brightness = 0.5, distance = 400 , fov=120, shadows = 1 },
		
		--[[2-2
		[97] = { "headlight",		Vector(465,-45,-19), Angle(0,-20,0), Color(216,161,92), fov = 70 },
		[98] = { "headlight",		Vector(465,45,-19), Angle(0,20,0), Color(216,161,92), fov = 70 },
		1-4-1
		2-2-2
		1-3-1
		[97] = { "headlight",		Vector(460,-45,-10), Angle(-5,-20,0), Color(216,161,92), fov = 70 },
		[98] = { "headlight",		Vector(465,0,-10), Angle(-5,0,0), Color(216,161,92), fov = 70 },
		[99] = { "headlight",		Vector(460,45,-10), Angle(-5,20,0), Color(216,161,92), fov = 70 },
		]]
	}
	-- Cross connections in train wires
	self.TrainWireCrossConnections = {
		[5] = 4, -- Reverser F<->B
		[31] = 32, -- Doors L<->R
	}
	
	-- Setup door positions
	self.LeftDoorPositions = {}
	self.RightDoorPositions = {}
	for i=0,3 do
		table.insert(self.LeftDoorPositions,Vector(353.0 - 35*0.5 - 231*i,65,-1.8))
		table.insert(self.RightDoorPositions,Vector(353.0 - 35*0.5 - 231*i,-65,-1.8))
	end
	
	-- KV wrench mode
	self.KVWrenchMode = 0
	
	self.KVPType = self.KVPType or 0+math.floor(math.random()*4+1.5)
	if self.KVPType == 1 then self.KVPType = 0 end
	-- BPSN type
	self.BPSNType = self.BPSNType or 2+math.floor(Metrostroi.PeriodRandomNumber()*7+0.5)
	self:SetNW2Int("BPSNType",self.BPSNType)
	self:SetNW2Int("KVPType",self.KVPType)

	self.Blok = 1
	self:SetNW2Int("Blok",1)

	self.RearDoor = false
	self.FrontDoor = false
	self.CabinDoor = false
	self.PassengerDoor = false

	self.OldTexture = 0
	self.LampsBlink = {}
	self.Lamps = {}
	self.BrokenLamps = {}
	local rand = math.random() > 0.5 and 1 or math.random(0.93,0.99)
	for i = 1,23 do
		if math.random() > rand then self.BrokenLamps[i] = math.random() > 0.5 end
	end

	self:UpdateTextures()
end

function ENT:UpdateTextures()
	local texture = Metrostroi.Skins["train"][self.Texture]
	local passtexture = Metrostroi.Skins["pass"][self.PassTexture]
	local cabintexture = Metrostroi.Skins["cab"][self.CabTexture]

	for k,v in pairs(self:GetMaterials()) do
		self:SetSubMaterial(k-1,"")
	end
	local cab = self.Blok == 5 and "ptv" or self.Blok == 4 and "paksdm" or self.Blok == 3 and "pam" or self.Blok == 2 and "paksd" or "puav"
	for k,v in pairs(self:GetMaterials()) do
		if v == "models/metrostroi_train/81/int02" then
			if not Metrostroi.Skins["717_schemes"] or not Metrostroi.Skins["717_schemes"]["p"] then
				self:SetSubMaterial(k-1,Metrostroi.Skins["717_schemes"][""])
			else
				if not self.Adverts or self.Adverts ~= 4 then
					self:SetSubMaterial(k-1,Metrostroi.Skins["717_schemes"]["p"].adv)
				else
					self:SetSubMaterial(k-1,Metrostroi.Skins["717_schemes"]["p"].clean)
				end
			end
		end
		local tex = string.Explode("/",v)
		tex = tex[#tex]
		if cabintexture and cabintexture.textures[cab][tex] then
			self:SetSubMaterial(k-1,cabintexture.textures[cab][tex])
		end
		if passtexture and passtexture.textures[tex] then
			self:SetSubMaterial(k-1,passtexture.textures[tex])
		end
		if texture and texture.textures[tex] then
			self:SetSubMaterial(k-1,texture.textures[tex])
		end
	end
	self:SetNW2Int("Blok",(self.Blok or 1))
	self:SetNW2Bool("Breakers",(self.Breakers or 0) > 0)
	self:SetNW2Int("LampType",(self.LampType or 1))
	self:SetNW2Bool("BPSNBuzzType",self.PNM)
	self:SetNW2String("texture",self.Texture)
	self:SetNW2String("passtexture",self.PassTexture)
	self:SetNW2String("cabtexture",self.CabTexture)
end


	self:SetBodygroup(1,(self.Breakers or 0))
	self:SetBodygroup(2,math.min(3,self.Adverts or 1)-1)
	self:SetBodygroup(3,2)
	self:SetBodygroup(4,(self.LampType or 1)-1)
	self:SetBodygroup(5,6)
	self:SetBodygroup(6,(self.MaskType or 1)-1)
	self:SetBodygroup(7,(self.SeatType or 1)-1)
	self:SetBodygroup(8,(self.HandRail or 1)-1)
	self:SetBodygroup(9,2)
	self:SetBodygroup(10,(self.BortLampType or 1)-1)
	self:SetBodygroup(12,0)
	self:SetBodygroup(13,1-(self.Lighter or 0))
	self:SetBodygroup(16,2-self.Pneumatic.ValveType)
	self:SetBodygroup(17,self.Blok)
	self:SetBodygroup(18,1)
	--self:SetSubMaterial(0,"metrostroi_skins/81-717/6.pnqw")
	--PrintTable(self:GetMaterials())
	--print(self.DeltaTime)
	--print(self.SpeedSign)
	--if not self.SpeedSign then return end

	--print(self.Panel["HeadLights1"])
	--if not self.Panel["HeadLights1"] then return end
	self.RetVal = self.BaseClass.Think(self)
	-- Check if wrench was pulled out
	

	-- Set wrench sounds

	
	-- Headlights
	local brightness = self.Panel["HeadLights1"] and (math.min(1,self.Panel["HeadLights1"])*0.50 + 
						math.min(1,self.Panel["HeadLights2"])*0.25 + 
						math.min(1,self.Panel["HeadLights3"])*0.25)
						or 0
	self:SetLightPower(1,self.Panel["HeadLights3"] and (self.Panel["HeadLights3"] > 0.5 or self.Panel["HeadLights1"] > 0.5) and (self.L_4.Value > 0.5),brightness*self.WorkingLights/6)
	
	if self.LED and self.Lights[1][4] ~= Color(127,255,255) then
		for i = 1,7 do self:SetLightPower(i,false) end
		self.Lights[1][4] = Color(127,255,255)
		for i = 2,7 do
			self.Lights[i][4] = Color(127,255,255)
			self.Lights[i]["brightness"] = 5
			self.Lights[i]["scale"] = 2.0
		end
	end
	if not self.LED and self.Lights[1][4] ~= Color(216,161,92) then
		for i = 1,7 do self:SetLightPower(i,false) end
		self.Lights[1][4] = Color(216,161,92)
		for i = 2,7 do
			self.Lights[i][4] = Color(255,220,180)
			self.Lights[i]["brightness"] = 1
			self.Lights[i]["scale"] = 1.0
		end
	end
	if self.MaskType == 1 and self.Lights[4][2] ~= Vector(467,-7, -19) then
		for i = 1,7 do self:SetLightPower(i,false) end
		 self.Lights[2][2] = Vector(465,-50,-19)
		 self.Lights[3][2] = Vector(467,-19,-19)
		 self.Lights[4][2] = Vector(467,-7, -19)
		 self.Lights[5][2] = Vector(467, 7, -19)
		 self.Lights[6][2] = Vector(467, 19,-19)
		 self.Lights[7][2] = Vector(465, 52,-19)
		 self.WorkingLights = 6
	end
	if self.MaskType == 2 and self.Lights[4][2] ~= Vector(467,-4, -19) then
		for i = 1,7 do self:SetLightPower(i,false) end
		 self.Lights[2][2] = Vector(467,-51,-19)
		 self.Lights[3][2] = Vector(467,-38, -19)
		 self.Lights[4][2] = Vector(467,-4, -19)
		 self.Lights[5][2] = Vector(467, 6, -19)
		 self.Lights[6][2] = Vector(467, 38, -19)
		 self.Lights[7][2] = Vector(467, 51,-19)
		 self.WorkingLights = 6
	end
	if self.MaskType == 3 and (self.Lights[3][2] ~= Vector(467,-38, -19) or self.Lights[4][2] ~= Vector(0,0, 0)) then
		for i = 1,7 do self:SetLightPower(i,false) end
		 self.Lights[2][2] = Vector(467,-51,-19)
		 self.Lights[3][2] = Vector(467,-38, -19)
		 self.Lights[4][2] = Vector(0,0, 0)
		 self.Lights[5][2] = Vector(0, 0, 0)
		 self.Lights[6][2] = Vector(467, 38, -19)
		 self.Lights[7][2] = Vector(467, 51,-19)
		 self.WorkingLights = 4
	end
	if self.MaskType == 4 and self.Lights[4][2] ~= Vector(467,-4, 58) then
		for i = 1,7 do self:SetLightPower(i,false) end
		 self.Lights[2][2] = Vector(467,-51,-19)
		 self.Lights[3][2] = Vector(467,-38, -19)
		 self.Lights[4][2] = Vector(467,-4, 58)
		 self.Lights[5][2] = Vector(467, 6, 58)
		 self.Lights[6][2] = Vector(467, 38, -19)
		 self.Lights[7][2] = Vector(467, 51,-19)
		 self.WorkingLights = 6
	end
	if self.MaskType == 5 and self.Lights[4][2] ~= Vector(467,1, -19) then
		for i = 1,7 do self:SetLightPower(i,false) end
		 self.Lights[2][2] = Vector(465,-50,-19)
		 self.Lights[3][2] = Vector(467,-12,-19)
		 self.Lights[4][2] = Vector(467,1, -19)
		 self.Lights[5][2] = Vector(467, 12, -19)
		 self.Lights[6][2] = Vector(0, 0,0)
		 self.Lights[7][2] = Vector(465, 52,-19)
		 self.WorkingLights = 6
	end
	if self.Panel["HeadLights1"] and self.Panel["HeadLights2"] then
		if self.MaskType == 1 then
				self:SetLightPower(2, (self.Panel["HeadLights2"] > 0.5) and (self.L_4.Value > 0.5))
				self:SetLightPower(3, (self.Panel["HeadLights1"] > 0.5) and (self.L_4.Value > 0.5))
				self:SetLightPower(4,  (self.Panel["HeadLights1"] > 0.5) and (self.L_4.Value > 0.5))
				self:SetLightPower(5,  (self.Panel["HeadLights2"] > 0.5) and (self.L_4.Value > 0.5))
				self:SetLightPower(6, (self.Panel["HeadLights1"] > 0.5) and (self.L_4.Value > 0.5))
				self:SetLightPower(7, (self.Panel["HeadLights2"] > 0.5) and (self.L_4.Value > 0.5))
		end
		if self.MaskType == 2 then
				self:SetLightPower(2, (self.Panel["HeadLights2"] > 0.5) and (self.L_4.Value > 0.5))
				self:SetLightPower(3, (self.Panel["HeadLights1"] > 0.5) and (self.L_4.Value > 0.5))
				self:SetLightPower(4,  (self.Panel["HeadLights2"] > 0.5) and (self.L_4.Value > 0.5))
				self:SetLightPower(5,  (self.Panel["HeadLights1"] > 0.5) and (self.L_4.Value > 0.5))
				self:SetLightPower(6, (self.Panel["HeadLights1"] > 0.5) and (self.L_4.Value > 0.5))
				self:SetLightPower(7, (self.Panel["HeadLights2"] > 0.5) and (self.L_4.Value > 0.5))
		end
		if self.MaskType == 3 then
				self:SetLightPower(2, (self.Panel["HeadLights2"] > 0.5) and (self.L_4.Value > 0.5))
				self:SetLightPower(3, (self.Panel["HeadLights1"] > 0.5) and (self.L_4.Value > 0.5))
				self:SetLightPower(4,  false)
				self:SetLightPower(5,  false)
				self:SetLightPower(6, (self.Panel["HeadLights1"] > 0.5) and (self.L_4.Value > 0.5))
				self:SetLightPower(7, (self.Panel["HeadLights2"] > 0.5) and (self.L_4.Value > 0.5))
		end
		if self.MaskType == 4 then
				self:SetLightPower(2, (self.Panel["HeadLights2"] > 0.5) and (self.L_4.Value > 0.5))
				self:SetLightPower(3, (self.Panel["HeadLights1"] > 0.5) and (self.L_4.Value > 0.5))
				self:SetLightPower(4,  (self.Panel["HeadLights2"] > 0.5) and (self.L_4.Value > 0.5))
				self:SetLightPower(5,  (self.Panel["HeadLights1"] > 0.5) and (self.L_4.Value > 0.5))
				self:SetLightPower(6, (self.Panel["HeadLights1"] > 0.5) and (self.L_4.Value > 0.5))
				self:SetLightPower(7, (self.Panel["HeadLights2"] > 0.5) and (self.L_4.Value > 0.5))
		end
		if self.MaskType == 5 then
				self:SetLightPower(2, (self.Panel["HeadLights2"] > 0.5) and (self.L_4.Value > 0.5))
				self:SetLightPower(3, (self.Panel["HeadLights1"] > 0.5) and (self.L_4.Value > 0.5))
				self:SetLightPower(4,  (self.Panel["HeadLights1"] > 0.5) and (self.L_4.Value > 0.5))
				self:SetLightPower(5,  (self.Panel["HeadLights1"] > 0.5) and (self.L_4.Value > 0.5))
				self:SetLightPower(6, false)
				self:SetLightPower(7, (self.Panel["HeadLights2"] > 0.5) and (self.L_4.Value > 0.5))
		end
	end

	-- Reverser lights
	self:SetLightPower(8, self.Panel["RedLightRight"] > 0.5)
	self:SetLightPower(9, self.Panel["RedLightLeft"] > 0.5)
	
	-- Interior/cabin lights
	self:SetLightPower(10,(self.Panel["CabinLight"] > 0.5) and (self.L_2.Value > 0.5))
	self:SetLightPower(30, (self.Panel["CabinLight"] > 0.5), 0.03 + 0.97*self.L_2.Value)
	
	local lightsActive1 = (self.Battery.Voltage > 55.0 and self.Battery.Voltage < 85.0) and
		((self:ReadTrainWire(33) > 0) or (self:ReadTrainWire(34) > 0))
	local lightsActive2 = (self.PowerSupply.LightsActive > 0.0) and
		(self:ReadTrainWire(33) > 0)
	local mul = 0
	local LampCount  = (self.LampType == 1 and 23 or 12)
	for i = 1,LampCount do
		local Ip = self.LampType == 1 and 6 or 3
		if (lightsActive2 or (lightsActive1 and (i+Ip-2)%Ip==1)) then
			if not self.BrokenLamps[i]  and not self.LampsBlink[i] then self.LampsBlink[i] = CurTime() + math.random() end
			if self.BrokenLamps[i] == nil and self.LampsBlink[i] and CurTime() - self.LampsBlink[i] > 0 and not self.Lamps[i] then self.Lamps[i] = CurTime() + math.random()*4 end
		else
			self.LampsBlink[i] = nil
			self.Lamps[i] = nil
		end
		if (self.Lamps[i] and CurTime() - self.Lamps[i] > 0) then
			mul = mul + 1
		elseif (self.LampsBlink[i] and CurTime() - self.LampsBlink[i] > 0) then
			mul = mul + 0.5
		end
		self:SetPackedBool("lightsActive"..i,(self.Lamps[i] and CurTime() - self.Lamps[i] > 0) or false)
		self:SetPackedBool("lightsActiveB"..i,(self.LampsBlink[i] and CurTime() - self.LampsBlink[i] > 0) or false)
	end
	self:SetLightPower(11, mul > 0,mul/LampCount)
	self:SetLightPower(12, mul > 0,mul/LampCount)
	self:SetLightPower(13, mul > 0,mul/LampCount)

	self:SetLightPower(31, (self.Panel["CabinLight"] > 0.5) and (self.L_3.Value > 0.5))
	self:SetLightPower(32, (self.Panel["CabinLight"] > 0.5) and (self.L_3.Value > 0.5))
	self:SetLightPower(33, (self.Panel["CabinLight"] > 0.5) and (self.L_3.Value > 0.5))
	self:SetLightPower(34, (self.Panel["CabinLight"] > 0.5) and (self.L_3.Value > 0.5))

	-- Door button lights
	self:SetPackedBool("Left",(self.Panel["HeadLights2"] > 0.5) and (self.DoorSelect.Value == 0) and self:ReadTrainWire(16) < 1)
	self:SetPackedBool("Right",(self.Panel["HeadLights2"] > 0.5) and (self.DoorSelect.Value == 1) and self:ReadTrainWire(16) < 1)
	self:SetPackedBool("KDLK",self.KDLK.Value > 0)
	self:SetPackedBool("KDLRK",self.KDLRK.Value > 0)
	self:SetPackedBool("KDPK",self.KDPK.Value > 0)
	self:SetPackedBool("KAHK",self.KAHK.Value > 0)
	if not self.Blok or self.Blok == 1 then
		self:SetPackedBool("W16",self:ReadTrainWire(16) > 0)
		self:SetPackedBool("ARS",self.ALS_ARS.EnableARS)
		self:SetPackedBool("AVT",self.Autodrive.AutodriveEnabled)
		self:SetPackedBool("LOS",self.RC1.Value < 0.5 and not self.ALS_ARS.EnableARS and self.KV.ReverserPosition ~= 0.0)
		self:SetPackedBool("KH",self.KH.Value > 0.5)
		self:SetPackedBool("VAV",self.VAV.Value > 0.5)
		self:SetPackedBool("P1",self.P1.Value > 0.5)
		self:SetPackedBool("P2",self.P2.Value > 0.5)
		self:SetPackedBool("P3",self.P3.Value > 0.5)
		self:SetPackedBool("P4",self.P4.Value > 0.5)
		self:SetPackedBool("P5",self.P5.Value > 0.5)
	end
	--self:SetLightPower(27,(self.Panel["HeadLights2"] > 0.5) and (self.DoorSelect.Value == 0) and (self.ARSType < 3 or self.ARSType == 3 and self:ReadTrainWire(16) < 1))
	--self:SetLightPower(28,(self.Panel["HeadLights2"] > 0.5) and (self.DoorSelect.Value == 0) and (self.ARSType < 3 or self.ARSType == 3 and self:ReadTrainWire(16) < 1))
	--self:SetLightPower(29,(self.Panel["HeadLights2"] > 0.5) and (self.DoorSelect.Value == 1) and (self.ARSType < 3 or self.ARSType == 3 and self:ReadTrainWire(16) < 1))
	if self.BortLampType == 1 and self.Lights[19][2] ~=  Vector(15,   -69, 58.3) then
		for i = 0,2 do self:SetLightPower(15+i,false) end
		for i = 0,2 do self:SetLightPower(19+i,false) end
		self.Lights[15][2] = Vector(15,   69, 58.3)
		self.Lights[16][2] = Vector(12,   69, 58.3)
		self.Lights[17][2] = Vector(9,  69, 58.3)
                                     
		self.Lights[19][2] = Vector(15,   -69, 58.3)
		self.Lights[20][2] = Vector(12,   -69, 58.3)
		self.Lights[21][2] = Vector(9,  -69, 58.3)
	end
	if self.BortLampType == 2 and self.Lights[19][2] ~= Vector(41.8,   -69, 55.8)then
		for i = 0,2 do self:SetLightPower(15+i,false) end
		for i = 0,2 do self:SetLightPower(19+i,false) end
		self.Lights[15][2] = Vector(-48.0,   69, 55.8)
		self.Lights[16][2] = Vector(-48.0,   69, 53.7)
		self.Lights[17][2] = Vector(-48.0,  69, 50.2)

		self.Lights[19][2] = Vector(41.8,   -69, 55.8)
		self.Lights[20][2] = Vector(41.8,   -69, 53.7)
		self.Lights[21][2] = Vector(41.8,  -69, 50.2)
	end
	-- Side lights
	self:SetLightPower(15, self.Panel["TrainDoors"] > 0.5)
	self:SetLightPower(19, self.Panel["TrainDoors"] > 0.5)
	
	self:SetLightPower(16, self.Panel["GreenRP"] > 0.5)
	self:SetLightPower(20, self.Panel["GreenRP"] > 0.5)
	
	self:SetLightPower(17, self.Panel["TrainBrakes"] > 0.5)
	self:SetLightPower(21, self.Panel["TrainBrakes"] > 0.5)
	self:SetPackedBool("PN", self.Panel["TrainBrakes"] > 0.5)
	local OhrSigWork = false
	for k,v in pairs(self.WagonList) do
		if v.OhrSig and v.OhrSig.Value > 0 then OhrSigWork = true break end
	end
	self.Panel.OhrSig = 0
	for k,v in pairs(self.WagonList) do
		if v.PassengerDoor then self.Panel.OhrSig = 1 end
	end
