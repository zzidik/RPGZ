-- RPGZ
---------------------
-- This module serves as the core manager for the RPGZ framework, 
-- handling initialization, scene management, event registration, 
-- player data handling, and system-wide controllers.


local RPGZ = {}

local Player = game.Players.LocalPlayer
local StarterGui = game:GetService("StarterGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Data = ReplicatedStorage:WaitForChild("Data")

local RPGZ_ReplicatedStorage = ReplicatedStorage:WaitForChild("RPGZ_ReplicatedStorage")
local Modules = RPGZ_ReplicatedStorage:WaitForChild("Modules")
local Controllers = Modules:WaitForChild("Controllers")
local Managers = Modules:WaitForChild("Managers")
local Utils = Modules:WaitForChild("Utils")

RPGZ.EventManager = require(Managers:WaitForChild("EventManager"))

---------------------------------------------
--[[ RPGZ EVENTS ]]
---------------------------------------------
-- The following events are registered within the RPGZ framework.
-- Developers can add listeners to these events to extend functionality 
-- or integrate custom game logic.
---------------------------------------------

-- Event: RPGZInitialized
-- Description:
--   Triggered when all RPGZ scripts have been loaded and initialized.
--   Useful for executing logic that depends on the full system being ready.
RPGZ.EventManager.Register("RPGZInitialized")

-- Event: FadeToBlackComplete
-- Description:
--   Triggered when the FadeScreenController has finished fading the screen to black.
RPGZ.EventManager.Register("FadeToBlackComplete")

-- Event: FadeToBlackComplete
-- Description:
--   Triggered when the FadeScreenController has finished fading the screen from black.
RPGZ.EventManager.Register("FadeFromBlackComplete")

-- Event: SceneLoaded
-- Description:
--   Triggered when a scene has finished loading.
-- Parameters:
--   1. (Model) A Model cloned into the Workspace. (optional).
RPGZ.EventManager.Register("SceneLoaded")

-- Event: SceneRunning
-- Description:
--   Triggered when a scene has faded in and is ready for interaction.
-- Parameters:
--   1. (Model) A Model cloned into the Workspace. (optional).
RPGZ.EventManager.Register("SceneRunning")

-- Event: PlayerRespawned
-- Description:
--   Triggered when the player has respawned.
RPGZ.EventManager.Register("PlayerRespawned")

-- Event: AlertGuiToggledOn
-- Description:
--   Triggered when the Alert GUI is displayed.
RPGZ.EventManager.Register("AlertGuiToggledOn")

-- Event: AlertGuiToggledOff
-- Description:
--   Triggered when the Alert GUI is closed.
RPGZ.EventManager.Register("AlertGuiToggledOff")

-- Event: CameraTransitionComplete
-- Description:
--   Triggered when a camera transition has finished.
RPGZ.EventManager.Register("CameraTransitionComplete")

-- Event: MainGuiToggledOn
-- Description:
--   Triggered when a frame in the Main GUI is toggled on.
-- Parameters:
--   1. (string) The name of the toggled-on frame (optional).
RPGZ.EventManager.Register("MainGuiToggledOn")

-- Event: MainGuiToggledOff
-- Description:
--   Triggered when a frame in the Main GUI is toggled off.
-- Parameters:
--   1. (string) The name of the toggled-off frame (optional).
RPGZ.EventManager.Register("MainGuiToggledOff")

-- Event: DialogStarted
-- Description:
--   Triggered when a conversation begins in the DialogController.
-- Parameters:
--   1. (string) The name of the started conversation (optional).
RPGZ.EventManager.Register("DialogStarted")

-- Event: DialogEnded
-- Description:
--   Triggered when a conversation ends in the DialogController.
-- Parameters:
--   1. (string) The name of the finished conversation (optional).
RPGZ.EventManager.Register("DialogEnded")

-- Event: MetricCreated
-- Description:
--   Triggered when a new metric is created by the MetricsManager.
-- Parameters:
--   1. (string) The name of the metric created (optional).
RPGZ.EventManager.Register("MetricCreated")

-- Event: MetricDestroyed
-- Description:
--   Triggered when a metric is removed by the MetricsManager.
-- Parameters:
--   1. (string) The name of the metric destroyed (optional).
RPGZ.EventManager.Register("MetricDestroyed")

-- Event: MetricValueChanged
-- Description:
--   Triggered when a metric's value is modified.
-- Parameters:
--   1. (string) The name of the modified metric (optional).
RPGZ.EventManager.Register("MetricValueChanged")

-- Event: MetricValueAtMax
-- Description:
--   Triggered when a metric reaches its maximum value.
-- Parameters:
--   1. (string) The name of the metric at max (optional).
RPGZ.EventManager.Register("MetricValueAtMax")

-- Event: MetricValueAtMin
-- Description:
--   Triggered when a metric reaches its minimum value.
-- Parameters:
--   1. (string) The name of the metric at min (optional).
RPGZ.EventManager.Register("MetricValueAtMin")

-- Event: MetricValueLooped
-- Description:
--   Triggered when a metric loops past its max value and resets.
-- Parameters:
--   1. (string) The name of the metric looped (optional).
RPGZ.EventManager.Register("MetricValueLooped")

-- Event: SubMetricValueChanged
-- Description:
--   Triggered when a sub-metric's value is modified.
-- Parameters:
--   1. (string) The name of the submetric modified (optional).
RPGZ.EventManager.Register("SubMetricValueChanged")

-- Event: SubMetricValueAtMax
-- Description:
--   Triggered when a sub-metric reaches its maximum value.
-- Parameters:
--   1. (string) The name of the submetric at max (optional).
RPGZ.EventManager.Register("SubMetricValueAtMax")

-- Event: SubMetricValueAtMin
-- Description:
--   Triggered when a sub-metric reaches its minimum value.
-- Parameters:
--   1. (string) The name of the submetric at min (optional).
RPGZ.EventManager.Register("SubMetricValueAtMin")

-- Event: SubMetricValueLooped
-- Description:
--   Triggered when a sub-metric loops past its max value and resets.
-- Parameters:
--   1. (string) The name of the submetric looped (optional).
RPGZ.EventManager.Register("SubMetricValueLooped")

-- Event: ItemSpawned
-- Description:
--   Triggered when an item is spawned by the ItemManager.
-- Parameters:
--   1. (string) The name of the spawned item (optional).
RPGZ.EventManager.Register("ItemSpawned")

-- Event: ItemCollected
-- Description:
--   Triggered when an item is collected by the player.
-- Parameters:
--   1. (string) The name of the collected item (optional).
RPGZ.EventManager.Register("ItemCollected")

-- Event: ItemUnlocked
-- Description:
--   Triggered when an item is unlocked and available for spawning.
-- Parameters:
--   1. (string) The name of the unlocked item (optional).
RPGZ.EventManager.Register("ItemUnlocked")

-- Event: ItemAction
-- Description:
--   Triggered when an action button is pressed for a selected inventory item.
-- Parameters:
--   1. (string) The name of the item (optional).
--   2. (string) The name of the action performed (optional).
RPGZ.EventManager.Register("ItemAction")

-- Event: ItemRemoved
-- Description:
--   Triggered when an item is removed from the player's inventory.
-- Parameters:
--   1. (string) The name of the removed item (optional).
RPGZ.EventManager.Register("ItemRemoved")

-- Event: QuestActivated
-- Description:
--   Triggered when a quest is activated in the QuestManager.
-- Parameters:
--   1. (string) The PID of the Quest activated (optional).
RPGZ.EventManager.Register("QuestActivated")

-- Event: QuestCompleted
-- Description:
--   Triggered when a quest is completed.
-- Parameters:
--   1. (string) The PID of the Quest completed (optional).
RPGZ.EventManager.Register("QuestCompleted")

-- Event: ObjectiveCompleted
-- Description:
--   Triggered when a quest objective is completed.
-- Parameters:
--   1. (string) The PID of the Quest the Objective is for (optional).
--   2. (string) The PID of the Objective completed (optional).
RPGZ.EventManager.Register("ObjectiveCompleted")

-- Event: AllQuestsAreComplete
-- Description:
--   Triggered when all quests in the game are completed.
RPGZ.EventManager.Register("AllQuestsAreComplete")

-- Event: Reset
-- Description:
--   Triggered when the player confirms a reset of their game data.
RPGZ.EventManager.Register("Reset")

-- Event: ResetComplete
-- Description:
--   Triggered when player data has been successfully reset.
RPGZ.EventManager.Register("ResetComplete")

-- Event: DataLoadComplete
-- Description:
--   Triggered when player data has finished loading.
RPGZ.EventManager.Register("DataLoadComplete")

-- Event: DataSaveComplete
-- Description:
--   Triggered when player data has been successfully saved.
RPGZ.EventManager.Register("DataSaveComplete")

---------------------------------------------
--[[ END RPGZ EVENTS ]]
---------------------------------------------


-- Controllers
RPGZ.AlertGuiController = require(Controllers:WaitForChild("AlertGuiController"))
RPGZ.ExamineController = require(Controllers:WaitForChild("ExamineController"))
RPGZ.FadeScreenController = require(Controllers:WaitForChild("FadeScreenController"))
RPGZ.CameraController = require(Controllers:WaitForChild("CameraController"))
RPGZ.DialogController = require(Controllers:WaitForChild("DialogController"))
RPGZ.InventoryController = require(Controllers:WaitForChild("InventoryController"))
RPGZ.MainGuiController = require(Controllers:WaitForChild("MainGuiController"))
RPGZ.PlayerController = require(Controllers:WaitForChild("PlayerController"))
RPGZ.TeleportController = require(Controllers:WaitForChild("TeleportController"))
RPGZ.UIScaleController = require(Controllers:WaitForChild("UIScaleController"))

-- Data Sources
RPGZ.DefualtPlayerData = require(Data:WaitForChild("DefaultPlayerData"))
RPGZ.StaticGameData = require(Data:WaitForChild("StaticGameData"))
RPGZ.CheckpointData = require(Data:WaitForChild("CheckpointData"))

-- Managers
RPGZ.SceneManager = require(Managers:WaitForChild("SceneManager"))
RPGZ.ItemManager = require(Managers:WaitForChild("ItemManager"))
RPGZ.InteractivityManager = require(Managers:WaitForChild("InteractivityManager"))
RPGZ.LightingManager = require(Managers:WaitForChild("LightingManager"))
RPGZ.LocalPlayerDataManager = require(Managers:WaitForChild("LocalPlayerDataManager"))
RPGZ.MetricsManager = require(Managers:WaitForChild("MetricsManager"))
RPGZ.ProximityPromptManager = require(Managers:WaitForChild("ProximityPromptManager"))
RPGZ.ProximityPromptStyleManager = require(Managers:WaitForChild("ProximityPromptStyleManager"))
RPGZ.QuestManager = require(Managers:WaitForChild("QuestManager"))
RPGZ.SettingsManager = require(Managers:WaitForChild("SettingsManager"))
RPGZ.CheckpointManager = require(Managers:WaitForChild("CheckpointManager"))

-- Utilities
RPGZ.InputDetectionUtility = require(Utils:WaitForChild("InputDetectionUtility"))
RPGZ.TableUtility = require(Utils:WaitForChild("TableUtility"))

-- USE DURING DEVELOPMENT FOR TESTING
-- SET TO FALSE IN PRODUCTION VERSION OF GAME
-- Set to true to start and respawn without using saved data 
-- When true the player data will be set to DefualtPlayerData
-- at start and respawn
local startFresh = false

-- SET TO FALSE IN PRODUCTION VERSION OF GAME
-- When true, if the GameVersion in their player data is missing 
-- or does not match the GameVersion in the DefualtPlayerData, 
-- the player's data will be reset when they join the game
-- See the CheckGameVersion for more player data patching options
local resetPlayerDataIfGameVersionIncorrect = true

-- True when the player data is loadeding
local isLoading = false

-- True when the RPGZ is intialized
local isInitialized = false

-- True after a player has died or choosen to respawn
local hasPlayerRespawned = false

-- the number of times the game has attempted to load the player data from the server
local loadAttempts = 0

-- the maximum load attempts 
local maxLoadAttempts = 3

-- the name of the loaded scene
-- to get the name of the loaded scene in your game
-- use the SceneManager
local sceneName = nil


-- initialize early in case it is needed to display load error
RPGZ.AlertGuiController.Initialize()


-- Returns the name of the first scene in the game.
-- The first scene is stored as a PID in DefaultPlayerData.
-- This scene does not change during gameplay.
local function GetFirstSceneName()
	--return RPGZ.SceneManager.GetSceneName(RPGZ.DefualtPlayerData.CurrentScene)
	
	return RPGZ.SceneManager.GetSceneName(RPGZ.StaticGameData.FirstScenePID)
end


-- Returns the name of the last saved scene.
-- Retrieves the CurrentScene value from local player data.
-- Used to resume the game from where the player last left off.
local function GetLastSavedSceneName()
	local localPlayerData = RPGZ.LocalPlayerDataManager.GetLocalPlayerData()
	return RPGZ.SceneManager.GetSceneName(localPlayerData.CurrentScene)	
end


-- Checks the player's saved game version against the current version.
-- If the version matches, no action is taken.
-- If the version is missing or incorrect, the player data may be patched or reset.
-- By default, resets the player data for safety.
-- Can be modified to implement version-based data patches instead.
local function CheckGameVersion()
	
	local localPlayerData = RPGZ.LocalPlayerDataManager.GetLocalPlayerData()
	
	-- first verify the player data has a GameVersion
	if localPlayerData.GameVersion then		
		print("Current GameVersion is " .. RPGZ.DefualtPlayerData.GameVersion .. ". Player GameVersion is " .. localPlayerData.GameVersion)
	end
	
	-- check if the player data has a correct GameVersion
	if localPlayerData.GameVersion and localPlayerData.GameVersion == RPGZ.DefualtPlayerData.GameVersion then
		
		-- if so, nothing will normally be needed
		
		print("Player's GameVersion is correct")	
		
	-- if not
	else
		
		-- send the proper warning
		if not localPlayerData.GameVersion then			
			warn("Player data was created with out a GameVersion.")			
		elseif localPlayerData.GameVersion ~= RPGZ.DefualtPlayerData.GameVersion then 
			print("Player's GameVersion is incorrect")
		end				
		
		-- HERE IS WHERE YOU CAN WRITE CUSTOM PATCHES FOR THE PLAYER DATA	
		
		-- resetting the player data will add the GameVersion
		-- since it should be in your DefualtPlayerData
		-- if you are patching some other way...
		-- DONT' FORGET TO ADD
		-- GameVersion property to the player data
		-- localPlayerData.GameVersion = RPGZ.DefualtPlayerData.GameVersion				
		
		
		-- FOR EXAMPLE
		-- add some new data for players who are already playing?
		-- if not localPlayerData.newData then
		-- 		localPlayerData.newData = 10
		--		localPlayerData.GameVersion = RPGZ.DefualtPlayerData.GameVersion	
		--		RPGZ.LocalPlayerDataManager.SetLocalPlayerData(localPlayerData)		
		-- end
		
		
		-- for now, we will just reset the player data for safety
		-- delete these lines, or set if resetPlayerDataIfGameVersionIncorrect to false
		-- you wish to patch another way
		if resetPlayerDataIfGameVersionIncorrect == true then
			local freshPlayerData = RPGZ.LocalPlayerDataManager.GetFreshLocalPlayerData()
			RPGZ.LocalPlayerDataManager.SetLocalPlayerData(freshPlayerData)		
			warn("Player data has been reset for safety.")	
			-- since we reset the data, we need to return the player to the inital scene of the game
			return GetFirstSceneName()
		end
	end
	
	return nil
end


-- Initializes all RPGZ modules and systems.
-- Ensures the correct game version is used before proceeding.
-- Calls initialization functions for UI controllers, quest systems, and managers.
-- Disables jumping for the player.
-- Prevents interactivity until initialization is complete.
-- Triggers the "RPGZInitialized" event.
-- @param newSceneName (string) The name of the scene to initialize (optional).
local function Initialize(newSceneName)	
	
	-- the GameVersion might effect which scene is loaded
	local altScenename = CheckGameVersion()
	
	if altScenename ~= nil then
		newSceneName = altScenename
	end

	RPGZ.MainGuiController.Initialize()
	RPGZ.ExamineController.Initialize()
	RPGZ.DialogController.Initialize()
	RPGZ.InventoryController.Initialize()	
	RPGZ.QuestManager.Initialize()
	RPGZ.MetricsManager.Initialize()
	RPGZ.ProximityPromptStyleManager.Initialize()
	RPGZ.SettingsManager.Initialize()

	RPGZ.PlayerController.DisableJumping()	

	isInitialized = true

	isLoading = false

	RPGZ.InteractivityManager.NoInteractivity()

	sceneName = newSceneName

	RPGZ.EventManager.Trigger("RPGZInitialized")	

	-- Check the local player data size
	-- Make sure it is under 260,000!!!
	print("Playey Data Size:", RPGZ.LocalPlayerDataManager.GetDataSize() .. " / 260000")
end


-- Modifies default Roblox GUI settings to fit the RPGZ framework.
-- Disables default UI elements such as the backpack, chat, and player list.
local function ModifyDefualtRobloxGui()
	StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)
	StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)
	StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.EmotesMenu, false)
	StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Health, false)
	StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)
