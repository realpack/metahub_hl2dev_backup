AddCSLuaFile("shared.lua");
AddCSLuaFile("cl_init.lua");

include("shared.lua");

local dissolver;

function ENT:Initialize()
	self:SetModel("models/props_lab/blastdoor001c.mdl");
	self:PhysicsInit(SOLID_VPHYSICS);
	self:SetMoveType(MOVETYPE_VPHYSICS);
    self:SetCollisionGroup(COLLISION_GROUP_NONE);
	self:SetSolid(SOLID_VPHYSICS);
    self:SetUseType(SIMPLE_USE)
	self:DrawShadow(false);

    self:SetNetVar('PoliceOnly', true)

    dissolver = ents.Create("env_entity_dissolver");
    dissolver:SetKeyValue("dissolvetype", 3);
    dissolver:SetKeyValue("magnitude", 5);
    -- self:SpawnProps();
    dissolver:Spawn();

	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:EnableMotion( false )
		phys:Wake()
	end

	self:SpawnProps();

    -- print(self.:GetPos())
    -- local ang = self:GetAngles()
    -- self:SetAngles(Angle(ang.x,ang.y-90,ang.z-90))

end;

function ENT:SpawnFunction(player, trace)
    if (not trace.Hit) then return; end;

    local entity = ents.Create("forcefield");
    entity:Spawn();
    entity:Activate();
    entity:SetPos( trace.HitPos + trace.HitNormal * 32 + Vector(0, 0, 53) );
    entity:SetAngles( Angle(180, 0, 90) );
    entity:SpawnProps();

    return entity;
end;

local blacklist = {
    "info_player_start",
    "physgun_beam",
    "player",
    "npc_cscanner",
    "prop_ragdoll",
    "predicted_viewmodel"
};

-- function ENT:DissolveEntity(entity)
--     if ( not table.HasValue( blacklist, entity:GetClass() ) ) then
--         local target = "targeted_"..entity:EntIndex();

--         entity:SetKeyValue("targetname", target);

--         dissolver:SetPos( entity:GetPos() );
--         dissolver:Fire("Dissolve", target, 0);
--     end;
-- end;

function ents.FindPlayersInBox( vCorner1, vCorner2 )
	local tEntities = ents.FindInBox( vCorner1, vCorner2 )
	local tPlayers = {}

	local iPlayers = 0

	for i = 1, #tEntities do
		if ( tEntities[ i ]:IsPlayer() ) then
			iPlayers = iPlayers + 1
			tPlayers[ iPlayers ] = tEntities[ i ]
		end
	end

	return tPlayers, iPlayers
end


function ENT:EndTouch(entity)
    -- print(entity,'1')
end

function ENT:StartTouch(entity)
    if ( (entity.nextFFTouch or 0) < CurTime() ) then
        if ( entity:IsPlayer() or entity:IsNPC() ) then
            if ( entity:IsPlayer() ) then
                -- local job = meta.jobs[entity:Team()]
                if not entity:IsCP() then
                    if (self:GetNetVar('PoliceOnly')) then
                        self:EmitSound("buttons/button8.wav");
                        entity.nextFFTouch = CurTime() + 2.5;

                        return;
                    end;
                end;
            end;

            self:EmitSound("buttons/button9.wav");
            self:SetCollisionGroup(COLLISION_GROUP_DEBRIS);
        else
            -- self:EmitSound("buttons/button8.wav");
            -- print(self.shouldDissolve)
            -- if ( self.shouldDissolve ) then
            --     print("Fuck:")
            --     self:DissolveEntity(entity);
            -- end;
        end;

        entity.nextFFTouch = CurTime() + 2.5;
    end;
end;

function ENTITY:IsStuck(entity)
    local pos = self:GetPos()

    local trace = util.TraceHull({
        start = pos,
        endpos = pos,
        filter = self,
        mins = self:OBBMins(),
        maxs = self:OBBMaxs()
    })

    return trace.Entity and (trace.Entity == entity or trace.Entity:IsValid())
end

