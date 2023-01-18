local RemoteEvents: Folder = script.Parent.RemoteEvents


local EventClient = {} 

function EventClient.getRegisteredEvent(name: string, timeout: number): RemoteEvent?

    local theElapsedTime          = 0
    local timeoutAt            = timeout or 5

    local TheEvent: RemoteEvent = RemoteEvents:FindFirstChild(name)

    if not TheEvent then
        repeat
            TheEvent = RemoteEvents:FindFirstChild(name) 
            
            if TheEvent then 
                break
            end

            theElapsedTime += 1
            task.wait(1)
    
        until theElapsedTime > timeoutAt
    end


    if TheEvent then 
        return TheEvent
    else 
        warn("Infinite yield on", name, ", the event was not found on time! Are you sure it was created?")
        return nil
    end 
    
end


table.freeze(EventClient)
return EventClient
