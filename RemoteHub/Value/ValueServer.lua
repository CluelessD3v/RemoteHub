local GlobalValues = Instance.new("Folder")
GlobalValues.Name   = "GlobalVlues"
GlobalValues.Parent = script.Parent


local InstanceValues: Folder = Instance.new("Folder")
InstanceValues.Name   = "InstanceValues"
InstanceValues.Parent = script.Parent


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

local function buildValueBase(theName: string, theValueType: string, anInitialValue: any?)
    local TheNewValueBase: ValueBase = Instance.new(theValueType)
    TheNewValueBase.Name   = theName
    TheNewValueBase.Value  = anInitialValue

    return TheNewValueBase
end


function ValueServer.new(theName: string, theValueType: string, anInitialValue: any?)
    local self = setmetatable({}, ValueServer)

    local TheNewValueBase: ValueBase = buildValueBase(theName, theValueType, anInitialValue)
    TheNewValueBase.Parent = GlobalValues

    self.Name    = theName
    self.Changed = TheNewValueBase.Changed
    self.Value   = anInitialValue

    --# Proxy table so we can change the BaseValue properties through the class.
    local proxy = setmetatable({}, {
        __index = self,
        __newindex =  function(t, k, v)
            if k == "Parent" then return end
            self[k] = v
            TheNewValueBase[k] = v
        end
    })

    return proxy
end




function ValueServer.newForInstance(theInstance: Instance, theName: string, theValueType: string, anInitialValue: any?)
    local self = setmetatable({}, ValueServer)


    local TheNewValueBase: ValueBase = buildValueBase(theName, theValueType, anInitialValue)

    self.Name             = TheNewValueBase.Name
    self.Value            = TheNewValueBase.Value
    self.Changed          = TheNewValueBase.Value
    self.AttachedInstance = theInstance

    local anExistingInstanceValuesFolder: Folder = InstanceValues:FindFirstChild(theInstance.Name.."Values")
    if not anExistingInstanceValuesFolder then
        anExistingInstanceValuesFolder        = Instance.new("Folder")
        anExistingInstanceValuesFolder.Name   = theInstance.Name.."Values"
        anExistingInstanceValuesFolder.Parent = InstanceValues
    end

    TheNewValueBase.Parent = anExistingInstanceValuesFolder 
    

    --# Proxy table so we can change the BaseValue properties through the class.
    local proxy = setmetatable({}, {
        __index = self,
        __newindex =  function(t, k, v)
            if k == "Parent" then return end

            if k == "AttachedInstance" then
                warn("Attached Instance is READ ONLY!")
                return
            end

            self[k] = v
            TheNewValueBase[k] = v
        end
    })

    return proxy
end




table.freeze(ValueServer)
return ValueServer