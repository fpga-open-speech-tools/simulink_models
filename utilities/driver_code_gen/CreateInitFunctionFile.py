from InputStructureFile import InputStructure


def CreateInitFunction(inputParams):
    if not isinstance(inputParams, InputStructure):
        print("inputParams must be an InputStructure object")
    return CreateInitFunctionHelper(inputParams)


def CreateInitFunctionHelper(inputParams):
    functionString = "/*********************************************************\n"
    functionString += "Generated in CreateInitFunction\n"
    functionString += "*********************************************************/\n"
    functionString += "static int " + inputParams.deviceName + "_init(void) {\n"
    functionString += "  printk(KERN_ALERT \"FUNCTION AUTO GENERATED AT: " + inputParams.currTime + "\\n\");\n"
    functionString += "  int ret_val = 0;\n"
    if inputParams.deviceType == 0:    # SPI device
        functionString += CreateInitFunctionSPI(inputParams)
    elif inputParams.deviceType == 1:  # I2C device
        functionString += CreateInitFunctionI2C(inputParams)
    elif inputParams.deviceType == 2:  # FPGA
        functionString += CreateInitFunctionFPGA(inputParams)
    else:
        print("FAILURE, device type not recognized")
        return "\nINIT NOT CREATED\n\n"
    functionString += "/* End CreateInitFunction */\n\n"
    return functionString


def CreateInitFunctionSPI(inputParams):
    functionString = "  // Add the spi master\n"
    functionString += "  struct spi_master *master;\n"
    functionString += "  pr_info(\"Initializing the Flat Earth " + inputParams.deviceName + " module\\n\");\n"
    functionString += "  // Register our driver with the \"Platform Driver\" bus\n"
    functionString += "  ret_val = platform_driver_register(&" + inputParams.deviceName + "_platform);\n"
    functionString += "  if (ret_val != 0) {\n"
    functionString += "    pr_err(\"platform_driver_register returned %d\\n\", ret_val);\n"
    functionString += "    return ret_val;\n"
    functionString += "  }\n"
    functionString += "  // Register the device\n"
    functionString += "  struct spi_board_info spi_device_info = {\n"
    functionString += "    .modalias = \"fe_" + inputParams.deviceName + "_\",\n"
    functionString += "    .max_speed_hz = " + inputParams.speed + ",\n"
    functionString += "    .bus_num = 0,\n"
    functionString += "    .chip_select = " + inputParams.chipSelect + ",\n"
    functionString += "    .mode = " + inputParams.mode + ",\n"
    functionString += "  };\n"
    functionString += "  /* To send data we have to know what spi port/pins should be used. This information\n"
    functionString += "  can be found in the device-tree. */\n"
    functionString += "  master = spi_busnum_to_master( spi_device_info.bus_num );\n"
    functionString += "  if( !master ) {\n"
    functionString += "    printk(\"MASTER not found.\\n\");\n"
    functionString += "    return -ENODEV;\n"
    functionString += "  }\n"
    functionString += "  // ceate a new slave device, given the master and device info\n"
    functionString += "  spi_device = spi_new_device(master, &spi_device_info);\n"
    functionString += "  printk(\"Setting up new slave device\\n\");\n"
    functionString += "  if (!spi_device) {\n"
    functionString += "    printk(\"FAILED to create slave.\\n\");\n"
    functionString += "    return -ENODEV;\n"
    functionString += "  }\n"
    functionString += "  printk(\"Set the bits per word\\n\");\n"
    functionString += "  spi_device->bits_per_word = bits;\n"
    functionString += "  printk(\"Setting up the device\\n\");\n"
    functionString += "  ret_val = spi_setup(spi_device);\n"
    functionString += "  if (ret_val) {\n"
    functionString += "    printk(\"FAILED to setup slave.\\n\");\n"
    functionString += "    spi_unregister_device(spi_device);\n"
    functionString += "    return -ENODEV;\n"
    functionString += "  }\n"
    functionString += "  printk(\"Sending SPI initialization commands...\\n\");\n"
    functionString += "  // Sending init commands\n"
    functionString += WriteInitCommands(inputParams)
    functionString += "  /********************************************************/\n"
    functionString += "  pr_info(\"Flat Earth " + inputParams.deviceName + " module successfully initialized!\\n\");\n"
    functionString += "  return 0;\n"
    functionString += "}\n"
    return functionString


