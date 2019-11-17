def CreateMiscTopOfFile(inputParams):
    functionString = "/***********************************************\n"
    functionString += "  Generated in CreateMiscTopOfFile\n"
    functionString += "***********************************************/\n"
    functionString += "struct fixed_num {\n"
    functionString += "  int integer;\n"
    functionString += "  int fraction;\n"
    functionString += "  int fraction_len;\n"
    functionString += "};\n"
    functionString += "static struct class *cl;  // Global variable for the device class\n"
    functionString += "static dev_t dev_num;\n\n"
    functionString += "/*********** Device type specific things **************/\n"
    if inputParams.deviceType == 0:   # SPI Device
        functionString = TopOfFileSPIStuff(inputParams, functionString)
    elif inputParams.deviceType == 1: # I2C Device
        functionString = TopOfFileI2CStuff(inputParams, functionString)
    elif inputParams.deviceType == 2: # FPGA Device
        functionString = TopOfFileFPGAStuff(inputParams, functionString)
    else:
        print("NOT A SPI I2C OR FPGA DEVICE?")
        return ""
    if inputParams.needsVolumeTable:
        functionString += "\n/* Volume table */\n"
        functionString = WriteVolumeTable(inputParams, functionString)
    functionString += "/* End of CreateMiscTopOfFile */\n\n\n"
    return functionString


def TopOfFileSPIStuff(inputParams, functionString):
    functionString += "// Define some SPI stuff\n"
    functionString += "static uint8_t bits = 8;\n"
    functionString += "static uint32_t speed = " + inputParams.speed + ";\n"
    functionString += "static struct spi_device *spi_device;\n"
    return functionString


def TopOfFileI2CStuff(inputParams, functionString):
    functionString += "// Define some I2C stuff\n"
    functionString += "struct i2c_driver " + inputParams.deviceNameAbbrev + "_i2c_driver;\n"
    functionString += "struct i2c_client * " + inputParams.deviceNameAbbrev + "_i2c_client;\n"
    functionString += "static const unsigned short normal_i2c[] = {0x35, I2C_CLIENT_END}; // remove? -Tyler\n"
    return functionString


def TopOfFileFPGAStuff(inputParams, functionString):
    try: # to lookup the pound defined constants from the input params, otherwise use what the HAv8 used and hope that works
        for i in range(len(inputParams.definedDataConstants)):
            functionString += "#define " + inputParams.definedDataConstants[i][0] + " " + str(inputParams.definedDataConstants[i][1]) + "\n"
    except:
        # These are almost certainly not universal. Should pull these from the params probably
        functionString += "//TODO: check this. Register memory map. Was not pulled from input params, might want to verify this\n"
        functionString += "#define BAND_ALL_OFFSET 0x00\n"
        functionString += "#define BAND1_OFFSET 0x01\n"
        functionString += "#define BAND2_OFFSET 0x02\n"
        functionString += "#define BAND3_OFFSET 0x03\n"
        functionString += "#define BAND4_OFFSET 0x04\n"
        functionString += "#define LEFT_OFFSET 0x00\n"
        functionString += "#define RIGHT_OFFSET 0x08\n"
        functionString += "#define GAIN_OFFSET 0\n"
    return functionString


def WriteVolumeTable(inputParams, functionString):
    functionString += "typedef struct {\n"
    functionString += "  uint16_t value;\n"
    functionString += "  uint8_t  code;\n"
    functionString += "} volumeLevel;\n\n"
    try:
        functionString += "#define PN_INDEX " + str(inputParams.PN_INDEX) + "\n"
    except:
        functionString += "// No PN_INDEX specified in input params\n"
    functionString += "static volumeLevel VolumeLevels[] = {\n"
    for i in range(len(inputParams.volumeTable)):
        functionString += "  {.value = " + str(inputParams.volumeTable[i][0]) + ", .code = " + str(inputParams.volumeTable[i][1]) + "},\n"
    functionString += "};\n"
    return functionString