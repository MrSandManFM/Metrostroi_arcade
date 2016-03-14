include("shared.lua")


--------------------------------------------------------------------------------
ENT.ClientProps = {}
ENT.ButtonMap = {}

--------------------------------------------------------------------------------
-- Add doors
local function GetDoorPosition(i,k,j)
	if j == 0 
	then return Vector(359.0 - 35.0*k     - 229.5*i,-65*(1-2*k),7.5)
	else return Vector(359.0 - 35.0*(1-k) - 229.5*i,-65*(1-2*k),7.5)
	end
end
for i=0,3 do
	for k=0,1 do
		ENT.ClientProps["door"..i.."x"..k.."a"] = {
			model = "models/metrostroi_train/81/leftdoor2.mdl",
			pos = GetDoorPosition(i,k,0),
			ang = Angle(0,90 +180*k,0)
		}
		ENT.ClientProps["door"..i.."x"..k.."b"] = {
			model = "models/metrostroi_train/81/leftdoor1.mdl",
			pos = GetDoorPosition(i,k,1),
			ang = Angle(0,90 +180*k,0)
		}
	end
end
--24.2 0.2 5.3
ENT.ClientProps["door1"] = {
	model = "models/metrostroi_train/81/frontdoor.mdl",
	pos = Vector(463.0,-16.2,6),
	ang = Angle(0,-90,0)
}
ENT.ClientProps["door2"] = {
	model = "models/metrostroi_train/81/backdoor.mdl",
	pos = Vector(-469.0,16.2,6),
	ang = Angle(0,-90,0)
}

for i = 1,25 do
	ENT.ClientProps["lamp1_"..i] = {
		model = "models/metrostroi_train/81/lamp1.mdl",
		pos = Vector(-455.8 + 34.801*i, 0, 76.9),
		ang = Angle(180,0,0),
		color = Color(255,175,100),
	}
end
for i = 1,13 do
	ENT.ClientProps["lamp2_"..i] = {
		model = "models/metrostroi_train/81/lamp2.mdl",
		pos = Vector(-466 + 66.12*i, 0, 76.7),
		ang = Angle(180,0,0),
		color = Color(240,240,255),
	}
	ENT.ClientProps["lamp3_"..i] = {
		model = "models/metrostroi_train/81/lamp3.mdl",
		pos = Vector(-466 + 66.12*i, 0, 77.5),
		ang = Angle(180,0,0),
	}
end
ENT.RearDoor = 0
ENT.FrontDoor = 0
--------------------------------------------------------------------------------

function ENT:UpdateTextures()
	local texture = Metrostroi.Skins["train"][self:GetNW2String("texture")]
	local passtexture = Metrostroi.Skins["pass"][self:GetNW2String("passtexture")]
	local cabintexture = Metrostroi.Skins["cab"][self:GetNW2String("cabtexture")]
	for _,self in pairs(self.ClientEnts) do
		if not IsValid(self) then continue end
		for k,v in pairs(self:GetMaterials()) do
			local tex = string.Explode("/",v)
			tex = tex[#tex]
			if cabintexture and cabintexture.textures[tex] then
				self:SetSubMaterial(k-1,cabintexture.textures[tex])
			end
			if passtexture and passtexture.textures[tex] then
				self:SetSubMaterial(k-1,passtexture.textures[tex])
			end
			if texture and texture.textures[tex] then
				self:SetSubMaterial(k-1,texture.textures[tex])
			end
		end
	end
end
