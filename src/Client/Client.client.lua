local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RemoteHub = require(ReplicatedStorage.RemoteHub)

local Value = RemoteHub.Value


Value.getValue("Money").Changed:Connect(function(property)
    print(property) 
end)