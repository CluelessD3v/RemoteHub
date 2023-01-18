local Players = game:GetService("Players")

local RemoteEventsFolder: Folder = Instance.new("Folder")
RemoteEventsFolder.Name   = "RemoteEvents"
RemoteEventsFolder.Parent = script.Parent

local theInternaEventlRegistry = {} 

local EventServer = {} 

function EventServer.new(name: string)
    local TheNewEvent = Instance.new("RemoteEvent")
    TheNewEvent.Name   = name
    TheNewEvent.Parent = RemoteEventsFolder

    theInternaEventlRegistry[name] = TheNewEvent

    return TheNewEvent
end


--[[
    Returns an event with the given event name, this will only work if the event was created via Remote hub event library!
    since those are the only ones getting regitered.
]]
function EventServer.getRegisteredEvent(theEventName: string): RemoteEvent
    local AnEvent = theInternaEventlRegistry[theEventName]
    if AnEvent then 
        return AnEvent
    end
    
    warn("Could not find a remote event named", theEventName, "did you created it?")
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
function EventServer.FireIfTrue(anEvent: RemoteEvent, thePlayersToFireTo: {Player} | {[any]: Player}, thePredicate: (player: Player) -> nil, ...:any)
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
