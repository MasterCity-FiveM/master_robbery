Config = {}
Translation = {}

Config.Shopkeeper = 416176080 -- hash of the shopkeeper ped
Config.Locale = 'en' -- 'en', 'sv' or 'custom'

Config.Shops = {
    -- {coords = vector3(x, y, z), heading = peds heading, money = {min, max}, cops = amount of cops required to rob, blip = true: add blip on map false: don't add blip, name = name of the store (when cops get alarm, blip name etc)}
    -- PD Zone
	{coords = vector3(24.03, -1345.63, 29.5-0.98), heading = 266.0, money = {500, 1000}, cops = 2, blip = true, name = 'Shop Robbery', cooldown = 2700, lastrobbed = 0, rob_time = 2000, organ = 'police'},
    {coords = vector3(-705.73, -914.91, 19.22-0.98), heading = 91.0, money = {600, 1200}, cops = 2, blip = true, name = 'Shop Robbery', cooldown = 2700, lastrobbed = 0, rob_time = 2000, organ = 'police'},
	{coords = vector3(-47.01099, -1759.108, 29.41467), heading = 50.0, money = {500, 1000}, cops = 2, blip = true, name = 'Shop Robbery', cooldown = 2700, lastrobbed = 0, rob_time = 2000, organ = 'police'},
	{coords = vector3(1134.04, -983.1033, 46.39929), heading = 275.0, money = {500, 1000}, cops = 2, blip = true, name = 'Shop Robbery', cooldown = 2700, lastrobbed = 0, rob_time = 2000, organ = 'police'},
	{coords = vector3(-1221.152, -908.189, 12.31213), heading = 35.0, money = {500, 1000}, cops = 2, blip = true, name = 'Shop Robbery', cooldown = 2700, lastrobbed = 0, rob_time = 2000, organ = 'police'},
	{coords = vector3(1165.358, -323.6835, 69.19702), heading = 100.0, money = {500, 1000}, cops = 2, blip = true, name = 'Shop Robbery', cooldown = 2700, lastrobbed = 0, rob_time = 2000, organ = 'police'},
	{coords = vector3(-1486.549, -377.3934, 40.14795), heading = 130.0, money = {500, 1000}, cops = 2, blip = true, name = 'Shop Robbery', cooldown = 2700, lastrobbed = 0, rob_time = 2000, organ = 'police'},
	{coords = vector3(372.1714, 326.3209, 103.5538), heading = 250.0, money = {500, 1000}, cops = 2, blip = true, name = 'Shop Robbery', cooldown = 2700, lastrobbed = 0, rob_time = 2000, organ = 'police'},
	-- Biron Shahr / Ham Bara PD Ham Sheriff
	{coords = vector3(2557.108, 380.5319, 108.6088), heading = 1.0, money = {500, 1000}, cops = 2, blip = true, name = 'Shop Robbery', cooldown = 2700, lastrobbed = 0, rob_time = 2000, organ = 'sheriff'},
	{coords = vector3(-1819.108, 793.7407, 138.0623), heading = 135.0, money = {500, 1000}, cops = 2, blip = true, name = 'Shop Robbery', cooldown = 2700, lastrobbed = 0, rob_time = 2000, organ = 'sheriff'},
	{coords = vector3(-2965.952, 391.5428, 15.04175), heading = 85.0, money = {500, 1000}, cops = 2, blip = true, name = 'Shop Robbery', cooldown = 2700, lastrobbed = 0, rob_time = 2000, organ = 'sheriff'},
	{coords = vector3(-3038.835, 584.1627, 7.897461), heading = 20.0, money = {500, 1000}, cops = 2, blip = true, name = 'Shop Robbery', cooldown = 2700, lastrobbed = 0, rob_time = 2000, organ = 'sheriff'},
	{coords = vector3(-3242.624, 999.6791, 12.81763), heading = 350.0, money = {500, 1000}, cops = 2, blip = true, name = 'Shop Robbery', cooldown = 2700, lastrobbed = 0, rob_time = 2000, organ = 'sheriff'},
	-- Sheriff Zone
	{coords = vector3(549.4022, 2671.068, 42.15308), heading = 100.0, money = {500, 1000}, cops = 2, blip = true, name = 'Shop Robbery', cooldown = 2700, lastrobbed = 0, rob_time = 2000, organ = 'sheriff'},
	{coords = vector3(1165.226, 2711.288, 38.14282), heading = 180.0, money = {500, 1000}, cops = 2, blip = true, name = 'Shop Robbery', cooldown = 2700, lastrobbed = 0, rob_time = 2000, organ = 'sheriff'},
	{coords = vector3(2677.899, 3279.059, 55.22852), heading = 330.0, money = {500, 1000}, cops = 2, blip = true, name = 'Shop Robbery', cooldown = 2700, lastrobbed = 0, rob_time = 2000, organ = 'sheriff'},
	{coords = vector3(1391.921, 3606.264, 34.9751), heading = 200.0, money = {500, 1000}, cops = 2, blip = true, name = 'Shop Robbery', cooldown = 2700, lastrobbed = 0, rob_time = 2000, organ = 'sheriff'},
	{coords = vector3(1959.692, 3739.899, 32.32971), heading = 300.0, money = {500, 1000}, cops = 2, blip = true, name = 'Shop Robbery', cooldown = 2700, lastrobbed = 0, rob_time = 2000, organ = 'sheriff'},
	{coords = vector3(1697.314, 4922.677, 42.052), heading = 320.0, money = {500, 1000}, cops = 2, blip = true, name = 'Shop Robbery', cooldown = 2700, lastrobbed = 0, rob_time = 2000, organ = 'sheriff'},
	{coords = vector3(1727.618, 6415.411, 35.02563), heading = 240.0, money = {500, 1000}, cops = 2, blip = true, name = 'Shop Robbery', cooldown = 2700, lastrobbed = 0, rob_time = 2000, organ = 'sheriff'}
}

Translation = {
    ['en'] = {
        ['shopkeeper'] = 'shopkeeper',
        ['robbed'] = "I was just robbed and ~r~don't ~w~have any money left!",
        ['cashrecieved'] = 'You got:',
        ['currency'] = '$',
        ['scared'] = 'Scared:',
        ['no_cops'] = 'There are ~r~not~w~ enough cops online!',
        ['cop_msg'] = 'We have sent a photo of the robber taken by the CCTV camera!',
        ['set_waypoint'] = 'Set waypoint to the store',
        ['hide_box'] = 'Close this box',
        ['robbery'] = 'Robbery in progress',
        ['walked_too_far'] = 'You walked too far away!'
    },
    ['sv'] = {
        ['shopkeeper'] = 'butiksbiträde',
        ['robbed'] = 'Jag blev precis rånad och har inga pengar kvar!',
        ['cashrecieved'] = 'Du fick:',
        ['currency'] = 'SEK',
        ['scared'] = 'Rädd:',
        ['no_cops'] = 'Det är inte tillräckligt med poliser online!',
        ['cop_msg'] = 'Vi har skickat en bild på rånaren från övervakningskamerorna!',
        ['set_waypoint'] = 'Sätt GPS punkt på butiken',
        ['hide_box'] = 'Stäng denna rutan',
        ['robbery'] = 'Pågående butiksrån',
        ['walked_too_far'] = 'Du gick för långt bort!'
    },
    ['custom'] = { -- edit this to your language
        ['shopkeeper'] = '',
        ['robbed'] = '',
        ['cashrecieved'] = '',
        ['currency'] = '',
        ['scared'] = '',
        ['no_cops'] = '',
        ['cop_msg'] = '',
        ['set_waypoint'] = '',
        ['hide_box'] = '',
        ['robbery'] = '',
        ['walked_too_far'] = ''
    }
}