function ToitureGridDraw(_grid)
{
    var _xx = tilemap_get_x(_grid.toitureID)
    var _yy = tilemap_get_y(_grid.toitureID)
	var _y = 0; repeat(ds_grid_height(_grid))
	{
		var _x = 0; repeat(ds_grid_width(_grid))
		{
			draw_set_valign(fa_middle)
			draw_set_halign(fa_center)
			draw_text(	_xx+(_x*_grid.tileWidth+_grid.tileWidth/2),
						_yy+(_y*_grid.tileHeight+_grid.tileHeight/2),
						string(_grid[# _x, _y]))
			_x++
		}
		_y++
	}
}


function ToitureTiledataDraw(_x, _y, _grid)
{	
    var _text = _grid.getTiledata(_x, _y)
    
    draw_text(_x, _y-16, _text)
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