function ENT:TimerCheckFeild(entity,time)
    if ( !IsValid(entity) ) then
        self:SetCollisionGroup(COLLISION_GROUP_NONE);
    else
        timer.Simple(time, function()
            if not entity or not IsValid(entity) then return end

            -- self:SetCollisionGroup(COLLISION_GROUP_NONE);

            self:SetCollisionGroup(COLLISION_GROUP_NONE);

            -- local players, count_players = ents.FindPlayersInBox( self:GetPos()+self:OBBMins(), self:GetPos()+self:OBBMaxs() )
            -- for _, pl in pairs(players) do
            --     pl:SetVelocity( self:GetPos() )
            -- end

            if entity and IsValid(entity) then
                if (entity:IsStuck(self) and not self:GetNetVar('PoliceOnly')) then
                    self:EmitSound("buttons/button9.wav");
                    self:SetCollisionGroup(COLLISION_GROUP_DEBRIS);
                    self:TimerCheckFeild(entity,1.5)
                end

            else
                self:EmitSound("buttons/button9.wav");
                self:SetCollisionGroup(COLLISION_GROUP_DEBRIS);
            end
                -- self:SetCollisionGroup(COLLISION_GROUP_NONE);
                -- entity:IsStuck(self)
            -- end
        end);
    end;
end

function ENT:EndTouch(entity)
    timer.Simple(1.5, function()
        self:TimerCheckFeild(entity,1.5)
    end);
end;

-- function ENT:Use(activator, caller)
    -- -- print(activator:IsCP())
    -- -- local job = rp.teams[activator:Team()]
    -- if ( IsValid(activator) and activator:IsPlayer() and activator:IsCP() ) then
    --     if ( (self.nextUse or 0) < CurTime() ) then
    --         self.nextUse = CurTime() + 2.5;
    --         self:SetNetVar('PoliceOnly', not self:GetNetVar('PoliceOnly'))

    --         if (self:GetNetVar('PoliceOnly')) then
    --             self:EmitSound("buttons/combine_button2.wav");
    --         else
    --             self:EmitSound("buttons/combine_button1.wav");
    --         end;
    --     end;
    -- end;
-- end;

function ENT:SpawnProps()
    self.left_prop, self.right_prop = self.left_prop or nil, self.right_prop or nil
    if self.left_prop and IsValid(self.left_prop) then self.left_prop:Remove() end
    if self.right_prop and IsValid(self.right_prop) then self.right_prop:Remove() end

    local rotation = Vector(180, 0, 90);
    local rotation2 = Vector(0, 0, 90);
    local angles = self:GetAngles();
    local angles2 = self:GetAngles();

    angles:RotateAroundAxis(angles:Right(),rotation.x);
    angles:RotateAroundAxis(angles:Up(), rotation.y);
    angles:RotateAroundAxis(angles:Forward(), rotation.z);

    angles2:RotateAroundAxis(angles2:Right(), 180);
    angles2:RotateAroundAxis(angles2:Up(), 0);
    angles2:RotateAroundAxis(angles2:Forward(), 90);

    if CLIENT then return end

    self.left_prop = ents.Create("prop_dynamic");
    self.left_prop:SetAngles(angles);
    self.left_prop:SetModel("models/props_combine/combine_fence01a.mdl")
    self.left_prop:Activate();
    self.left_prop:SetParent(self);
    self.left_prop:Spawn();
    self.left_prop:SetPos(Vector(0,0,-1000));
    self.left_prop:SetPos(self:GetPos() + self:GetRight() * -43.525 + self:GetUp() * -16);
    -- self.left_prop:DeleteOnRemove(self);

    self.right_prop = ents.Create("prop_dynamic");
    self.right_prop:SetAngles(angles2);
    self.right_prop:SetModel("models/props_combine/combine_fence01b.mdl")
    self.right_prop:Activate();

    self.right_prop:SetParent(self);
    self.right_prop:Spawn();
    self.right_prop:SetPos(Vector(0,0,-1000));
    self.right_prop:SetPos(self:GetPos() + self:GetUp() * 122 + self:GetRight() * -44);

    -- print(right)
    -- right:DeleteOnRemove(self);
end;