end


-- Handles the confirmation to reset player data due to a data error.
-- Resets player data and restarts the game.
local function OnResetFromDataErrorConfrim()

	startFresh = true

	Start()

	startFresh = false
end


-- Displays a confirmation prompt for resetting player data after an error.
-- Warns the player about the potential data loss.
-- Calls AlertGuiController to handle the prompt.
local function OnDataErroConfirm()

	print("Data error confrimed")

	local message = "Are you sure you want to reset? \n All saved data and progress \n will be lost."	

	RPGZ.AlertGuiController.SetConfirmButtonText("RESET")	
	RPGZ.AlertGuiController.DisplayConfirmOrCancelAlert("REPAIR DATA ERROR", message, OnResetFromDataErrorConfrim, "error")	
end


-- Attempts to load the player's saved data.
-- Retries a set number of times if data is unavailable.
-- Displays an error message if loading fails after multiple attempts.
-- If data is successfully loaded, initializes the game.
local function Load()

	loadAttempts += 1

	-- check if the player data is loaded
	-- if not yet loaded
	if RPGZ.LocalPlayerDataManager.GetLocalPlayerData() == nil then

		RPGZ.FadeScreenController.SetScreenToBlack()		

		print("Attempting to load player data...")

		-- comment this line out if you want to test data load failure
		RPGZ.LocalPlayerDataManager.LoadData()

		wait(2) -- pause while the data loads

		-- check if the player data is loaded after the wait
		if RPGZ.LocalPlayerDataManager.GetLocalPlayerData() == nil then

			if loadAttempts <= maxLoadAttempts then

				Load() -- try to load again				
			else

				local message = "Can't locate player data. \n Reset or try again later."

				RPGZ.AlertGuiController.SetConfirmButtonText("RESET")				
				RPGZ.AlertGuiController.DisplayConfirmOrCancelAlert("DATA LOADING ERROR", message, OnDataErroConfirm, "error")	
			end

		else -- when the player data is loaded	
			if isInitialized == false then
				Initialize(GetLastSavedSceneName()) -- initializ the modules
			end
		end
		return			

	-- when the player data is loaded	
	else 	

		loadAttempts = 0

		if isInitialized == false then
			Initialize(GetLastSavedSceneName()) -- initializ the modules
		end
	end
