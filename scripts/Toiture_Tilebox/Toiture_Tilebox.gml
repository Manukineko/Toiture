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

    
    #region METHODS - SETTERS
    /***** ADD BY COORDINATE *****/
    
    /// @func tileAddData
    /// @desc Add tiledatas to one tile - It will append the provided struct to the stored one or change the value of the exixting members
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
    /// @desc Add tiledatas to a region of the tilebox - It will append the provided struct to the stored one or change the value of the exixting members
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
    /// @desc Add tiledatas to a region of the tile - It will append the provided struct to the stored one or change the value of the exixting members
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
    /// @desc Add tiledatas to one tile or several Tile - It will append the provided struct to the stored one or change the value of the exixting members
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
    /// @desc Add tiledatas to all tile - It will append the provided struct to the stored one or change the value of the exixting members
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
