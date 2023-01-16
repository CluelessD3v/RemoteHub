local GlobalValuesFolder: Folder = script.Parent.GlobalValues




local ValueClient = {} 
ValueClient.__index = ValueClient


function ValueClient.get(theObjectValueName: string, aNamespace: string?)
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
        TheRequestedValue = GlobalValuesFolder:FindFirstChild(theObjectValueName)

        if not TheRequestedValue then
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
    end


    return TheRequestedValue or warn("Exhausted wait time...", theObjectValueName, "Was not found!")
end



function ValueClient.getFromInstance(theInstance: Instance, theObjectValueName: string, aNamespace: string?)
    local TheRequestedValue: ValueBase

    local elapsedTime: number      = 0
    local timeoutAt: number        = 5  --> seconds


    if aNamespace then  --# Look for the namespace folder
        local TheNamespaceFolder = theInstance:FindFirstChild(aNamespace)
        
        if TheNamespaceFolder == nil or TheNamespaceFolder:FindFirstChild(theObjectValueName)  then --# Ergo the value does not exist either sooo wait for the namespace to exist
            warn(aNamespace, "namespace was not found! Waiting for it to exist, this will yield the thread!")
            
            repeat
                TheNamespaceFolder = theInstance:FindFirstChild(aNamespace)

                if TheNamespaceFolder and TheNamespaceFolder:FindFirstChild(theObjectValueName) then  
                    TheRequestedValue = TheNamespaceFolder:FindFirstChild(theObjectValueName) 
                    break
                end
    
                elapsedTime += 1
                task.wait(1)
        
            until elapsedTime >= timeoutAt
        end

    else  --# Search directly under the global folders 
        TheRequestedValue = theInstance:FindFirstChild(theObjectValueName)
        if not TheRequestedValue then
            warn(theObjectValueName, "Object Value was not found waiting in", theInstance,"waiting for its creation. This will yield the thread!")

            repeat
                TheRequestedValue = theInstance:FindFirstChild(theObjectValueName) 
                
                if TheRequestedValue ~= nil then 
                    break
                end
    
                elapsedTime += 1
                task.wait(1)
        
            until elapsedTime >= timeoutAt            
        end
        warn(theObjectValueName, "Object Value was not found waiting for its creation. This will yield the thread!")
    end

    return TheRequestedValue or warn("Exhausted wait time...", theObjectValueName, "Was not found!")
end



return ValueClient