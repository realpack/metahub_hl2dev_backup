ExtendedRender.Entities = ExtendedRender.Entities or {}
ExtendedRender.Parts = {}
ExtendedRender.Parts.Types = {}

local LocalToWorld = LocalToWorld
local pairs = pairs

function ExtendedRender.Parts:Register( name, part )
	ExtendedRender.Parts.Types[name] = part
end

function ExtendedRender.Parts:Create( name, ent )
	if self.Types[name] then
		local part = {}
		part.parent = ent

		local obj = table.Copy( ExtendedRender.Part )

		setmetatable(part, {
			["__index"] = obj
		} )

		local partType = table.Copy( self.Types[name] )

		table.Merge(part, partType)

		part:Spawn()
		part:Init()

		return part
	end
end

local function Position( parent, part )
	local owner = parent:GetParent()
	local lpos

	if IsValid( owner ) and owner:IsPlayer() and owner == LocalPlayer() and not owner:ShouldDrawLocalPlayer() then
		parent = owner:GetViewModel()
		lpos = part.transform.view.pos
	else
		lpos = part.transform.world.pos
	end

	local bone = parent:LookupBone( part:GetBone() )
	local attachment = parent:LookupAttachment( part:GetBone() )
	local pos, ang

	if attachment and attachment != 0 and attachment != -1 then
		local attachmentData = parent:GetAttachment( attachment )

		pos = attachmentData.Pos
		ang = attachmentData.Ang

		return LocalToWorld( lpos, Angle(0,0,0), pos, ang )
	elseif bone then
		pos, ang = parent:GetBonePosition( bone )
		return LocalToWorld( lpos, Angle(0,0,0), pos, ang )

	else
		return LocalToWorld( lpos, Angle(0,0,0), parent:GetPos(), parent:GetAngles() )
	end
end

local function CanRender( ent )

	if ent:IsWeapon() then
		local owner = ent:GetParent()

		if IsValid( owner ) and owner:GetActiveWeapon() != ent or ( owner:IsPlayer() and owner:InVehicle() ) then
			return false
		else
			return true
		end
	end
	if ent:IsPlayer() and ent == LocalPlayer() and not ent:ShouldDrawLocalPlayer() then return false end
	if ent:GetNoDraw() then return false end
	if not ent:GetPos():ToScreen().visible then return false end

	return true
end

ExtendedRender.Parts.RenderCount = 0

function ExtendedRender.Parts:Render( context3D )
	if GetConVar("r_extended_enable"):GetBool() then
		for ent, set in pairs( ExtendedRender.Entities ) do
			if IsValid( ent ) then
				for i, part in pairs( ExtendedRender.Entities[ent] ) do
					if part.Redraw and part.render3D == context3D then

                        -- PrintTable(part)
                        -- return false
                        if ( part.filter_func and part.filter_func(ent) ) then
                            dist = part.tempPos:DistToSqr( part.tempPrevPos )

                            if dist > 1.5 then
                                part:Render( Position( part:GetParent(), part ) )
                            else
                                part:Render( part.tempPos )
                            end
                        end
					end
				end
			end
		end
	end
end

function ExtendedRender.Parts:Filter( ent, filter )
	if filter then
		local props = {
			["class"] = ent:GetClass(),
			["model"] = ent:GetModel(),
			["skin"] = ent:GetSkin()
		}

		for i, selector in pairs( filter ) do
			local selectProp = 0

			for k, v in pairs( selector ) do
				if props[k] == v then
					selectProp = selectProp + 1
				end
			end

			if selectProp == table.Count( selector ) then
				return true
			end
		end
	end
end

function ExtendedRender.Parts:Clear( ent )
	if IsValid( ent ) and ExtendedRender.Entities[ent] then
		for i, part in pairs( ExtendedRender.Entities[ent] ) do
			part:OnRemove()
		end

		ExtendedRender.Entities[ent] = nil

	end
end

function ExtendedRender.Parts:Setup( ent )
	if IsValid( ent ) then
		local data = ExtendedRender.Data.Storage["Packages"]
		local class = ent:GetClass()

		for i, set in pairs( data ) do

			if self:Filter( ent, set.filter ) or ( set.filter_func and set.filter_func(ent) ) then

				ent.ExtendedRender = {
					["cacheModel"] = ent:GetModel(),
					["cacheSkin"] = ent:GetSkin()
				}
				self:Clear( ent )
				ExtendedRender.Entities[ent] = {}

				for i, part in pairs( set.parts ) do
					if part.name then
						local partNew = self:Create( part.name, ent )

						local partData = table.Copy( part )

						table.Merge( partNew, partData )

						table.insert( ExtendedRender.Entities[ent], partNew )

						partNew:Spawn()
						partNew:Init()
                        partNew.filter_func = set.filter_func
					end
				end
			end
		end
	end
