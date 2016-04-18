# SL030 RFID tag reader example  18/08/2014  D.J.Whale
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
# or
#   sudo python3 rfid_example.py


# Import this module to gain access to the RFID driver
import rfid


# fill in this map with the names of your card ID's
cards = {
  "2B53B49B"       : "whaleygeek", 
  "04982B29EE0280" : "elektor RFID card", 
  "EAC85517"       : "white card 1",
  "24B1E145"       : "white card 2",
  "C2091F58"       : "label 1",
  "22F51E58"       : "label 2"
}


# MAIN PROGRAM

while True:

  # wait for a card to be detected as present
  print("Waiting for a card...")
  rfid.waitTag()
  print("Card present")

  # This demo only uses Mifare cards
  if not rfid.readMifare():
    print("This is not a mifare card")
  else:
    # What type of Mifare card is it? (there are different types)
    print("Card type:" + rfid.getTypeName())

    # look up the unique ID to see if we recognise the user
    uid = rfid.getUniqueId()
    try:
      user = cards[uid]
      print("User:" + user)
    except KeyError:
      print("Unknown card:" + uid)

  # wait for the card to be removed
  print("Waiting for card to be removed...")
  rfid.waitNoTag()
  print("Card removed")

# END
