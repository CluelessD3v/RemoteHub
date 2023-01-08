local ValuesFolder: Folder = script.Parent.Values


local ValueClient = {} 
ValueClient.__index = ValueClient

function ValueClient.getValue(theName: string, theTimeout: number?)
    local self = setmetatable({}, ValueClient)


    local elapsedTime: number      = 0
    local timeoutAt: number        = theTimeout or 5
    local MyValueBase: RemoteEvent = ValuesFolder:FindFirstChild(theName)


    if not MyValueBase then
        repeat
            MyValueBase = ValuesFolder:FindFirstChild(theName) 
            
            if MyValueBase then 
                break
            end

            elapsedTime += 1
            task.wait(1)
    
        until elapsedTime > timeoutAt
    end


    if MyValueBase then
        self.Name    = MyValueBase.Name
        self.Changed = MyValueBase.Changed
        return self
    else 
        warn("Infinite yield on", theName, ", the Value base was not found on time! Are you sure it was created?")
        return nil
    end 


    return self
end
    

return ValueClient