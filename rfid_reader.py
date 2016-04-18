# SL030 RFID tag reader based on code by D.J.Whale
# http://blog.whaleygeek.co.uk/raspberry-pi-rfid-tag-reader
#
# For use with SKPang Electronics SL030 RFID module,
# with a SL030 Raspberry Pi cable, and a Raspberry Pi
# running Raspbian Wheezy.
# product numbers: RFID-SL030, RSP-SL030-CAB
# http://skpang.co.uk/blog/archives/946
#
# Run this program as follows:
#   sudo python rfid_example.py
# The brain backend should be running first!

#   Import this module to gain access to the RFID driver
import rfid
import urllib2
import time

#   Keep track of what the last tag we saw was
old_tag = 0
api = "http://localhost:8000/api/"

#   This, like, forever!
while True:

    # try to check to see if a card is present
    try:
        tagIsPresent = rfid.tagIsPresent()
    except:
        time.sleep(0.2)
        continue

    #   If one is, see if it's different to the one we had before
    if tagIsPresent:
        #   try and grab the data
        try:
            rfid.readMifare()
            uid = rfid.getUniqueId()
        except:
            time.sleep(0.2)
            continue

        #   If it's a new tag, then do the thing!
        if uid != old_tag:
            #   try and call the brain api endpoint
            try:
                response = urllib2.urlopen(api + "miab.tag.detected?id=" + uid)
                response.close()
                old_tag = uid
            except:
                time.sleep(0.5)
                continue
    else:
        #   If there is no tag and we used to have a tag, then
        #   we have lost the tag
        if old_tag != 0:
            #   try and call the brain api endpoint
            try:
                response = urllib2.urlopen(api + "miab.tag.lost")
                response.close()
                old_tag = 0
            except:
                time.sleep(0.5)
                continue

    time.sleep(0.2)

# END
