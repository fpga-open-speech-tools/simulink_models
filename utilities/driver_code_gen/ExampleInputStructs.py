from InputStructureFile import InputStructure

AD1939inputStruct = InputStructure()
AD1939inputStruct.deviceName = "AD1939"
AD1939inputStruct.deviceNameAbbrev = "ad1939"
AD1939inputStruct.deviceType = 0
AD1939inputStruct.speed = "500000"
AD1939inputStruct.chipSelect = "0"
AD1939inputStruct.mode = "3"
AD1939inputStruct.initComm = [["0x08", "0x00", "0x80"], ["0x08", "0x01", "0x00"], ["0x08", "0x10", "0xC8"], ["0x08", "0x02", "0x00"], ["0x08", "14", "0x00"]]
AD1939inputStruct.initCommBytes = 3
AD1939inputStruct.initCommLen = 5
AD1939inputStruct.initCommSendFunc = "spi_write"
AD1939inputStruct.initCommSendParams = "spi_device,&cmd, sizeof(cmd)"
AD1939inputStruct.deviceAttributes = ["sample_frequency", "dac1_left_volume", "dac1_right_volume",
    "dac2_left_volume", "dac2_right_volume", "dac3_left_volume", "dac3_right_volume", "dac4_left_volume", "dac4_right_volume"]
AD1939inputStruct.attributePerms = ["0664", "0664", "0664", "0664", "0664", "0664", "0664", "0664", "0664"]
AD1939inputStruct.compatibleFlag = "dev,fe-ad1939"
AD1939inputStruct.volumeLevelParams = "uint32_t fp28_num"
AD1939inputStruct.attributeReadIsNormal = [True] + [True] * (len(AD1939inputStruct.deviceAttributes) - 1)
AD1939inputStruct.attributeWriteIsNormal = [False] + [True] * (len(AD1939inputStruct.deviceAttributes) - 1)
AD1939inputStruct.attrWriteCommBytes = 3
AD1939inputStruct.attrWriteComm = [["0x08", "0x06", "0x00"], ["0x08", "0x06", "0x00"], ["0x08", "0x07", "0x00"],
                                   ["0x08", "0x08", "0x00"], ["0x08", "0x09", "0x00"], ["0x08", "0x0A", "0x00"],
                                   ["0x08", "0x0B", "0x00"], ["0x08", "0x0C", "0x00"], ["0x08", "0x0D", "0x00"], ]
print(AD1939inputStruct.attributeReadIsNormal)


TPAinputStruct = InputStructure()
TPAinputStruct.deviceName = "TPA6130A2"
TPAinputStruct.deviceNameAbbrev = "tpa"
TPAinputStruct.deviceType = 1
TPAinputStruct.initComm = [["0x01", "0xc0"], ["0x02", "0x34"]]
TPAinputStruct.initCommBytes = 2
TPAinputStruct.initCommLen = 2
TPAinputStruct.initCommSendFunc = "i2c_master_send"
TPAinputStruct.initCommSendParams = "tpa_i2c_client,&cmd[0],sizeof(cmd)/sizeof(cmd[0])"
TPAinputStruct.deviceAttributes = ["volume"]
TPAinputStruct.attributePerms = ["0664"]
TPAinputStruct.compatibleFlag = "dev,fe-tpa613a2"
TPAinputStruct.volumeLevelParams = "uint32_t fp28_num, uint8_t pn"
TPAinputStruct.deviceID = "0x60"
TPAinputStruct.attributeReadIsNormal = [True]
TPAinputStruct.attributeWriteIsNormal = [True]
TPAinputStruct.attrWriteCommBytes = 2
TPAinputStruct.attrWriteComm = [["0x02", "0x00"]]



HAinputStruct = InputStructure()
HAinputStruct.deviceName = "HA"
HAinputStruct.deviceType = 2
HAinputStruct.deviceAttributes = ["gain_all_left",  "band1_left",  "band2_left",  "band3_left",  "band4_left",
                                  "gain_all_right", "band1_right", "band2_right", "band3_right", "band4_right"]
