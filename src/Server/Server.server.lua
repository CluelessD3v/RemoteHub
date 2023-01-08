local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RemoteHub = require(ReplicatedStorage.RemoteHub)
local Value     = RemoteHub.Value

game.Players.PlayerAdded:Connect(function(player)
    -- local Money = Instance.new("IntValue")
    -- Money.Parent = player
    -- Money.Value = 10
    -- Money.Name = "Money"

    local money = Value.new("Money", Value.ValueTypes.IntValue, 10)
    task.wait(5)

    money.Value = 500    
end)    





