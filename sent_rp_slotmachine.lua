--[[rp_slotmachine by Foul Play | Version 1.0.1 Pre-Alpha]]
--[[
	function() end --A function
	for() do --A loop
	while() do --A loop
	if then --A statment
	else --A condiction
	elseif then --A condiction
	a = nil --A var
	a ~= b -- Relational Operator
	a == b --Relational Operator
	a > b -- Relational Operator
	a < b -- Relational Operator
	a => b -- Relational Operator
	a <= b -- Relational Operator
	a + b = c --Add maths
	a - b = c --Subtract maths
	a / b = c --Divide maths
	a * b = c --Multiply maths
	a = {} --A Table
]]
AddCSLuaFile()

DEFINE_BASECLASS( "base_anim" )

cleanup.Register( "" ) --Registers for the entity to be cleaned up by Admins and clients.

ENT.PrintName = "" --The name of the entity in the Spawn Menu.
ENT.Author = "Nathan Binks" --The author of the entity in the Spawn Menu.
ENT.Information = "" --Information about the entity in the Spawn Menu.
ENT.Category = "" --The Category where its going to be stored in the Spawn Menu.
ENT.Spawnable = true --Makes it Spawnable by Clients.
ENT.AdminOnly = false --Make it so non-admins can spawn it in.
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT --TODO: Add information about what it does.

function ENT:SetupDataTables()
	self:NetworkVar( "Int", 0, "price" ) --The price of the entity in the F4 Menu in DarkRP.
	self:NetworkVar( "Entity", 1, "owning_ent" ) --Sets the owner of the entity when spawned by clients to them.
end

function ENT:SpawnFunction( ply, tr, ClassName )
	if ( !tr.Hit ) then return end --If trace doesn't hit something then don't spawn.

	local SpawnPos = tr.HitPos + tr.HitNormal * 16 --Spawn in the air.
	local ent = ents.Create( ClassName ) --Create the entity.

	ent:SetPos( SpawnPos ) --Spawn it where you are looking at.
	ent:Spawn() --Spawn the entity.
	ent:Activate() --Activate the entity.
	ent:PhysWake() --Makes the entity fall to the ground.

	ply:AddCleanup( "", ent ) --Adds the entity that the client has spawn to their cleanup menu in Spawn Menu.

	return ent --Return the entity.
end

function ENT:Initialize()
	self:SetModel( "" ) --Set the model ingame.

	--Enables Physics on Client.
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )

	if ( SERVER ) then
		--Only use this on server side because this is server side only Physics or else the PhysGun beam will be set incorrectly.
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

language.Add( "Cleanup_", "" ) --Sets what it says in the cleanup menu in the Spawn Menu.
language.Add( "Cleaned_", "" ) --Sets what it says when the entity gets cleaned.

function ENT:Draw()
	self:DrawModel() --Drawing the model
end