end


-- Begins the RPGZ sequence.
-- Sets up game initialization and player data loading.
-- Resets player data if the startFresh flag is enabled.
-- Ensures interactivity is disabled until loading is complete.
function Start()

	isLoading = true	

	isInitialized = false

	-- interactivity is disabled until scene is loaded
	RPGZ.InteractivityManager.NoInteractivity()

	if startFresh == true then

		-- sets local player data to default
		local freshPlayerData = RPGZ.LocalPlayerDataManager.GetFreshLocalPlayerData()
		RPGZ.LocalPlayerDataManager.SetLocalPlayerData(freshPlayerData)

		Initialize(GetLastSavedSceneName())		
	else		
		-- get player data from server
		Load()
	end
end


-- Triggered when a scene has finished loading.
-- Logs the loaded scene's name.
-- @param scene (Instance) The scene object that was loaded.
local function OnSceneLoaded(scene)

	print(scene.Name .. " has been loaded.")	
end


-- Triggered when a scene has started running and is interactive.
-- Enables full player interactivity.
-- @param scene (Instance) The scene object that is now running.
local function OnSceneRunning(scene)

	print(scene.Name .. " is running.")

	RPGZ.InteractivityManager.FullInteractivity()
end


-- Handles the player respawning process.
-- Restores camera settings and UI.
-- Ensures the player is placed correctly in the scene.
local function OnPlayerRespawn()

	print("Player has respawned.")

	if RPGZ.SceneManager.Scene ~= nil then

		RPGZ.FadeScreenController.SetScreenToBlack()		

		RPGZ.SceneManager.LightsCameraAction()

		wait(1) -- wait for camera to get into position

		RPGZ.FadeScreenController.FadeFromBlack(0.5)

		RPGZ.InteractivityManager.FullInteractivity()

	else
		warn("There is no scene loaded to respawn into.")
	end
