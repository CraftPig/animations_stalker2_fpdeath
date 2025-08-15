if CLIENT then 
    -- SWEP.WepSelectIcon = surface.GetTextureID( "vgui/hud/vgui_stalker2_bread" )
	-- SWEP.BounceWeaponIcon = true 
    -- SWEP.DrawWeaponInfoBox = true
end

SWEP.PrintName = ""
SWEP.Author = "Craft_Pig"
SWEP.Purpose = 
[[
]]
SWEP.Category = "S.T.A.L.K.E.R. 2"
-- SWEP.Category1 = "EFT"
-- SWEP.Category2 = "Medkits"

SWEP.ViewModelFOV = 100
SWEP.ViewModel = "models/animations/fp/stalker2/death/v_death.mdl"
SWEP.WorldModel = ""
SWEP.UseHands = true
SWEP.DrawCrosshair = false 

SWEP.Spawnable = false
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false
SWEP.Slot = 5
SWEP.SlotPos = 11

SWEP.SwayScale = 0.15
SWEP.BobScale = 0.75

SWEP.m_bPlayPickupSound = false

SWEP.Secondary.Ammo = "none"
SWEP.Primary.Ammo = "none"
SWEP.Primary.ClipSize = -1
SWEP.Primary.Automatic = false
SWEP.Primary.DefaultClip = -1
SWEP.DrawAmmo = false


local ID_WEAPON = "weapon_stalker2_death"

function SWEP:Initialize()
	

    self:SetHoldType("pistol") 
	
	if CLIENT then
        timer.Simple(0.1, function()
            local owner = self:GetOwner()
			local ownerModel = owner:GetModel()
			local vm = owner:GetViewModel()
            if IsValid(owner) and owner:GetNW2Bool("enable_stalker2_fullbody") == true then
                local hands = owner:GetHands()
                if IsValid(hands) then
				
					local boneTable = {
						"ValveBiped.Bip01_Head1",
						"ValveBiped.Bip01_Neck1",
						"ValveBiped.Bip01_R_Clavicle",
						"ValveBiped.Bip01_L_Clavicle",
					}	
					for _, boneName in ipairs(boneTable) do
						local boneIndex = vm:LookupBone(boneName)
						vm:ManipulateBoneScale(boneIndex, Vector(0, 0, 0))
					end
					
                    hands:SetModel(ownerModel)
                    hands:InvalidateBoneCache()
					
                end
            end
        end)
    end
end 

function SWEP:Deploy()
	local owner = self:GetOwner() 
	
	owner:Freeze(true)
	owner:SetNoTarget(true)
	owner:GodEnable(true)
	owner:SetNoDraw(true)
	
	self:SendWeaponAnim(ACT_VM_IDLE)
	self:DoDeathAnimation()

	return true
end

function SWEP:PrimaryAttack()
end

function SWEP:SecondaryAttack()
end

function SWEP:DoDeathAnimation()
	local owner = self:GetOwner() 
	
	if self.IsDead == true then return end
	self.IsDead = true
	
	if owner:GetNWFloat("DamageWasDrown") == true or owner:WaterLevel() >= 2 then self:SendWeaponAnim(ACT_VM_MISSRIGHT)
	elseif owner:GetNWFloat("DamageWasFall") == true then self:SendWeaponAnim(ACT_VM_HITRIGHT)
	
	elseif owner:GetNWFloat("DamageWasBlast") == true then
		local rnd = math.random(1,2)
		if rnd == 1 then
			self:SendWeaponAnim(ACT_VM_HITLEFT)
		elseif rnd == 2 then
			self:SendWeaponAnim(ACT_VM_HITLEFT2)
		end	
	
	elseif owner:GetNWFloat("DamageWasBurn") == true then self:SendWeaponAnim(ACT_VM_HITRIGHT2)
	elseif owner:GetNWFloat("DamageWasElectrical") == true then self:SendWeaponAnim(ACT_VM_DRYFIRE)
	elseif owner:GetNWFloat("DamageWasSonic") == true then self:SendWeaponAnim(ACT_VM_SWINGHARD)
	elseif owner:GetNWFloat("DamageWasPoison") == true then self:SendWeaponAnim(ACT_VM_RELOAD)
	elseif owner:GetNWFloat("DamageWasRadiation") == true then self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	elseif owner:GetNWFloat("DamageWasVehicle") == true then  self:SendWeaponAnim(ACT_VM_PULLBACK)
	
	elseif owner:GetNWFloat("DamageWasBullet") == true then
		local rnd = math.random(1,4)
		if rnd == 1 then
			self:SendWeaponAnim(ACT_VM_PULLBACK_HIGH)
		elseif rnd == 2 then
			self:SendWeaponAnim(ACT_VM_PULLBACK_LOW)
		elseif rnd == 3 then
			self:SendWeaponAnim(ACT_VM_THROW)
		elseif rnd == 4 then
			self:SendWeaponAnim(ACT_VM_PULLPIN)
		end
		
	elseif owner:GetNWFloat("DamageWasSlash") == true then self:SendWeaponAnim(ACT_VM_MISSLEFT2)
	elseif owner:GetNWFloat("DamageWasCrush") == true then  self:SendWeaponAnim(ACT_VM_PULLBACK)
	
	else
	
		local rnd = math.random(1,3) -- ACT_VM_HITCENTER ACT_VM_HITCENTER2
		if rnd == 1 then
			self:SendWeaponAnim(ACT_VM_HITCENTER)
		elseif rnd == 2 then
			self:SendWeaponAnim(ACT_VM_HITCENTER2)
		elseif rnd == 3 then
			self:SendWeaponAnim(ACT_VM_PULLPIN)
		end	
		
	end
	
	SeqDur = self:SequenceDuration()
	self:SetNextPrimaryFire(SeqDur + CurTime())
	
	timer.Create("TimerSetHoster",SeqDur + 1, 1, function()
		if IsValid(self) and owner:GetActiveWeapon():GetClass() == ID_WEAPON then
			owner:Freeze(false)
		end
	end)
