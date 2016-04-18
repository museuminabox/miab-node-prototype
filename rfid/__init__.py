# SL030 RFID reader driver for skpang supplied SL030 Mifare reader
# (c) 2013-2014 Thinking Binaries Ltd, David Whale

#===============================================================================
# CONFIGURATION
#
# You can change these configuration items either by editing them in this
# file, or by refering to the module by name inside your own program. 
# e.g. 
#   import rfid
#   rfid.CFGEN_GPIO = False


# set to True to detect card presence by using GPIO
# set to False to detect card presence by reading card status
CFGEN_GPIO = True

# Set to the GPIO required to monitor the tag detect (OUT) line
CFG_TAG_DETECT = 4

# The I2C address of the SL030 RFID tag reader
CFG_ADDRESS = 0x50

# How often to poll (in seconds) for a tag present
CFG_TAG_PRESENT_POLL_TIME = 0.01

# How often to poll (in seconds) for a tag absent
CFG_TAG_ABSENT_POLL_TIME = 0.5

# Set to True to throw an exception when an error is printed
# Set to False to just print the error
CFGEN_EXCEPTIONS = True

# The function called when an error occurs in this module
# you can replace this with a function of your own to handle errors
def error(str):
  print("ERROR:" + str)
  if CFGEN_EXCEPTIONS:
    raise ValueError(str)


#===============================================================================
# SETUP

try:
  import ci2c # python2
except ImportError:
  from . import ci2c # python3

import time

CMD_SELECT_MIFARE = 0x01
CMD_GET_FIRMWARE  = 0xF0
WR_RD_DELAY       = 0.05

ci2c.initDefaults()


#===============================================================================
# UTILITIES

def typename(type):
  if (type == 0x01):
    return "mifare 1k, 4byte UID"
  elif (type == 0x02):
    return "mifare 1k, 7byte UID"
  elif (type == 0x03):
    return "mifare UltraLight, 7 byte UID"
  elif (type == 0x04):
    return "mifare 4k, 4 byte UID"
  elif (type == 0x05):
    return "mifare 4k, 7 byte UID"
  elif (type == 0x06):
    return "mifare DesFilre, 7 byte UID"
  elif (type == 0x0A):
    return "other"
  else:
    return "unknown:" + str(type)



#===============================================================================
# class-based interface.
# If for some reason you had multiple SL030's with different addresses,
# you could use this to have multiple instances. It's not really written
# that way yet as CFG_ADDRESS is global, but it's easy to change if you
# did want more than one reader, or if you wanted different types of readers
# that implemented this same interface and were interchangeable at product
# install time.

# The gpio parameter in __init__ can be used to provide an alternative GPIO
# implementation or to share an application wide GPIO object.

class SL030:
  def __init__(self, gpio=None):
    self.type = None
    self.uid  = None
    self.GPIO = gpio

    if CFGEN_GPIO:
      if gpio == None:
        # use default RPi.GPIO, if nothing else provided
        import RPi.GPIO as GPIO
        GPIO.setmode(GPIO.BCM)
        self.GPIO = GPIO
      self.GPIO.setup(CFG_TAG_DETECT, GPIO.IN)

  def tagIsPresent(self):
    if CFGEN_GPIO:
      return self.GPIO.input(CFG_TAG_DETECT) == False
    else:
      return self.select_mifare()

  def waitTag(self):
    while not self.tagIsPresent():
      time.sleep(CFG_TAG_PRESENT_POLL_TIME)

  def waitNoTag(self):
    while self.tagIsPresent():
      time.sleep(CFG_TAG_ABSENT_POLL_TIME)

  def validateVer(self, ver):
    first = ver[0]
    if first != ord('S'):
      if first == ord('S') + 0x80:
        error("validateVer:Corruption from device detected")
      else:
        error("validateVer:unrecognised device")

  def tostr(self, ver):
    verstr = ""
    for b in ver:
      verstr += chr(b)
    return verstr

  def getFirmware(self):
    # Tx ADDRESS, 1, CMD_GET_FIRMWARE
    result = ci2c.write(CFG_ADDRESS, [1, CMD_GET_FIRMWARE])
    time.sleep(WR_RD_DELAY)
    if result != 0:
      error("getFirmware:Cannot read, result=" + str(result))
      return None
      
    result, buf = ci2c.read(CFG_ADDRESS, 15)
    if result != 0:
      error("getFirmware:Cannot write, result=" + str(result))
      return None
    ver = buf[3:]
    self.validateVer(ver)		
    return self.tostr(ver)


  def readMifare(self):
    result = ci2c.write(CFG_ADDRESS, [1, CMD_SELECT_MIFARE])
    time.sleep(WR_RD_DELAY)
    if result != 0:
      error("readMifare:Cannot read, result=" + str(result))
      return False
      
    result, buf = ci2c.read(CFG_ADDRESS, 15)
    if result != 0:
      error("readMifare:Cannot write, result=" + str(result))
      return False
      
    length = buf[0]
    cmd    = buf[1]
    status = buf[2] 

    if (status != 0x00):
      self.uid  = None
      self.type = None
      return False 

    # uid length varies on type, and type is after uuid
    uid       = buf[3:length]
    type      = buf[length]
    self.type = type
    self.uid  = uid
    return True

  def getUID(self):
    return self.uid

  def getUniqueId(self):
    uidstr = ""
    for b in self.uid:
      uidstr += "%02X" % b
    return uidstr

  def getType(self):
    return self.type



#===============================================================================
# class-less interface
#
# Useful if you want kids to use the interface and don't want the complexity
# of classes. It also allows us to hide some of the more complex functions
# and provide simpler documentation strings

instance = SL030()

def tagIsPresent():
  """Check if there is a tag present or not"""
  return instance.tagIsPresent()

def waitTag():
  """Wait until a tag is present"""
  instance.waitTag()

def waitNoTag():
  """Wait until there is no longer a tag present"""
  instance.waitNoTag()

def readMifare():
  """Try to read this as a mifare tag. Returns False if not a mifare"""
  return instance.readMifare()

def getUID():
  """Get the unique ID number of the card"""
  return instance.getUID()

def getUniqueId():
  """Get the unique ID number of the card as a printable string"""
  return instance.getUniqueId()

def getType():
  """Get the type number of the card"""
  return instance.getType()

def getTypeName():
  """Get a string representing the name of the type of card in use"""
  return typename(instance.getType())

# END
