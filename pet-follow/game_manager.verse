
using { /Fortnite.com/Devices }
using { /Fortnite.com/Characters }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Verse.org/Simulation/Tags }

# See https://dev.epicgames.com/documentation/en-us/uefn/create-your-own-device-in-verse for how to create a verse device.

global_device_manager := class(tag){}

# A Verse-authored creative device that can be placed in a level
game_manager := class(creative_device):

    @editable
    var PlayerSpawner : player_spawner_device = player_spawner_device{}

    @editable
    var MinionSpawner : npc_spawner_device = npc_spawner_device{}

    var LastAgentSpawned : ?agent = false

    var MinionPlayerMapping : [agent]agent = map{}

    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=
        PlayerSpawner.SpawnedEvent.Subscribe(OnPlayerSpawn)
        MinionSpawner.SpawnedEvent.Subscribe(OnMinionSpawn)
    
    OnMinionSpawn(Agent:agent):void=
        if(ThisAgent := LastAgentSpawned?):
            if(set MinionPlayerMapping[Agent] = ThisAgent){}
    
    GetMinionFollowTarget(MinionAgent:agent)<transacts>:?agent=
        var FollowAgent : ?agent = false
        if(FoundAgent := MinionPlayerMapping[MinionAgent]):
            set FollowAgent = option{FoundAgent}
        return FollowAgent 
    
    OnPlayerSpawn(Agent:agent):void=
        if(FortCharacter := Agent.GetFortCharacter[]):
            if(MinionSpawner.TeleportTo[FortCharacter.GetTransform().Translation, rotation{}]):
                set LastAgentSpawned = option{Agent}
                MinionSpawner.Spawn()
