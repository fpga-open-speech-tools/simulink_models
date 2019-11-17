def CreateFileHeaderInfo(inputParams):
    functionString = "/*********************************************************************\n"
    functionString += "Generated in CreateFileHeaderInfo \n"
    functionString += "*********************************************************************/\n"
    functionString += "#include <linux/module.h>\n"
    functionString += "#include <linux/platform_device.h>\n"
    functionString += "#include <linux/io.h>\n"
    functionString += "#include <linux/fs.h>\n"
    functionString += "#include <linux/types.h>\n"
    functionString += "#include <linux/uaccess.h>\n"
    functionString += "#include <linux/init.h>\n"
    functionString += "#include <linux/cdev.h>\n"
    functionString += "#include <linux/regmap.h>\n"
    if inputParams.deviceType == 0: # SPI Device, fpga needs struct of_device_id from here
        functionString += "#include <linux/spi/spi.h>\n"
    elif inputParams.deviceType == 1: # I2C Device
        functionString += "#include <linux/i2c.h>\n"
    elif inputParams.deviceType == 2:
        functionString += "#include <linux/of.h>\n"
    functionString += "#include \"custom_functions.h\"\n"
    functionString += "\nMODULE_LICENSE(\"GPL\");\n"
    functionString += "MODULE_AUTHOR(\"Tyler Davis <support@flatearthinc.com\");\n"
    functionString += "MODULE_DESCRIPTION(\"Loadable kernel module for the " + inputParams.deviceName + "\");\n"
    functionString += "MODULE_VERSION(\"1.0\");\n"
    functionString += "/* End CreateFileHeaderInfo */\n\n\n"
    return functionString
