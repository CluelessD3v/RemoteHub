local RemoteEvents: Folder = script.Parent.RemoteEvents


local EventClient = {} 
EventClient.__index = EventClient

function EventClient.getEvent(name: string, timeout: number)
    local self = setmetatable({}, EventClient)
    self.Name = name

    local elapsedTime          = 0
    local timeoutAt            = timeout or 5
    local MyEvent: RemoteEvent = RemoteEvents:FindFirstChild(name)

    self.OnClientEvent = MyEvent.OnClientEvent:: RBXScriptSignal

    if not MyEvent then
        repeat
            MyEvent = RemoteEvents:FindFirstChild(name) 
            
            if MyEvent then 
                break
            end

            elapsedTime += 1
            task.wait(1)
    
        until elapsedTime > timeoutAt
    end


    if MyEvent then 
        table.freeze(self)
        return self
    else 
        warn("Infinite yield on", name, ", the event was not found on time! Are you sure it was created?")
        return nil
    end 
    
end




function EventClient:FireServer(...:any)
    local MyEvent = RemoteEvents[self.Name]
    MyEvent:FireServer(...)
end


table.freeze(EventClient)
return EventClient
