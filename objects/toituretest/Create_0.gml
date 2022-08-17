enum TYPES
{
    GROUND,
    SLOPE
}

propsToiture = false

//AUTO MODE
ToitureTileboxCreate(tsGreenValley, sGreenValley)
ToitureTileboxAllSetTiledataByID(tsGreenValley, {solid:true, type:"Ground"})
ToitureTileboxAddTiledataByID(tsGreenValley, [0], {solid:false, type:"Void"})
ToitureTileboxAddTiledataByID(tsGreenValley, [ [60,63], [70,73] ], {type:"Slope"})
ToitureTileboxRegionAddTiledata(tsGreenValley, 4,6,7,7, {solid:false, props: "Mushrooms"})

//AUTO MODE - Lite
//ToitureTileboxCreate(tsDungeon_Mainground32, sTileDungeon_Mainground32, true)
//ToitureTileboxAllSetTiledataByID(tsDungeon_Mainground32, true, [0, [3,6]])
//ToitureTileboxSetTiledataByID(tsDungeon_Mainground32, [0, [3,6]], false)
//ToitureTileboxAllAddTiledataByID(tsDungeon_Mainground32, 100, [16])
//ToitureTileboxAddTiledataByID(tsDungeon_Mainground32, [16], 1)

//MANUAL
//DungeonMainground = new ToitureTilebox(tsDungeon_Mainground32, sTileDungeon_Mainground32)
//DungeonMainground.tileAllSetDataByID({
//	all:true
//}, [0, [3,6]])
//.tileSetDataByID([0, [3,6]],{all:false})
//.tileAllAddDataByID({type:"together"}, [16])
//.tileAddDataByID([16], {type: "alone"})

//MANUAL - Lite
//DungeonMainground = new ToitureTilebox(tsDungeon_Mainground32, sTileDungeon_Mainground32, true )
//DungeonMainground.tileAllSetDataByID(true, [0, [3,6]])
//.tileSetDataByID([0, [3,6]],false)
//.tileAllAddDataByID(100, [16])
//.tileAddDataByID([16], 1)

Mainground = new Toiture("Foreground")
Props = new Toiture("Props")
//Mainground.assignTilebox(DungeonMainground)
//room_goto(Dungeon)