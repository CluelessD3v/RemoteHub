local GlobalValuesFolder: Folder = script.Parent.GlobalValues




local ValueClient = {} 
ValueClient.__index = ValueClient


function ValueClient.getValue(theObjectValueName: string, aNamespace: string?)
    local TheRequestedValue: ValueBase

    local elapsedTime: number      = 0
    local timeoutAt: number        = 5  --> seconds




    if aNamespace then  --# Look for the namespace folder
        local TheNamespaceFolder = GlobalValuesFolder:FindFirstChild(aNamespace)
        
        if TheNamespaceFolder == nil or TheNamespaceFolder:FindFirstChild(theObjectValueName)  then --# Ergo the value does not exist either sooo wait for the namespace to exist
            warn(aNamespace, "namespace was not found! Waiting for it to exist, this will yield the thread!")
            
            repeat
                TheNamespaceFolder = GlobalValuesFolder:FindFirstChild(aNamespace)

                if TheNamespaceFolder and TheNamespaceFolder:FindFirstChild(theObjectValueName) then  
                    TheRequestedValue = TheNamespaceFolder:FindFirstChild(theObjectValueName) 
                    break
                end
    
                elapsedTime += 1
                task.wait(1)
        
            until elapsedTime >= timeoutAt
        end

    else  --# Search directly under the global folders 
        warn(theObjectValueName, "Object Value was not found waiting for its creation. This will yield the thread!")
        
        repeat
            TheRequestedValue = GlobalValuesFolder:FindFirstChild(theObjectValueName) 
            
            if TheRequestedValue ~= nil then 
                break
            end

            elapsedTime += 1
            task.wait(1)
    
        until elapsedTime >= timeoutAt
    end


    return TheRequestedValue or warn("Exhausted wait time...", theObjectValueName, "Was not found!")
end



-- function ValueClient.getValueFromInstance(theInstance: Instance, theName: string, theTimeout: number?): ValueBase?
--     local self = setmetatable({}, ValueClient)


--     local elapsedTime: number      = 0
--     local timeoutAt: number        = theTimeout or 5
--     local MyValueBase: RemoteEvent = ValuesFolder:FindFirstChild(theName)


--     if not MyValueBase then
--         repeat
--             MyValueBase = ValuesFolder:FindFirstChild(theName) 
            
--             if MyValueBase then 
--                 break
--             end

--             elapsedTime += 1
--             task.wait(1)
    
--         until elapsedTime > timeoutAt
--     end


--     if MyValueBase then
--         self.Name    = MyValueBase.Name
--         self.Changed = MyValueBase.Changed
--         return self
--     else 
--         warn("Infinite yield on", theName, ", the Value base was not found on time! Are you sure it was created?")
--         return nil
--     end 


--     return self
-- end
    
    

return ValueClient