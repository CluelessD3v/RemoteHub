# Remote Hub

An interface to create more powerful remote communications inspired by Sleitnick's [Signal](https://sleitnick.github.io/RbxUtil/api/Signal/), & [Net](https://sleitnick.github.io/RbxUtil/api/Net).

This utility does not tries to pull magic wizardry, or meta-brograming, *it just wraps around Remote instances (remote events, remote function, and object values) and give them much more functionality.*


**NOTE: This is just a pre-release, there's no type checking, not a whole lot of error handling, and no implementation for remote functions. These docos are placeholders!**


# How to require:
All 3 interfaces are already indexed through Remote Hub, so no need to require anything else than Remote Hub module

```lua
local RemoteHub = require(ReplicatedStorage.RemoteHub)
local Event = RemoteHub.Event
local NewEvent = Event.new("TestEvent")

local Value = RemoteHub.Value
local newVal = Value.new({Name ="TestVal", Type = "IntValue", Value = 10, Parent = workspace})
```

# **[Get in on wally](https://wally.run/package/cluelessd3v/remotehub)**


### Docs coming soom
