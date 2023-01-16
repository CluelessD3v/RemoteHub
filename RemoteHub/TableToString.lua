-- Credit to Weeve#9132 for graciously giving this function.
-- Note: It's overcomplicated since it tries to also return cyclic references
-- instead of ignoring them! A leaner version that excludes them should be implemented!

return function(Table,Indentation,TablesEvaluated)
    Indentation = Indentation or 0
    if TablesEvaluated then
        TablesEvaluated[Table] = true
    else
        TablesEvaluated = {[Table] = true}
    end
 
    local Metatable = getmetatable(Table)
    if Metatable and Metatable.__tostring then
        local SubString = tostring(Table)
        local Lines = string.split(SubString,"\n")
 
        local NewString = Lines[1].."\n"
        for i=2,#Lines do
            NewString = NewString..string.rep("\t",Indentation)..Lines[i]
            if i ~= #Lines then
                NewString = NewString.."\n"
            end
        end
        return NewString
    else
        local String = "{"
        local FirstIndex = true
        for Index,Value in Table do
            local IndexString,ValueString
            if type(Index) == "table" then
                if TablesEvaluated[Index] then
                    IndexString = "[(CyclicTable){...}]"
                else
                    IndexString = "["..TableToString(Index,Indentation+1,TablesEvaluated).."]"
                end
            elseif type(Index) == "string" then
                IndexString = Index
            else
                IndexString = "["..tostring(Index).."]"
            end
 
            if type(Value) == "table" then
                if TablesEvaluated[Value] then
                    ValueString = "(CyclicTable){...}"
                else
                    ValueString = TableToString(Value,Indentation+1,TablesEvaluated)
                end
            elseif type(Value) == "string" then
                ValueString = "\""..Value.."\""
            else
                ValueString = tostring(Value)
            end
 
            if not FirstIndex then
                String = String..","
            else
                FirstIndex = false
            end
            String = String.."\n"..string.rep("\t",Indentation+1)..IndexString.." = "..ValueString
        end
 
        return String.."\n"..string.rep("\t",Indentation).."}"
    end
end