end


-- Handles events when the player dies or chooses to respawn.
-- Disables interactivity.
-- Hides any open UI elements.
-- Fades the screen to black to transition to the respawn state.
-- @param character (Model) The player's character that died or respawned.
local function OnPlayerDeathOrRespawn(character)	

	print("Player has died, or elected to respawn.")

	hasPlayerRespawned = true

	RPGZ.InteractivityManager.NoInteractivity() -- stop all interactivity

	RPGZ.AlertGuiController.HideAlert()

	RPGZ.DialogController.HideDialog()
	
	RPGZ.ExamineController.HideExamine()

	RPGZ.CameraController.CutToShot("Pause") -- stop the camera from trying to follow the player

	RPGZ.FadeScreenController.FadeToBlack(0.5) -- fade the screen to black and while waiting for respawn
end


-- Triggered when the player character is added to the game.
-- Connects the death event to handle respawning.
-- Determines whether this is a new player or a respawned player.
-- @param character (Model) The player's character that was added.
local function OnCharacterAdded(character)
	
	-- connect the player death event
	-- this will fire when the player dies or elects to respawn
	local humanoid = character:WaitForChild("Humanoid")
	humanoid.Died:Connect(OnPlayerDeathOrRespawn)
	
	-- if this is a respawning player
	if hasPlayerRespawned == true then
		
		OnPlayerRespawn()

	-- if this is the player joining the game
	else		
		print("Player has joined the game.")
	end
end


-- Calls LocalPlayerDataManager to reset saved data.
-- Reloads the initial scene.
local function OnReset()

	RPGZ.LocalPlayerDataManager.ResetData()
end


-- Triggered when data has been successfully reset.
-- Re-initializes the game starting from the first scene.
-- Reloads the initial scene.
local function OnResetComplete()

	Initialize(GetFirstSceneName())	
	
	RPGZ.LoadScene()
end


-- Add some listeners to events
RPGZ.EventManager.AddListener("RPGZInitialized", RPGZ.SceneManager.SetRPGZReady)
RPGZ.EventManager.AddListener("SceneLoaded", OnSceneLoaded)
RPGZ.EventManager.AddListener("SceneRunning", OnSceneRunning)
RPGZ.EventManager.AddListener("Reset", OnReset)
RPGZ.EventManager.AddListener("ResetComplete", OnResetComplete)



