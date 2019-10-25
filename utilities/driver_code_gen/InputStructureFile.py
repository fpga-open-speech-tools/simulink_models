class InputStructure:
    def __init__(self):

        # device specifications
        self.deviceName = None
        self.deviceType = None  # 0 for spi, 1 for i2c, 2 for memory mapped device
        self.deviceNameAbbrev = None  # some vars only have an abbrev of the device name, i.e. tpa instead of TPA6130A2
        self.compatibleFlag = None  # something like "dev,fe-AD1939" gets inserted into .compatible
        self.deviceID = None  # An address(?), only used i think for i2c

        # device attribute specifications
        self.deviceAttributes = None  # list of string attributes
        self.attributeDataTypes = None  # list of string data types
        self.attributePerms = None  # attribute permissions, list of "0446" or whatever the desired permission is
        #                             for the attribute at the same index
        self.attributeReadIsNormal = None  # is a list of bool vals that informs whether to insert a stub or definition
        self.attributeWriteIsNormal = None  # same as above but for writes
        self.attrWriteCommBytes = None  # number of bytes in a command. Should be same as len(self.attrWritComm[0])
        self.attrWriteComm = None  # of the form [ ["0xNN", "0xNN", ..] ..] for however many bytes a command contains,
        #                            and however many attributes there are. They are matched according to index
        self.attributeWriteOffsets = None  # used for fpga's only i think. should be of the form [ [ "OFFSET_N", "OFFSET_N" ..] ..]
        #                            for each attribute it should be the defined constants which are added to devp->regs

        # initial command information
        self.initComm = None  # initial commands that get run in init. 2d list [ ["0xNN", "0xNN", ..] ..]
        self.initCommBytes = None  # number of bytes in a initialization command. Should be same as len(initComm[0])
        self.initCommLen = None  # number of initialization commands. Should be same as len(initComm)
        self.initCommSendFunc = None  # function that sends each command, spi_master_write, for instance
        self.initCommSendParams = None  # parameters that should be inserted for the commSendFunc. ie "dev,cmd,sizeof(cmd)"

        # top of file stuff
        self.needsVolumeTable = None  # true if the device needs a volume table
        self.volumeTable = None  # should be filled in with [ [ <val>, "0xNN"] .. ] in decreasing order of val
        self.PN_INDEX = None  # index where the val goes from positive to negative

        # stuff
        self.speed = 500000  # not even sure what this is
        self.mode = None  # rising edge or whatever
        self.chipSelect = None  # not even sure what this is either


        # min and max for each attribute
        # look for data type var