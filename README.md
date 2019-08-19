# Rafelder's Megajump

These are the source (and compiled) files for the SA:MP gamemode "Rafelder's Megajump"

I don't know if it's compatible with todays pawno/SA:MP server, so i added the compiled `*.amx` file, which still works.

Feel free to update/change/use the code under the terms of the MIT license. Feel free to send a pull request. Feel free the ask for access to the repository, because i dont know how to test changed code properly.

I am aware of bad indentation/code - sorry for that. The code is over ten years old and i didn't change it since then.

Hafe fun!

## Copyright/License

__bfx_oStream__ (by BlackFoX)  
https://forum.sa-mp.com/showthread.php?t=78598  
(Download not available anymore, so I included it in the source files)

__Rest__ (by me)  
Do whatever you like to do with that code. You can ignore all licenses (if there are any) except the new MIT license in this repo.

## Setup

1) Copy all files to your SA:MP server directory
- `filterscripts/Megajump/bfx_stream.pwn`
- `gamemodes/MM.pwn`
- `pawno/include/Megajump/bfx_oStream.inc`
- `pawno/include/LanguageNew.inc`
- `pawno/include/MegajumpO.inc`

2) Compile (if possible; otherwise just use the `*.amx`)

3) Configure your server.cfg

```
gamemode0 MM
filterscripts Megajump/bfx_stream
```
