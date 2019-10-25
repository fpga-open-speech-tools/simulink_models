def CreateRemoveFunction(inputParams):
    functionString =  "/******************************************************\n"
    functionString += "Generated in CreateRemoveFunction\n"
    functionString += "*******************************************************/\n"
    functionString += "static int " + inputParams.deviceName + "_remove(struct platform_device *pdev) {\n"
    functionString += "  fe_" + inputParams.deviceName + "_dev_t *dev = (fe_" + inputParams.deviceName + "_dev_t *)platform_get_drvdata(pdev);\n"
    functionString += "  pr_info(\"" + inputParams.deviceName + "_remove enter\\n\");\n"
    functionString += "  cdev_del(&dev->cdev);\n"
    functionString += "  unregister_chrdev_region(dev_num, 2);\n"
    if inputParams.deviceType == 2:  # FPGA device
        functionString += "  iounmap(dev->regs);\n"
    functionString += "  pr_info(\"" + inputParams.deviceName + "_remove exit\\n\");\n"
    functionString += "  return 0;\n"
    functionString += "}\n"
    functionString += "/* End CreateRemoveFunction */\n\n\n"
    return functionString