end

function ExtendedRender.Parts:UpdateAll()
	for i, ent in pairs( ents.GetAll() ) do
		ExtendedRender.Parts:Setup( ent )
	end
end

function ExtendedRender.Parts:Think()
	local counter = 0

	for ent, set in pairs( ExtendedRender.Entities ) do
		if IsValid( ent ) then
			local canRender = CanRender( ent )
			for i, part in pairs( ExtendedRender.Entities[ent] ) do
				part.Redraw = false

				if canRender and GetConVar( part.command ):GetBool() then

					counter = counter + 1

					if counter < GetConVar("r_extended_limit"):GetInt() then
						part:Think()

						if part:GetEnabled() then
							part.tempPrevPos = part.tempPos
							part.tempPos = Position( part.parent, part )
							part.Redraw = true
						end

					end
				end
			end
		end
	end
end

function ExtendedRender.Parts:Load()
	ExtendedRender:IncludeDirectory( "extended_render/parts" )
end

ExtendedRender.Parts:Load()

if CLIENT then

	net.Receive( "ExtendedRender_Spawn", function()
		local ent = net.ReadEntity()
		timer.Simple( 0.2, function()
			ExtendedRender.Parts:Setup( ent )
		end )

	end )

	net.Receive( "ExtendedRender_Death", function()
		local ent = net.ReadEntity()
		ExtendedRender.Parts:Clear( ent )

	end )

	hook.Add("OnEntityCreated", "ExtendedRender_OnEntityCreated", function( ent )
		if ent:IsPlayer() then
			timer.Simple( 0.2, function()
				ExtendedRender.Parts:Setup( ent )
			end )
		else
			ExtendedRender.Parts:Setup( ent )
		end
	end )

	hook.Add("EntityRemoved", "ExtendedRender_EntityRemoved", function( ent )
		ExtendedRender.Parts:Clear( ent )
	end )

	hook.Add("PostDrawOpaqueRenderables", "ExtendedRender_PostDrawOpaqueRenderables", function()
		ExtendedRender.Parts:Render( true )
	end )

	hook.Add("RenderScreenspaceEffects", "ExtendedRender_RenderScreenspaceEffects_Debug", function()
		ExtendedRender.Parts:Render( false )
	end )

	ExtendedRender.Parts.LastUpdate = 0

	hook.Add("Think", "ExtendedRender_Think", function()
		if GetConVar("r_extended_enable"):GetBool() then

			ExtendedRender.Parts:Think()

			if GetConVar("r_extended_update_enable"):GetBool() and SysTime() > ExtendedRender.Parts.LastUpdate then
				ExtendedRender.Parts.LastUpdate = SysTime() + GetConVar("r_extended_update_interval"):GetFloat()

				for i, ent in pairs( ents.GetAll() ) do
					if ent.ExtendedRender then
						if ent.ExtendedRender.cacheModel != ent:GetModel() or ent.ExtendedRender.cacheSkin != ent:GetSkin() then
							ExtendedRender.Parts:Setup( ent )
						end
					end
				end
			end
		end
	end )

end

if SERVER then

	util.AddNetworkString("ExtendedRender_Death")
	util.AddNetworkString("ExtendedRender_Spawn")

	hook.Add("OnNPCKilled", "ExtendedRender_OnNPCKilled", function( npc, attaker, inflictor )
		net.Start( "ExtendedRender_Death" )
		net.WriteEntity( npc )
		net.Broadcast()
	end )

	hook.Add("DoPlayerDeath", "ExtendedRender_DoPlayerDeath", function( ply, attaker, dmg )
		net.Start( "ExtendedRender_Death" )
		net.WriteEntity( ply )
		net.Broadcast()
	end )

	hook.Add("PlayerSpawn", "ExtendedRender_PlayerSpawn", function( ply )
		net.Start( "ExtendedRender_Spawn" )
		net.WriteEntity( ply )
		net.Broadcast()
	end )

end
