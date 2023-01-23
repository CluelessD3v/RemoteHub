local Function = {}

function Function.new(theFunctionData: {Name: string?, Parent: Instance?, OnServerInvoke: (any...) -> any...}): RemoteFunction
     local newFunction = Instance.new("RemoteFunction")
     newFunction.Name = theFunctionData.Name or "RemoteFunction"
     newFunction.OnServerInvoke = theFunctionData.OnServerInvoke or function() end
     newFunction.Parent = theFunctionData.Parent or game.ReplicatedStorage

     return newFunction
end



return Function