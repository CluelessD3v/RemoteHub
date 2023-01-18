local RunService = game:GetService("RunService")

local RemoteHub = {}
if RunService:IsServer() then
    RemoteHub.Event = require(script.Event.EventServer)
    RemoteHub.Value = require(script.Value)
else
    RemoteHub.Event = require(script.Event.EventClient)
end


return RemoteHub