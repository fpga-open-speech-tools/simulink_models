def WriteDeviceAttributes(inputParams):
    functionString = "/*************************************************\n"
    functionString += "Generated in WriteDeviceAttributes\n"
    functionString += "*************************************************/\n"
    for i in range(len(inputParams.deviceAttributes)):
        functionString += ("DEVICE_ATTR(" + inputParams.deviceAttributes[i] + ", " + inputParams.attributePerms[i]
                           + ", " + inputParams.deviceAttributes[i] + "_read, " + inputParams.deviceAttributes[i]
                           + "_write);\n")
    functionString += "DEVICE_ATTR(name, 0444, name_read, NULL);\n"
    functionString += "/* End WriteDeviceAttributes */\n\n\n"
    return functionString