AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua')

util.AddNetworkString("OpenTrashDerma")
util.AddNetworkString("TrashFail")

if !ID then ID = 1 end

function ENT:Initialize()
	self:SetModel( table.Random({
        "models/props_junk/garbage128_composite001a.mdl",
        "models/props_junk/garbage128_composite001b.mdl",
        "models/props_junk/garbage128_composite001c.mdl",
        "models/props_junk/garbage128_composite001d.mdl",
        "models/props_junk/garbage256_composite001a.mdl",
        "models/props_junk/garbage256_composite002a.mdl",
        "models/props_junk/garbage256_composite002b.mdl"
    }) )

    self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self.NextUse = true

    self.Uses = 0

	-- Wake the physics object up
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:EnableMotion( false )
		phys:Wake()
	end

	self:SetUseType( SIMPLE_USE )
end

local trash_team = TEAM_CWU3
function ENT:Use( activator, caller )
    if self.cur_user then return end
    -- if activator:Team() == trash_team then
    self.cur_user = activator

    net.Start( "OpenTrashDerma" )
    net.WriteInt(self.TakeDuration, 16)
    net.Send( activator )

    self.over_time = CurTime() + self.TakeDuration
    -- else
    --     rp.Notify(activator, NOTIFY_ERROR, 'Вы не "'..team.GetName(trash_team)..'", и не можете собирать мусор.')
    -- end
end

function ENT:OnSpawn( ID, hitEntity )
	self.spawned = true
end

local function scrap_concat(scrap)
	local str = ""

	for k,v in pairs(scrap) do
		str = str..k.."(x"..v.."), "
	end

	return str ~= "" and string.sub( str, 1, string.len(str)-2 ) or "Ничего"
end

-- local TRASH_RANDOM_ITEMS = {
-- 	'trash_paper',
-- 	'trash_can',
-- 	'trash_bottle'
-- }

function ENT:SpawnTrash()
    local PosSpawn = self:GetPos()
	local AnglesSpawn = self:GetAngles()

	local Limit = rp.cfg.InvLimit

	local p = self.cur_user:GetInv()
	if (table.Count(p) >= Limit) then
        rp.Notify(self.cur_user, NOTIFY_GREEN, "В вашем чемодане нету места")
		return
	end

    local cl = table.Random(table.GetKeys(rp.cfg.Trash))

	local tab = {}
	tab.Class = cl

	local sh_data = false
	for i, s in pairs(rp.entities) do
		if s.ent == cl then
			sh_data = s
		end
	end

	if not sh_data then return end

	tab.Model = sh_data.model
	tab.Title = sh_data.name

	net.Start("Pocket.AddItem")
		net.WriteUInt(ID, 32)
		net.WriteString(tab.Title)
		net.WriteString('')
		net.WriteString(tab.Model)
	net.Send(self.cur_user)

	p[ID] = tab

	self.cur_user:SaveInv()

	ID = ID + 1

	rp.Notify(self.cur_user, NOTIFY_GREEN, "Вы нашли: "..tab.Title)

    self.over_time = nil
    self.cur_user = nil

    self.Uses = self.Uses + 1

    if self.Uses >= 5 then
        SafeRemoveEntity(self)

        local RandomReSpawnTimer = math.random(120,360)

        timer.Simple(RandomReSpawnTimer,function()
            local ent = ents.Create('trash_ent')
            ent:Spawn()
            ent:SetPos(PosSpawn)
            ent:SetAngles(AnglesSpawn)
        end)
    end
end

function ENT:FailFunc()
    net.Start("TrashFail")
    net.Send(self.cur_user)
    self.over_time = nil
    self.cur_user = nil
end

function ENT:Think()
    if not self.cur_user then return end
    if not self.over_time then return end

    if not IsValid(self.cur_user) then
        self:FailFunc()
        return
    end

    local ent = self.cur_user:GetEyeTrace().Entity

    if ent ~= self then
        self:FailFunc()
        return
    end

    if self.over_time < CurTime() then
        self:SpawnTrash()
        return
    end
end
