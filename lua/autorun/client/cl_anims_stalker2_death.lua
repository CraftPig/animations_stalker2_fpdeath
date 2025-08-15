CreateClientConVar("cl_stalker2_deathanims_enable", "1", true, true)

local function SendEnableStalker2DeathAnimation()
    net.Start("send_stalker2_deathanim_convar")
    net.WriteBool(GetConVar("cl_stalker2_deathanims_enable"):GetBool())
    net.SendToServer()
end

cvars.AddChangeCallback("cl_stalker2_deathanims_enable", function(_, _, _)
    SendEnableStalker2DeathAnimation()
end)

----------------------------------------------------------------------------------------

CreateClientConVar("cl_stalker2_fullbody_enable", "1", true, true)

local function SendEnableStalker2Fullbody()
    net.Start("send_stalker2_fullbody_convar")
    net.WriteBool(GetConVar("cl_stalker2_fullbody_enable"):GetBool())
    net.SendToServer()
end

cvars.AddChangeCallback("cl_stalker2_fullbody_enable", function(_, _, _)
    SendEnableStalker2Fullbody()
end)

----------------------------------------------------------------------------------------

hook.Add("InitPostEntity", "HookSendDeathAnimSetting", function() 
	SendEnableStalker2DeathAnimation()
	SendEnableStalker2Fullbody()
end) 

----------------------------------------------------------------------------------------








-- local value = GetConVar("cl_stalker2_deathanims_enable"):GetFloat()
-- net.Start("SendMyConVarToServer")
-- net.WriteString(value)
-- net.SendToServer()


-- concommand.Add("sas", function(ply, cmd, args)
-- end)

-- cvars.AddChangeCallback("cl_stalker2_deathanims_enable", function(convar_name, oldValue, newValue)
	-- net.Start("SendMyConVarToServer")
	-- net.WriteString(newValue)
	-- net.SendToServer()
-- end)
