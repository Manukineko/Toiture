propsToiture = false
displayGrid = false

//AUTO MODE
ToitureTileboxCreate(tsGreenValley, sGreenValley)
ToitureTileboxAllAddTiledataByID(tsGreenValley, {solid:true, type:"Ground"}, 0)
ToitureTileboxAddTiledataByID(tsGreenValley, 0, {solid:false, type:"Void"})
ToitureTileboxAddTiledataByID(tsGreenValley, [ [60,63], [70,73] ], {type:"Slope"})
ToitureTileboxRegionAddTiledata(tsGreenValley, 4,6,7,7, {solid:false, props: "Mushrooms"})

//AUTO MODE - Lite
//ToitureTileboxCreate(tsGreenValley, sGreenValley, true)
//ToitureTileboxAllAddTiledataByID(tsGreenValley, 100)
//ToitureTileboxAddTiledataByID(tsGreenValley, [0], 0)
//ToitureTileboxAddTiledataByID(tsGreenValley, [ [60,63], [70,73] ], 200)
//ToitureTileboxRegionAddTiledata(tsGreenValley, 4,6,7,7, 300)

//MANUAL
//Terrain = new ToitureTilebox(tsGreenValley, sGreenValley)
//Terrain.tileAllAddDataByID({solid:true, type:"Ground"})
//.tileAddDataByID([0], {solid:false, type:"Void"})
//.tileAddDataByID([ [60,63], [70,73] ], {type:"Slope"})
//.tileRegionAddData(4,6,7,7, {solid:false, props: "Mushrooms"})
//.tileAddDataByID([0], {solid:true, type:"banana", color: c_red}) //replace the tile 0 data

//MANUAL - Lite
//Terrain = new ToitureTilebox(tsGreenValley, sGreenValley, true)
//Terrain.tileAllAddDataByID(100)
//.tileAddDataByID([0], 0)
//.tileAddDataByID([ [60,63], [70,73] ], 200)
//.tileRegionAddData(4,6,7,7, 300)
//.tileAddDataByID([0], 666) //replace the tile 0 data

Foreground = new Toiture("Foreground")
Props = new Toiture("Props")
//Foreground.assignTilebox(Terrain)
//Props.assignTilebox(Terrain)
//room_goto(Dungeon)