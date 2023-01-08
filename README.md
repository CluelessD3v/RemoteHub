# Remote Hub

# Remote Hub

An interface to create more powerful remote communications inspired by Sleitnick's [Signal](https://sleitnick.github.io/RbxUtil/api/Signal/), & [Net](https://sleitnick.github.io/RbxUtil/api/Net).

This utility does not tries to pull magic wizardry, or meta-brograming, *it just wraps around Remote instances (remote events, remote function, and object values) and give them much more functionality.*


# API's
Remote Hub includes 3 API's:
- Remote Events API called "Event" (For Remote Events)
- Remote Functions API called "Function" (For Remote Functions)
- Object Values API called "Value" (For Object values)

Each API has it's server and client version you can seamlessly retrieve

## Event
### Properties

#### `OnServerEvent`
[[abstract | Server]]
| This property can only be used in server scripts and modules required by server scripts
> *Equal to OnServerEvent*



#### `OnClientEvent`
[[abstract | Client]]
| This property can only be used in local scripts and modules required by local scripts
> *Equal to OnClientEvent*



<br>

---
---
---

<br>




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




#### Client
[[abstract | Client]]
| these methods can only be used in local scripts and modules required by local scripts

#### `getEvent`
> **Params: `(aName: string, aTimeout: number)` YIELDS**
> *Attempts to get Remote event of the given name created from the server, if it does not exists it'll wait the given timeout time or 5 seconds before it returns nil.*




<br>

---
---
---

<br>






## Function

## Value

### Properties

#### `Name`
>**`string`**
> *Non unique string identifier*

#### `Value`
>**`any` (Value type dependant) **
>*Holds a reference to a value*

### Events
#### `Changed`
>**RbxScriptSignal**
>*Fired whenever the Value is changed.*


### Methods
#### Server

#### `new`
>**Params:`name: string, type: string, initialValue: any?`**
> *Constructs a new object of the given type with the given name, the initial value is optional*


#### Client 
### `getValue` 
>**Params: `name: string, timeout: number?` YIELDS** 
>*Attempts to get an already created value from the server, if it does not exist it'll wait the given timeout or 5 seconds before it returns nil.*

[[abstract | Client]]
| these methods can only be used in local scripts and modules required by local scripts