HAinputStruct.attributePerms = ["0664", "0664", "0664", "0664", "0664", "0664", "0664", "0664", "0664", "0664", "0664", "0664",]
HAinputStruct.definedDataConstants = [["BAND_ALL_OFFSET", "0x00"], ["BAND1_OFFSET", "0x01"], ["BAND2_OFFSET", "0x02"],
                                      ["BAND3_OFFSET", "0x03"], ["BAND4_OFFSET", "0x04"], ["LEFT_OFFSET", "0x00"],
                                      ["RIGHT_OFFSET", "0x08"], ["GAIN_OFFSET", "0"]]
HAinputStruct.compatibleFlag = "dev,fe-Simple-HAv8"
HAinputStruct.attributeReadIsNormal = [True] * len(HAinputStruct.deviceAttributes)
HAinputStruct.attributeWriteIsNormal = [True] * len(HAinputStruct.deviceAttributes)
HAinputStruct.attributeWriteOffsets = [ ["BAND_ALL_OFFSET", "GAIN_OFFSET", "LEFT_OFFSET"], ["BAND1_OFFSET", "GAIN_OFFSET", "LEFT_OFFSET"],
                                      ["BAND1_OFFSET", "GAIN_OFFSET", "LEFT_OFFSET"], ["BAND2_OFFSET", "GAIN_OFFSET", "LEFT_OFFSET"],
["BAND3_OFFSET", "GAIN_OFFSET", "LEFT_OFFSET"], ["BAND4_OFFSET", "GAIN_OFFSET", "LEFT_OFFSET"], ["BAND1_OFFSET", "GAIN_OFFSET", "RIGHT_OFFSET"],
["BAND2_OFFSET", "GAIN_OFFSET", "RIGHT_OFFSET"], ["BAND3_OFFSET", "GAIN_OFFSET", "RIGHT_OFFSET"], ["BAND4_OFFSET", "GAIN_OFFSET", "RIGHT_OFFSET"],
]

TPAinputStruct.PN_INDEX = 54
TPAinputStruct.needsVolumeTable = True
TPAinputStruct.volumeTable = [
  [1000, "0xFF"],
  [595, "0x00"],
  [535, "0x01"],
  [500, "0x02"],
  [475, "0x03"],
  [455, "0x04"],
  [439, "0x05"],
  [414, "0x06"],
  [395, "0x07"],
  [365, "0x08"],
  [353, "0x09"],
  [333, "0x0A"],
  [317, "0x0B"],
  [304, "0x0C"],
  [286, "0x0D"],
  [271, "0x0E"],
  [263, "0x0F"],
  [247, "0x10"],
  [237, "0x11"],
  [225, "0x12"],
  [217, "0x13"],
  [205, "0x14"],
  [196, "0x15"],
  [188, "0x16"],
  [178, "0x17"],
  [170, "0x18"],
  [162, "0x19"],
  [152, "0x1A"],
  [145, "0x1B"],
  [137, "0x1C"],
  [130, "0x1D"],
  [123, "0x1E"],
  [116, "0x1F"],
  [109, "0x20"],
  [103, "0x21"],
  [97, "0x22"],
  [90, "0x23"],
  [85, "0x24"],
  [78, "0x25"],
  [72, "0x26"],
  [67, "0x27"],
  [61, "0x28"],
  [56, "0x29"],
  [51, "0x2A"],
  [45, "0x2B"],
  [41, "0x2C"],
  [35, "0x2D"],
  [31, "0x1E"],
  [26, "0x1F"],
  [21, "0x30"],
  [17, "0x31"],
  [12, "0x32"],
  [8, "0x33"],
  [3, "0x34"],
  [1, "0x35"],
  [5, "0x36"],
  [9, "0x37"],
  [14, "0x38"],
  [17, "0x39"],
  [21, "0x3A"],
  [25, "0x3B"],
  [29, "0x3C"],
  [33, "0x3D"],
  [36, "0x3E"],
  [40, "0x3F"] ]
