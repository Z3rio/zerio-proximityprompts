Example usage:
(This includes all parameters, you can skip the ones you dont care about and it will just use the default value)

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
    usage = function(data) -- function which gets executed when you use the proximity prompt
        print("Proximity prompt got used, the following params got passed: " .. json.encode(data))
    end,
    drawdist = 3, -- max distance to see the prompt
    usagedist = 1.5 -- max distance to use the prompt
})
```

Removing a prompt:

```lua
local prompt = exports["zerio-proximityprompt"]:AddNewPrompt({})

prompt:remove()
```
