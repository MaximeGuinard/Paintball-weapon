if SERVER then
	AddCSLuaFile ("shared.lua")
	SWEP.Weight 		= 8
	SWEP.AutoSwitchTo 	= true
	SWEP.AutoSwitchFrom = true
	
elseif CLIENT then
	SWEP.PrintName 		= "paint_gunbase"
	SWEP.Slot 			= 4
	SWEP.SlotPos 		= 4
	SWEP.DrawAmmo 		= true
	SWEP.DrawCrosshair 	= true
	SWEP.SwayScale		= 1
	SWEP.BounceWeaponIcon = false
	SWEP.BobScale 		= 1
end



SWEP.Author 			= "Kayxy"
SWEP.Contact 			= ""
SWEP.Purpose 			= "It does basey things. What more can I say?"
SWEP.Instructions 		= "Don't use this?"
SWEP.Spawnable 			= false
SWEP.AdminSpawnable 	= true
SWEP.Category 			= "♦ Paintball ♦"

SWEP.WorldModel 		= ""
SWEP.ViewModel			= ""
SWEP.UseHands			= false
SWEP.HoldType			= ""
SWEP.HoldTypeBackup		= ""
SWEP.ViewModelFlip		= false


SWEP.Primary.Sound		= ""
SWEP.Primary.Damage		= 0
SWEP.Primary.NumShots	= 1
SWEP.Primary.Cone		= 0
SWEP.Primary.Delay		= 0
SWEP.Primary.ClipSize	= 0
SWEP.Primary.DefaultClip		= 0
SWEP.Primary.Tracer		= 0
SWEP.Primary.Force		= 0
SWEP.Primary.Automatic	= false
SWEP.Primary.Ammo		= "Pistol"


-- Secondary attack
-- THIS SPACE BE FER IF I EVER ACTUALLY NEED A SECONDARY ATTACK.

-- Ye olde pit of variables.
local regen = 0
-- Ye olde exit of variables pit.

-- ENTERIN' YE OLD PIT O FUNCTIONS! NO RETURN PAST HERE M80's.

function SWEP:Initialize()
	util.PrecacheModel( self.WorldModel )
	util.PrecacheModel( self.ViewModel )
	util.PrecacheSound( self.Primary.Sound )
	self:SetWeaponHoldType( self.HoldType )
	regen = CurTime()
end

function SWEP:Deploy()
	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
	self.Weapon:SetNextPrimaryFire( CurTime() + 1.5 )
	return true
	
end


function SWEP:PrimaryAttack()
	if self.Weapon:Clip1() <= 0 then return end
	if !self:CanPrimaryAttack() then return end
	BanRounds(self.Owner, self.Weapon, self.Primary.Damage)
	self:TakePrimaryAmmo(self.Primary.NumShots)
	self.Owner:EmitSound(self.Primary.Sound)
	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	regen = CurTime() + 0.8
end


function SWEP:SecondaryAttack()
	-- Dear self: Why does this exist?
return end



function BanRounds( locplayer, wep, wepdam )
	-- Incase you read this, this is where I am creating entity based bullets, which means you should
	-- probably prepare your FPS butthole.
	
	if SERVER then
	local entround = ents.Create( "paintball" )
	entround:SetPos(locplayer:EyePos())
	entround:SetAngles(locplayer:EyeAngles())
	--entround:SetModel("models/hunter/misc/sphere025x025.mdl")
	entround:SetCollisionGroup(COLLISION_GROUP_NONE)
	entround:Spawn()
	entround:SetOwner(locplayer)
	
	local obj = entround:GetPhysicsObject()
	if (!IsValid( obj )) then entround:Remove() return end
	obj:SetMass(10)
	local vel = locplayer:GetAimVector()
	vel = vel*25000
	obj:ApplyForceCenter( vel )
	
	local daminf = DamageInfo()
	daminf:SetAttacker( locplayer )
	daminf:SetInflictor( locplayer )
	daminf:SetDamage( wepdam )
	daminf:SetDamageType( DMG_GENERIC )
	end
	
end

function SWEP:Reload()
	return
	/*
	if self.Weapon:Clip1() == self.Primary.ClipSize then return end
	self.Weapon:SetClip1( self.Primary.ClipSize )
	self.Owner:RemoveAmmo( (self.Primary.ClipSize - self.Weapon:Clip1()), self.Primary.Ammo)
	nreload = 0
	self:SetNextPrimaryFire( 2 )
	*/
end

function SWEP:Think()
	if self.Weapon:Clip1() > self.Primary.ClipSize then
		self.Weapon:SetClip1( self.Primary.ClipSize )
	end
	self.Weapon:SetHoldType( self.HoldTypeBackup )
	--Regen ammo function!
	
	if self.Weapon:Clip1() != self.Primary.ClipSize and regen < CurTime() then
		self.Weapon:SetClip1( self.Weapon:Clip1() + 1)
		regen = CurTime() + 0.3
	end
	
end