------------------------------------------------------------------------------------------
--[[ RPGZ START SEQUENCE ]]
------------------------------------------------------------------------------------------
-- 1. Customize the defualt Roblox Gui
ModifyDefualtRobloxGui()

-- 2. Start RPGZ 
Start()

-- 3. Get the initial player
if Player.Character then
	OnCharacterAdded(Player.Character)
end

-- Since this is a single player game,
-- This will only be called when the player respawns
Player.CharacterAdded:Connect(OnCharacterAdded)
------------------------------------------------------------------------------------------
--[[ END RPGZ START SEQUENCE ]]
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------
--[[ RPGZ SHORTCUTS ]]
------------------------------------------------------------------------------------------
-- These shortcuts give quick acces to functions of the RPGZ system without having to be
-- be familar with the Controller, Manager and Utility Modules.
-- These functions needed for custom game logic.


-- ALERTS
-------------------------------------------

-- Displays a simple alert with a title, message, and an OK button.
-- Optionally executes a callback function when the alert is dismissed.
-- @param titleText (string) - The title of the alert.
-- @param alertMessage (string) - The message to be displayed in the alert.
-- @param callback (function) - (Optional) A function to execute when the alert is dismissed.
-- @param alertType (string) - The type of alert to display ("Alert", "Info", "Objective", "Quest", "Metric").
function RPGZ.DisplaySimpleAlert(titleText, alertMessage, callback, alertType)
	RPGZ.AlertGuiController.DisplaySimpleAlert(titleText, alertMessage, callback, alertType)
end

-- Displays an alert with a title, message, and two buttons: Confirm and Cancel.
-- If the confirm button is clicked, the provided callback function is executed.
-- @param titleText (string) - The title of the alert.
-- @param alertMessage (string) - The message to be displayed in the alert.
-- @param callback (function) - (Optional) A function to execute if the confirm button is clicked.
-- @param alertType (string) - The type of alert to display ("Alert", "Info", "Objective", "Quest", "Metric").
function RPGZ.DisplayConfirmOrCancelAlert(titleText, alertMessage, callback, alertType)
	RPGZ.AlertGuiController.DisplayConfirmOrCancelAlert(titleText, alertMessage, callback, alertType)
end

-- Customize the text label of the confirm button for confirm or cancel alerts.
-- @param confirmButtonText (string) - The text to display on the confirm button.
function RPGZ.SetConfirmButtonText(confirmButtonText)
	RPGZ.AlertGuiController.SetConfirmButtonText(confirmButtonText)
end
-------------------------------------------
-------------------------------------------

-- CAMERA
-------------------------------------------
-- Instantly cuts to a new camera shot without transitioning.
-- @param shotName (string) Name of the shot type:
-- - "FollowPlayer"
-- - "FollowPlayerMedium"
-- - "FollowPlayerClose" 
-- - "FollowPlayerFar"
-- - "Dialog"
-- - "Examine"
-- - "Custom"
-- @param shotConfig (table) Optional configuration table for the shot settings:
-- - RotationType (string) [Optional] - Fixed or Free. Fixed stays aligned to world. Free stays aligned with the follow object. Fixed by default.
-- - Follow (instance) [Optional] - An object the camera follows the postions of. Local player by default.
-- - LookAt (instance) [Optional] - An object the camera rotates to looks at. Local player by default.
-- - Offset (vector3) [Optional] - Offset the camera's position from the Follow object. Vector3.new(0, 0, 0) by default.
function RPGZ.CutToShot(shotName, shotConfig)
	RPGZ.CameraController.CutToShot(shotName, shotConfig)
end

-- Smoothly transitions to a new camera shot.
-- @param shotName (string) Name of the shot type:
-- - "FollowPlayer"
-- - "FollowPlayerMedium"
-- - "FollowPlayerClose" 
-- - "FollowPlayerFar"
-- - "Dialog"
-- - "Examine"
-- - "Custom"
-- @param shotConfig (table) Optional configuration table for the shot settings:
-- - RotationType (string) [Optional] - Fixed or Free. Fixed stays aligned to world. Free stays aligned with the follow object. Fixed by default.
-- - Follow (instance) [Optional] - An object the camera follows the postions of. Local player by default.
-- - LookAt (instance) [Optional] - An object the camera rotates to looks at. Local player by default.
-- - Offset (vector3) [Optional] - Offset the camera's position from the Follow object. Vector3.new(0, 0, 0) by default.
-- - PositionTransitionTime (number)[Optional] - Number of seconds it takes to transition to the position of the new shot.
-- - RotationTransitionTime (number) [Optional] - Number of seconds it takes to transition to the rotation of the new shot.
function RPGZ.TranstionToShot(shotName, shotConfig)
	RPGZ.CameraController.TranstionToShot(shotName, shotConfig)
end
-------------------------------------------
-------------------------------------------

-- CHECKPOINTS
-------------------------------------------

-- Loads a checkpoint by replacing the current player data
-- Re-initializes Metrics, Quests and Inventory to include any changes from the checkpoint
-- Loads a scene where the player is at checkpoint
-- @param checkpointName The name of the checkpoint to load
function RPGZ.LoadCheckpoint(checkpointName)
	
	RPGZ.CheckpointManager.LoadCheckpoint(checkpointName)
end
-------------------------------------------
-------------------------------------------

-- COLLISION
-------------------------------------------

-- Creates a collision-based door to another scene.
-- Automatically transitions when the player touches the door.
-- Disconnects the touch event after use to prevent multiple triggers.
-- @param object (Instance) The door object.
-- @param sceneName (string) The scene the door leads to.
-- @param config (table) Optional configuration settings.
-- Example config: {SpawnLocationName = "SpawnFrom_LastSceneName"}
function RPGZ.CreateCollisionDoor(object, sceneName, config)
	RPGZ.SceneManager.CreateCollisionDoor(object, sceneName, config)
