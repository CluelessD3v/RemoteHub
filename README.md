# Remote Hub

"An interface to streamline Remote Events, Remote Function, and Object Values instancing through code. Inspired by Sleitnick's Signal, & Net. 

This utility does not tries to pull magic wizardry, or meta-brograming, simply put: I made this because I like to create remote communication instances  through code.

Also added some useful functions to event because why not.

**This is a library, not a class/service! I'm not returning special objects or tables in the constructors,  you're always dealing with a remote instance** 


### **WARNING: Remote functions and events are parented to module, you are free to reparent them, but do note that the client getter will NOT work unless the remote is childed to the module were it was created originaly** 

**[Get it on wally](https://wally.run/package/cluelessd3v/remotehub)**


***Proper Documentation coming soon***


# API's
Remote Hub includes 3 API's:
- Remote Events API called "Event" (For Remote Events)
- Remote Functions API called "Function" (For Remote Functions)
- Object Values API called "Value" (For Object values) **Not finalized**



## Event

### Functions
#### `new`
>**Params: `(name: string?, namespace: string?)`**
> *Creates a new Remote Event Instance of the given name within the given namespace if any. if no parent is given then the remote event will be childed to the module.*



#### `FireSomeClients`
>**Params: `(anEvent: RemoteEvent, thePlayersTable: {Player} | {any: Player}, ...:any)`**
> *Fires the event exclusively to the players in the given players table, essentially a whitelist*



#### `FireSomeClientsExcept`
>**Params: (anEvent: RemoteEvent, theExcludedPlayersTable: {Player} | {any: Player}, ...:any)**
> *The opposite of FireSomeClients, Fires the event exclusively to the players THAT ARE NOT in the given players table, essentially a blacklist*





#### `FireAllClientsInRadius`
>**Params: `(anEvent: RemoteEvent, aRadius: number, inPosition: Vector3, ...:any)`**
> *Fires the event exclusively to the players within the given radius of the given position*


### `FireAllClientsInRadiusExcept`
>**Params: `(anEvent: RemoteEvent, thePlayersToExcludeTable: {Player} | {[any]: Player}, theRadius: number, thePosition: Vector3, ...:any)`**
> *Fires the event exclusively to the players within the given radius of the given position*


[[note | Wildcard function]]
| A general use case Fire function in the case you *really* want to keep the event firing condition as a single logical unit, I don't approve using it since it's redundant and less readable, but hey it's there if you really want to use it.

#### `FireIfTrue`
>**Params: (anEvent: RemoteEvent, thePlayersTable: {Player} | {any: Player}, thePredicateFunction: (player: player) -> nil ...:any)**
> *Fires the event to the players in the given players table if the predicate function returns true*


**Client**

### `get`
>**Params: `(name: string?, namespace: string?)`**
> *Attempts to get an existing remote event from RemoteHub, if it's not found then it'll wait 10 seconds for it to appear*





## Function


### Functions


#### `new`
>**Params: `(name: string?, namespace: string?)`**
> *Creates a new Remote Function Instance of the given name within the given namespace if any. if no parent is given then the Remote Function will be childed to the module.*


**Client**

### `get`
>**Params: `(name: string?, namespace: string?)`**
> *Attempts to get an existing Remote Function from RemoteHub, if it's not found then it'll wait 10 seconds for it to appear*





# Example

*Notify the players in your team that you joined them* 

**In a server script**
```lua
local Teams = game:GetService("Teams")

local RemoteHub = require(game.ReplicatedStorage.RemoteHub)
local Event = RemoteHub.Event



local BlueTeam = Instance.new("Team", Teams)
BlueTeam.Name = "BlueTeam"

local RedTeam = Instance.new("Team", Teams)
RedTeam.Name = "RedTeam"


local NotifyPlayerJoinedTeam = Event.new("NotifyPlayerJoinedTeam")

game.Players.PlayerAdded:Connect(function(player)
     player.characterAdded:Wait()
     local teamsList = Teams:GetTeams()

     player.Team = teamsList[math.random(1, #teamsList)]
     Event.FireSomeClients(NotifyPlayerJoinedTeam, player.Team:GetPlayers(), player)
end)
```

**In a local script**
```lua
local RemoteHub = require(game.ReplicatedStorage.RemoteHub)
local Event = RemoteHub.Event

local NotifyPlayerJoinedTeam: RemoteEvent = Event.get("NotifyPlayerJoinedTeam")

NotifyPlayerJoinedTeam.OnClientEvent:Connect(function(player)
     print(player, "joined our team!")
end)
```


*That's pretty much the pattern to use Remote hub, Function works exactly the same*


# Footnotes:
Developing this I realized that it would actually be useful to pull metabrogramming for this, lol. It would be nice that you could access these methods from the remote event instance itself, as in: `SomeRemoteEvent:FireSomeClients`, *[which would require me to wrap a metatable around remote comms instances](https://devforum.roblox.com/t/wrapping-with-metatables-or-how-to-alter-the-functionality-of-roblox-objects-without-touching-them/221611)*

But oh well, right now it's out of scope for now as I don't really need it, it just would be nice though.


