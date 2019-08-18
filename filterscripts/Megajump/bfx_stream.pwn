/*
	Streamer Core 4.3 ( BFX_OBJECTS ) - (c) 2010 by BlackFoX_UD_    				>>>>>>( ONLY FOR 0.3b )<<<<<<<<

    [[ http://www.gnu.org/licenses/gpl-3.0.txt ]]
    
    >>...This is a Part of BFX Streamer...<<

	http://www.bfxsoftware.kilu.de/
	
	...Underground Clan...
*/
#include <a_samp>
/* User Functions [START]*/
forward CreateStreamerObject(bmodel,Float:x,Float:y,Float:z,Float:rx,Float:ry,Float:rz,oInterior,vw,Float:streamer_distance,xplayerid,Float:draw_dist);
forward DestroyStreamerObject(stream_id);
forward MoveStreamerObject(stream_id,Float:x,Float:y,Float:z,Float:speed);
forward StopStreamerObject(stream_id);
forward SetStreamerObjectPos(stream_id,Float:x,Float:y,Float:z);
forward SetStreamerObjectRot(stream_id,Float:rx,Float:ry,Float:rz);
forward SetStreamerAreaObjects(stream_limit);
forward GetStreamerObjectPos(stream_id,&Float:x,&Float:y,&Float:z);
forward GetStreamerObjectRot(stream_id,&Float:rx,&Float:ry,&Float:rz);
forward SetStreamerObjectToPlayerid(stream_id,playerid);
forward getObjectCount();
forward DestroyAllStreamerObjects();
forward StreamerLoadMap(Mapfile[]);
/* User Functions [END]*/

//[+] Benutzerdefiniert
#define MAX_STREAM 8000 // Limit kann nun unendlich Groß sein aber bitte Realistisch bleiben.
#define INVALID_STREAMER_OBJECT (MAX_STREAM+1) // Ungültige Streamer Objekt ID
#define LIMIT_AREA 400 // Sollte reichen bzw. geht ans Limit
#define STREAMER_INTERVALL 900 // (MS) Reaktion

/* Alles was unter dieser Linie steht nicht verändern bzw. nur auf eigene Gefahr! */
/* Streamer Only  [START]*/
enum data
{
	model,
	Float:ox,
	Float:oy,
	Float:oz,
	Float:rox,
	Float:roy,
	Float:roz,
	interior,
	virtual_world,
	Float:stream_distance,
	Float:draw_distance,
	object,
	forplayeridx,
	exist,
	rot_timer
}
new bfxobject[MAX_STREAM][data];

new PLAYER_OBJEKTE[MAX_PLAYERS];
new bool:ERSTELLT[MAX_PLAYERS][MAX_STREAM];
new OBJ_ID[MAX_PLAYERS][MAX_STREAM];

