## FE-Collection Creator (FeCC)
FE-Collection Creator (Frontend Collection Creator) or FeCC for short is designed for rapidly creating collections for ES-DE, base upon ROM file names. My intention was to make an easy way to make this collections files without having to use the front end to manually search and select each game. I can now generate collections based upon my own ROM sets in a fraction of the time I could from one of my devices.

### Disclaimer

I made this on a whim. Actually, a literal fever dream to be specific. It isn't perfect but its a huge advancement over the manual alternative. This is 100% based upon file name, and nothing more. However, because of how quickly it generates most the file list, you will be able to quickly and easily add additional games manually. This extra step is primarily for MAME roms as they have a different naming convention than everything else.

### Setup

Pre-requisites and Setup:
1. Your roms should be in directories that match ES-DE. The output depends on the paths being correct to begin with. For example, nes\Tetris.zip will work but Nintendo\Tetris won't. This is an ES-DE limitation. Sorry.
2. This script uses PowerShell. I haven't tested it on a Mac but it should work. It should also work on all current Windows systems.
3. Download the script (.ps1 file) and save it to your computer
4. You must be an administrator, and adjust local unsigned policy to allow this script to run, as it is not signed. You can do this by running
   `Set-ExecutionPolicy RemoteSigned`
   >You should never make security changes to your computer because someone on the internet told you to. For more information on what this setting changes does, please visit https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_signing?view=powershell-7.4

5. To run an unsigned script, use the Unblock-File cmdlet or use the following procedure.

  1.Save the script file on your computer.
  2. Click Start, click My Computer, and locate the saved script file.
  3. Right-click the script file, and then click Properties.
  4. Click Unblock.

### How To Use

1. Open Terminal or Powershell on your computer and navigate to where your stored your downloaded script.
2. Enter .\FE-CollectionCreator.ps1 into the window and hit Enter or Return
   ![Step 01.](https://github.com/Y2J1245/FE-CollectionCreator/blob/main/Images/FeCC-Step01.png)

3. The script will now run and begin to ask you for a series of inputs.
   The first is: Enter the top-level ROM directory to search. Example: E:\ROMs. This means if your roms are organized correctly you would enter something like E:\Roms to scan things like E:\Roms\nes, E:\Roms\gb, etc.
  Next Enter the output directory for your collection .cfg files. Example: E:\ES-DE\collections. This is where the .cfgs will be created that ES-DE will use. It's also where the paths will be added once the files are created.*
  Enter the directory to save the XML files. Example: E:\themes_tempoary\_inc\systems\metadata-global\: is next. I reference this path, because it will help make things look pretty later. It's a bit beyond the scope of this tool, but but creating this XML, and later dropping it into a theme, your collection will be more polished in the end.**
  Enter the search term. This one is pretty straightforward. If you want a Mario collection, search Mario. If you want a Super Mario collection search Super Mario. Search will work the same as it would in Windows Explorer.
  Enter the name for the output file (without extension). Example: Tecmo Super Bowl. This is the name of the .cfg that will be generated. The script will automatically prepend "custom-" to your choice. Its recommended you keep track of this entry (case sensitive) if you intend adding custom artwork later.
  Add all found results to the collection? (Y/N): is also pretty easy. If you know your results will be pretty specific, such as Metroid, you could choose Y, to have all results found added to your new created collection. However, if you wanted a bunch of Mario games, but want to be selective about them, you'd search Mario and then hit N. Instead of adding them all, each result will ask you to add it using Y or N.
 ![Step 02.](https://github.com/Y2J1245/FE-CollectionCreator/blob/main/Images/FeCC-Step02.png)

5. Once you've completed your first run, it will ask you if you'd like to make another list. You won't have to setup your paths again, unless you restart the script.
6. You will now have the files you need to setup custom collections on your device.
  If you chose directories you use on your device, you are nearly done. Just press Start in ES-DE, go to Game Collection Settings, select Custom Game Collections, toggle on your newly created custom Collections, back out and let ES-DE refresh. You should now see your collections. Enjoy!

  If you setup your directories to be somewhere else, you will need to copy the exported files to the correct locations on your device. You will need to copy your .cfg files to ES-DE/Collections/. The ES-DE folder will be where you chose to setup your device during initial setup. On Android this can be your SD Card, but an initial folder will be setup called ES-DE on your device's internal storage.  Once you've put them in place, from ES-DE, press Start, go to Game Collection Settings, select Custom Game Collections, toggle on your newly created custom Collections, back out and let ES-DE refresh. You should now see your collections. Enjoy!

* This will updated but not overwrite existing files. 
** More info about how I use these here. Coming Soon.

### Other Notes & Updating .cfgs

This script is meant to be append entries, and not meant to be destructive. So by default, it only add lines to your .cfgs. By happenstance, this makes the tool a bit more useful. For example, if you want a collection called Sega Favorites, you can reference the same cfg when prompted to enter "Enter the name for the output file (without extension). Example: Tecmo Super Bowl". With a couple of quick runs, you can quickly add Streets of Rage and Mortal Kombat to your Sonic games.

Manually Adding or Remove Games

I recongize 2 issues with this script. The first is that it doesn't handle MAME titles well, and second is that it's easy to add something by accident. For example, let's say I want to add Super C to a collection, but accidentally added Super Cobra. Oh no! Now what? Easy open the file that was created or updated with a text editor. Even Notepad will work, but I'd recommened something good like VS Code or Notepad++. Find the entry and delete the row.

To add a game, do the opposite, find the file for the collection to which you want to add a MAME game. Open it with a proper text editor (see above),  and add a line that starts with %ROMPATH%/mame/ and then enter the rom name you want to include.

For example: %ROMPATH%/mame/1943.zip

Save your file and test, or copy it to your device and test.

 ![Step 03.](https://github.com/Y2J1245/FE-CollectionCreator/blob/main/Images/FeCC-Step03.png)

### Theming & Bonus Info

This section is exclusively for those that want to go above and beyond. ES-DE allows you to group unthemed collections, and is a perfectly viable option.

This process generates an XML file. I add this to the process so I can use a custom version of Icon. The XML ensures the menu information in Iconic (https://github.com/Siddy212/iconic-es-de)  loads correctly. I'll likely make this optional in the future, but for now I'm leaving it in place. 

Once the XML files are created, they have to be placed on your device in a semi-convoluted way. Android protects files that are downloaded within it. This means I had to download Iconic on my computer, then rename it so I have an indicator to differentiate in ES-DE, and finally drop it in [Android Internal Storage Root Directory]/Android/data/or.es_de.frontedn/files/themes/[customthemedirectory]/_inc/systems/metadata-global/. This will show the correct metadata on the main menu of ES-DE once you refresh or reload.

You can then add Wheel/Marquee/Icon/Carousel art to /_inc/systems/carousel-icons/ in .webp format. I've found changing .PNG to .WEBP has been sufficient. You can add custom backgrounds by adding .webp files to the correct folder for your settings, ie Classic vs Modern vs Alternate. Regardless of what you choose for your images, their file names should match or XML file, case included. You also shouldn't have Batman-1.webp and Batman.webp in your directories as ES-DE won't load either, leaving you with generic place holder text.
