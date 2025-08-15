util.AddNetworkString("send_stalker2_deathanim_convar")
net.Receive("send_stalker2_deathanim_convar", function(len, ply)
    local setting = net.ReadBool()
    ply:SetNW2Bool("enable_stalker2_deathanim", setting)
end)

util.AddNetworkString("send_stalker2_fullbody_convar")
net.Receive("send_stalker2_fullbody_convar", function(len, ply)
    local setting = net.ReadBool()
    ply:SetNW2Bool("enable_stalker2_fullbody", setting)
end)


hook.Add("EntityTakeDamage", "HookEntityDamageDeathStalker2", function(target,dmginfo)	
	if IsValid(target) and target:IsPlayer() and not target:IsBot() and target:Alive() then
	
		if dmginfo:GetDamage() >= target:Health() then
			 
			if dmginfo:IsDamageType(DMG_GENERIC) then target:SetNWFloat("DamageWasGeneric",true) end
			if dmginfo:IsDamageType(DMG_CRUSH) or dmginfo:GetDamageType(DMG_CLUB) then target:SetNWFloat("DamageWasCrush",true) end
			if dmginfo:IsDamageType(DMG_BULLET) then target:SetNWFloat("DamageWasBullet",true) end
			if dmginfo:IsDamageType(DMG_SLASH) then target:SetNWFloat("DamageWasSlash",true) end
			if dmginfo:IsDamageType(DMG_BURN) then target:SetNWFloat("DamageWasBurn",true) end
			if dmginfo:IsDamageType(DMG_VEHICLE) then target:SetNWFloat("DamageWasVehicle",true) end
			if dmginfo:IsDamageType(DMG_BLAST) then target:SetNWFloat("DamageWasBlast",true) end
			if dmginfo:IsDamageType(DMG_SHOCK + DMG_ENERGYBEAM + DMG_ENERGYBEAM) then target:SetNWFloat("DamageWasElectrical",true) end
			if dmginfo:IsDamageType(DMG_SONIC) then target:SetNWFloat("DamageWasSonic",true) end
			if dmginfo:IsDamageType(DMG_POISON + DMG_NERVEGAS + DMG_ACID) then target:SetNWFloat("DamageWasPoison",true) end
			if dmginfo:IsDamageType(DMG_RADIATION) then target:SetNWFloat("DamageWasRadiation",true) end
			if dmginfo:IsDamageType(DMG_DROWN) then target:SetNWFloat("DamageWasDrown",true) end
			if dmginfo:IsFallDamage() then target:SetNWFloat("DamagewasFall",true) end
			
		end
	end
end)

hook.Add("PlayerDeath", "HookAnimationDeathStalker2", function(victim, inflictor, attacker)
	if IsValid(victim) and victim:IsPlayer() and not victim:IsBot() then
		
	if victim:GetNW2Bool("enable_stalker2_deathanim") == false then return end



		if ( file.Exists( "lua/autorun/lima_teleport_effect_autorun.lua", "GAME" ) ) then
		
			local ligmaTable = {
				lima_xte_spawn = false,
				lima_xte_fall = false,
				lima_xte_explosion = false,
				lima_xte_blunt = false,
			}
			if (GetConVar("lima_xte_spawn"):GetFloat()) == 1 then ligmaTable.lima_xte_spawn = true end
			if (GetConVar("lima_xte_fall"):GetFloat()) == 1 then ligmaTable.lima_xte_fall = true end
			if (GetConVar("lima_xte_explosion"):GetFloat()) == 1 then ligmaTable.lima_xte_explosion = true end
			if (GetConVar("lima_xte_blunt"):GetFloat()) == 1 then ligmaTable.lima_xte_blunt = true end
			
			for convar, boolean in pairs(ligmaTable) do
				RunConsoleCommand(convar, "0")
			end
			
			timer.Simple(0.5, function()
				for convar, boolean in pairs(ligmaTable) do
					if boolean == true then
						RunConsoleCommand(convar, "1")
					end
				end
			end)
			
		end	
		
		local PreDeathPos = victim:GetPos()
		local PreDeathAng = victim:GetAngles()
		
		local ConsecutiveDeaths = victim:GetNWFloat("ConsecutiveDeaths")
		victim:SetNWFloat("ConsecutiveDeaths",1 + ConsecutiveDeaths)
			
		timer.Simple(0.01, function()
			if IsValid(victim) then
			
				if victim:GetNWFloat("ConsecutiveDeaths") >= 3 then
				
					victim:Spawn()
					victim:SetNWFloat("ConsecutiveDeaths",0)
				
				else
			
					victim:Spawn()
					
					victim:Give("weapon_stalker2_death")
					victim:SelectWeapon("weapon_stalker2_death")
					
					victim:SetEyeAngles(PreDeathAng)
					victim:SetPos(PreDeathPos)
				
				end
			end
		end)
	end
end)
