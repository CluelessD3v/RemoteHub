type ValueTypes = string | number | boolean | CFrame | Vector3 | Color3 | BrickColor 

export type Value = { 
    Changed: RBXScriptSignal,
    Name: string,
    Value: ValueTypes
}


local Table2String = require(script.Parent.Parent.TableToString)

local GlobalValuesFolder = Instance.new("Folder")
GlobalValuesFolder.Name   = "GlobalValues"
GlobalValuesFolder.Parent = script.Parent



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
            return Table2String(self, 4)
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


--! NOTE: These tables are not safe to edit! Treat them as READ-ONLY
ValueServer.GlobalValuesMap    = {}:: {string: Value}
ValueServer.InstancesValuesMap = {}:: {Instance: Value} & {Instance:{string: Value}}



-- =============================== Methods ===============================||>
--[[
    + Creates a new object value of the given type
    + Optionally give it a namespace so you can segregate object values with same names or different functioanlities, basically folders.
--]]
function ValueServer.new(theObjectValueData: Value, aNamespace: string?)
    local self            = setmetatable({}, ValueServer)
    local NewObjectValue = BuildObjectValueAndMapIt2Self(self, theObjectValueData)
    local proxy           = BuildProxy(self, NewObjectValue)


    if aNamespace then  
        local anExistingNamespace = ValueServer.GlobalValuesMap[aNamespace]

        if not anExistingNamespace then
            NewObjectValue.Parent = anExistingNamespace

            --# namespace folder for the Object values instances versions
            local NewNamespaceFolder = Instance.new("Folder")
            NewNamespaceFolder.Name   = aNamespace
            NewNamespaceFolder.Parent = GlobalValuesFolder
        
            ValueServer.GlobalValuesMap[aNamespace] = {}

            anExistingNamespace       = ValueServer.GlobalValuesMap[aNamespace]
        end 

        local AnExitingsNamespaceFolder = GlobalValuesFolder[aNamespace]

        anExistingNamespace[self.Name] = proxy
        NewObjectValue.Parent = AnExitingsNamespaceFolder
    
    else 
        NewObjectValue.Parent = GlobalValuesFolder
        ValueServer.GlobalValuesMap[self.Name] = proxy
    end

    
    return proxy:: Value
end


--[[
    + Creates a new object value of the given type for the given instance
    + Optionally give it a namespace so you can segregate object values with same names or different functioanlities, basically folders.
--]]
function ValueServer.newForInstance(theInstance: Instance, theObjectValueData: Value, aNamespace: string)
    local self            = setmetatable({}, ValueServer)
    local ANewObjectValue = BuildObjectValueAndMapIt2Self(self, theObjectValueData)
    local proxy           = BuildProxy(self, ANewObjectValue)


    --## Creating the instance object values table if it doesn't exists
    local anInstanceValuesDict = ValueServer.InstancesValuesMap[theInstance] 
    if anInstanceValuesDict == nil then
        ValueServer.InstancesValuesMap[theInstance] = {}
    end 


    if aNamespace then  
        local anExistingNamespaceFolder = theInstance:FindFirstChild(aNamespace)

        if anExistingNamespaceFolder then --# Parent to an existing namespace folder
            ANewObjectValue.Parent = anExistingNamespaceFolder

        else --# Create the namespace folder & namespace table
            local NewNamespaceFolder = Instance.new("Folder")
            NewNamespaceFolder.Name   = aNamespace
            NewNamespaceFolder.Parent = theInstance

            ANewObjectValue.Parent = NewNamespaceFolder
            ValueServer.InstancesValuesMap[theInstance][aNamespace] = {}
        end 

        --## Add the object value to the instance values namespace table
        ValueServer.InstancesValuesMap[theInstance][aNamespace][self.Name] = proxy

    
    else --# Just parent the object value to the instance & add it to the instance object values table
        ANewObjectValue.Parent = theInstance
        ValueServer.InstancesValuesMap[theInstance][self.Name] = proxy
    end

    
    return proxy :: Value
end


--[[
    + If it exists, returns the object value of the given name
    
    + Note, be mindful of namespaces:
    + If the requested value is in a namespace, YOU HAVE to pass a namespace argument, this is to avoid collisions
    + between object values with the same name.

    + Conversely! If the value is in a namespace but you don't pass a namespace argument, it will return nil!
]]
function ValueServer:GetGlobalValue(theValueName: string, aNamespace: string?): Value?
    if aNamespace then
        local foundNamespace = ValueServer.GlobalValuesMap[aNamespace]
        if foundNamespace == nil then
            return warn(aNamespace, "namespace was not found! Are you sure the namespace exists?")
        end

        local theRequestedValue: Value = foundNamespace[theValueName]
        if theRequestedValue == nil then
            return warn(theValueName, "value inside", aNamespace, "Make sure to create it WITHIN the first!")
        end 

        return theRequestedValue
    
    else --# no namespace passed, so let's look directly in the global table
        local theRequestedValue: Value = ValueServer.GlobalValuesMap[theValueName]

        if theRequestedValue == nil then
            return warn(theValueName,"Value was not found, Either: Make sure to create it first! OR that is not in a namespace")
        end

        return theRequestedValue
    end
end



--[[
    + If it exists, returns the object value of the given name inside the given instance
    
    + Note, be mindful of namespaces:
    + If the requested value is in a namespace, YOU HAVE to pass a namespace argument, this is to avoid collisions
    + between object values with the same name.

    + Conversely! If the value is in a namespace but you don't pass a namespace argument, it will return nil!
]]
function ValueServer:GetValueFromInstance(theInstance: Instance, theValueName: string, aNamespace: string?): Value?
    local theInstanceValuesMap = ValueServer.InstancesValuesMap[theInstance]
    if theInstanceValuesMap == nil then
        return warn(theInstance, "Does not have any registered values! Make sure to create them first!")
    end

    if aNamespace then
        local foundNamespace = theInstanceValuesMap[aNamespace]
        if foundNamespace == nil then
            return warn(theInstance, "Does not have", aNamespace, "namespace. Are you sure the namespace exists?")
        end

        local theRequestedValue: Value = foundNamespace[theValueName]
        if theRequestedValue == nil then
            return warn(theInstance, "Does not have the", theValueName, "value inside", aNamespace, "Make sure to create it WITHIN the first!")
        end 

        return theRequestedValue
    
    else --# no namespace passed, so let's look directly in the instance table
        local theRequestedValue: Value = theInstanceValuesMap[theValueName]

        if theRequestedValue == nil then
            return warn(theValueName, "Value was not found direclty under", theInstance, "Either: Make sure it exists OR it's not within a namespace")
        end

        return theRequestedValue
    end
end


table.freeze(ValueServer)
return ValueServer
