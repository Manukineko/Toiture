/// @description Insert description here
// You can write your code in this editor

//ToitureGridDraw(Mainground)
draw_set_font(ftToiture)
if propsToiture
{
    ToitureTiledataDraw(mouse_x, mouse_y, Props)
    if displayGrid ToitureGridDraw(Props)
}
else
{
    ToitureTiledataDraw(mouse_x, mouse_y, Foreground)
    if displayGrid ToitureGridDraw(Foreground)
}
draw_set_font(-1)

