type ValueTypes = string | number | boolean | CFrame | Vector3 | Color3 | BrickColor 

export type Value = { 
    Changed: RBXScriptSignal,
    Name: string,
    Value: ValueTypes
}




local GlobalValuesFolder = Instance.new("Folder")
GlobalValuesFolder.Name   = "GlobalVlues"
GlobalValuesFolder.Parent = script.Parent


local GlobalNamespacesFolder = Instance.new("Folder")
GlobalNamespacesFolder.Name   = "Namespaces"
GlobalNamespacesFolder.Parent = script.Parent


local globalValuesDict = {}:: {string: Value}
local globalNameSpacesDict = {}::{string: {string: Value}}  


local instanceValuesMap = {}:: {Instance: Value} & {Instance:{string: Value}}



local function BuildObjectValueAndMapIt2Self(self, theObjectValueData)
    local TheNewObjectValue: ValueBase = Instance.new(theObjectValueData.Type)
    TheNewObjectValue.Name   = theObjectValueData.Name
    TheNewObjectValue.Value  = theObjectValueData.Value

    self.Name    = theObjectValueData.Name
    self.Value   = theObjectValueData.Value
    self.Changed = TheNewObjectValue.Changed  --! Reference to the value instance Changed event

    TheNewObjectValue.Changed:Connect(function(newValue)
        self.Value = newValue
    end)

    return TheNewObjectValue
end


local function BuildProxy(self, theObjectValue)
    --# Proxy table so we can change the Object Value properties through the class w/o direct access to the instance.
    local proxy = setmetatable({}, {
        __index = self,

        __newindex =  function(_, key, value)
            if key == "Parent" then 
                warn("WARNING: The parent property of", self.Name, "is locked! This is to prevent internal errors.")
                return 
            elseif key == "Name" then
                warn("WARNING: The parent property of", self.Name, "is locked! This is to prevent internal errors.")
            end

            self[key] = value
            theObjectValue[key] = value
        end,

        __tostring = function()
            print(self)
            return ""
        end,
    })


    return proxy
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



-- =============================== Methods ===============================||>
--[[
    + Creates a new object value of the given type
    + Optionally give it a namespace so you can segregate object values with same names or different functioanlities, basically folders.
--]]
function ValueServer.new(theObjectValueData: Value, aNamespace: string?)
    local self            = setmetatable({}, ValueServer)
    local ANewObjectValue = BuildObjectValueAndMapIt2Self(self, theObjectValueData)
    local proxy           = BuildProxy(self, ANewObjectValue)


    if aNamespace then  
        local anExistingNamespaceFolder = script.Parent:FindFirstChild(aNamespace)

        if anExistingNamespaceFolder then
            ANewObjectValue.Parent = anExistingNamespaceFolder


        else 
            local NewNamespaceFolder = Instance.new("Folder")
            NewNamespaceFolder.Name   = aNamespace
            NewNamespaceFolder.Parent = GlobalNamespacesFolder

            ANewObjectValue.Parent = NewNamespaceFolder

            globalNameSpacesDict[aNamespace] = {}
        end 

        globalNameSpacesDict[aNamespace][self.Name] = proxy

    
    else 
        ANewObjectValue.Parent = GlobalValuesFolder
        globalValuesDict[self.Name] = proxy
    end

    
    return proxy:: Value
end



function ValueServer.newForInstance(theInstance: Instance, theObjectValueData: Value, aNamespace: string)
    local self            = setmetatable({}, ValueServer)
    local ANewObjectValue = BuildObjectValueAndMapIt2Self(self, theObjectValueData)
    local proxy           = BuildProxy(self, ANewObjectValue)




    if aNamespace then  
        local anExistingNamespaceFolder = theInstance:FindFirstChild(aNamespace)

        if anExistingNamespaceFolder then
            ANewObjectValue.Parent = anExistingNamespaceFolder

        else 
            local NewNamespaceFolder = Instance.new("Folder")
            NewNamespaceFolder.Name   = aNamespace
            NewNamespaceFolder.Parent = theInstance

            ANewObjectValue.Parent = NewNamespaceFolder
        end 

        instanceValuesMap[theInstance][aNamespace][self.Name] = proxy
    
    else 
        if instanceValuesMap[theInstance] == nil then
            instanceValuesMap[theInstance] = {}
        end 

        ANewObjectValue.Parent = theInstance
        instanceValuesMap[theInstance][self.Name] = proxy
    end

    
    return proxy
end


--[[
    + If it exists, returns the object value of the given name
    
    + Note, be mindful of namespaces:
    + If the requested value is in a namespace, YOU HAVE to pass a namespace argument, this is to avoid collisions
    + between object values with the same name.

    + Conversely! If the value is in a namespace but you don't pass a namespace argument, it will not return you anything.
]]
function ValueServer:GetObjectValue(theValueName: string, aNamespace: string?): ValueBase?
    if aNamespace then
        local foundNamespace = globalNameSpacesDict[aNamespace]
        if foundNamespace then
            return globalNameSpacesDict[aNamespace][theValueName] or 
            warn(theValueName, "Value base was not found! in", aNamespace, "namespace Make sure to create the value there!")
        else
            warn(aNamespace, "namespace was not found! Make sure to create it first!")
            return
        end
    end

    local TheRequestedValue = GlobalValuesFolder[theValueName]

    if TheRequestedValue == true then
        return TheRequestedValue
    else
        warn(theValueName, "Value base was not found!")
        warn("Make sure to create it first OR Maybe you wanted a value that is in a namespace?")
    end
end


--[[
    + Returns an array of object values.
]]
function ValueServer:GetGlobalValues(): {ValueBase}
    return GlobalValuesFolder:GetChildren()
end


table.freeze(ValueServer)
return ValueServer
