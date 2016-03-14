AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.BogeyDistance = 650 -- Needed for gm trainspawner

ENT.SubwayTrain = {
	Type = "81",
	Name = "81-714.5m",
	Manufacturer = "LVZ",
	WagType = 2,
}
function ENT:Initialize()
	if self.FrontBogey then
		
	--DISTANCES
	--0.774
	--WHEELS:81 2.05 --2.66
	--TRAIN:755 19.17 24.79
	--89 2.26 2.92
	--171 4.34 5.61
	--584 14.83 19.17
	--666 16.91 21.84
	end
	self.MaskType = 1
	self.LampType = 1

	-- Set model and initialize
	self:SetModel("models/metrostroi_train/81/81-714.mdl")
	self.BaseClass.Initialize(self)
	self:SetPos(self:GetPos() + Vector(0,0,140))
	
	-- Create seat entities
	self.DriverSeat = self:CreateSeat("driver",Vector(415+16,0,-48+2.5+6),Angle(0,90,0),"models/vehicles/prisoner_pod_inner.mdl")
	--self.InstructorsSeat = self:CreateSeat("instructor",Vector(430,47,-27+2.5),Angle(0,-90,0))

	-- Hide seats
	self.DriverSeat:SetColor(Color(0,0,0,0))
	self.DriverSeat:SetRenderMode(RENDERMODE_TRANSALPHA)
	--self.InstructorsSeat:SetColor(Color(0,0,0,0))
	--self.InstructorsSeat:SetRenderMode(RENDERMODE_TRANSALPHA)

	-- Create bogeys
	self.FrontBogey = self:CreateBogey(Vector( 317-5,0,-75),Angle(0,180,0),true)
	self.RearBogey  = self:CreateBogey(Vector(-317+0,0,-75),Angle(0,0,0),false)

	-- Initialize key mapping
	self.KeyMap = {
		[KEY_8] = "KRPSet",
		[KEY_G] = "VozvratRPSet",
	
		[KEY_0] = "PMPUp",
		[KEY_9] = "PMPDown",
		[KEY_F] = "PneumaticBrakeUp",
		[KEY_R] = "PneumaticBrakeDown",
		[KEY_PAD_PLUS] = "PMPUp",
		[KEY_PAD_MINUS] = "PMPDown",
		[KEY_PAD_1] = "PneumaticBrakeSet1",
		[KEY_PAD_2] = "PneumaticBrakeSet2",
		[KEY_PAD_3] = "PneumaticBrakeSet3",
		[KEY_PAD_4] = "PneumaticBrakeSet4",
		[KEY_PAD_5] = "PneumaticBrakeSet5",
		[KEY_PAD_6] = "PneumaticBrakeSet6",
		[KEY_PAD_7] = "PneumaticBrakeSet7",
		[KEY_PAD_DIVIDE] = "KRPSet",
		[KEY_PAD_0] = "DriverValveDisconnectToggle",
		
		[KEY_LSHIFT] = {
			[KEY_L] = "DriverValveDisconnectToggle",
			
			--[KEY_7] = "KVWrenchNone",
			--[KEY_8] = "KVWrenchKRU",
			--[KEY_9] = "KVWrenchKV",
			--[KEY_0] = "KVWrench0",
		},
		
		[KEY_RSHIFT] = {
			--[KEY_7] = "KVWrenchNone",
			--[KEY_8] = "KVWrenchKRU",
			--[KEY_9] = "KVWrenchKV",
			--[KEY_0] = "KVWrench0",
			[KEY_L] = "DriverValveDisconnectToggle",
		},
	}
	
	
	self.InteractionZones = {
		--[[
		{	Pos = Vector(460,-26,-47),
			Radius = 16,
			ID = "FrontBrakeLineIsolationToggle" },
		{	Pos = Vector(460, 21, -49),
			Radius = 16,
			ID = "FrontTrainLineIsolationToggle" },
		{	Pos = Vector(460, 52,-41),
			Radius = 16,
			ID = "ParkingBrakeToggle" },
		{	Pos = Vector(-482,-30,-55),
			Radius = 16,
			ID = "RearBrakeLineIsolationToggle" },
		{	Pos = Vector(-469, 23, -48),
			Radius = 16,
			ID = "RearTrainLineIsolationToggle" },
		{	Pos = Vector(122, 61, -53),
			Radius = 16,
			ID = "GVToggle" },
		{	Pos = Vector(437, 0, 63),
			Radius = 30,
			ID = "VBToggle" },
		{	Pos = Vector(-180,61,-53),
			Radius = 20,
			ID = "AirDistributorDisconnectToggle" },
		]]
		{	Pos = Vector(-475, -25, 20),
			Radius = 32,
			ID = "1:RearDoor" },
		{	Pos = Vector(-475, -25, -11),
			Radius = 32,
			ID = "2:RearDoor" },
		{	Pos = Vector(468, 25, 20),
			Radius = 32,
			ID = "1:FrontDoor" },
		{	Pos = Vector(468, 25, -11),
			Radius = 32,
			ID = "2:FrontDoor" },
	}

	-- Lights
	self.Lights = {
		-- Headlight glow
		[1] = { "headlight",		Vector(465,0,-20), Angle(0,0,0), Color(216,161,92), fov = 100 },
		-- Headlight glow ДУВ
		[110] = { "headlight",		Vector(465,0,-20), Angle(0,0,0), Color(127,255,255), fov = 100 },
		
		-- Head (type 1)
		[2] = { "glow",				Vector(470,-51,-19), Angle(0,0,0), Color(255,220,180), brightness = 1, scale = 1.0 },
		[3] = { "glow",				Vector(472,-40, -19), Angle(0,0,0),Color(255,220,180), brightness = 1, scale = 1.0 },
		[4] = { "glow",				Vector(0,0, 0), Angle(0,0,0),  Color(255,220,180), brightness = 1, scale = 1.0 },
		[5] = { "glow",				Vector(0, 0, 0), Angle(0,0,0),  Color(255,220,180), brightness = 1, scale = 1.0 },
		[6] = { "glow",				Vector(472, 41, -19), Angle(0,0,0),Color(255,220,180), brightness = 1, scale = 1.0 },
		[7] = { "glow",				Vector(470, 53,-19), Angle(0,0,0), Color(255,220,180), brightness = 1, scale = 1.0 },

		-- Reverse
		[8] = { "light",			Vector(478,-44, 60), Angle(0,0,0), Color(255,0,0),     brightness = 10, scale = 1.0 },
		[9] = { "light",			Vector(478, 44, 60), Angle(0,0,0), Color(255,0,0),     brightness = 10, scale = 1.0 },
		
		-- Cabin
		[10] = { "dynamiclight",	Vector( 440, 0, 40), Angle(0,0,0), Color(255,255,255), brightness = 0.1, distance = 550 },
		
		-- Interior
		[11] = { "dynamiclight",	Vector( 270, 0, 5), Angle(0,0,0), Color(255,220,180), brightness = 3, distance = 400 },
		[12] = { "dynamiclight",	Vector(   00, 0, 5), Angle(0,0,0), Color(255,220,180), brightness = 3, distance = 400 },
		[13] = { "dynamiclight",	Vector(-350, 0, 5), Angle(0,0,0), Color(255,220,180), brightness = 3, distance = 400 },
		
		-- Side lights
		[14] = { "light",			Vector(-50, 68, 69.5), Angle(0,0,0), Color(255,0,0), brightness = 0.9, scale = 0.10, texture = "sprites/light_glow02.vmt" },
		[15] = { "light",			Vector(15.2,   69, 59.5), Angle(0,0,0), Color(150,255,255), brightness = 0.9, scale = 0.10, texture = "sprites/light_glow02.vmt" },
		[16] = { "light",			Vector(12,   69, 59.5), Angle(0,0,0), Color(50,255,0), brightness = 0.9, scale = 0.10, texture = "sprites/light_glow02.vmt" },
		[17] = { "light",			Vector(9,  69, 59.5), Angle(0,0,0), Color(255,255,0), brightness = 0.9, scale = 0.10, texture = "sprites/light_glow02.vmt" },
		
		[18] = { "light",			Vector(-50, -69, 59.5), Angle(0,0,0), Color(255,0,0), brightness = 0.9, scale = 0.10, texture = "sprites/light_glow02.vmt" },
		[19] = { "light",			Vector(15,   -69, 59.5), Angle(0,0,0), Color(150,255,255), brightness = 0.9, scale = 0.10, texture = "sprites/light_glow02.vmt" },
		[20] = { "light",			Vector(12,   -69, 59.5), Angle(0,0,0), Color(50,255,0), brightness = 0.9, scale = 0.10, texture = "sprites/light_glow02.vmt" },
		[21] = { "light",			Vector(9,  -69, 59.5), Angle(0,0,0), Color(255,255,0), brightness = 0.9, scale = 0.10, texture = "sprites/light_glow02.vmt" },

		-- Green RP
		[22] = { "light",			Vector(461,12.75+1.5-9.6,-0.8), Angle(0,0,0), Color(0,255,0), brightness = 1.0, scale = 0.020 },
		-- AVU
		[23] = { "light",			Vector(463.0,12.6+1.5-20.3,1.15), Angle(0,0,0), Color(255,40,0), brightness = 1.0, scale = 0.020 },
		-- LKVP
		[24] = { "light",			Vector(463.0,12.6+1.5-23.1,1.15), Angle(0,0,0), Color(255,160,0), brightness = 1.0, scale = 0.020 },
	}
	for i = 1,23 do
		self.Lights[69+i] = { "light", Vector(-470 + 35.8*i, 0, 70), Angle(180,0,0), Color(255,220,180), brightness = 1, scale = 0.75}
	end

	
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
	
	-- BPSN type
	self.BPSNType = self.BPSNType or 2+math.floor(Metrostroi.PeriodRandomNumber()*7+0.5)
	self:SetNW2Int("BPSNType",self.BPSNType)
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

	for k,v in pairs(self:GetMaterials()) do
		self:SetSubMaterial(k-1,"")
	end
	local cab = self.Blok == 4 and "paksdm" or self.Blok == 3 and "pam" or self.Blok == 2 and "paksd" or "puav"
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
		if passtexture and passtexture.textures[tex] then
			self:SetSubMaterial(k-1,passtexture.textures[tex])
		end
		if texture and texture.textures[tex] then
			self:SetSubMaterial(k-1,texture.textures[tex])
		end
	end
	self:SetNW2Int("LampType",(self.LampType or 1))
	self:SetNW2Bool("BPSNBuzzType",self.PNM)
	self:SetNW2String("texture",self.Texture)
	self:SetNW2String("passtexture",self.PassTexture)