end
-------------------------------------------
-------------------------------------------

-- DATA
-------------------------------------------

-- Retrieves the local copy of the player's data.
-- If the data is not yet defined, a warning is issued.
-- @return (table) - The local player data or nil if it has not been initialized.
function RPGZ.GetPlayerData()
	return RPGZ.LocalPlayerDataManager.GetLocalPlayerData()
end

-- Updates the local player data.
-- If auto-save is enabled, it schedules a save operation after a debounce delay.
-- @param playerData (table) - The new player data to store locally.
function RPGZ.SetPlayerData(playerData)
	RPGZ.LocalPlayerDataManager.SetLocalPlayerData(playerData)
end
-------------------------------------------
------------------------------------------

-- DIALOG
-------------------------------------------

-- Checks if a persistent conversation has already been completed.
-- @param dialogData (table) The dialog data structure.
-- @param conversationName (string) The name of the conversation.
-- @return (boolean) True if the conversation has been completed, false otherwise
function RPGZ.IsConversationComplete(dialogData, conversationPID)
	return RPGZ.DialogController.IsConversationComplete(dialogData, conversationPID)
end

-- Initiates a dialog sequence.
-- Triggers the start of a conversation, ensuring all necessary
-- systems are active and the sequence begins at the specified conversation.
-- @param dialogWith (Instance) The object the player is talking to.
-- @param dialogData (table) The dialog data structure.
-- @param conversationName (string) The name of the conversation.
function RPGZ.StartDialog(dialogWithObject, dialogData, conversationName)
	RPGZ.DialogController.StartDialog(dialogWithObject, dialogData, conversationName)
end
-------------------------------------------
-------------------------------------------

-- EVENTS
-------------------------------------------

-- Adds a listener (callback function) to a registered event.
-- Ensures the event is registered before adding the listener.
-- @param eventName (string) The unique identifier of the event.
-- @param callback (function) The function to execute when the event is triggered.
-- @return (function) The callback reference for potential removal.
function RPGZ.AddListener(eventName, callback)
	RPGZ.EventManager.AddListener(eventName, callback)
end

-- Checks if a given event has been registered.
-- @param eventId (string) The unique identifier of the event.
-- @return (boolean) True if the event is registered, otherwise false.
function RPGZ.IsEventRegistered(eventName)
	RPGZ.EventManager.IsEventRegistered(eventName)
end

-- Registers a new event if it has not already been registered.
-- Creates an empty listener table for the event.
-- @param eventId (string) The unique identifier of the event
function RPGZ.RegisterNewEvent(eventName)
	RPGZ.EventManager.Register(eventName)
end

-- Removes a specific listener (callback function) from an event.
-- Warns if the event has no registered listeners or if the callback is not found.
-- @param eventName (string) The unique identifier of the event.
-- @param callback (function) The function to remove from the event's listener list.
function RPGZ.RemoveListener(eventName, callback)
	RPGZ.EventManager.RemoveListener(eventName, callback)
end
-------------------------------------------
-------------------------------------------

-- INTERACTIVITY
-------------------------------------------

-- Restores full player interactivity if no alerts are active.
-- Moves the taskbar onto the screen.
-- Enables player movement.
-- Binds input keys for UI navigation.
-- Enables all proximity prompts.
-- Only executes if `onAlert` is false.
function RPGZ.FullInteractivity()
	RPGZ.InteractivityManager.FullInteractivity()
end

-- Disables all player interactivity.
-- Moves the taskbar off the screen.
-- Disables player movement.
-- Hides all UI frames.
-- Unbinds UI navigation keys.
-- Disables all proximity prompts.
function RPGZ.NoInteractivity()
	RPGZ.InteractivityManager.NoInteractivity()
end
-------------------------------------------
-------------------------------------------

-- ITEMS
------------------------------------------

-- Unlocks an item.
-- If the player is currently in the scene where the item is located,
-- the item will be spawned into the scene. Otherwise, the item will
-- spawn the next time the player enters that scene.
-- @param itemPID (string)  The unique Persistent ID (PID) of the item
-- found in StaticGameData -> Places -> Scene -> Items.
function RPGZ.UnlockItem(itemPID)
	RPGZ.ItemManager.UnlockItemByPID(itemPID)
end
------------------------------------------
------------------------------------------

-- LIGHTING
-------------------------------------------

-- Applies a predefined lighting scenario with smooth transitions.
-- This function adjusts various lighting properties such as brightness, fog, ambient color,
-- and color correction based on the selected scenario.
-- @param scenarioName (string) - The name of the lighting scenario to apply.
-- @param duration (number) [optional] - The duration of the transition (default: 1 second).
function RPGZ.ChangeLightingScenario(scenarioName, duration)
	RPGZ.LightingManager.SetScenario(scenarioName, duration)
end
-------------------------------------------
-------------------------------------------

-- PLAYER
-------------------------------------------

-- Gets the local player.
-- @return (Player) The local player.
function RPGZ.GetLocalPlayer()	
	return game.Players.LocalPlayer
end

-- Checks if the player is within a certain distance of a given object.
-- Useful for triggering proximity-based interactions.
-- @param object (Instance) The object to check distance from.
-- @param distanceThreshold (number) The maximum distance allowed.
-- @return (boolean) True if the player is within range, otherwise false.
function RPGZ.IsPlayerNearObject(object, distanceThreshold)
	return RPGZ.PlayerController.IsPlayerNearObject(object, distanceThreshold)
end
-------------------------------------------
-------------------------------------------

-- PROXIMITY PROMPTS
-------------------------------------------

-- Creates a proximity prompt door to another scene.
-- Displays a prompt when near the door.
-- Uses a button press to transition to the new scene.
-- @param object (Instance) The door object.
-- @param sceneName (string) The scene the door leads to.
-- @param config (table) Optional configuration settings.
-- Example config: {SpawnLocationName = "SpawnFrom_LastSceneName"}
function RPGZ.AssignDoorPromptTo(object, sceneName, config)
	RPGZ.SceneManager.CreatePromptDoor(object, sceneName, config)
