local ValuesFolder: Folder = script.Parent.Values

local ValueServer = {} 
ValueServer.__index = ValueServer

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

function ValueServer.new(theName: string, theValueType: string, anInitialValue: any?)
    local self = setmetatable({}, ValueServer)

    local baseValue: ValueBase = Instance.new(theValueType)
    baseValue.Name   = theName
    baseValue.Value  = anInitialValue
    baseValue.Parent = ValuesFolder


    self.Name    = theName
    self.Changed = baseValue.Changed
    self.Value   = anInitialValue

    --# Proxy table so we can change the BaseValue properties through the class.
    local proxy = setmetatable({}, {
        __index = self,
        __newindex =  function(t, k, v)
            self[k] = v
            baseValue[k] = v
        end
    })

    return proxy
end







table.freeze(ValueServer)
return ValueServer