forward CoreStream();
forward searchSlot();
/* Streamer Only [END] */
new _core_timer;
public CoreStream()
{
	for(new i = 0;i<MAX_PLAYERS;i++)
	{
	    if(!IsPlayerConnected(i) || IsPlayerNPC(i))continue;
	    for(new j = 0;j<MAX_STREAM;j++)
	    {
	        if(!bfxobject[j][exist])continue;
	        if(bfxobject[j][forplayeridx] != i && bfxobject[j][forplayeridx] !=-1)continue;
	        if
			(
				(IsPlayerInRangeOfPoint(i,bfxobject[j][stream_distance],bfxobject[j][ox],bfxobject[j][oy],bfxobject[j][oz]) && bfxobject[j][virtual_world] == -1 && bfxobject[j][interior] == -1) ||
				(IsPlayerInRangeOfPoint(i,bfxobject[j][stream_distance],bfxobject[j][ox],bfxobject[j][oy],bfxobject[j][oz]) && (bfxobject[j][virtual_world] > -1 && GetPlayerVirtualWorld(i) == bfxobject[j][virtual_world]) && (bfxobject[j][interior] > -1 && GetPlayerInterior(i) == bfxobject[j][interior])) ||
				(IsPlayerInRangeOfPoint(i,bfxobject[j][stream_distance],bfxobject[j][ox],bfxobject[j][oy],bfxobject[j][oz]) && (bfxobject[j][virtual_world] > -1 && GetPlayerVirtualWorld(i) == bfxobject[j][virtual_world]) && bfxobject[j][interior] == -1) ||
				(IsPlayerInRangeOfPoint(i,bfxobject[j][stream_distance],bfxobject[j][ox],bfxobject[j][oy],bfxobject[j][oz]) && bfxobject[j][virtual_world] == -1 && (bfxobject[j][interior] > -1 && GetPlayerInterior(i) == bfxobject[j][interior]))
			)
			{
			    if(PLAYER_OBJEKTE[i] < LIMIT_AREA)
			    {
			    	if(!ERSTELLT[i][j])
			    	{
			        	PLAYER_OBJEKTE[i]++;
                        OBJ_ID[i][j] = CreatePlayerObject(i,bfxobject[j][model],bfxobject[j][ox],bfxobject[j][oy],bfxobject[j][oz],bfxobject[j][rox],bfxobject[j][roy],bfxobject[j][roz],bfxobject[j][draw_distance]);
						CallRemoteFunction("OnBFXObjectStreamIn","iiii",j,i,PLAYER_OBJEKTE[i],LIMIT_AREA);
						ERSTELLT[i][j] = true;
			    	}
			    }
			}
			else
			{
			    if(ERSTELLT[i][j])
			    {
			        if(IsValidPlayerObject(i,OBJ_ID[i][j]))
			        {
				        PLAYER_OBJEKTE[i]--;
				        DestroyPlayerObject(i,OBJ_ID[i][j]);
				        CallRemoteFunction("OnBFXObjectStreamOut","iiii",j,i,PLAYER_OBJEKTE[i],LIMIT_AREA);
				        ERSTELLT[i][j] = false;
			        }
			    }
			}
	    }
	}
	return 1;
}

public OnFilterScriptInit()
{
	print("\n--------------------------------------");
	print(" [[ BFX Object Streamer 4.2 ( Stable ) ]]");
	print(" [[  (c) 2010 By BlackFoX_UD_          ]]");
	print("--------------------------------------\n");
	_core_timer = SetTimer("CoreStream",STREAMER_INTERVALL,1);
	return 1;
}

