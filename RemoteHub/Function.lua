local RunService = game:GetService("RunService")
local RemoteFunctionsFolder --> defiend at EOF to avoid duplicating it on client require

local FunctionServer = {}

-- function Function.new(theFunctionData: {Name: string?, Parent: Instance?, OnServerInvoke: (any...) -> any...}): RemoteFunction
--      local newFunction = Instance.new("RemoteFunction")
--      newFunction.Name = theFunctionData.Name or "RemoteFunction"
--      newFunction.OnServerInvoke = theFunctionData.OnServerInvoke or function() end
--      newFunction.Parent = theFunctionData.Parent or game.ReplicatedStorage

--      return newFunction
-- end



function FunctionServer.new(name: string?, namespace: string?): RemoteFunction
     local RemoteFunction = Instance.new("RemoteFunction")
     RemoteFunction.Name   = name or "RemoteFunction"
 
 
     --# If a namespace is passed, check if it exist, else create it
     local NamespaceFolder
 
     if namespace  then
         NamespaceFolder = RemoteFunctionsFolder:FindFirstChild(namespace)
         if not NamespaceFolder then
             NamespaceFolder        = Instance.new("Folder")
             NamespaceFolder.Name   = namespace
             NamespaceFolder.Parent = RemoteFunctionsFolder  
         end
     end
 
     --# Parent to either the namespace folder or the remote event folder
     RemoteFunction.Parent = NamespaceFolder or RemoteFunctionsFolder
     
     return RemoteFunction
 end




local FunctionClient = {}

function FunctionClient.get(name: string, namespace: string?)
     local timeout = 10
     local elapsedTime = 0
     
     local NamespaceFolder
     local FolderToLook
 
     if namespace then
         namespace = RemoteFunctionsFolder:FindFirstChild(namespace) or  error(namespace.." namespace does not exist, did you forgot to create it?")
         FolderToLook = namespace
     else
         FolderToLook = RemoteFunctionsFolder
     end
     
     print(FolderToLook)
     
     local RemoteFunction = FolderToLook:FindFirstChild(name)
     
     if not RemoteFunction then
         repeat
             task.wait(1)
             elapsedTime += 1
             RemoteFunction =  FolderToLook:FindFirstChild(name)
         until RemoteFunction or timeout > elapsedTime
     end
 
     return RemoteFunction or error("Infinite yield on ".. name.. " Did you forgot to create it?")
 end



if RunService:IsServer() then
     RemoteFunctionsFolder        = Instance.new("Folder")
     RemoteFunctionsFolder.Name   = "RemoteFunctions"
     RemoteFunctionsFolder.Parent = script.Parent

     return FunctionServer
else
     RemoteFunctionsFolder = script.Parent.RemoteFunctions
     return FunctionClient
end 