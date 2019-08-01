def CreateFunctionPrototypes(inputParams):
    functionString = "/*****************************************************\n"
    functionString += "Generate in CreateFunctionPrototypes\n"
    functionString += "*****************************************************/\n"
    devName = inputParams.deviceName
    functionString += "static int " + devName + "_probe(struct platform_device *pdev);\n"
    functionString += "static int " + devName + "_remove(struct platform_device *pdev);\n"
    functionString += "static ssize_t " + devName + "_read(struct file *file, char *buffer, size_t len, loff_t *offset);\n"
    functionString += "static ssize_t " + devName + "_write(struct file *file, const char *buffer, size_t len, loff_t *offset);\n"
    functionString += "static int " + devName + "_open(struct inode *inode, struct file *file);\n"
    functionString += "static int " + devName + "_release(struct inode *inode, struct file *file);\n"
    functionString += "static ssize_t name_read(struct device *dev, struct device_attribute *attr, char *buf);\n\n"
    functionString += "/************** Generate device specific prototypes ********************/\n"
    if inputParams.deviceType == 0:    # SPI device
        functionString += CreateSPIAttributePrototypes(inputParams)
    elif inputParams.deviceType == 1:  # I2c device
        functionString += CreateI2CAttributePrototypes(inputParams)
    elif inputParams.deviceType == 2:  # fpga device
        functionString += CreateFPGAAttributePrototypes(inputParams)
    functionString += "\n/* Custom function declarations */\n"
    if not inputParams.deviceType == 2:
        functionString += "uint8_t find_volume_level(" + inputParams.volumeLevelParams + ");\n"
        functionString += "uint32_t decode_volume(uint8_t code);\n"
    functionString += "/* End CreateFunctionPrototypes */\n\n\n"
    return functionString


def CreateSPIAttributePrototypes(inputParams):
    functionString = "// SPI Device funcs\n"
    for i in range(len(inputParams.deviceAttributes)):
        functionString += "static ssize_t " + inputParams.deviceAttributes[i] + \
                          "_write (struct device *dev, struct device_attribute *attr, const char *buf, size_t count);\n"
        functionString += "static ssize_t " + inputParams.deviceAttributes[i] + \
                          "_read  (struct device *dev, struct device_attribute *attr, char *buf);\n"
    return functionString


def CreateI2CAttributePrototypes(inputParams):
    functionString = "// I2C Device funcs\n"
    for i in range(len(inputParams.deviceAttributes)):
        functionString += "static ssize_t " + inputParams.deviceAttributes[i] + \
                          "_write (struct device *dev, struct device_attribute *attr, const char *buf, size_t count);\n"
        functionString += "static ssize_t " + inputParams.deviceAttributes[i] + \
                          "_read  (struct device *dev, struct device_attribute *attr, char *buf);\n"
    return functionString


# in the HAv8 driver these are named attr_show_left/right. im assuming every attr has both a left and a right
def CreateFPGAAttributePrototypes(inputParams):
    functionString = "// FPGA device funcs\n"
    for i in range(len(inputParams.deviceAttributes)):
        functionString += "static ssize_t " + inputParams.deviceAttributes[i] + \
                          "_write (struct device *dev, struct device_attribute *attr, const char *buf, size_t count);\n"
        functionString += "static ssize_t " + inputParams.deviceAttributes[i] + \
                          "_read  (struct device *dev, struct device_attribute *attr, char *buf);\n"
    return functionString