/* BFX Object Streamer 4.3                                                          (ONLY FOR 0.3b)

	(c) 2010 by BlackFoX_UD_
	
	
	...This is a Part of BFX Streamer...
	
*/
#define STREAMER_DISTANCE 200.0
/*
native b_CreateObject(modelid,Float:bx,Float:by,Float:bz,Float:brx,Float:bry,Float:brz,interiorid = 0,virtualwid = 0,stream_dis = STREAMER_DISTANCE,forplayerid = -1);
native b_DestroyObject(id);
native b_SetObjectPos(id,Float:posx,Float:posy,Float:posz);
native b_SetObjectRot(id,Float:posrx,Float:posry,Float:posrz);
native b_MoveObject(id,Float:mx,Float:my,Float:mz,Float:speed);
native b_StopObject(id);
native b_SetAreaLimit(limit);
native b_GetPlayerPos(id,&Float:x,&Float:y,&Float:z);
native b_GetPlayerRot(id,&Float:rx,&Float:ry,&Float:rz);
native b_GetObjectCount(Keine Parameter gebraucht);
native b_SetTotalLimit(stream_limit);
native b_DestroyAllObjects(Keine Parameter gebraucht);
native b_LoadMap(Mapname[]);
*/
forward OnBFXObjectStreamIn(streamobjectid,forplayerid,playerObjectCount,MaxmimalObjects);
forward OnBFXObjectStreamOut(streamobjectid,forplayerid,playerObjectCount,MaxmimalObjects);
stock b_CreateObject(modelid,Float:bx,Float:by,Float:bz,Float:brx,Float:bry,Float:brz,interiorid = -1,virtualwid = -1,Float:stream_dis = STREAMER_DISTANCE,forplayerid = -1,Float:DRAW_DISTANCE = 300.0)return CallRemoteFunction("CreateStreamerObject","iffffffiifif",modelid,bx,by,bz,brx,bry,brz,interiorid,virtualwid,stream_dis,forplayerid,DRAW_DISTANCE);
stock b_DestroyObject(id)return CallRemoteFunction("DestroyStreamerObject","i",id);
stock b_SetObjectPos(id,Float:posx,Float:posy,Float:posz)return CallRemoteFunction("SetStreamerObjectPos","ifff",id,posx,posy,posz);
stock b_SetObjectRot(id,Float:posrx,Float:posry,Float:posrz)return CallRemoteFunction("SetStreamerObjectRot","ifff",id,posrx,posry,posrz);
stock b_MoveObject(id,Float:mx,Float:my,Float:mz,Float:speed)return CallRemoteFunction("MoveStreamerObject","iffff",id,mx,my,mz,speed);
stock b_StopObject(id)return CallRemoteFunction("StopStreamerObject","i",id);
stock b_SetAreaLimit(limit)return CallRemoteFunction("SetStreamerAreaObjects","i",limit);
stock b_GetPlayerPos(id,&Float:x,&Float:y,&Float:z)return CallRemoteFunction("GetStreamerObjectPos","ifff",id,x,y,z);
stock b_GetPlayerRot(id,&Float:rx,&Float:ry,&Float:rz)return CallRemoteFunction("GetStreamerObjectRot","ifff",id,rx,ry,rz);
stock b_GetObjectCount()return CallRemoteFunction("getObjectCount","");
stock b_SetTotalLimit(stream_limit)return CallRemoteFunction("SetStreamTotal","i",stream_limit);
stock b_SetObjectToPlayer(id,playerid)return CallRemoteFunction("SetStreamerObjectToPlayerid","ii",id,playerid);
stock b_DestroyAllObjects()return CallRemoteFunction("DestroyAllStreamerObjects","");
stock b_LoadMap(Mapname[])return CallRemoteFunction("StreamerLoadMap","s",Mapname);
