type ValueTypes = string | number | boolean | CFrame | Vector3 | Color3 | BrickColor 

local TheObjectValuesFolder = Instance.new("Folder") :: Folder
TheObjectValuesFolder.Name   = "ObjectValues"
TheObjectValuesFolder.Parent = game:GetService("ReplicatedStorage")

local theInterValuesRegistry   = {} ::{string: ValueBase & {string: ValueBase}}

local Value = {}

Value.ValueTypes = {
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


Value.new = function(theObjectValueData: {Name: string?, Type: ValueTypes, InitialValue: ValueTypes?, Parent: Instance? })
    theObjectValueData.Type = theObjectValueData.Type or "ObjectValue"

    local TheNewObjectValue: ValueBase = Instance.new(theObjectValueData.Type)
    TheNewObjectValue.Name   = theObjectValueData.Name
    TheNewObjectValue.Value  = theObjectValueData.Value or nil
    TheNewObjectValue.Parent = theObjectValueData.Parent or TheObjectValuesFolder

    if not theObjectValueData.Parent then
        theInterValuesRegistry[TheNewObjectValue.Name] = TheObjectValuesFolder
    end

    return TheNewObjectValue
end


--! Experimental registry not sure if this will stay.
Value.GetValueFromRegistry = function(theObjectValueName)
    return theInterValuesRegistry[theObjectValueName] or warn(theObjectValueName, "Object value was not found, make sure it exists!") and nil
end

return Value