end

function ENT:CreateJointSound(sndnum)
	table.insert(self.Joints,{type = sndnum,state = self.SpeedSign > 0 and 0 or 4,dist = self.SpeedSign > 0 and 0 or 19.17})
end
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
function ENT:OnCouple(train,isfront)
	self.BaseClass.OnCouple(self,train,isfront)
	
	if isfront then
		self.FrontBrakeLineIsolation:TriggerInput("Open",1.0)
		self.FrontTrainLineIsolation:TriggerInput("Open",1.0)
	else
		self.RearBrakeLineIsolation:TriggerInput("Open",1.0)
		self.RearTrainLineIsolation:TriggerInput("Open",1.0)
	end
end
function ENT:OnButtonPress(button)
	if button:find(":") then
		button = string.Explode(":",button)[2]
	end
	if string.find(button,"PneumaticBrakeSet") then
		self.Pneumatic:TriggerInput("BrakeSet",tonumber(button:sub(-1,-1)))
		return
	end
	if button == "FrontDoor" then
		self.FrontDoor = not self.FrontDoor
		if self.FrontDoor then self:PlayOnce("door_open_tor") else self:PlayOnce("door_close_tor") end
	end
	if button == "RearDoor" then
		self.RearDoor = not self.RearDoor
		if self.RearDoor then self:PlayOnce("door_open_tor") else self:PlayOnce("door_close_tor") end
	end
	if button == "AirDistributorDisconnectToggle" then return end
	if button == "GVToggle" then
		if self.GV.Value > 0.5 then
			--self:PlayOnce("revers_f",nil,0.7)
		else
			--self:PlayOnce("revers_b",nil,0.7)
		end
		return
	end
	if (button == "VUToggle") or ((string.sub(button,1,1) == "A") and (tonumber(string.sub(button,2,2)))) then
		local name = string.sub(button,1,(string.find(button,"Toggle") or 0)-1)
		if self[name] then
			if self[name].Value > 0.5 then
				--self:PlayOnce("av_off","cabin")
			else
				--self:PlayOnce("av_on","cabin")
			end
		end
		return
	end
	
	if button == "DriverValveDisconnectToggle" then
		if self.DriverValveDisconnect.Value == 1.0 then
			if self.Pneumatic.ValveType == 2 then
				self:PlayOnce("pneumo_disconnect2","cabin",0.9)
			end
		else
			self:PlayOnce("pneumo_disconnect1","cabin",0.9)
		end
		return
	end
	if string.find(button,"PneumaticBrakeSet") then
		self.Pneumatic:TriggerInput("BrakeSet",tonumber(button:sub(-1,-1)))
		return
	end
	if (not string.find(button,"KVT")) and string.find(button,"KV") then return end
	if string.find(button,"KRU") then return end
	

	if button == "VBToggle" then 
		if self.VUD1.Value > 0.5 then
			--self:PlayOnce("vu22_off","cabin")
		else
			--self:PlayOnce("vu22_on","cabin")
		end
		return
	end
	-- Generic button or switch sound
	if string.find(button,"Set") then
		--self:PlayOnce("button_press","cabin")
	end
	if string.find(button,"Toggle") then
		--self:PlayOnce("switch2","cabin",0.7)
	end
end

function ENT:OnButtonRelease(button)
	if button:find(":") then
		button = string.Explode(":",button)[2]
	end
	if string.find(button,"PneumaticBrakeSet") then
		return
	end
	if (button == "PneumaticBrakeDown") and (self.Pneumatic.DriverValvePosition == 1) then
		self.Pneumatic:TriggerInput("BrakeSet",2)
	end	
	if self.Pneumatic.ValveType == 1 then
		if (button == "PneumaticBrakeUp") and (self.Pneumatic.DriverValvePosition == 5) then
			self.Pneumatic:TriggerInput("BrakeSet",4)
		end
	end

	if (not string.find(button,"KVT")) and string.find(button,"KV") then return end
	if string.find(button,"KRU") then return end

	if string.find(button,"Set") then
		--self:PlayOnce("button_release","cabin")
	end
end