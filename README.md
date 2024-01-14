# Zerio Proximity Prompts

This is a simple to use proximity prompt library, which can act as a great
alternative to GTA 5 Help Texts, Targetting Points, etc.

[**Preview**](https://www.youtube.com/watch?v=S2k_cC64QG8)

## Creating a prompt

(This includes all parameters, you can skip the ones you dont care about and it
will just use the default value)

```lua
exports["zerio-proximityprompt"]:AddNewPrompt({
    name = "testprompt", -- unique name, kinda like an "id"
    job = "police", -- job required to use it, remove if you want everyone to see it
    objecttext = "World", -- upper texqt / "object text"
    actiontext = "Interact with something", -- lower text / "action text"
    holdtime = 5000, -- amount of time you have to hold in milliseconds for it to execute the action
    key = "E", -- key to press
    position = vector3(0.0, 0.0, 0.0), -- position of the proximity prompt
    params = {"test", "data"}, -- this gets passed through into the usage callback as shown below
    usage = function(data, actions) -- function which gets executed when you use the proximity prompt
        -- actions is the same object which gets returned from `AddNewPrompt`, meaning you can use :Remove, :Update, and such on it.
        print("Proximity prompt got used, the following params got passed: " .. json.encode(data))
    end,
    drawdist = 3, -- max distance to see the prompt
    usagedist = 1.5 -- max distance to use the prompt
})
```

## Removing a prompt

```lua
local prompt = exports["zerio-proximityprompt"]:AddNewPrompt({})

prompt:Remove()
```

## Updating a prompt

```lua
local prompt = exports["zerio-proximityprompt"]:AddNewPrompt({})

prompt:Update({
    objecttext = "Test",
    key = "Q"
})
```

## Using it with an entity instead of a position

If you want to use an entity instead of a position you have to use the entity
value instead of the position value.

Old example with a prompt:

```lua
exports["zerio-proximityprompt"]:AddNewPrompt({
    position = vector3(0.0, 0.0, 0.0)
})
```

The same but changed to an entity:

```lua
exports["zerio-proximityprompt"]:AddNewPrompt({
    entity = 8911106
})
```

## Entity offsets example

```lua
exports["zerio-proximityprompt"]:AddNewPrompt({
    entity = 837378,
    offset = vector3(0.0, 1.0, 2.0)
})
```
