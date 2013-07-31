import os
import shutil
import commands
import urllib

# Path where the images are saved
imgpath = "/home/hokage/.config/ario/covers/"

# Path where 'artist-only' images can be found
artistimgpath = "/home/hokage/.config/ario/covers/"

# Image displayed when no image found
noimg = "/home/hokage/.config/airo/nocover.jpg"

# Cover displayed by conky
cover = "/tmp/cover.jpg"

def copycover(currentalbum, src, artistsrc, dest, defaultfile):
    searchstring = currentalbum.replace(" ", "+")
    if not os.path.exists(src):
        url = "http://www.albumart.org/index.php?srchkey=" + searchstring + "&itempage=1&newsearch=1&searchindex=Music"
        cover = urllib.urlopen(url).read()
        image = ""
        for line in cover.split("\n"):
            if "http://www.albumart.org/images/zoom-icon.jpg" in line:
                image = line.partition('src="')[2].partition('"')[0]
                break
        if image:
            urllib.urlretrieve(image, src)
    if os.path.exists(src):
        shutil.copy(src, dest)
    elif os.path.exists(artistsrc):
        shutil.copy(artistsrc, dest)
    elif os.path.exists(defaultfile):
        shutil.copy(defaultfile, dest)
    else:
        print ""

# Name of current album
album = commands.getoutput("mpc --format %artist%-%album% | head -n 1")
artist = commands.getoutput("mpc --format %artist% | head -n 1")

# If tags are empty, use noimg.
# Hieronder stond steeds conkycover ipv cover, heb ik gewijzigd.
if album == "":
    if os.path.exists(cover):
        os.remove(cover)
    if os.path.exists(noimg):
        shutil.copy(noimg, cover)
    else:
        print ""
else:
    filename = imgpath + album + ".jpg"
    artistfilename = artistimgpath + artist + ".jpg"
    if os.path.exists("/tmp/nowplaying") and os.path.exists("/tmp/cover.jpg"):
        nowplaying = open("/tmp/nowplaying").read()
        if nowplaying == album:
            pass
        else:
            copycover(album, filename, artistfilename, cover, noimg)
            open("/tmp/nowplaying", "w").write(album)
    else:
        copycover(album, filename, artistfilename, cover, noimg)
        open("/tmp/nowplaying", "w").write(album)
