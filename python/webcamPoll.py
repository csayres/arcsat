import os.path
import urllib
import time
import shutil

refreshPeriod = 10. # seconds
baseDir = "C:\Users\Public\Documents\ACP Web Data\Doc Root\webcam"
teleURL = "http://vivotek.apo.nmsu.edu/cgi-bin/viewer/video.jpg"
domeURL = "http://arcsat-domecam.apo.nmsu.edu/cgi-bin/viewer/video.jpg?resolution=768x768"
teleDest = os.path.join(baseDir, "tele.jpg")
domeDest = os.path.join(baseDir, "dome.jpg")
notFoundDest = os.path.join(baseDir, "notFound.jpg")

while True:
        try:
                urllib.urlretrieve(teleURL, teleDest)
        except:
                ## image not found
                shutil.copy(notFoundDest, teleDest)
        #try:
         #      urllib.urlretrieve(domeURL, domeDest)
        #except:
                ## image not found
                #shutil.copy(notFoundDest, domeDest)
        print time.strftime("%Y-%m-%d %H:%M:%S ")
        time.sleep(refreshPeriod)
