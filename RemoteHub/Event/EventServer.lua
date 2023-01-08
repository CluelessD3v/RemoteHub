local Players = game:GetService("Players")
local RemoteEvents: Folder = script.Parent.RemoteEvents


local EventServer = {} 
EventServer.__index = EventServer

function EventServer.new(name: string)
    local self = setmetatable({}, EventServer)
    
    local newRe = Instance.new("RemoteEvent")
    newRe.Name   = name
    newRe.Parent = RemoteEvents

    self.Name          = name
    self.OnServerEvent = newRe.OnServerEvent

    return self
end



--# NOTE: MyEvent simply refers self associated event if for some reason that was not
--# clear enough. 

function EventServer:FireClient(aPlayer: Player, ...:any): nil
    local MyEvent = RemoteEvents[self.Name]
    MyEvent:FireClient(aPlayer, ...)
end


function EventServer:FireAllClients(...:any): nil
    local MyEvent = RemoteEvents[self.Name]
    MyEvent:FireAllClients(...)
end



function EventServer:FireSomeClients(thePlayersTable: {Player} | {[any]: Player}, ...:any)
    for _, player in thePlayersTable do
        self:FireClient(player, ...)
    end
end



function EventServer:FireSomeClientsExcept(thePlayersToExcludeTable:{Player} | {[any]: Player}, ...:any)
    for index, aPlayer in Players:GetPlayers() do
        if thePlayersToExcludeTable[index] == aPlayer then continue end
        self:FireClient(aPlayer, ...)
    end
end


function EventServer:FireAllClientsInRadius(theRadius: number, thePosition: Vector3, ...:any)
    for _, aPlayer: Player in Players:GetPlayers() do
        local Character = aPlayer.Character
        if not Character then continue end

        local CharacterPos: Vector3 = Character:GetPivot().Position
        
        if (CharacterPos - thePosition).Magnitude <= theRadius then
            self:FireClient(aPlayer, ...)
        end
    end
end



function EventServer:FireIfTrue(thePlayersTable: {Player} | {[any]: Player}, thePredicate: (player: Player) -> nil, ...:any)
    for _, aPlayer in thePlayersTable do
        if thePredicate(aPlayer) == true then
            self:FireClient(aPlayer, ...)
        end    
    end
end


function EventServer:Destroy()
    local MyEvent = RemoteEvents[self.Name]
    MyEvent:Destroy()
end


table.freeze(EventServer)
return EventServer
