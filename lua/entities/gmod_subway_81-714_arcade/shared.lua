ENT.Type            = "anim"
ENT.Base            = "gmod_subway_base"

ENT.PrintName       = "81-714 Arcade"
ENT.Author          = ""
ENT.Contact         = ""
ENT.Purpose         = ""
ENT.Instructions    = ""
ENT.Category		= "Metrostroi (Arcade)"

ENT.Spawnable       = true
ENT.AdminSpawnable  = false

function ENT:InitializeSystems()
	self:LoadSystem("Tatra_Systems")
end