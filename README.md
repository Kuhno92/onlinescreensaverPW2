THIS REPO CONTAINS THE ORIGINAL WORK OF Peterson from https://www.mobileread.com/forums/showthread.php?t=236104

It additionally combines the info from D. Krannich https://blog.krannich.de/fhem-status-auf-kindle-paperwhite-3/

to make this project work for the kindle paperwhite 2

<a href="https://www.buymeacoffee.com/kuhno92" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/default-orange.png" alt="Buy Me A Coffee" height="41" width="174"></a>


Online Screensaver
------------------ v0.3
                   by peterson, via mobileread.com
                   thanks to the great folks in the Kindle developer corner

The Online Screensaver automatically fetches a new screensaver image from a
user-specified URL at a user-specified interval. If a screensaver is shown
at download time, the downloaded image will be displayed.

This extension supports updating the screensaver even when the Kindle is 
asleep (obviously it won't work if you have really powered the Kindle down
by pressing the power button for many seconds). As such, it will use 
additional battery as it will un-suspend your Kindle at the configured
intervals for one or two minutes.

The image should be in the correct resolution of your device, otherwise the
results may not look so pretty :-) The image also needs to be a "clean" png,
as otherwise you may only get a white screen (you can test whether an image
is working by calling "eips -f -g image.png" on your Kindle).

Possible use cases:
 - download the latest weather report (this was the initial reason this
   extension was developed), you need a server to automatically create this
   image - see for example https://github.com/mpetroff/kindle-weather-display
 - download the latest comic each day as your screensaver
 - download inspirational images/messages each day
 - etc


Disclaimer
----------

As of version 0.3, this extension has only been tested on a Kindle
Paperwhite 2 with WiFi. The auto-update script is currently only enabled
for devices with firmware 5 or newer (which should cover the devices that
actually have a front light).

If you get this extension to run on your device, please provide feedback
at http://www.mobileread.com/forums/showthread.php?t=236104 where you will
also find the latest version.

How this script interacts with 3G models is also unknown.

It is recommended to test the extension manually prior to activating auto
updates. To do so, connect to your Kindle via SSH (ref. USBNet) and run

	/mnt/us/extensions/onlinescreensaver/bin/scheduler.sh &

and then exit. If anything should go wrong, rebooting the Kindle should fix
any problem.

Either way, as usual please be advised that you are using this extension on
your own risk. 


Prerequisites
-------------

* You must have KUAL v2 or later installed.
* You must have linkss installed ("screensavers hack")
* By default, the extension copies the screensaver image to /mnt/us/linkss/screensavers
  as bg_medium_ss00.png. On Paperwhite 2, you most likely already have a
  file of that name - if you don't want it overwritten, please make a
  backup. It is advisable to only have one screensaver image, as otherwise
  the results may become unpredictable.


Installation
------------

Unzip the downloaded file into the extensions folder (/mnt/us/extensions
when using SSH, otherwise the extensions folder at root of the Kindle volume
when connected to your PC).


Configuration
-------------

Edit onlinescreensaver/bin/config.sh, all available options are described
here. Note that you MUST use an editor that supports Unix line endings. On
Windows, use e.g. the free notepad++ application.


Use
---

Run KUAL and enter the "Online-Screensaver" section. Here you have an item
to update the screensaver right away (one time), and you can also enable or
disable the auto-download.


Uninstalling
------------

It is recommended to disable auto-updates prior to deleting the folder
from the extensions directory.
