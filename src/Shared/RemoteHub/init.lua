local RunService = game:GetService("RunService")

local RemoteHub = {}
if RunService:IsServer() then
    RemoteHub.Event     = require(script.Event.EventServer)
    RemoteHub.Value = require(script.Value.ValueServer)
else
    RemoteHub.Event     = require(script.Event.EventClient)
    RemoteHub.Value = require(script.Value.ValueClient)

end



return RemoteHub