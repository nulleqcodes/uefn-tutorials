using { /Fortnite.com/AI }
using { /Fortnite.com/Characters }
using { /Fortnite.com/Devices }
using { /Verse.org/Colors }
using { /Verse.org/Random }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Verse.org/Simulation/Tags }

# A Verse-authored NPC Behavior that can be used within an NPC Character Definition or a NPC Spawner device's NPC Behavior Script Override.
bear_minion<public> := class(npc_behavior):

    GetGameManager()<decides><transacts>:game_manager=
        var FoundManager : ?game_manager = false
        TaggedActors := GetCreativeObjectsWithTag(global_device_manager{})
 
        for (TaggedActor : TaggedActors):
            if (GameManager := game_manager[TaggedActor]):
                set FoundManager = option{GameManager}
        FoundManager?

    # This function runs when the NPC is spawned in the world and ready to follow a behavior.
    OnBegin<override>()<suspends>:void =

        if:
            # Get the Agent (the NPC).
            Agent := GetAgent[]

            # Gets the Fortnite Character interface, which gets you access to its gameplay data 
            # including its AI module for navigation and focus.
            Character := Agent.GetFortCharacter[]

            # Get the Navigatable Interface, this allows you to tell it to move.
            Navigatable := Character.GetNavigatable[]

            # Get the Focus Interface, this allows you to tell it to look at something or somewhere.
            Focus := Character.GetFocusInterface[]

        then:

            loop:

                if(GameManager := GetGameManager[]):
                    if(AgentTarget := GameManager.GetMinionFollowTarget(Agent)?):
                        NavTarget := MakeNavigationTarget(AgentTarget)
                        race:
                            NavResultGoTo := Navigatable.NavigateTo(NavTarget)
                            Sleep(2.0)
                Sleep(0.25)
