#region /***** BY COORDINATE *****/
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
#endregion


#region /***** BY ID *****/
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