end

-- Sets up a proximity prompt on the object.
-- Allows players to interact with the object to start an examination.
-- @param object (Instance) The object the player is examining.
-- @param dialogData (table) The dialog data structure.
-- @param conversationName (string) The name of the conversation.
function RPGZ.AssignExamineDialogPromptTo(object, dialogData, conversationName)
	RPGZ.ExamineController.AssignExamineDialogPromptTo(object, dialogData, conversationName)
end

-- Displays a popup on proximity
-- Pop ups a simple GUI that can display a title and text.
-- @param object (Instance) The object the player is examining.
-- @param popUpTitle (string) The title on the pop up.
-- @param popUpText (string) Text message on the pop up.
function RPGZ.AssignExaminePopUpTo(object, popUpTitle, popUpText)
	RPGZ.ExamineController.AssignExaminePopUpTo(object, popUpTitle, popUpText)
end

-- Sets up a proximity prompt on the object.
-- Allows players to interact with the object to start a conversation.
-- @param object (Instance) The object the player can talk to.
-- @param dialogData (table) The dialog data structure.
-- @param conversationName (string) The name of the conversation.
function RPGZ.AssignDialogPromptTo(object, dialogData, conversationName)
	RPGZ.DialogController.AssignDialogPromptTo(object, dialogData, conversationName)
end

-- Removes a proximity prompt from a specified object.
-- If the object has an associated proximity prompt, it is destroyed along with 
-- its parent attachment if applicable. The reference is also removed from the internal tracking table.
-- @param object (Instance) The object from which to remove the proximity prompt.
function RPGZ.RemovePromptFrom(object)
	RPGZ.ProximityPromptManager.RemoveProximityPromptFromObject(object)
end
-------------------------------------------
-------------------------------------------

-- METRICS
-------------------------------------------

-- Adds a metric from StaticGameData to ActiveMetrics in player data
-- @param metricName (string) - The name of the metric to add to the ActiveMetrics.
function RPGZ.ActivateMetric(metricName)
	RPGZ.MetricsManager.ActivateMetric(metricName)
end

-- Adds a specified amount to a metric's value.
-- This function increases the value of the specified metric while considering 
-- constraints such as max values and looping behavior. It also updates the UI 
-- and triggers relevant events.
-- @param metricName (string) - The name of the metric to modify.
-- @param amountToAdd (number) - The amount to add to the metric's value.
function RPGZ.AddToMetric(metricName, valueToAdd)
	RPGZ.MetricsManager.AddToMetric(metricName, valueToAdd)
end

-- Adds a specified amount to a submetric's value.
-- This function increases the value of a submetric within a metric, considering 
-- constraints such as max values and looping behavior. It also updates the UI 
-- and triggers relevant events.
-- @param metricName (string) - The name of the parent metric.
-- @param subMetricName (string) - The name of the submetric to modify.
-- @param amountToAdd (number) - The amount to add to the submetric's value.
function RPGZ.AddToSubMetric(metricName, subMetricName, amountToAdd)
	RPGZ.MetricsManager.AddToSubMetric(metricName, subMetricName, amountToAdd)
end

-- Removes a metric from the ActiveMetrics in player data
-- @param metricName (string) - The name of the metric to remove from the ActiveMetrics.
function RPGZ.DeactivateMetric(metricName)
	RPGZ.MetricsManager.DeactivateMetric(metricName)
end

-- Retrieves the current value of a metric.
-- This function searches for the specified metric in the player's data 
-- and returns its current value. If the metric does not exist, it logs a warning.
-- @param metricName (string) - The name of the metric to retrieve.
-- @return (number | nil) - The current value of the metric, or nil if not found.
function RPGZ.GetMetricValue(metricName)
	return RPGZ.MetricsManager.GetMetricValue(metricName)
end

-- Retrieves the current value of a submetric.
-- This function searches for the specified submetric within its parent metric 
-- in the player's data and returns its current value. If the submetric does not exist, 
-- it logs a warning.
-- @param metricName (string) - The name of the parent metric.
-- @param subMetricName (string) - The name of the submetric to retrieve.
-- @return (number | nil) - The current value of the submetric, or nil if not found.
function RPGZ.GetSubMetricValue(metricName, subMetricName)
	return RPGZ.MetricsManager.GetSubMetricValue(metricName, subMetricName)
end

-- Checks if a metric is currently active in player data.
-- @param metricName (string) - The name of the metric to check ActiveMetrics for.
-- @return (boolean) - True if the metric is active.
function RPGZ.IsMetricActive(metricName)
	return RPGZ.MetricsManager.IsMetricActive(metricName)
end

-- Sets the value of a specified metric.
-- This function updates the value of a metric in the player's data. 
-- It ensures the value does not exceed the defined min/max limits, 
-- triggers relevant events when limits are reached, and updates 
-- UI elements accordingly.
-- @param metricName (string) - The name of the metric to update.
-- @param newValue (number) - The new value to assign to the metric.
function RPGZ.SetMetricValue(metricName, value)
	RPGZ.MetricsManager.SetMetricValue(metricName, value)
end

-- Sets the value of a specified sub-metric.
-- This function updates the value of a sub-metric within a parent metric 
-- in the player's data. It ensures the value does not exceed defined 
-- min/max limits, triggers relevant events when limits are reached, 
-- and updates UI elements accordingly.
-- @param metricName (string) - The name of the parent metric.
-- @param subMetricName (string) - The name of the sub-metric to update.
-- @param newValue (number) - The new value to assign to the sub-metric.
function RPGZ.SetSubMetricValue(metricName, subMetricName, newValue)
	RPGZ.MetricsManager.SetSubMetricValue(metricName, subMetricName, newValue)
end

