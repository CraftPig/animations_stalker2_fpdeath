
hook.Add("EntityTakeDamage", "HookEntityDamageDeathStalker2", function(target,dmginfo)	
	if IsValid(target) and target:IsPlayer() and target:Alive() then
		if dmginfo:GetDamage() >= target:Health() then
			 
			if dmginfo:IsDamageType(DMG_GENERIC) then target:SetNWFloat("DamageWasGeneric",true) end
			if dmginfo:IsDamageType(DMG_CRUSH) or dmginfo:GetDamageType(DMG_CLUB) then target:SetNWFloat("DamageWasCrush",true) end
			if dmginfo:IsDamageType(DMG_BULLET) then target:SetNWFloat("DamageWasBullet",true) end
			if dmginfo:IsDamageType(DMG_SLASH) then target:SetNWFloat("DamageWasSlash",true) end
			if dmginfo:IsDamageType(DMG_BURN) then target:SetNWFloat("DamageWasBurn",true) end
			if dmginfo:IsDamageType(DMG_VEHICLE) then target:SetNWFloat("DamageWasVehicle",true) end
			if dmginfo:IsDamageType(DMG_BLAST) then target:SetNWFloat("DamageWasBlast",true) end
			if dmginfo:IsDamageType(DMG_SHOCK + DMG_SONIC + DMG_ENERGYBEAM) then target:SetNWFloat("DamageWasElectrical",true) end
			if dmginfo:IsDamageType(DMG_POISON + DMG_NERVEGAS + DMG_ACID) then target:SetNWFloat("DamageWasPoison",true) end
			if dmginfo:IsDamageType(DMG_RADIATION) then target:SetNWFloat("DamageWasRadiation",true) end
			if dmginfo:IsDamageType(DMG_DROWN) then target:SetNWFloat("DamageWasDrown",true) end
			
		end
	end
end)

hook.Add("PlayerDeath", "HookAnimationDeathStalker2", function(victim, inflictor, attacker)
	if IsValid(victim) and victim:IsPlayer() then
			
		local PreDeathPos = victim:GetPos()
		local PreDeathAng = victim:GetAngles()
		-- local PreFrags = victim:Frags()
		
		local ConsecutiveDeaths = victim:GetNWFloat("ConsecutiveDeaths")
		victim:SetNWFloat("ConsecutiveDeaths",1 + ConsecutiveDeaths)
			
		timer.Simple(0.001, function()
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