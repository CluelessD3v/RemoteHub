local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RemoteEventsFolder: Folder = Instance.new("Folder")
RemoteEventsFolder.Name   = "RemoteEvents"
RemoteEventsFolder.Parent = script.Parent

local EventServer = {} 

--[[
    Creates a new Remote Event Instance of the given name within the given parent.
    if no parent is given then the remote event will be parented to ReplicatedStorage.
]]
function EventServer.new(theEventData: {Name: string?, Parent: Instance?})
    local TheNewEvent = Instance.new("RemoteEvent")
    TheNewEvent.Name   = theEventData.Name or "RemoteEvent"
    TheNewEvent.Parent = theEventData.Parent or ReplicatedStorage

    return TheNewEvent
end


--[[
    Fires the given remote event to all players found in the players table, basically a whitelist.
]]
function EventServer.FireSomeClients(anEvent: RemoteEvent, thePlayersTable: {Player} | {[any]: Player}, ...:any)
    if typeof(anEvent) == "Instance" and anEvent:IsA("RemoteEvent") then
        for _, player in thePlayersTable do
            anEvent:FireClient(player, ...)
        end
    end
end


--[[
    Fires the given remote event to all players not found in the players to exclude table, basically a blacklist.
]]
function EventServer.FireSomeClientsExcept(anEvent: RemoteEvent, thePlayersToExcludeTable:{Player} | {[any]: Player}, ...:any)
    if typeof(anEvent) == "Instance" and anEvent:IsA("RemoteEvent") then
        
        for index, aPlayer in Players:GetPlayers() do
            if thePlayersToExcludeTable[index] == aPlayer then continue end
            anEvent:FireClient(aPlayer, ...)
        end
    end
end



--[[
    Fires the given remote event to all players found in the given radius of the given position. 
]]
function EventServer.FireAllClientsInRadius(anEvent: RemoteEvent, theRadius: number, thePosition: Vector3, ...:any)
    if typeof(anEvent) == "Instance" and anEvent:IsA("RemoteEvent") then
        for _, aPlayer: Player in Players:GetPlayers() do
            local theCharacter = aPlayer.Character
            if not theCharacter then continue end

            local theCharacterPos: Vector3 = theCharacter:GetPivot().Position
            
            if (theCharacterPos - thePosition).Magnitude <= theRadius then
                anEvent:FireClient(aPlayer, ...)
            end
        end
    end
end

--! Note that FireAllClientsInRadius is already a whitelist function since it only fires to the players in the given radius

--[[
    Fires the given remote event to all players except the ones in the given blacklist table, that are 
    found in the given radius of the given position. 
]]
function EventServer.FireAllClientsInRadiusExcept(anEvent: RemoteEvent, thePlayersToExcludeTable: {Player} | {[any]: Player}, theRadius: number, thePosition: Vector3, ...:any)
    if typeof(anEvent) == "Instance" and anEvent:IsA("RemoteEvent") then
        for index, aPlayer: Player in Players:GetPlayers() do
            if thePlayersToExcludeTable[index] == aPlayer then continue end

            local theCharacter = aPlayer.Character
            if not theCharacter then continue end

            local theCharacterPos: Vector3 = theCharacter:GetPivot().Position
            
            if (theCharacterPos - thePosition).Magnitude <= theRadius then
                anEvent:FireClient(aPlayer, ...)
            end
        end
    end
end




--[[
    WildCard function that evalutes the predicate for EACH player in the given players table. The event will fire for the player element
    only if the predicate returns true.
]]
function EventServer.FireIfTrue(anEvent: RemoteEvent, thePlayersToFireTo: {Player} | {[any]: Player}, thePredicate: (player: Player) -> nil, ...:any): nil
    if typeof(anEvent) == "Instance" and anEvent:IsA("RemoteEvent") then
        for _, aPlayer in thePlayersToFireTo do
            if thePredicate(aPlayer) == true then
                anEvent:FireClient(aPlayer, ...)
            end    
        end
    end
end



table.freeze(EventServer)
return EventServer
