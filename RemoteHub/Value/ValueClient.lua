local GlobalValuesFolder: Folder = script.Parent.ObjectValues
local ValueCreated: RemoteEvent = script.Parent.ValueCreated


local objectValues   = {} ::{string: ValueBase & {string: ValueBase}}
local instanceValues = {} :: {Instance:{string: ValueBase & {string: ValueBase}}}

local ValueClient = {} 
ValueClient.__index = ValueClient


local function WaitForInstance(theInstanceName2LookUp: string, theParent2LookIn: Instance, aTimeout: number?): Instance?
    local elapsedTime: number      = 0
    aTimeout = aTimeout or 5

    local RequestedInstance = theParent2LookIn:FindFirstChild(theInstanceName2LookUp)
    
    if not RequestedInstance then
        warn(theInstanceName2LookUp, "was not found within", theParent2LookIn, "waiting for it to exist for", tostring(aTimeout), "seconds... this will yield the thread!")
        repeat
            task.wait(1)

            elapsedTime += 1

            RequestedInstance = theParent2LookIn:FindFirstChild(theInstanceName2LookUp)
            if RequestedInstance then break end

        until elapsedTime >= aTimeout
    end

    return RequestedInstance or warn(theInstanceName2LookUp, "was not found within", theParent2LookIn, "Make sure it's being created!") and nil
end


function ValueClient.get(theObjectValueName: string, aNamespace: string?):  ValueBase?
    local TheRequestedObjectValue
    local TIMEOUT = 5  --> seconds


    if aNamespace then 
        local AnExistingNamespaceFolder = WaitForInstance(aNamespace, GlobalValuesFolder, TIMEOUT)
        if not AnExistingNamespaceFolder then 
            return 
        end

        TheRequestedObjectValue =  WaitForInstance(theObjectValueName, AnExistingNamespaceFolder, TIMEOUT)
        if not TheRequestedObjectValue then
            return
        end

    else
        TheRequestedObjectValue = WaitForInstance(theObjectValueName, GlobalValuesFolder, TIMEOUT)
        if not TheRequestedObjectValue then
            return
        end
    end


    return TheRequestedObjectValue

end



function ValueClient.getFromInstance(theInstance: Instance, theObjectValueName: string, aNamespace: string?): ValueBase?
    local TheRequestedValue: ValueBase
    local TIMEOUT = 5  --> seconds
    if not theInstance then
        return warn("the given instance is nil!") and nil
    end

    if aNamespace then 
        local AnExistingNamespaceFolder = WaitForInstance(aNamespace, theInstance, TIMEOUT)
        if not AnExistingNamespaceFolder then 
            return 
        end

        TheRequestedObjectValue =  WaitForInstance(theObjectValueName, AnExistingNamespaceFolder, TIMEOUT)
        if not TheRequestedObjectValue then
            return
        end

    else
        TheRequestedObjectValue = WaitForInstance(theObjectValueName, theInstance, TIMEOUT)
        if not TheRequestedObjectValue then
            return
        end
    end


    return TheRequestedObjectValue
end


return ValueClient