-- Subtracts a specified amount from a metric's value.
-- This function decreases the value of the specified metric while considering 
-- constraints such as min values and looping behavior. It also updates the UI 
-- and triggers relevant events.
-- @param metricName (string) - The name of the metric to modify.
-- @param amountToSubtract (number) - The amount to subtract from the metric's value.
function RPGZ.SubtractFromMetric(metricName, valueToSubtract)
	RPGZ.MetricsManager.SubtractFromMetric(metricName, valueToSubtract)
end

-- Subtracts a specified amount from a submetric's value.
-- This function decreases the value of a submetric within a metric, considering 
-- constraints such as min values and looping behavior. It also updates the UI 
-- and triggers relevant events.
-- @param metricName (string) - The name of the parent metric.
-- @param subMetricName (string) - The name of the submetric to modify.
-- @param amountToSubtract (number) - The amount to subtract from the submetric's value.
function RPGZ.SubtractFromSubMetric(metricName, subMetricName, amountToSubtract)
	RPGZ.MetricsManager.SubtractFromSubMetric(metricName, subMetricName, amountToSubtract)
end
-------------------------------------------
-------------------------------------------

-- OBJECTS
-------------------------------------------

-- Looks for an object in the currently loaded scene.
-- @param objectName (string) The name of the object.
-- @return (Instance) The object if found. nil if not found.
function RPGZ.FindObjectInScene(objectName)
	if RPGZ.SceneManager.Scene:FindFirstChild(objectName) then 
		return RPGZ.SceneManager.Scene:FindFirstChild(objectName)
	end
	warn("The object named " .. objectName .. " can not be found.")
	return nil
end
-------------------------------------------
-------------------------------------------

-- QUEST
-------------------------------------------

-- Activates a quest by its PID, marking it as active in the player's data.
-- @param questPID (string) The unique identifier (PID) of the quest.
function RPGZ.ActivateQuest(questPID)
	RPGZ.QuestManager.ActivateQuestByPID(questPID)
end

-- Retrieves the name of a quest using its PID.
-- @param questPID (string) The unique identifier (PID) of the quest.
-- @return (string) The name of the quest as a string.
function RPGZ.GetQuestName(questPI)
	return RPGZ.QuestManager.GetQuestName(questPI)
end

-- Checks if a specific objective of a quest is marked as complete in the player's data.
-- @param questPID (string) The unique identifier (PID) of the quest.
-- @param objectivePID (string) The unique identifier (PID) of the objective.
-- @return (Boolean) indicating whether the objective is complete, or nil if the quest is not active or complete.
function RPGZ.IsObjectiveComplete(questPID, objectivePID)
	return RPGZ.QuestManager.IsObjectiveCompleteInPlayerData(questPID, objectivePID)
end

-- Checks if a quest is currently active in the player's data.
-- @param questPID (string) The unique identifier (PID) of the quest.
-- @return (Boolean) indicating whether the quest is active.
function RPGZ.IsQuestActive(questPID)
	return RPGZ.QuestManager.IsQuestActiveInPlayerData(questPID)
end

-- Checks if a quest has been marked as complete in the player's data.
-- @param questPID (string) The unique identifier (PID) of the quest.
-- @return (Boolean) indicating whether the quest is complete.
function RPGZ.IsQuestComplete(questPID)
	return RPGZ.QuestManager.IsQuestCompleteInPlayerData(questPID)
end

-- Marks an objective as complete in the player's quest data.
-- Updates the quest GUI and checks if the entire quest is now complete.
-- @param questPID (string) The unique identifier (PID) of the quest.
-- @param objectivePID (string) The unique identifier (PID) of the objective.
function RPGZ.MarkObjectiveComplete(questPID, objectivePID)
	RPGZ.QuestManager.MarkObjectiveCompleteByPID(questPID, objectivePID)
end

-- Marks a quest as complete by adding it to the player's CompletedQuests list.
-- Removes the quest from the player's ActiveQuests list.
-- Quests are automatically marked as complete when all objectives are marked as complete.
-- @param questPID (string) The unique identifier (PID) of the quest.
function RPGZ.MarkQuestComplete(questPID)
	RPGZ.QuestManager.MarkQuestCompleteByPID(questPID)
end
-------------------------------------------
-------------------------------------------

-- SCENE
-------------------------------------------

-- Gets the name of the current scene.
-- @return (string) The name of the current scene.
function RPGZ.GetCurrentSceneName()
	return RPGZ.SceneManager.SceneName
end

-- Loads a specified scene.
-- Prevents player interaction during the transition.
-- Calls SceneManager to handle scene loading.
-- @param newSceneName (string) The name of the scene to load.
function RPGZ.LoadScene(newSceneName)

	RPGZ.InteractivityManager.NoInteractivity()

	if newSceneName then
		sceneName = newSceneName
	end

	RPGZ.SceneManager.LoadScene(sceneName)
end

-- Controls whether a scene should wait for a button press before starting.
-- Calls SceneManager to apply this setting.
-- @param shouldWait (boolean) Whether the scene should wait for a button press before starting.
function RPGZ.WaitForButtonToStartScene(shouldWait)
	RPGZ.SceneManager.WaitForButtonToStartScene(shouldWait)
end
-------------------------------------------
-------------------------------------------

-- SCREEN
-------------------------------------------

-- Fades the screen back from black over a specified duration.
-- @param duration (number) The time in seconds for the fade effect.
function RPGZ.FadeFromBlack(duration)
	RPGZ.FadeScreenController.FadeFromBlack(duration)
end

-- Fades the screen to black over a specified duration.
-- @param duration (number) The time in seconds for the fade effect.
function RPGZ.FadeToBlack(duration)
	RPGZ.FadeScreenController.FadeToBlack(duration)
end
-------------------------------------------
-------------------------------------------

-- TABLE
-------------------------------------------
function RPGZ.PrintTable(tableToPrint)
	RPGZ.TableUtility.PrintTable(tableToPrint)
end
-------------------------------------------
-------------------------------------------
------------------------------------------------------------------------------------------
--[[ END RPGZ SHORTCUTS ]]
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------

return RPGZ

