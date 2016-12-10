--[[rp_slotmachine by Foul Play | Version 1.4.2 Pre-Alpha]]
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

local bWinChance = 10 --Win chance number. Modify this for a higher or lower chance of winning.

local aSlot1String = "♥" --Modify this to change what's going to be outputted on the VGUI.
local aSlot2String = "♣" --Modify this to change what's going to be outputted on the VGUI.
local aSlot3String = "♦" --Modify this to change what's going to be outputted on the VGUI.
local aSlot1WinAmount = 25 --Modify this what the Slot 1 win amount will be.
local aSlot2WinAmount = 50 --Modify this what the Slot 2 win amount will be.
local aSlot3WinAmount = 100 --Modify this what the Slot 3 win amount will be.

--a is siring to output on VGUI and b is how much is won on the slot.
local aTbl = { a = { a = aSlot1String, b = aSlot1WinAmount }, b = { a = aSlot2String, b = aSlot2WinAmount }, c = { a = aSlot3String, b = aSlot3WinAmount } }

--Checks if the player has won anything
local function Check( a, b, c )
	--[[If Slot 1 is the same as Slot 2 and Slot 2 is the same as Slot 3 then
	the player has won money else they lost the roll and have not won any money.]]
	if ( a == b and b == c ) then
		print("You have won " .. tostring(a.b) .. "!")
	else
		print("Oh oh, you have lost...")
	end
end

--Generate a win for the player.
local function GenerateWin()
	--Randomly select a key then send it to the Check function.
	local a = table.Random( aTbl )
	print( "[GenerateWin]: Sending " .. a.a .. " " .. a.a .. " " .. a.a )
	Check( a, a, a )
end

--Generate a loose for the player
local function GenerateLoose()
	--Randomly select a key and send it to the check function.
	local a, b, c = table.Random( aTbl ), table.Random( aTbl ), table.Random( aTbl )
	--If all of them are the same then get a key and change it to another key.
	if ( a == b and b == c ) then
		if ( a == 1 ) then
			a = a + 1
			print( "[GenerateLoose]: Sending " .. a.a .. " " .. b.a .. " " .. c.a )
			Check( a, b, c )
		end
		if ( a == 2 ) then
			b = b - 1
			print( "[GenerateLoose]: Sending " .. a.a .. " " .. b.a .. " " .. c.a )
			Check( a, b, c )
		end
		if ( a == 3 ) then
			c = c - 2
			print( "[GenerateLoose]: Sending " .. a.a .. " " .. b.a .. " " .. c.a )
			Check( a, b, c )
		end
	end
	print( "[GenerateLoose]: Sending " .. a.a .. " " .. b.a .. " " .. c.a )
	Check( a, b, c ) --Send the keys to the function
end

--Rolls the slots.
local function Roll()
	--Vars for table outputs and to send to the Check function.
	--local b, c, d = table.Random(a), table.Random(a), table.Random(a)
	--print("Slot 1 String Output: " .. b.a, "Slot 2 String Output: " .. c.a, "Slot 3 String Output: " .. d.a)
	--Check(b, c, d)
	
	--[[Win chance and math random to generate a number to compare it to the win chance
	then if random number is less or equals to the win chance then the player has won
	else the player has lost.]]
	local a, b = bWinChance, math.random(100) 
	if ( b <= a ) then
		GenerateWin()
	else
		GenerateLoose()
	end
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
	ent:SetUseType( SIMPLE_USE ) --Use only fires once everytime used key pressed on the entity.

	ply:AddCleanup( "SlotMachine", ent ) --Adds the entity that the client has spawn to their cleanup menu in Spawn Menu.

	return ent --Return the entity.
end

function ENT:Initialize()
	self:SetModel( "models/props_lab/monitor01a.mdl" ) --Set the model ingame.
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
	Roll()
end

--Call this function when the entity gets removed.
function ENT:OnRemove()
end

--https://github.com/garrynewman/garrysmod/blob/master/garrysmod/lua/entities/sent_ball.lua#L149
if ( SERVER ) then return end -- We do NOT want to execute anything below in this FILE on SERVER 

surface.CreateFont( "rp_slotmachine_font1", {
	font = "Arial",
	size = 15,
	antialias = true,
	weight = 1000,
} )


language.Add( "Cleanup_SlotMachine", "SlotMachine" ) --Sets what it says in the cleanup menu in the Spawn Menu.
language.Add( "Cleaned_SlotMachine", "SlotMachine(s)" ) --Sets what it says when the entity gets cleaned.

function ENT:Draw()
	self:DrawModel() --Draw the model.

	local a = self:GetPos() --Get the position of the entity.
	local b = self:GetAngles() --Get the angles of the entity.
	b:RotateAroundAxis( b:Right(), -85.5 ) --Rotate the angle in degrees (Vector, number (rotation))
	b:RotateAroundAxis( b:Up(), 90 ) --Rotate the angle in degrees (Vector, number (rotation))

	--We use this on Client because it draws anything in 2D to 3D on the prop on the Client's screen.
	cam.Start3D2D( a + b:Up() * 12.6, b, 0.11 ) --(position, angle, scale)
		surface.SetDrawColor( Color( 0, 0, 0, 255 ) ) --Set draw colour before drawing a shape. ()
		surface.DrawRect( -90, -100, 180, 150 ) --Draw a rectangle. (position x, position y, size x, size y)

		--[[Draw the text at the top of the VGUI (String text to be displade, font to be used, position x, 
		position, y, colour of text, the alignment of the text)]]
		draw.DrawText( "RP Slot Machine", "rp_slotmachine_font1", 0, -100, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER )
		
		--Rectangle left
		surface.SetDrawColor( Color( 255, 255, 255, 255 ) ) --Set the colour before drawing the rectangle.
		surface.DrawOutlinedRect( -75, -30, 50, 50 ) --Draw the rectangle (position x, position y, size, x, size, y)
		
		--Rectangle middle
		surface.SetDrawColor( Color( 255, 255, 255, 255 ) ) --Set the colour before drawing the rectangle.
		surface.DrawOutlinedRect( -25, -30, 50, 50 ) --Draw the rectangle (position x, position y, size, x, size, y)
		
		--Rectangle right
		surface.SetDrawColor( Color( 255, 255, 255, 255 ) ) --Set the colour before drawing the rectangle.
		surface.DrawOutlinedRect( 25, -30, 50, 50 ) --Draw the rectangle (position x, position y, size, x, size, y)
	cam.End3D2D()
end