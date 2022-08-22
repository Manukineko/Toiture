/// @func ToitureTileboxCreate
/// @desc Create a new Tilebox for a Tileset
/// @param {tileset} tileset
/// @param {sprite} sprite - the sprite used for the tileset in the Tileset Editor
/// @param {bool} Litemode - set the Lite Mode for the tilebox

function ToitureTileboxCreate(_tileset, _sprite = undefined, _litemode = false){
	if !TOITURE_AUTO TOITURE_AUTO_ERROR 
	if !variable_global_exists("__toitureTileboxList") global.__toitureTileboxList = ds_map_create()
	
	var _toitureTileset = new ToitureTilebox(_tileset, _sprite, _litemode)
	ds_map_set(global.__toitureTileboxList, _toitureTileset.name, _toitureTileset)
}

#region TILEBOX - GETTER

/// @func ToitureTileboxGet
/// @desc Get the Tilebox corresponding to the tileset
/// @param {tileset} tileset

function ToitureTileboxGet(_tileset)
{
	if !TOITURE_AUTO TOITURE_AUTO_ERROR 
	
	var _name = tileset_get_name(_tileset)
	if !ds_map_exists(global.__toitureTileboxList,_name) show_error("[TOITURE] <<Error>> - No tileset has been created with this name ("+_name+")",true)
	return global.__toitureTileboxList[? _name]
}

/// @func ToitureTileboxGetProperty
/// @desc get a property of the tilebox
/// @param {tileset} tileset
/// @param {string} property - as a string

function ToitureTileboxGetProperty(_tileset, _property)
{
	var _tilebox = ToitureTileboxGet(_tileset)
	return _tilebox.getProperty(_property)
}

/// @func ToitureTileboxGetTile
/// @desc //Get the tiledata of a tile in the tilebox
/// @param {tileset} tileset
/// @param {array_or_int} tile - Array for the x,y coordinate of the tile in the tileset or the tileID.

function ToitureTileboxGetTile(_tileset, _tile )
{
	var _tilebox = ToitureTileboxGet(_tileset)
	if is_array(_tile){
		return _tilebox.tileGetData([ _tile[0],_tile[1] ])
	}
	return _tilebox.tileGetData(_tile)
}


#endregion