public OnFilterScriptExit()
{
	KillTimer(_core_timer);
	for(new i = 0;i<MAX_PLAYERS;i++)
	{
		if(!IsPlayerConnected(i) || IsPlayerNPC(i))continue;
		for(new j = 0;j<MAX_STREAM;j++)
		{
		    if(!ERSTELLT[i][j])continue;
		    ERSTELLT[i][j] = false;
		    DestroyPlayerObject(i,OBJ_ID[i][j]);
		    OBJ_ID[i][j] = 0;
		}
	 	PLAYER_OBJEKTE[i] = 0;
	}
	return 1;
}
public OnPlayerDisconnect(playerid, reason)
{
	for(new j = 0;j<MAX_STREAM;j++)
	{
	    if(!ERSTELLT[playerid][j])continue;
  		ERSTELLT[playerid][j] = false;
		DestroyPlayerObject(playerid,OBJ_ID[playerid][j]);
  		OBJ_ID[playerid][j] = 0;
  		if(bfxobject[j][forplayeridx] == playerid)
  		{
		  	bfxobject[j][exist] = 0;
			bfxobject[j][model] = 0;
			bfxobject[j][ox] = (0.0);
			bfxobject[j][oy] = (0.0);
			bfxobject[j][oz] = (0.0);
			bfxobject[j][rox] = (0.0);
			bfxobject[j][roy] = (0.0);
			bfxobject[j][roz] = (0.0);
			bfxobject[j][interior] = 0;
			bfxobject[j][virtual_world] = 0;
			bfxobject[j][stream_distance] = (0.0);
            bfxobject[j][draw_distance] = (300.0);
			bfxobject[j][forplayeridx] = -1;
  		}
	}
 	PLAYER_OBJEKTE[playerid] = 0;
	return 1;
}
public CreateStreamerObject(bmodel,Float:x,Float:y,Float:z,Float:rx,Float:ry,Float:rz,oInterior,vw,Float:streamer_distance,xplayerid,Float:draw_dist)
{
	if(xplayerid != -1 && IsPlayerNPC(xplayerid))return -1;
    new getid = searchSlot();
	if(getid >= MAX_STREAM)return (printf("[BFX_OBJECTS] : Limit erreicht. ( %d )",MAX_STREAM)) ? (-1) : (0);
	bfxobject[getid][exist] = 1;
	bfxobject[getid][model] = bmodel;
	bfxobject[getid][ox] = x;
	bfxobject[getid][oy] = y;
	bfxobject[getid][oz] = z;
	bfxobject[getid][rox] = rx;
	bfxobject[getid][roy] = ry;
	bfxobject[getid][roz] = rz;
	bfxobject[getid][interior] = oInterior;
	bfxobject[getid][virtual_world] = vw;
	bfxobject[getid][forplayeridx] = xplayerid;
	bfxobject[getid][stream_distance] = streamer_distance;
	bfxobject[getid][draw_distance] = draw_dist;
	return getid;
}
public DestroyStreamerObject(stream_id)
{
	if(stream_id > MAX_STREAM || stream_id < 0)return 0;
	if(!bfxobject[stream_id][exist])return 0;
	bfxobject[stream_id][exist] = 0;
	for(new i = 0;i<MAX_PLAYERS;i++)
	{
	    if(!IsPlayerConnected(i) || IsPlayerNPC(i))continue;
		if(ERSTELLT[i][stream_id])DestroyPlayerObject(i,OBJ_ID[i][stream_id]);
	}
	return 1;
}
public MoveStreamerObject(stream_id,Float:x,Float:y,Float:z,Float:speed)
{
    if(stream_id > MAX_STREAM || stream_id < 0)return 0;
    if(!bfxobject[stream_id][exist])return 0;
    bfxobject[stream_id][ox] = x;
    bfxobject[stream_id][oy] = y;
    bfxobject[stream_id][oz] = z;
    for(new i = 0;i<MAX_PLAYERS;i++)
    {
        if(!IsPlayerConnected(i) || IsPlayerNPC(i))continue;
        if(ERSTELLT[i][stream_id])MovePlayerObject(i,OBJ_ID[i][stream_id],x,y,z,speed);
    }
    return 1;
}
public StopStreamerObject(stream_id)
{
    if(stream_id > MAX_STREAM || stream_id < 0)return 0;
   	if(!bfxobject[stream_id][exist])return 0;
    for(new i = 0;i<MAX_PLAYERS;i++)
    {
        if(!IsPlayerConnected(i) || IsPlayerNPC(i))continue;
        if(ERSTELLT[i][stream_id])
		{
		    GetPlayerObjectPos(i,OBJ_ID[i][stream_id],bfxobject[stream_id][ox],bfxobject[stream_id][oy],bfxobject[stream_id][oz]);
			StopPlayerObject(i,OBJ_ID[i][stream_id]);
		}
    }
	return 1;
}
public SetStreamerObjectPos(stream_id,Float:x,Float:y,Float:z)
{
    if(stream_id > MAX_STREAM || stream_id < 0)return 0;
    if(!bfxobject[stream_id][exist])return 0;
    bfxobject[stream_id][ox] = x;
    bfxobject[stream_id][oy] = y;
    bfxobject[stream_id][oz] = z;
    for(new i = 0;i<MAX_PLAYERS;i++)
    {
		if(!IsPlayerConnected(i) || IsPlayerNPC(i))continue;
		if(ERSTELLT[i][stream_id])SetPlayerObjectPos(i,OBJ_ID[i][stream_id],x,y,z);
    }
    return 1;
}
public SetStreamerObjectRot(stream_id,Float:rx,Float:ry,Float:rz)
{
    if(stream_id > MAX_STREAM || stream_id < 0)return 0;
    if(!bfxobject[stream_id][exist])return 0;
    bfxobject[stream_id][rox] = rx;
    bfxobject[stream_id][roy] = ry;
    bfxobject[stream_id][roz] = rz;
    for(new i = 0;i<MAX_PLAYERS;i++)
    {
		if(!IsPlayerConnected(i) || IsPlayerNPC(i))continue;
		if(ERSTELLT[i][stream_id])SetPlayerObjectRot(i,OBJ_ID[i][stream_id],rx,ry,rz);
    }
    return 1;
}
public GetStreamerObjectPos(stream_id,&Float:x,&Float:y,&Float:z)
{
    if(stream_id > MAX_STREAM || stream_id < 0)return 0;
    if(!bfxobject[stream_id][exist])return 0;
    new foundno = 0;
    for(new i = 0;i<MAX_PLAYERS;i++)
    {
        if(!IsPlayerConnected(i) || IsPlayerNPC(i))continue;
        if(ERSTELLT[i][stream_id])
        {
            GetPlayerObjectPos(i,OBJ_ID[i][stream_id],x,y,z);
            foundno = 1;
            break;
        }
    }
    if(!foundno)
	{
	    x = bfxobject[stream_id][ox];
	    y = bfxobject[stream_id][oy];
	    z = bfxobject[stream_id][oz];
	}
	return 1;
}
public GetStreamerObjectRot(stream_id,&Float:rx,&Float:ry,&Float:rz)
{
    if(stream_id > MAX_STREAM || stream_id < 0)return 0;
    if(!bfxobject[stream_id][exist])return 0;
    new foundno = 0;
    for(new i = 0;i<MAX_PLAYERS;i++)
    {
        if(!IsPlayerConnected(i) || IsPlayerNPC(i))continue;
        if(ERSTELLT[i][stream_id])
        {
            GetPlayerObjectRot(i,OBJ_ID[i][stream_id],rx,ry,rz);
            foundno = 1;
            break;
        }
    }
    if(!foundno)
	{
	    rx = bfxobject[stream_id][rox];
	    ry = bfxobject[stream_id][roy];
	    rz = bfxobject[stream_id][roz];
	}
	return 1;
}
public searchSlot()
{
	new xidx = INVALID_STREAMER_OBJECT;
	for(new i = 0;i<MAX_STREAM;i++)
	{
	    if(!bfxobject[i][exist])
	    {
			xidx = i;
			break;
	    }
	}
	return xidx;
}
public getObjectCount()
{
	new oCount;
	for(new i = 0;i<MAX_STREAM;i++)
	{
		if(bfxobject[i][exist])oCount++;
	}
	return oCount;
}
public SetStreamerObjectToPlayerid(stream_id,playerid)
{
    if(stream_id > MAX_STREAM || stream_id < 0)return 0;
    if(!bfxobject[stream_id][exist])return 0;
    bfxobject[stream_id][forplayeridx] = playerid;
    for(new i = 0;i<MAX_PLAYERS;i++)
    {
        if(!IsPlayerConnected(i) || IsPlayerNPC(i))continue;
        if(ERSTELLT[i][stream_id])
		{
			DestroyObject(OBJ_ID[i][stream_id]);
			ERSTELLT[i][stream_id] = false;
		}
    }
    return 1;
}
public DestroyAllStreamerObjects()
{
	for(new i = 0;i<MAX_PLAYERS;i++)
	{
		if(!IsPlayerConnected(i) || IsPlayerNPC(i))continue;
		for(new j = 0;j<MAX_STREAM;j++)
		{
		    if(!bfxobject[j][exist])continue;
  			bfxobject[j][exist] = 0;
			bfxobject[j][model] = 0;
			bfxobject[j][ox] = (0.0);
			bfxobject[j][oy] = (0.0);
			bfxobject[j][oz] = (0.0);
			bfxobject[j][rox] = (0.0);
			bfxobject[j][roy] = (0.0);
			bfxobject[j][roz] = (0.0);
			bfxobject[j][interior] = 0;
			bfxobject[j][virtual_world] = 0;
			bfxobject[j][stream_distance] = (0.0);
            bfxobject[j][draw_distance] = (300.0);
			bfxobject[j][forplayeridx] = -1;
		    if(!ERSTELLT[i][j])continue;
		    ERSTELLT[i][j] = false;
		    DestroyPlayerObject(i,OBJ_ID[i][j]);
		    OBJ_ID[i][j] = 0;
		}
	 	PLAYER_OBJEKTE[i] = 0;
	}
	return 1;
}
public StreamerLoadMap(Mapfile[])
{
	new File:fl = fopen(Mapfile,io_read),input[255];
	new obj_model,
	    Float:obj_x,
	    Float:obj_y,
	    Float:obj_z,
	    Float:obj_rotx,
	    Float:obj_roty,
	    Float:obj_rotz,
		gl_count,bool:erkannt,parse[64],p_pos = -1,bool:can_close,key;
	while(fread(fl,input))
	{
	    for(new i = 0;i<strlen(input);i++)
	    {
	        if(input[i] == '=')
	        {
	            gl_count++;
	            if(!erkannt)
	        	{
		            if(strlen(input) >= (i - 9))
		            {
		                if(!strcmp(input[i-9],"object id",_,9))erkannt = true;
		            }
	        	}
	        	else
	        	{
	        	    if(!strcmp(input[i-strlen("model")],"model",_,strlen("model")))key = 4;
	        	    else if(!strcmp(input[i-strlen("posX")],"posX",_,strlen("posX")))key = 7;
	        	    else if(!strcmp(input[i-strlen("posY")],"posY",_,strlen("posY")))key = 8;
	        	    else if(!strcmp(input[i-strlen("posZ")],"posZ",_,strlen("posZ")))key = 9;
	        	    else if(!strcmp(input[i-strlen("rotX")],"rotX",_,strlen("rotX")))key = 10;
	        	    else if(!strcmp(input[i-strlen("rotY")],"rotY",_,strlen("rotY")))key = 11;
	        	    else if(!strcmp(input[i-strlen("rotZ")],"rotZ",_,strlen("rotZ")))key = 12;
	        	    else key = 0;
					i = i + 2;
					if(key == 4 || (key >= 7 && key <= 12))
					{
						while(input[i] != '"')
						{
						    p_pos++;
							parse[p_pos] = input[i];
							i++;
						}
						parse[p_pos+1] = '\0';
						i++;
					}
					switch(key)
					{
					    case 4:obj_model = strval(parse);
					    case 7:obj_x = floatstr(parse);
					    case 8:obj_y = floatstr(parse);
					    case 9:obj_z = floatstr(parse);
					    case 10:obj_rotx = (floatstr(parse));
					    case 11:obj_roty = (floatstr(parse));
					    case 12:obj_rotz = (floatstr(parse));
					}
					
					p_pos = -1;
					parse[0] = '\0';
					key = 0;
	        	}
	        }
	        else if(input[i] == '/')can_close = true;
			else if(input[i] == '>')
			{
			    if(can_close)
			    {
			        can_close = false;
					erkannt = false;
					gl_count = 0;
					CreateStreamerObject(obj_model,obj_x,obj_y,obj_z,obj_rotx,obj_roty,obj_rotz,-1,-1,200.0,-1,300.0);
					obj_model = 0;
					obj_x = (0.0);
					obj_y = (0.0);
					obj_z = (0.0);
					obj_rotx = (0.0);
					obj_roty = (0.0);
					obj_rotz = (0.0);
					p_pos = -1;
					parse[0] = '\0';
				}
			}
			else can_close = false;
	    }
	}
	return 1;
}
