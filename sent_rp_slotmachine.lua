--[[rp_slotmachine by Foul Play | Version 1.0.0 Pre-Alpha]]
--[[
	function() end --A function
	for() do --A loop
	while() do --A loop
	if then --A statment
	else --A condiction
	elseif then --A condiction
	a = nil --A var
	a + b = c --Add maths
	a - b = c --Subtract maths
	a / b = c --Divide maths
	a * b = c --Multiply maths
	a = {} --A Table
]]
AddCSLuaFile()

DEFINE_BASECLASS( "base_anim" )

cleanup.Register( "" )

ENT.PrintName = ""
ENT.Author = "Nathan Binks"
ENT.Information = ""
ENT.Category = ""
ENT.Spawnable = true
ENT.AdminOnly = false
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

function ENT:SetupDataTables()
	self:NetworkVar( "Int", 0, "price" )
	self:NetworkVar( "Entity", 1, "owning_ent" )
end

function ENT:SpawnFunction( ply, tr, ClassName )
	if ( !tr.Hit ) then return end --If trace doesn't hit something then don't spawn.

	local SpawnPos = tr.HitPos + tr.HitNormal * 16 --Spawn in the air.
	local ent = ents.Create( ClassName ) --Create the entity.

	ent:SetPos( SpawnPos ) --Spawn it where you are looking at.
	ent:Spawn() --Spawn the entity.
	ent:Activate() --Activate the entity.
	ent:PhysWake() --Makes the entity fall to the ground.
	
	ply:AddCleanup( "", ent )

	return ent --Return the entity.
end

function ENT:Initialize()
	--Set the model ingame.
	self:SetModel( "" )

	--Enables Physics on Client.
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )

	if ( SERVER ) then
		--Only use this Physics on server side or the Physgun beam will fuck up.
		self:PhysicsInit( SOLID_VPHYSICS )
	end
end

--Since we won't be using the entity for anything yet, make Use return nothing and do nothing.
function ENT:Use()
	return
end

--Call this function when the entity gets removed.
function ENT:OnRemove()
end

--https://github.com/garrynewman/garrysmod/blob/master/garrysmod/lua/entities/sent_ball.lua#L149
if ( SERVER ) then return end -- We do NOT want to execute anything below in this FILE on SERVER 

language.Add( "Cleanup_", "" )
language.Add( "Cleaned_", "" )

function ENT:Draw()
	--Drawing the model
	self:DrawModel()
end