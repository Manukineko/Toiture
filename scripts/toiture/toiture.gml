#macro TOITURE_AUTO true
#macro TOITURE_DEBUG false

#macro TilesetSpriteNamePrefix "s_"

#macro TOITURE_AUTO_ERROR show_error("[TOITURE] <<ERROR>> - EASY MODE not set\n- Use the ToitureTileset constructor and its associated methods or set the EASYMODE mcro to <true>", true)

/// @func Toiture
/// @desc Create a Toiture constructor which stores properties and a grid mirroring a given Tilemap
/// @param {layer_name_or_tilemap_id} tilemap
/// @param {tileset} [tileset] the tileset assigned to the tilemap in the Room Editor (Automatically retrieved in AUTO MODE)

function Toiture(_tilemap, _tileset = undefined) constructor
{
	//the tilemap ID
	toitureID = undefined
	layerID  = undefined
	var _l
    //if string search for the layer
	//if set to the tilemap element
    if is_string(_tilemap)
    {
        try
        {
            _l = layer_get_id(_tilemap)
        } catch(err)
        {
            show_error("[TOITURE] <<ERROR>> No Layer found with this name: " + _tilemap, true)
        }
        
        layerID = _l
        toitureID = layer_tilemap_get_id(layerID)
    }
    
    if is_undefined(toitureID) toitureID = _tilemap
    
    toitureWidth = tilemap_get_width(toitureID)
    toitureHeight = tilemap_get_height(toitureID)
    tileWidth = tilemap_get_tile_width(toitureID)
    tileHeight = tilemap_get_tile_height(toitureID)
    toitureGrid = ds_grid_create(toitureWidth, toitureHeight)
    tileset = tilemap_get_tileset(toitureID)
    tilesetName = tileset_get_name(tileset)
    tilebox = undefined
    
    if TOITURE_AUTO
    {	//Check into the global list
    	if variable_global_exists("__toitureTileboxList") tilebox = global.__toitureTileboxList[? tilesetName]
    }
    
    var _y = 0; repeat(toitureHeight)
    {
        var _x = 0; repeat(toitureWidth)
        {
            var _tID = tilemap_get_at_pixel(toitureID, _x*tileWidth, _y*tileHeight)
            ds_grid_set(toitureGrid, _x, _y, _tID)
            
            _x++
        }
        _y++
    }
    
    
    /// @func assignTilebox
    /// @desc Manually assign a tilebox to a Toiture
    /// @param {struct} tilebox - the tilebox corresponding to the tileset assign to the tilemap in the Room Editor
    
    static assignTilebox = function(_tilebox = undefined)
	    {
            if TOITURE_AUTO 
	    	{
	    		show_error("[TOITURE] <<ERROR>> Tileset Assignation\n - Deactivate AUTO MODE to manually manage Tileset Assignation to Tilemap"+ string(toitureID) +" or use <ToitureTilesetCreate> first", true)
	    	}
	    	tilebox = _tilebox
	    	
	    }
	    
	    
    /// @func getToitureGrid
    /// @desc Get the Grid mirroring the tilemap
    
	static getToitureGrid = function()
	    {
	    	return toitureGrid
	    }
    
    
    /// @func getTiledata
    /// @desc Get the tiledata in the Room at position [x,y]. Replacement for <tilemap_get_at_x/y> functions
    /// @param {real} x the x position in the room
    /// @param {real} y the y position in the room
    /// @param {string}  data the data to get. if no input is given, it will return the whole tiledata struct. In LITE MODE the argument will be ignored.
    /// @return tiledata struct or the value of data.
    
    static getTiledata = function(_x, _y, _data = undefined)
	    {
		    var _xx, _yy, _id
		    
		    _xx = floor((_x div tileWidth) + (tilemap_get_x(toitureID) div tileWidth))//floor(_x / tileWidth)
		    _yy = floor((_y div tileHeight) + (tilemap_get_y(toitureID) div tileHeight))//floor(_y / tileHeight)
		    _id = toitureGrid[# _xx, _yy]
		    
		    if is_undefined(_id) || _id < 0
		    {
		    	logthis("*INFO* No Valid TileID at x:", string(_x), "(", string(_xx), "), y:", string(_y),"(",string(_yy),") for Tilemap ",string(toitureID),"\n- Normalize Index to 0 - <Out of Tilemap or no Tile ?>")
				_id = 0
			}
		   
		   return tilebox.tileGetData(_id, _data)
		   
		  
		}
	
	
	/// @func getTileID
	/// @desc Get the tile ID in the tileset, as GM calculate it, in the room at position [x,y]. Replacement for <tilemap_get_at_x/y> functions
	/// @param {real} x the x position in the room
    /// @param {real} y the y position in the room
    /// @return integrer
	
    static getTileID = function(_x, _y)
	    {
	    	var _xx, _yy, _id,
			_xx = floor(_x / tileWidth)
			_yy = floor(_y / tileHeight)
			_id = toitureGrid[# _xx, _yy]
			if is_undefined(_id) || _id < 0
			{
			    logthis("*INFO* Out of Tilemap\n - Index to 0")
				_id = 0
			}
			return _id
	    }
    
    
    /// @func getTilebox
    /// @desc Get the tilebox assigned to the Toiture
    /// @return struct
    
    static getTilebox = function()
	    {
	    	return tilebox
	    }
}


#region INTERNALS UTILS - DO NOT DELETE
function __structCopy(_struct)
{
	if is_struct(_struct)
	{
		var _copy = {}
        var _names = variable_struct_get_names(_struct)
        var _i = 0; repeat(array_length(_names))
        {
        	var _name = _names[_i]
        	var _value = variable_struct_get(_struct, _name)
        	variable_struct_set(_copy, _name, _value)
        	_i++
        }
        return _copy
	}
	
	return _struct
}
#endregion





