# Remote Hub

An interface to stream line instancing of Remote Events, Remote Function, and Object Values through code. Inspired by [leitnick's Signal](https://sleitnick.github.io/RbxUtil/api/Signal/), & [Net](https://sleitnick.github.io/RbxUtil/api/Net).


This utility does not tries to pull magic wizardry, or meta-brograming, I made this because I don't like dealing with the process of having to create instances meant for communication through the explorer, and hey also made some useful functions because why not.

**This is mainly a library, not a class/service! I'm not returning special objects or tables,  you're always dealing with an instance**

[Get it on wally](remotehub = "cluelessd3v/remotehub@0.3.1")


***Proper Documentation coming soon***


# API's
Remote Hub includes 3 API's:
- Remote Events API called "Event" (For Remote Events)
- Remote Functions API called "Function" (For Remote Functions)
- Object Values API called "Value" (For Object values)



## Event


### Methods

#### Server
[[abstract | Server]]
| These methods can only be used in server scripts and modules required by server scripts** |
#### `new`
>**Params: `(aName: string)`**
> *Constructs a Remote event with the given name and parents it to a Remote Events Folder.*


#### `FireClient`
> **Params:`(thePlayer: Player, ...:any)`**
> *Equal to FireClient*



#### `FireAllClients`
>**Params: `(...:any)`**
> *Equal to FireAllClients*
 




#### `FireSomeClients`
>**Params: `(thePlayersTable: {Player} | {any: Player}, ...:any)`**
> *Fires the event exclusively to the players in the given players table, essentially a whitelist*



#### `FireSomeClientsExcept`
>**Params: (theExcludedPlayersTable: {Player} | {any: Player}, ...:any)**
> *The opposite of FireSomeClients, Fires the event exclusively to the players THAT ARE NOT in the given players table, essentially a blacklist*





#### `FireAllClientsInRadius`
>**Paras: `(aRadius: number, inPosition: Vector3, ...:any)`**
> *Fires the event exclusively to the players within the given radius of the given position*



[[note | Wildcard function]]
| A general use case Fire function in the case you *really* want to keep the event firing condition as a single logical unit, I don't approve using it since it's redundant and less readable, but hey it's there if you really want to use it.

#### `FireIfTrue`
>**Params: (thePlayersTable: {Player} | {any: Player}, thePredicateFunction: (player: player) -> nil ...:any)**
> *Fires the event to the players in the given players table if the predicate function returns true*








# Footnotes:
Developing this I realized that it would actually be useful to pull metabrogramming for this, lol. It would be nice that you could access these methods from the remote event instance itself, as in: `SomeRemoteEvent:FireSomeClients`, *[which would require me to wrap a metatable around remote comms instances](https://devforum.roblox.com/t/wrapping-with-metatables-or-how-to-alter-the-functionality-of-roblox-objects-without-touching-them/221611)*

But oh well, right now it's out of scope for now as I don't really need it, it just would be nice though.