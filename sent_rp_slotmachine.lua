--[[rp_slotmachine by Foul Play | Version 1.1.0 Pre-Alpha]]
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

local a = {a = "♥", b = 25} --Slot 1 (a is siring to output on VGUI and b is how much is won on the slot.)
local b = {a = "♥", b = 50} --Slot 2 (a is siring to output on VGUI and b is how much is won on the slot.)
local c = {a = "♦", b = 75} --Slot 3 (a is siring to output on VGUI and b is how much is won on the slot.)
local d = {a = "♦", b = 100} --Slot 4 (a is siring to output on VGUI and b is how much is won on the slot.)

local function Spin()
end

DEFINE_BASECLASS( "base_anim" )

cleanup.Register( "SlotMachine" ) --Registers for the entity to be cleaned up by Admins and clients.

ENT.PrintName = "SlotMachine" --The name of the entity in the Spawn Menu.
ENT.Author = "Nathan Binks" --The author of the entity in the Spawn Menu.
ENT.Information = "A spawnable slot machine" --Information about the entity in the Spawn Menu.
ENT.Category = "rp_slotmachine" --The Category where its going to be stored in the Spawn Menu.
ENT.Spawnable = true --Makes it Spawnable by Clients.
ENT.AdminOnly = true --Make it so non-admins can spawn it in.
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

	ply:AddCleanup( "SlotMachine", ent ) --Adds the entity that the client has spawn to their cleanup menu in Spawn Menu.

	return ent --Return the entity.
end

function ENT:Initialize()
	self:SetModel( "models/props_combine/combine_intmonitor003.mdl" ) --Set the model ingame.
	self:SetSkin(1) --Set the skin ingame.

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

language.Add( "Cleanup_SlotMachine", "SlotMachine" ) --Sets what it says in the cleanup menu in the Spawn Menu.
language.Add( "Cleaned_SlotMachine", "SlotMachine(s)" ) --Sets what it says when the entity gets cleaned.

local e, f, g, h = 0, 0, 0, 0 --To be used later.

function ENT:Draw()
	self:DrawModel() --Draw the model.

	local i = self:GetPos() --Get the position of the entity.
	local j = self:GetAngles() --Get the angles of the entity.
	j:RotateAroundAxis(j:Right(), -90) --Rotate the angle in degrees (Vector, number (rotation))
	j:RotateAroundAxis(j:Up(), 90) --Rotate the angle in degrees (Vector, number (rotation))

	--We use this on Client because it draws anything in 2D to 3D on the prop on the Client's screen.
	cam.Start3D2D(i + j:Up() * 10, j, 1) --(position, angle, scale)
		surface.SetDrawColor( Color( 0, 0, 0, 255 ) ) --Set draw colour before drawing a shape. ()
		surface.DrawRect( 0, 0, 100, 100 ) --Draw a rectangle. (position x, position y, size x, size y)

		surface.SetTextColor( 255, 255, 255, 255 ) --Set the text colour before drawing the text.
		surface.SetTextPos( 0, 0 ) --Set the text position before
		surface.DrawText( "Hello World" ) --Draw the text.
	cam.End3D2D()
end