end

function SWEP:Think()
	local owner = self:GetOwner() 
	if not SERVER then return end
	if (owner:KeyDown(IN_ATTACK) or owner:KeyDown(IN_ATTACK2) or owner:KeyDown(IN_JUMP) or owner:KeyDown(IN_FORWARD) or owner:KeyDown(IN_BACK) or owner:KeyDown(IN_MOVELEFT) or owner:KeyDown(IN_MOVERIGHT)) and SeqDur <= CurTime() then
		
		local DamageEnumTable = {
		 "DamageWasGeneric",
		 "DamageWasCrush",
		 "DamageWasBullet",
		 "DamageWasSlash",
		 "DamageWasBurn",
		 "DamageWasVehicle",
		 "DamageWasBlast",
		 "DamageWasElectrical",
		 "DamageWasSonic",
		 "DamageWasPoison",
		 "DamageWasRadiation",
		 "DamageWasDrown",
		 "DamageWasFall",
		}
		for _, NW in ipairs(DamageEnumTable) do
			owner:SetNWFloat(NW,false)
		end
	
		owner:SetNWFloat("ConsecutiveDeaths",0)
		
		owner:KillSilent()
		owner:Spawn()

		-- if engine.ActiveGamemode() == "sandbox" then
		-- end
		
	end
end

function SWEP:Holster()
end

function SWEP:AdjustMouseSensitivity()
	return 0.00001
end

function SWEP:PostDrawViewModel(vm)
    local attachment = vm:GetAttachment(1)
    if attachment then
        self.vmcameraPos = attachment.Pos + Vector(0,-0,1.5)
        self.vmcameraAng = attachment.Ang + Angle(-10,-0,0)
    else
        self.vmcameraPos = nil
        self.vmcameraAng = Angle(0, 0, 0)
    end
end

function SWEP:CalcView(ply, pos, ang, fov)
    if self.vmcameraPos then
        pos = pos + (self.vmcameraPos - ply:EyePos())
    end

    if self.vmcameraAng then
        ang = ang + self.vmcameraAng - ply:EyeAngles() 
    end

    return pos, ang, fov
end

local hide = {
	["CHudHealth"] = true,
	["CHudBattery"] = true,
	["CHudAmmo"] = true,
	["CHudSecondaryAmmo"] = true,
	["CHudHistoryResource"] = true,
	["CHudWeaponSelection"] = true,
	["CHudPoisonDamageIndicator"] = true,
	["CHudZoom"] = true,
	["CHudGMod"] = true,
}
hook.Add("HUDShouldDraw", "HideDefaultHUDOnDeath", function(name)
    local ply = LocalPlayer()
    if not IsValid(ply) then return end

    local wep = ply:GetActiveWeapon()
    if IsValid(wep) and wep:GetClass() == "weapon_stalker2_death" then

		if ( hide[ name ] ) then
			return false
		end
	
	end
	
end)