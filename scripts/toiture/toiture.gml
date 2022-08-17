#macro TilesetSpriteNamePrefix "s_"

#macro TOITURE_AUTO true
#macro TOITURE_DEBUG false

#macro TOITURE_AUTO_ERROR show_error("[TOITURE] <<ERROR>> - EASY MODE not set\n- Use the ToitureTileset constructor and its associated methods or set the EASYMODE mcro to <true>", true)

/// @func Toiture
/// @desc Create a Toiture constructor which stores properties and a grid mirroring a given Tilemap
/// @param {layer_name_or_tilemap_id} tilemap
/// @param {tileset} [tileset] the tileset assigned to the tilemap in the Room Editor (Automatically retrieved in AUTO MODE)

function Toiture(_tilemap, _tileset = undefined) constructor
{
	//the tilemap ID
	toitureID = undefined
	
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
        toitureID = layer_tilemap_get_id(_tilemap)
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
		    
		    _xx = floor(_x / tileWidth)
		    _yy = floor(_y / tileHeight)
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


/// @func ToitureTilebox
/// @desc Create a Tilebox which contains the properties of the tileset as set in the Tileset Editor and the list of tile with their tiledata
/// @param {tileset} tileset
/// @param {sprite} sprite - the sprite use to create the tileset. Toiture will try to find it, but it's better to input it as there are no GM functions to retrieved it
/// @param {boolean} LiteMode - Default: false. Lite Mode allow only one data by tile.

function ToitureTilebox( _tileset, _sprite = undefined, _litemode = false ) constructor
{
    var _layer = layer_create(1)
    var _tilemap = layer_tilemap_create(_layer,0,0,_tileset, 1,1)
    
    LITEMODE = _litemode
    tileset = _tileset
    name = tileset_get_name(_tileset)
    tileWidth  = tilemap_get_tile_width(_tilemap)
    tileHeight = tilemap_get_tile_height(_tilemap)
    tilesetSprite = __getAssignedSprite(_sprite)
    tilesetWidth = sprite_get_width(tilesetSprite)/tileWidth
    tilesetHeight = sprite_get_height(tilesetSprite)/tileHeight
    tilesetSize = tilesetWidth * tilesetHeight
    tilelist = array_create(tilesetSize, undefined)
    
    if !LITEMODE
    {
        var _i = 0; repeat(tilesetSize){
            tilelist[_i] = {}
            _i++
        }
        
    }
    
    
    layer_tilemap_destroy(_tilemap)
    layer_destroy(_layer)
    
    #region METHODS - INTERNAL
    static __getAssignedSprite = function(_sprite)
	    {
		    if is_undefined(_sprite)
		    {
	    	    var _tSprite = asset_get_index(TilesetSpriteNamePrefix+name)
		        if _tSprite = -1 show_error("NO Sprite found for tileset "+name, true)
		        return _tSprite
	    	
		    }else
		    {
		        return _sprite
		    }
	    }
    
    
    static __tilelistSetTiledata = function(_id, _tiledata)
	    {
	        if LITEMODE{
	            
	            if is_struct(_tiledata) show_error("[TOITURE] <<ERROR>> Mode Lite Activated\n- tiledata for tile "+string(_id)+" should be a real (is_struct:true) - tileset "+name, true)
	        
	        }else{
	        	
	        	if !is_struct(_tiledata) show_error("[TOITURE] <<ERROR>> Not a <Struct>\n- tiledata for tile "+string(_id)+" should be a <Struct> - tileset "+name, true)
	        }
	        
	        if is_struct(tilelist[@ _id]) logthis("!!WARNING!! Tiledata Overwrited\n- If you meant to ADD a tiledata, use the \"TileAdd\*\" methods - Tile ",string(_id)," in tileset ",name)
	        
	        tilelist[@ _id] = __structCopy(_tiledata)
	        
	    }
    
	// static __tilelistChangeTiledata = function(_id, _tiledata)
	// {
	// 	if LITEMODE
 //       {
 //           if is_struct(_tiledata) show_error("[TOITURE] <<ERROR>> Mode Lite Activated\n- tiledata for tile "+string(_id)+" should be a <Real> (is_struct:true) - tileset "+name, true)
 //       }
 //       else
 //       {
 //       	if !is_struct(_tiledata) show_error("[TOITURE] <<ERROR>> Not a <Struct>\n- tiledata for tile "+string(_id)+" should be a <Struct> (to use <Real>, set TOITURE_LITE to <true>) - tileset "+name, true)
 //       }
 //       if is_struct(tilelist[@ _id]){
			    
	// 	    var _names
		    
	// 	    _names = variable_struct_get_names(_tiledata)
		    
	// 	    var _i = 0; repeat(array_length(_names)){
				
	// 			var _name = _names[_i]
		        
	// 	        if variable_struct_exists(tilelist[@ _id], _name)
	// 	        {
	// 	            logthis("!!WARNING!! Tiledata Overwrite\n- Tiledata",_name," already exists for Tile ",string(_id)," in tileset ",name)
	// 	        }
		        
	// 	        var _value = _tiledata[$ _name]
	// 	        tilelist[@ _id][$ _name] = _value
		      
	// 	        _i++;
	// 	    }
	// 	    return
 //       }
 //       //If the index hasn't been SET, set it instead.
 //       if is_undefined(tilelist[@ _id])
 //       {
 //       	__tilelistSetTiledata(_id, _tiledata)
 //       	logthis("!!WARNING!! <Undefined> tiledata\n- SET Tile ",string(_id)," in tileset "+name)
        	
 //       	return
 //       }
		    
	// 	tilelist[@ _id] = _tiledata
        
	        
	// }
   static __tilelistAddTiledata = function(_id, _tiledata)
	   {
	        if LITEMODE
	        {
	            if is_struct(_tiledata) show_error("[TOITURE] <<ERROR>> Mode Lite Activated\n- tiledata for tile "+string(_id)+" should be a <Real> (is_struct:true) - tileset "+name, true)
	        }
	        else
	        {
	        	if !is_struct(_tiledata) show_error("[TOITURE] <<ERROR>> Not a <Struct>\n- tiledata for tile "+string(_id)+" should be a <Struct> (to use <Real>, set TOITURE_LITE to <true>) - tileset "+name, true)
	        }
			
			if is_struct(tilelist[@ _id]){
			    
			    var _names
			    
			    _names = variable_struct_get_names(_tiledata)
			    
			    var _i = 0; repeat(array_length(_names)){
					
					var _name = _names[_i]
			        
			        if variable_struct_exists(tilelist[@ _id], _name)
			        {
			            logthis("!!WARNING!! Tiledata Overwrite\n- Tiledata",_name," already exists for Tile ",string(_id)," in tileset ",name)
			        }
			        
			        var _value = _tiledata[$ _name]
			        tilelist[@ _id][$ _name] = _value
			      
			        _i++;
			    }
			    return
	        }
	        //If the index hasn't been SET, set it instead.
	        if is_undefined(tilelist[@ _id])
	        {
	        	__tilelistSetTiledata(_id, _tiledata)
	        	logthis("!!WARNING!! <Undefined> tiledata\n- SET Tile ",string(_id)," in tileset "+name)
	        	
	        	return
	        }
			    
			tilelist[@ _id] = _tiledata
	   	
	   }
   
   static __tileCoordinateToID = function (_x, _y, _tilesetwidth)
	   {
	        return (_y * _tilesetwidth) + (_x mod _tilesetwidth)
	   }
	#endregion
	
	
	#region METHODS - GETTERS
   
   
   /// @func getProperty
   /// @desc Get the property of a tilebox
   /// @param {string} property - the property to retrieve
   /// @return value
   
   static getProperty = function(_property)
	    {
	    	return self[$ _property]
	    }
   
   
   /// @func getTile
   /// @desc Get the tiledata of a tile in the tilebox
   /// @param {array_or_int} tile - tile position in an array or the tile ID
   /// @return struct
   
   static tileGet = function(_tile)
	    {
	    	if is_array(_tile)
	    	{
	        	_tile = __tileCoordinateToID(_tile[0], _tile[1], tilesetWidth)
	    	}
	    	
	    	return tilelist[_tile]
	    }
	    
	    
	/// @func tileGetData
   /// @desc Get one data from a tile in the tilebox
   /// @param {array_or_int} tile - tile position in an array or the tile ID
   /// @param {string} data
   /// @return value
   
   static tileGetData = function(_tile, _data = undefined)
	    {
	    	//var _id = _tile
	    	if is_array(_tile)
	    	{
	        	_tile = __tileCoordinateToID(_tile[0], _tile[1], tilesetWidth)
	    	}
			
			if LITEMODE || _data = undefined
			{ //<undefined> without Lite mode means that the whole tiledata struct for a tile will be return. It is like a "all" parameter
				return tilelist[@ _tile]
			}
			
		    if !variable_struct_exists(self, _data) logthis("*INFO* No data with this name ",_data," for tile", string(_tile),
		        "\n<undefined> will be returned. Please check the code")
	    	
	    	return tilelist[_tile][$ _data]
	    }
   #endregion
   
   
    #region METHODS - SETTER
//    
//    /***** SET BY COORDINATES *****/
//    
//    
//    /// @func tileSetData
//    /// @desc Set tiledatas to one tile - setting an already set tile will override it.
//    /// @param {real} x - the left position of the tile to set, in the tileset.
//    /// @param {real} y - the top position of the tile to set, in the tileset.
//    /// @param {struct} tiledata - a struct that contains all parameters for the tile.
//    
//    static tileSetData = function(_x, _y, _tiledata)
//    {
//        var _id = __tileCoordinateToID(_x, _y, tilesetWidth)
//        __tilelistSetTiledata(_id, _tiledata)
//        
//        return self
//    }
//    
//    
//    /// @func tileRegionSetData
//    /// @desc Set tiledatas to a region of the tile - setting an already set tile will override it.
//    /// @param {real} x1 - the starting tile left position of the region to set, in the tileset.
//    /// @param {real} y1 - the starting tile top position of the region to set, in the tileset.
//    /// @param {real} x2 - the ending tile left position of the region to set, in the tileset.
//    /// @param {real} y2 - the ending tile top position of the region to set, in the tileset.
//    /// @param {struct} tiledata - a struct that contains all parameters for the tile.
//    
//    static tileRegionSetData = function(_x1, _y1, _x2, _y2, _tiledata)
//    {
//        var _tsw = tilesetWidth
//        
//        var _xl = _x2-_x1
//        var _yl = _y2-_y1
//	        
//        var _y = _y1; repeat(_yl+1)
//        {
//            var _x = _x1; repeat(_xl+1)
//            {
//        
//            	var _id = __tileCoordinateToID(_x, _y, tilesetWidth)
//            	__tilelistSetTiledata(_id, _tiledata)
//            	_x++
//    		}
//        	_y++
//    	}
//        
//        return self
//    }
//    
//    
//    /// @func tileAllSetData
//    /// @desc Set tiledatas to all the tiles - setting an already set tile will override it.
//   /// @param {struct} tiledata - a struct that contains all parameters for the tile.
//    static tileAllSetData = function(_tiledata)
//    {
//        var _i = 0; repeat(array_length(tilelist))
//        {
//            __tilelistSetTiledata(_i, _tiledata)
//            _i++;
//        }
//        
//        return self
//        
//    }
//    
//    
//    /***** SET BY ID *****/
//    
//    /// @func tileSetDataByID
//    /// @desc Set tiledatas to one tile - setting an already set tile will override it.
//    /// @param {array_or_tileID} TileID - Tile(s) to set. Either an unique ID or an array of IDs. You can also nest arrays to set following IDs. (ex: [0,3,[5,10],12] will set tiles at ID 0,3, 5 to 10 and 12.)
//    /// @param {struct} tiledata - a struct that contains all parameters for the tile.
//    
//    static tileSetDataByID = function(_idInclude, _tiledata)
//	{
//		var _idnumber = array_length(_idInclude)
//
//		var _i = 0 ; repeat(_idnumber)
//		{
//			var _id = _idInclude[_i]
//			
//			if is_array(_id)
//			{
//				if _id[0] > _id[1] show_error("[TOITURE] <<ERROR>> Can't Set By IDs\n- First ID ("+string(_id[0])+") is higher than Last ID ("+string(_id[1])+") in IDList array for Tileset "+name,true)
//				if array_length(_id) > 2 logthis("[!WARNING!] <SetByID> Array Index Overflow at IdList index",string(_i) ,"\n- Only the first two value (",string(_id[0])," & ",string(_id[1]),") will be used.\nValue ",_id[2]," in [2] and following will be ignored for Tileset ",name)
//				
//				var _ids = _id[1] - _id[0]
//				_ids++
//				
//				var _n = _id[0];repeat(_ids)
//				{
//					__tilelistSetTiledata(_n, _tiledata)
//					_n++
//				}
//			}
//			else
//			{
//				__tilelistSetTiledata(_id, _tiledata)
//			}
//			_i++
//		}
//        
//        
//        return self
//    }
//    
//    
//    /// @func tileAllSetDataByID
//    /// @desc Set tiledatas to all tile - setting an already set tile will override it. 
//    /// @param {struct} tiledata - a struct that contains all parameters for the tile.
//    /// @param {array_or_tileID} [TileID] Optional: Exclude Tiles - Either an unique ID or an array IDs. You can also nest arrays to set following IDs. (ex: [0,3,[5,10],12] will set tiles at ID 0,3, 5 to 10 and 12.)
//    
//    static tileAllSetDataByID = function(_tiledata, _idExclude = undefined)
//    {
//		var _include = array_create(tilesetSize, true)
//		
//		if !is_undefined(_idExclude){
//			var _i = 0; repeat(array_length(_idExclude))
//			{
//				var _id = _idExclude[_i]
//				
//				if is_array(_id)
//				{
//					if _id[0] > _id[1] show_error("[TOITURE] <<ERROR>> <SetAllByID> Can't Exclude IDs\n- First ID ("+string(_id[0])+") is higher than Last ID ("+string(_id[1])+") in IDList array for Tileset "+name,true)
//					if array_length(_id) > 2 logthis("[!WARNING!] <SetAllByID> Exclude Array Index Overflow at IdList index",string(_i) ,"\n- Only the first two value (",string(_id[0])," & ",string(_id[1]),") will be used.\nValue ",_id[2]," in [2] and following will be ignored for Tileset ",name)
//					
//					var _ids = _id[1] - _id[0]
//					_ids++
//					
//					var _n = _id[0];repeat(_ids)
//					{
//						_include[@ _n] = false
//						_n++
//					}
//				}
//				else
//				{
//					_include[@ _id] = false
//				}
//				_i++
//			}
//		}
//		
//		var _i = 0 ; repeat(tilesetSize)
//		{
//			if _include[_i] = true
//			{
//				__tilelistSetTiledata(_i, _tiledata)
//			}
//			_i++
//		}
//        
//        
//        return self
//    }
	#endregion

    
    #region METHODS - ADDERS
    /***** ADD BY COORDINATE *****/
    
    /// @func tileAddData
    /// @desc Add tiledatas to one tile - It will append the provided struct to the stored one.
    /// @param {real} x - the left position of the tile, in the tileset.
    /// @param {real} y - the top position of the tile, in the tileset.
    /// @param {struct} tiledata - a struct that contains additional parameters for the tile.
    
    static tileAddData = function(_x, _y, _tiledata)
	    {
	        var _tsw = tilesetWidth
	        var _id = (_y * _tsw) + (_x mod _tsw)
	        
	        __tilelistAddTiledata(_id, _tiledata)
	        
	        return self
	    }
    
    /// @func tileRegionAddData
    /// @desc Add tiledatas to a region of the tilebox - It will append the provided struct to the stored one.
    /// @param {real} x1 - the starting tile left position of the region , in the tileset.
    /// @param {real} y1 - the starting tile top position of the region , in the tileset.
    /// @param {real} x2 - the ending tile left position of the region , in the tileset.
    /// @param {real} y2 - the ending tile top position of the region , in the tileset.
    /// @param {struct} tiledata - a struct that contains additional parameters for the tile.
    
    static tileRegionAddData = function(_x1, _y1, _x2, _y2, _tiledata)
	    {
	        var _xl = _x2-_x1
            var _yl = _y2-_y1
	        
	        var _y = _y1; repeat(_yl+1)
	        {
	            var _x = _x1; repeat(_xl+1)
	            {
	                var _id = __tileCoordinateToID(_x,_y, tilesetWidth)
	                __tilelistAddTiledata(_id, _tiledata)
	                _x++
	            }
	            _y++
	        }
	        
	        return self
	    }
    
    /// @func tileAllAddData
    /// @desc Add tiledatas to a region of the tile - It will append the provided struct to the stored one.
	/// @param {struct} tiledata - a struct that contains additional parameters for the tile.
    static tileAllAddData = function(_tiledata)
	    {
	        var _i = 0; repeat(array_length(tilelist))
	        {
	            __tilelistAddTiledata(_i, _tiledata)
	            _i++;
	        }
	        
	        return self
	    }
    

    /***** ADD BY ID *****/
    
    /// @func tileAddDataByID
    /// @desc Add tiledatas to one tile or several Tile - It will append the provided struct to the stored one.
    /// @param {array_or_tileID} TileID - Tile(s) Either an unique ID or an array of IDs. You can also nest arrays to set following IDs. (ex: [0,3,[5,10],12] will set tiles at ID 0,3, 5 to 10 and 12.)
    /// @param {struct} tiledata - a struct that contains additional parameters for the tile.
    
    static tileAddDataByID = function(_idInclude, _tiledata)
	    {
	    	if is_array(_idInclude){
		    	var _idnumber = array_length(_idInclude)
		
				var _i = 0 ; repeat(_idnumber)
				{
					var _id = _idInclude[_i]
					
					if is_array(_id)
					{
						if _id[0] > _id[1] show_error("[TOITURE] <<ERROR>> Can't Add By IDs\n- First ID ("+string(_id[0])+") is higher than Last ID ("+string(_id[1])+") in IDList array for Tileset "+name,true)
						if array_length(_id) > 2 logthis("[!WARNING!] <AddByID> Array Index Overflow at IdList index",string(_i) ,"\n- Only the first two value (",string(_id[0])," & ",string(_id[1]),") will be used.\nValue ",_id[2]," in [2] and following will be ignored for Tileset ",name)
						
						var _ids = _id[1] - _id[0]
						_ids++
						
						var _n = _id[0];repeat(_ids)
						{
							__tilelistAddTiledata(_n, _tiledata)
							_n++
						}
					}
					else
					{
						__tilelistAddTiledata(_id, _tiledata)
					}
					_i++
				}
				return self
	    	}
	    	
	    	__tilelistAddTiledata(_idInclude, _tiledata)
	        
	        return self
	    }
    
    /// @func tileAllAddDataByID
    /// @desc Add tiledatas to all tile - It will append the provided struct to the stored one.
    /// @param {struct} tiledata - a struct that contains additionals parameters for the tile.
    /// @param {array_or_tileID} [TileID] Optional: Exclude Tiles - Either an unique ID or an array IDs. You can also nest arrays to set following IDs. (ex: [0,3,[5,10],12] will set tiles at ID 0,3, 5 to 10 and 12.)
    
    static tileAllAddDataByID = function(_tiledata, _idExclude = undefined)
	    {
	    	var _include = array_create(tilesetSize, true)
			
			if !is_undefined(_idExclude)
			{
				if is_array(_idExclude)
				{
					var _i = 0; repeat(array_length(_idExclude))
					{
						var _id = _idExclude[_i]
						
						if is_array(_id)
						{
							if _id[0] > _id[1] show_error("[TOITURE] <<ERROR>> <AddAllByID> Can't Exclude IDs\n- First ID ("+string(_id[0])+") is higher than Last ID ("+string(_id[1])+") in IDList array for Tileset "+name,true)
							if array_length(_id) > 2 logthis("[!WARNING!] <AddAllByID> Exclude Array Index Overflow at IdList index",string(_i) ,"\n- Only the first two value (",string(_id[0])," & ",string(_id[1]),") will be used.\nValue ",_id[2]," in [2] and following will be ignored for Tileset ",name)
							
							var _ids = _id[1] - _id[0]
							_ids++
							
							var _n = _id[0];repeat(_ids)
							{
								_include[@ _n] = false
								_n++
							}
						}
						else
						{
							_include[@ _id] = false
						}
						_i++
					}
				}
				else
				{
					_include[@ _idExclude] = false
				}
			}
			
			var _i = 0 ; repeat(tilesetSize)
			{
				if _include[_i] = true
				{
					__tilelistAddTiledata(_i, _tiledata)
				}
				_i++
			}
	        
	        
	        return self
	    }
    #endregion

}


#region TOITURE WRAPPER - GETTERS

/// @func ToitureCreate
/// @desc Create a new Toiture
/// @param {layer_name_or_tilemap_id} tilemap
/// @param {tileset} tileset - the tileset assign to the tilemap in the Room Editor
/// @return struct

function ToitureCreate(_tilemap, _tileset)
{
	var _c = new Toiture(_tilemap, _tileset)
	return _c
}


/// @func ToitureGetTilebox
/// @desc Get the Tilebox of a Toiture
/// @param {struct} toiture

function ToitureGetTilebox(_toiture)
{
	return _toiture.getTilebox()
}


/// @func ToitureGetTiledata
/// @desc Get the tile data of a tile in the Toiture
/// @param {struct} toiture
/// @param {real} x
/// @param {real} y
/// @param {string} data

function ToitureGetTiledata( _toiture, _x, _y, _data = undefined)
{
    return _toiture.getTiledata(_x, _y, _data)
}

/// @func ToitureGetTileID
/// @desc Get the ID of a Tile in the Toiture
/// @param {struct} toiture
/// @param {real} x
/// @param {real} y

function ToitureGetTileID(_toiture, _x, _y)
{
    return _toiture.getTileID(_x,_y)
}
#endregion


#region AUTO MODE

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


#region TILEBOX - SETTERS

/***** BY COORDINATE *****/

///// @func ToitureTileboxSetTiledata
///// @desc Set tiledatas to one tile - setting an already set tile will override it.
///// @param {tileset} tileset - the tileset assign to the tilempa in the Room Editor
///// @param {real} x - the left position of the tile to set, in the tileset.
///// @param {real} y - the top position of the tile to set, in the tileset.
///// @param {struct} tiledata - a struct that contains all parameters for the ti

//function ToitureTileboxSetTiledata(_tileset, _x, _y, _tiledata)
//{
//	var _tilebox = ToitureTileboxGet(_tileset)
//	_tilebox.tileSetData(_x, _y, _tiledata)
//}
//
///// @func ToitureTileboxRegionSetTiledata
///// @desc Set tiledatas for all tiles in a region of the tileset - setting an already set tile will override it.
///// @param {tileset} tileset - the tileset assign to the tilempa in the Room Editor
///// @param {real} x1 - the starting tile left position of the region to set, in the tileset.
///// @param {real} y1 - the starting tile top position of the region to set, in the tileset.
///// @param {real} x2 - the ending tile left position of the region to set, in the tileset.
///// @param {real} y2 - the ending tile top position of the region to set, in the tileset.
///// @param {struct} tiledata - a struct that contains all parameters for the tile.

//function ToitureTileboxRegionSetTiledata(_tileset, _x1, _y1, _x2, _y2, _tiledata)
//{
//	var _tilebox = ToitureTileboxGet(_tileset)
//	_tilebox.tileRegionSetData(_x1, _y1, _x2, _y2, _tiledata)
//}
//
///// @func tileAllSetData
///// @desc Set tiledatas to all the tiles - setting an already set tile will override it.
///// @param {tileset} tileset - the tileset assign to the tilempa in the Room Editor
///// @param {struct} tiledata - a struct that contains all parameters for the tile.
//function ToitureTileboxAllSetTiledata(_tileset, _tiledata)
//{
//	var _tilebox = ToitureTileboxGet(_tileset)
//	_tilebox.tileAllSetData(_tiledata)
//}
//
//
///***** BY ID *****/
//
///// @func ToitureTileboxSetTiledataByID
///// @desc Set tiledatas to one tile - setting an already set tile will override it.
///// @param {tileset} tileset - the tileset assign to the tilempa in the Room Editor
///// @param {array_or_tileID} TileID - Tile(s) to set. Either an unique ID or an array of IDs. You can also nest arr
///// @param {struct} tiledata - a struct that contains all parameters for the tile.
//
//function ToitureTileboxSetTiledataByID(_tileset, _idInclude, _tiledata)
//{
//	var _tilebox = ToitureTileboxGet(_tileset)
//	_tilebox.tileSetDataByID(_idInclude, _tiledata)
//}
//
///// @func ToitureTileboxAllSetTiledataByID
///// @desc Set tiledatas to all tile - setting an already set tile will override it. 
///// @param {tileset} tileset - the tileset assign to the tilempa in the Room Editor
///// @param {struct} tiledata - a struct that contains all parameters for the tile.
///// @param {array_or_tileID} [TileID] Optional: Exclude Tiles - Either an unique ID or an array IDs. You can also nest arrays to set following IDs. (ex: [0,3,[5,10],12] will set tiles at ID 0,3, 5 to 10 and 12.)
//function ToitureTileboxAllSetTiledataByID(_tileset, _tiledata, _idExclude = undefined)
//{
//	var _tilebox = ToitureTileboxGet(_tileset)
//	_tilebox.tileAllSetDataByID(_tiledata, _idExclude)
//}

#endregion


#region TILEBOX - ADDERS

/***** BY COORDINATE *****/
/// @func ToitureTileboxAddTiledata
/// @desc Add tiledatas to one tile - It will append the provided struct to the stored one.
/// @param {tileset} tileset - the tileset assign to the tilempa in the Room Editor
/// @param {real} x - the left position of the tile, in the tileset.
/// @param {real} y - the top position of the tile, in the tileset.
/// @param {struct} tiledata - a struct that contains additional parameters for the tile.
function ToitureTileboxAddTiledata(_tileset, _x, _y, _tiledata)
{
	var _tilebox = ToitureTileboxGet(_tileset)
	_tilebox.tileAddData(_x, _y, _tiledata)
}

/// @func ToitureTileboxRegionAddTiledata
/// @desc Add tiledatas to a region of the tilebox - It will append the provided struct to the stored one.
/// @param {tileset} tileset - the tileset assign to the tilempa in the Room Editor
/// @param {real} x1 - the starting tile left position of the region , in the tileset.
/// @param {real} y1 - the starting tile top position of the region , in the tileset.
/// @param {real} x2 - the ending tile left position of the region , in the tileset.
/// @param {real} y2 - the ending tile top position of the region , in the tileset.
/// @param {struct} tiledata - a struct that contains additional parameters for the tile.
function ToitureTileboxRegionAddTiledata(_tileset, _x1, _y1, _x2, _y2, _tiledata)
{
	var _tilebox = ToitureTileboxGet(_tileset)
	_tilebox.tileRegionAddData(_x1, _y1, _x2, _y2, _tiledata)
}

/// @func ToitureTileboxAllAddTiledata
/// @desc Add tiledatas to a region of the tile - It will append the provided struct to the stored one.
/// @param {tileset} tileset - the tileset assign to the tilempa in the Room Editor
/// @param {struct} tiledata - a struct that contains additional parameters for the tile.
function ToitureTileboxAllAddTiledata(_tileset, _tiledata)
{
	var _tilebox = ToitureTileboxGet(_tileset)
	_tilebox.tileAllAddData(_tiledata)
}


/***** BY ID *****/
/// @func ToitureTileboxAddTiledataByID
/// @desc Add tiledatas to one tile or several Tile - It will append the provided struct to the stored one.
/// @param {tileset} tileset - the tileset assign to the tilempa in the Room Editor
/// @param {array_or_tileID} TileID - Tile(s) Either an unique ID or an array of IDs. You can also nest arrays to set following IDs. (ex: [0,3,[5,10],12] will set tiles at ID 0,3, 5 to 10 and 12.)
/// @param {struct} tiledata - a struct that contains additional parameters for the tile.
function ToitureTileboxAddTiledataByID(_tileset, _idInclude, _tiledata)
{
	var _tilebox = ToitureTileboxGet(_tileset)
	_tilebox.tileAddDataByID(_idInclude, _tiledata)
}

/// @func ToitureTileboxAllAddTiledataByID
/// @desc Add tiledatas to all tile - It will append the provided struct to the stored one.
/// @param {tileset} tileset - the tileset assign to the tilempa in the Room Editor
/// @param {struct} tiledata - a struct that contains additionals parameters for the tile.
/// @param {array_or_tileID} [TileID] Optional: Exclude Tiles - Either an unique ID or an array IDs. You can also nest arrays to set following IDs. (ex: [0,3,[5,10],12] will set tiles at ID 0,3, 5 to 10 and 12.)
function ToitureTileboxAllAddTiledataByID(_tileset, _tiledata, _idExclude = undefined)
{
	var _tilebox = ToitureTileboxGet(_tileset)
	_tilebox.tileAllAddDataByID(_tiledata, _idExclude)
}
#endregion

#endregion

    
#region DEBUG FUNCTIONS

function ToitureGridDraw(_grid)
{
	var _y = 0; repeat(ds_grid_height(_grid))
	{
		var _x = 0; repeat(ds_grid_width(_grid))
		{
			draw_set_valign(fa_middle)
			draw_set_halign(fa_center)
			draw_text(_x*32+16,_y*32+16,string(_grid[# _x, _y]))
			_x++
		}
		_y++
	}
}


function ToitureTiledataDraw(_x, _y, _grid)
{	
    var _text = _grid.getTiledata(_x, _y)
    
    draw_text(_x, _y-8, _text)
}
#endregion


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


function logthis()
{
	if TOITURE_DEBUG
	{
	    var _string = "";
	    var _i = 0;
	    repeat(argument_count)
	    {
	        _string += string(argument[_i]);
	        ++_i;
	    }
	    
	    show_debug_message("[TOITURE] " + _string);
	}
}


