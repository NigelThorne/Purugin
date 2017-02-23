require 'purugin/util'

include Purugin::StringUtils

# Quick hack on results of searching Bukkit:
# % find . -name '*.java' | xargs grep 'Event extends' > aaa
# % cat aaa | ruby -ne 'a ||= [] ; a << $_.split(/:/)[1].gsub(/(public|class|abstract)\s+/, "").split(/ extends.*/)[0].inspect; END { puts  a.join(", ") }'
EVENT_CLASS_NAMES = ["ConversationAbandonedEvent", "BlockBreakEvent", "BlockBurnEvent", "BlockCanBuildEvent", "BlockDamageEvent", "BlockDispenseEvent", "BlockEvent", "BlockExpEvent", "BlockFadeEvent", "BlockFormEvent", "BlockFromToEvent", "BlockGrowEvent", "BlockIgniteEvent", "BlockPhysicsEvent", "BlockPistonEvent", "BlockPistonExtendEvent", "BlockPistonRetractEvent", "BlockPlaceEvent", "BlockRedstoneEvent", "BlockSpreadEvent", "EntityBlockFormEvent", "LeavesDecayEvent", "NotePlayEvent", "SignChangeEvent", "EnchantItemEvent", "PrepareItemEnchantEvent", "CreatureSpawnEvent", "CreeperPowerEvent", "EntityBreakDoorEvent", "EntityChangeBlockEvent", "EntityCombustByBlockEvent", "EntityCombustByEntityEvent", "EntityCombustEvent", "EntityCreatePortalEvent", "EntityDamageByBlockEvent", "EntityDamageByEntityEvent", "EntityDamageEvent", "EntityDeathEvent", "EntityEvent", "EntityExplodeEvent", "EntityInteractEvent", "EntityPortalEnterEvent", "EntityPortalEvent", "EntityPortalExitEvent", "EntityRegainHealthEvent", "EntityShootBowEvent", "EntityTameEvent", "EntityTargetEvent", "EntityTargetLivingEntityEvent", "EntityTeleportEvent", "ExpBottleEvent", "ExplosionPrimeEvent", "FoodLevelChangeEvent", "ItemDespawnEvent", "ItemSpawnEvent", "PigZapEvent", "PlayerDeathEvent", "PotionSplashEvent", "ProjectileHitEvent", "ProjectileLaunchEvent", "SheepDyeWoolEvent", "SheepRegrowWoolEvent", "SlimeSplitEvent", "HangingBreakByEntityEvent", "HangingBreakEvent", "HangingEvent", "HangingPlaceEvent", "BrewEvent", "CraftItemEvent", "FurnaceBurnEvent", "FurnaceExtractEvent", "FurnaceSmeltEvent", "InventoryClickEvent", "InventoryCloseEvent", "InventoryCreativeEvent", "InventoryDragEvent", "InventoryEvent", "InventoryInteractEvent", "InventoryMoveItemEvent", "InventoryOpenEvent", "InventoryPickupItemEvent", "PrepareItemCraftEvent", "HangingBreakByEntityEvent", "HangingBreakEvent", "HangingEvent", "HangingPlaceEvent", "AsyncPlayerChatEvent", "AsyncPlayerPreLoginEvent", "PlayerAnimationEvent", "PlayerBedEnterEvent", "PlayerBedLeaveEvent", "PlayerBucketEmptyEvent", "PlayerBucketEvent", "PlayerBucketFillEvent", "PlayerChangedWorldEvent", "PlayerChannelEvent", "PlayerChatEvent", "PlayerChatTabCompleteEvent", "PlayerCommandPreprocessEvent", "PlayerDropItemEvent", "PlayerEditBookEvent", "PlayerEggThrowEvent", "PlayerEvent", "PlayerExpChangeEvent", "PlayerFishEvent", "PlayerGameModeChangeEvent", "PlayerInteractEntityEvent", "PlayerInteractEvent", "PlayerItemBreakEvent", "PlayerItemConsumeEvent", "PlayerItemHeldEvent", "PlayerJoinEvent", "PlayerKickEvent", "PlayerLevelChangeEvent", "PlayerLoginEvent", "PlayerMoveEvent", "PlayerPickupItemEvent", "PlayerPortalEvent", "PlayerPreLoginEvent", "PlayerQuitEvent", "PlayerRegisterChannelEvent", "PlayerRespawnEvent", "PlayerShearEntityEvent", "PlayerTeleportEvent", "PlayerToggleFlightEvent", "PlayerToggleSneakEvent", "PlayerToggleSprintEvent", "PlayerUnregisterChannelEvent", "PlayerVelocityEvent", "MapInitializeEvent", "PluginDisableEvent", "PluginEnableEvent", "PluginEvent", "RemoteServerCommandEvent", "ServerCommandEvent", "ServerEvent", "ServerListPingEvent", "ServiceEvent", "ServiceRegisterEvent", "ServiceUnregisterEvent", "VehicleBlockCollisionEvent", "VehicleCollisionEvent", "VehicleCreateEvent", "VehicleDamageEvent", "VehicleDestroyEvent", "VehicleEnterEvent", "VehicleEntityCollisionEvent", "VehicleEvent", "VehicleExitEvent", "VehicleMoveEvent", "VehicleUpdateEvent", "LightningStrikeEvent", "ThunderChangeEvent", "WeatherChangeEvent", "WeatherEvent", "ChunkEvent", "ChunkLoadEvent", "ChunkPopulateEvent", "ChunkUnloadEvent", "PortalCreateEvent", "SpawnChangeEvent", "StructureGrowEvent", "WorldEvent", "WorldInitEvent", "WorldLoadEvent", "WorldSaveEvent", "WorldUnloadEvent", "TestEvent"].sort

listener_names = EVENT_CLASS_NAMES.dup

listener_names.map! { |name| "#{name}Listener" }

BUKKIT_SRC_DIR='../bukkit/src/main/java'
PACKAGES = {}
require 'find'
Dir.chdir(BUKKIT_SRC_DIR) do
  Find::find(".") do |path|
    EVENT_CLASS_NAMES.each do |name|
      if path.end_with? "/" + name + ".java"
        PACKAGES[name] = path.gsub(/\//, '.').sub('..', '').sub(/\.[^.]+\.java$/, '')
      end
    end
  end
end

# To be put into src/purugin/event.rb
EVENT_CLASS_NAMES.each do |event_name|
  puts "    define_event_listener('#{event_name}', '#{PACKAGES[event_name]}')"
end
