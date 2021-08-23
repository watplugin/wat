extends Reference
# Stores and scales editor related UI assets according to the user's editor scale.
# Repo: https://github.com/Atlinx/Godot-PluginAssetsRegistry

# Replace 'demo_plugin' with your plugin's name
const PLUGIN_ABSOLUTE_PATH_PREFIX = "res://addons/WAT/"

var plugin

# Stores already loaded assets so multiple loads of the same asset 
# do not duplicate the same asset multiple times.  
var loaded_editor_assets: Dictionary

# Only used by pre 3.3 Godot editors
var _cached_editor_scale = -1

func _init(plugin_ = null):
	plugin = plugin_

# Returns an asset scaled to fit the current editor's UI scale
# Can load scaled asset with a string using the plugin folder as the root older
# Can load scaled asset using an already loaded asset 
func load_asset(asset):
	if asset is String:
		return load_asset(load(PLUGIN_ABSOLUTE_PATH_PREFIX + asset))
	else:
		# Godot compares by reference by default for dictionaries that use objects as keys
		if loaded_editor_assets.has(asset):
			return loaded_editor_assets[asset]
		else:
			if asset is Font:
				loaded_editor_assets[asset] = _load_scaled_font(asset)
				return loaded_editor_assets[asset]
			elif asset is Texture:
				loaded_editor_assets[asset] = _load_scaled_texture(asset)
				return loaded_editor_assets[asset]
			assert(false, "Cannot scale asset of type " + asset.get_class())

func _load_scaled_texture(texture: Texture) -> Texture:
	# get_data already returns a copy, therefore no need to duplicate
	var image = texture.get_data()
	image.resize(image.get_width() * get_editor_scale(), image.get_height() * get_editor_scale())
	
	var scaled_texture = ImageTexture.new()
	scaled_texture.create_from_image(image)
	
	return scaled_texture 

func _load_scaled_font(font: Font) -> DynamicFont:
	var duplicate = font.duplicate()
	duplicate.size *= get_editor_scale()
	return duplicate

func get_editor_scale() -> float:
	if plugin == null:
		return 1.0
	if Engine.get_version_info().major > 3 or (Engine.get_version_info().major == 3 and Engine.get_version_info().minor >= 3):
		return plugin.get_editor_interface().get_editor_scale()
	elif Engine.get_version_info().major == 3:
		if _cached_editor_scale == -1:
			if Engine.get_version_info().minor >= 1:
				_cached_editor_scale = _calculate_current_editor_scale_3_1()
			else:
				_cached_editor_scale = _calculate_current_editor_scale_3_0()
		return _cached_editor_scale
	else:
		push_error("PluginAssetsRegistry is not supported for version: " % Engine.get_version_info().string)
		return 1.0

func _calculate_current_editor_scale_3_1() -> float:
	var editor_settings = plugin.get_editor_interface().get_editor_settings()
	
	var display_scale: int = editor_settings.get_setting("interface/editor/display_scale")
	var custom_display_scale: float = editor_settings.get_setting("interface/editor/custom_display_scale")

	match display_scale:
		0:
			if OS.get_name() == "OSX":
				return OS.get_screen_max_scale()
			else:
				var screen: int = OS.get_current_screen()
				if OS.get_screen_dpi(screen) >= 192 and OS.get_screen_size(screen).x > 2000:
					return 2.0
				else:
					return 1.0
		1:
			return 0.75
		2:
			return 1.0
		3:
			return 1.25
		4:
			return 1.5
		5:
			return 1.75
		6:
			return 2.0
		_:
			return custom_display_scale

func _calculate_current_editor_scale_3_0() -> float:
	var editor_settings = plugin.get_editor_interface().get_editor_settings()
	
	var dpi_mode = editor_settings.get_settings("interface/editor/hidpi_mode")
	
	match dpi_mode:
		0:
			var screen: int = OS.get_current_screen()
			if OS.get_screen_dpi(screen) >= 192 and OS.get_screen_size(screen).x > 2000:
				return 2.0
			else:
				return 1.0
		1:
			return 0.75
		2:
			return 1.0
		3:
			return 1.5
		4:
			return 2.0
		_:
			return 1.0
