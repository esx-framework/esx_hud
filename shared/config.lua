Config = {
    Lang = GetConvar('esx:locale', 'en'):upper(),
    Colors = {
        Info = {
            ['money-text-color'] = "#4d6973",
            ['bank-text-color'] = "#32a852",
            ['job-text-color'] = "orange",
        },
        Status = {
            healthBar = 'orange',
            armorBar = 'blue',
            drinkBar = 'lightblue',
            foodBar = 'yellow'
        },
        Speedo = {
            ['segment-color'] = '#eee',
            ['segment-progress-color'] = 'green',
            ['number-color'] = '#eee',
            ['danger-color'] = 'red',
            ['danger-progress-color'] = 'pink',
            ['number-danger-color'] = '#eee',
            ['speedo-progress-color'] = 'orange',
            ['damage-progress-color'] = '#258539',
            ['speedo-all-texts'] = 'orange',
            ['engine-icon-color'] = "#FEC32C",
            ['tempomat-icon-color'] = "#FEC32C",
            ['light-icon-color'] = "#FEC32C",
            ['door-icon-color'] = "#FEC32C",
            ['fuel-icon-color'] = "white",
            ['fuel-level-color'] = "white",
            ['mileage-level-color'] = "#eee",
            ['unit-color'] = "white",
            ['current-speed-color'] = "pink",
            ['left-right-index-color'] = "#00B065",
            ['damage-icon-color'] = "white",
            ['speedo-background-color'] = "rgba(0,0,0,.5)",
            ['speedo-outer-circle-color'] = "#242222",
            ['speedo-nooble-color'] = "#48a3cb",
            ['speedo-nooble-container'] = "#1f2937"
        }
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
        VehicleHandlers = false, -- Engine toggle, Indicator lights
        MinimapOnFoot = false,
        Needle = true,
        StatusPercent = false,
        CenterStatuses = false,
        PassengerSpeedo = true
    },
    Default = {
        ServerLogo = 'https://esx.s3.fr-par.scw.cloud/blanc-800x800.png',
        Kmh = false,
    }
}
