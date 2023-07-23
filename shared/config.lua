Config = {
    Locale = GetConvar("esx:locale", "en"), -- If you want to change UI language texts you can do it here: web/src/assets/translate.json !!IMPORTANT that this can only be modified with the unbuilt version.
    Colors = {
        Info = {
            ["money-text-color"] = "#4d6973",
            ["bank-text-color"] = "#32a852",
            ["job-text-color"] = "orange",
        },
        Status = {
            healthBar = "red",
            armorBar = "blue",
            drinkBar = "lightblue",
            foodBar = "yellow",
        },
        Speedo = {
            ["segment-color"] = "#eee",
            ["segment-progress-color"] = "green",
            ["number-color"] = "#eee",
            ["danger-color"] = "red",
            ["danger-progress-color"] = "pink",
            ["number-danger-color"] = "#eee",
            ["speedo-progress-color"] = "orange",
            ["damage-progress-color"] = "#258539",
            ["speedo-all-texts"] = "orange",
            ["engine-icon-color"] = "#FEC32C",
            ["tempomat-icon-color"] = "#FEC32C",
            ["light-icon-color"] = "#FEC32C",
            ["door-icon-color"] = "#FEC32C",
            ["fuel-icon-color"] = "white",
            ["fuel-level-color"] = "white",
            ["mileage-level-color"] = "#eee",
            ["unit-color"] = "white",
            ["current-speed-color"] = "pink",
            ["left-right-index-color"] = "#00B065",
            ["damage-icon-color"] = "white",
            ["speedo-background-color"] = "rgba(0,0,0,.5)",
            ["speedo-outer-circle-color"] = "#242222",
            ["speedo-nooble-color"] = "#48a3cb",
            ["speedo-nooble-container"] = "#1f2937",
            ["speedo-seatbelt-icon-color"] = "#D22B2B",
        },
    },
    Disable = {
        Status = false,
        Vehicle = false,
        Weapon = false,
        Position = false,
        Voice = false,
        Money = false,
        Info = false,
        IndicatorSound = false, --vehicle index sound
        IndicatorSeatbeltSound = false, --seatbelt sound
        VehicleHandlers = false, -- Engine toggle, Indicator lights
        MinimapOnFoot = false,
        Needle = true,
        StatusPercent = true,
        CenterStatuses = true,
    },
    Default = {
        ServerLogo = "https://esx.s3.fr-par.scw.cloud/blanc-800x800.png",
        Kmh = false,
        PassengerSpeedo = false, -- if this true , you can see speedometer if you don't driver
    },
}