def CreateInitFunctionI2C(inputParams):
    functionString = "  struct i2c_adapter *i2c_adapt;\n"
    functionString += "  struct i2c_board_info i2c_info;\n"
    functionString += "  pr_info(\"Initializing the Flat Earth " + inputParams.deviceName + " module\\n\");\n"
    functionString += "  // Register our driver with the \"Platform Driver\" bus\n"
    functionString += "  ret_val = platform_driver_register(&" + inputParams.deviceName + "_platform);\n"
    functionString += "  if (ret_val != 0) {\n"
    functionString += "    pr_err(\"platform_driver_register returned %d\\n\", ret_val);\n"
    functionString += "    return ret_val;\n"
    functionString += "  }\n"
    functionString += "  /*-------------------------------------------------------\n"
    functionString += "     I2C communication\n"
    functionString += "  --------------------------------------------------------*/\n"
    functionString += "  // Register the device\n"
    functionString += "  ret_val = i2c_add_driver(&" + inputParams.deviceNameAbbrev + "_i2c_driver);\n"
    functionString += "  if (ret_val < 0) {\n"
    functionString += "    pr_err(\"Failed to register I2C driver\");\n"
    functionString += "    return ret_val;\n"
    functionString += "  }\n"
    functionString += "  i2c_adapt = i2c_get_adapter(0);\n"
    functionString += "  memset(&i2c_info,0,sizeof(struct i2c_board_info));\n"
    functionString += "  strlcpy(i2c_info.type, \"" + inputParams.deviceNameAbbrev + "_i2c\",I2C_NAME_SIZE);\n"
    functionString += "  " + inputParams.deviceNameAbbrev + "_i2c_client = i2c_new_device(i2c_adapt,&" + inputParams.deviceNameAbbrev + "_i2c_info);\n"
    functionString += "  i2c_put_adapter(i2c_adapt);\n"
    functionString += "  if (!" + inputParams.deviceNameAbbrev + "_i2c_client) {\n"
    functionString += "    pr_err(\"Failed to connect to I2C client\\n\");\n"
    functionString += "    ret_val = -ENODEV;\n"
    functionString += "    return ret_val;\n"
    functionString += "  }\n"
    functionString += "  // Send some initialization commands\n"
    functionString += WriteInitCommands(inputParams)
    functionString += "  /**************************************************************************/\n"
    functionString += "  pr_info(\"Flat Earth " + inputParams.deviceName + " module successfully initialized!\\n\");\n"
    functionString += "  return 0;\n"
    functionString += "}\n"
    return functionString


def CreateInitFunctionFPGA(inputParams):
    functionString = "  pr_info(\"Initializing the Flat Earth " + inputParams.deviceName + " module\\n\");\n"
    functionString += "  // Register our driver with the \"Platform Driver\" bus\n"
    functionString += "  ret_val = platform_driver_register(&" + inputParams.deviceName + "_platform);"
    functionString += "  if (ret_val != 0) {\n"
    functionString += "    pr_err(\"platform_driver_register returned %d\\n\", ret_val);\n"
    functionString += "    return ret_val;\n"
    functionString += "  }\n"
    functionString += "  pr_info(\"Flat Earth " + inputParams.deviceName + " module successfully initialized!\\n\");\n"
    functionString += "  return 0;\n"
    functionString += "}\n"
    return functionString


def WriteInitCommands(inputParams):
    functionString = ""
    if inputParams.initCommLen > 0:
        functionString += "  char cmd[" + str(inputParams.initCommBytes) + "];\n"
    for i in range(inputParams.initCommLen):
        try:
            functionString += "  // desc: " + inputParams.initCommDesc[i] + "\n"
        except:
            functionString += "  // no command description\n"
        for j in range(inputParams.initCommBytes):
            functionString += "  cmd[" + str(j) + "] = " + inputParams.initComm[i][j] + ";"
        functionString += "\n"
        functionString += "  ret_val = " + inputParams.initCommSendFunc + "(" + inputParams.initCommSendParams + ");\n\n"
    return functionString
