AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
 
include('shared.lua')

 
function ENT:Initialize()
	
	local rand1 = math.random( 0, 255 )
	local rand2 = math.random( 0, 255 )
	local rand3 = math.random( 0, 255 )
	local randcolor = Color( rand1, rand2, rand3, 255 )
	
	self:SetModel( "models/hunter/misc/sphere025x025.mdl" )
	self:SetMaterial( "models/debug/debugwhite" )
	self:SetColor(randcolor)
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetTrigger( true )
    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
end

 
function ENT:Think()
    local phys = self:GetPhysicsObject()
end

function ENT:Touch( contactent )
	local own = self:GetOwner()
	local ownent = contactent:GetOwner()
	if contactent:IsValid() and contactent:IsPlayer() and (ownent != own) then
		--contactent:TakeDamage( 200, self.Owner, self)
		self:EmitSound("weapons/paintmarker/pball_impact1.wav")
		self:Remove()

		local dam = DamageInfo()
		local attacker = self.Owner
		if ( !IsValid( attacker ) ) then attacker = self end
		dam:SetAttacker( attacker )
		dam:SetInflictor( self )
		dam:SetDamage( 200 )
		dam:SetDamageType( DMG_GENERIC )
		contactent:TakeDamageInfo( dam )
		
	end
	
	if contactent:IsValid() and (contactent:IsSolid() or contactent:IsOnGround()) then
		self:Remove()
		if contactent:IsPlayer() then
			--contactent:Kill()
			--contactent:TakeDamage( 200, self.Owner, self)
			--contactent:TakeDamage( 200, self.Owner, self)
		end
	end

end

function ENT:PhysicsCollide( data, obj )
	self:Remove()
	if (data.Speed > 50 ) then
		--self:Remove()
		local colors = { "paintsplatpink", "paintsplatblue", "paintsplatgreen"}
		local randmat = table.Random( colors )
		self:EmitSound("weapons/paintmarker/pball_impact1.wav")
		util.Decal(randmat, (data.HitPos + data.HitNormal), (data.HitPos - data.HitNormal))
	end

end