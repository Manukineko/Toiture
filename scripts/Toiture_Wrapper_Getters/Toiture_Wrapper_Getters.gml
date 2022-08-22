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