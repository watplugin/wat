# Repo: https://github.com/Atlinx/Godot-PluginAssetsRegistry

extends Reference

# Replace 'demo_plugin' with your plugin's name
const PLUGIN_ABSOLUTE_PATH_PREFIX = "res://addons/WAT/"

var plugin: EditorPlugin

# Stores already loaded assets so multiple loads of the same asset 
# do not duplicate the same asset multiple times.  
var loaded_editor_assets: Dictionary

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
	
func get_editor_scale():
	if plugin == null:
		return 1
	return plugin.get_editor_interface().get_editor_scale()
