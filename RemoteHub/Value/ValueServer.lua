type ValueTypes = string | number | boolean | CFrame | Vector3 | Color3 | BrickColor 

export type ValueComponent = { 
    Changed: RBXScriptSignal,
    Name: string,
    Value: ValueTypes
}

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Table2String = require(script.Parent.Parent.TableToString)

local TheObjectValuesFolder = Instance.new("Folder")
TheObjectValuesFolder.Name   = "ObjectValues"
TheObjectValuesFolder.Parent = script.Parent



local function BuildObjectValueAndMapIt2Self(theObjectValueData)
    local TheNewObjectValue: ValueBase = Instance.new(theObjectValueData.Type)
    TheNewObjectValue.Name   = theObjectValueData.Name
    TheNewObjectValue.Value  = theObjectValueData.Value

    return TheNewObjectValue
end





-- !== ================================================================================||>
-- !==                                      API
-- !== ================================================================================||>
local ValueServer = {} 
ValueServer.__index = ValueServer

-- =============================== Properties ===============================||>
ValueServer.ValueTypes = {
    StringValue     = "StringValue",
    NumberValue     = "NumberValue",
    IntValue        = "IntValue",
    CFrameValue     = "CFrameValue",
    Vector3Value    = "Vector3Value",
    BoolValue       = "BoolValue",
    Color3Value     = "Color3Value",
    BrickColorValue = "BrickColorValue",
    RayValue        = "RayValue",
}

local objectValues   = {} ::{string: ValueBase & {string: ValueBase}}
local instanceValues = {} :: {Instance:{string: ValueBase & {string: ValueBase}}}


-- =============================== Methods ===============================||>
--[[
    + Creates a new object value of the given type
    + Optionally give it a namespace so you can segregate object values with same names or different functioanlities, basically folders.
--]]
function ValueServer.new(theObjectValueData: ValueComponent, aNamespace: string?): ValueBase
    local TheNewObjectValue = BuildObjectValueAndMapIt2Self(theObjectValueData)
    TheNewObjectValue.Parent = TheObjectValuesFolder 

    if aNamespace then  
        local anExistingNamespace = objectValues[aNamespace]
        if not anExistingNamespace then
            objectValues[aNamespace] = {}
            anExistingNamespace = objectValues[aNamespace]
        end
        
        anExistingNamespace[TheNewObjectValue.Name] = TheNewObjectValue

    else
        objectValues[TheNewObjectValue.Name] = TheNewObjectValue
    end
    

    return TheNewObjectValue:: ValueBase
end


--[[
    + Creates a new object value of the given type within the given instance
    + Optionally give it a namespace so you can segregate object values with same names or different functioanlities, basically folders.
--]]
function ValueServer.newForInstance(theInstance: Instance, theObjectValueData: ValueComponent, aNamespace: string?): ValueBase
    local TheNewObjectValue: ValueBase = BuildObjectValueAndMapIt2Self(theObjectValueData)
    TheNewObjectValue.Parent = TheObjectValuesFolder 

    local theInstanceObjectValues = instanceValues[theInstance]

    if theInstanceObjectValues == nil then
        instanceValues[theInstance] = {}
        theInstanceObjectValues  = instanceValues[theInstance]
    end


    if aNamespace then  
        local anExistingNamespace = theInstanceObjectValues[aNamespace]
        local AnExistingNamespaceFolder

        if not anExistingNamespace then
            theInstanceObjectValues[aNamespace] = {}
            anExistingNamespace = theInstanceObjectValues[aNamespace]

            AnExistingNamespaceFolder = Instance.new("Folder")
            AnExistingNamespaceFolder.Name   = aNamespace
            AnExistingNamespaceFolder.Parent = theInstance
        end
        
        AnExistingNamespaceFolder = theInstance[aNamespace]

        anExistingNamespace[TheNewObjectValue.Name] = TheNewObjectValue
        TheNewObjectValue.Parent = AnExistingNamespaceFolder 
    else
        theInstanceObjectValues[TheNewObjectValue.Name] = TheNewObjectValue
        TheNewObjectValue.Parent = theInstance
    end


    theInstance.Destroying:Connect(function()
        instanceValues[theInstance] = nil
    end)

    return TheNewObjectValue:: ValueBase
end


function ValueServer.get(theObjectValueName: string, aNamespace: string?): ValueBase?
    if aNamespace then
        local anExistingNamespace = objectValues[aNamespace]

        if anExistingNamespace then
            local TheRequestedObjectValue = anExistingNamespace[theObjectValueName]
            return TheRequestedObjectValue or warn(theObjectValueName, "Object value was not found in", aNamespace, "namespace make sure it was created there!")
        else
            return warn(aNamespace, "namespace was not found, make sure it exits!") and nil
        end
    end

    return objectValues[theObjectValueName] or warn(theObjectValueName, "Object value was not found, make sure it exists!") and nil
end

function ValueServer.getFromInstance(theInstance: Instance, theObjectValueName: string, aNamespace: string?): ValueBase?
    local theInstanceObjectValues = instanceValues[theInstance]
    
    if theInstanceObjectValues == nil then
        return warn(theInstance, "does not have object values! Make sure to create them first") and nil
    end

    if aNamespace then
        local anExistingNamespace = instanceValues[aNamespace]

        if anExistingNamespace then
            local TheRequestedObjectValue = anExistingNamespace[theObjectValueName]
            return TheRequestedObjectValue or warn(theObjectValueName, "Object value was not found in", aNamespace, "namespace make sure it was created there!")
        else
            return warn(aNamespace, "namespace was not found in", theInstance,  "make sure it exits!") and nil
        end
    end

    return objectValues[theObjectValueName] or warn(theObjectValueName, "Object value was not found, make sure it exists!") and nil
end


table.freeze(ValueServer)
return ValueServer
