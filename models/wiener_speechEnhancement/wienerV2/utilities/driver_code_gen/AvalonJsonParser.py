from InputStructureFile import InputStructure
import json
def AvalonJsonParse(jsonFileName):
    file = open(jsonFileName, "r")
    fileStr = file.read()
    jsonDict = json.loads(fileStr)
    inputStruct = InputStructure()

    inputStruct.deviceName = jsonDict['linux_device_name']
    inputStruct.deviceType = 2
    inputStruct.deviceNameAbbrev = jsonDict['model_abbreviation']
    inputStruct.compatibleFlag = 'dev,fe-' + inputStruct.deviceName
    attributes = jsonDict['avalon_memorymapped']['register']
    inputStruct.deviceAttributes = []
    inputStruct.attributePerms = []
    inputStruct.attributeWriteIsNormal = []
    inputStruct.attributeReadIsNormal = []
    inputStruct.attributeWriteOffsets = []
    inputStruct.attributeDataTypes = []
    for attr in attributes:
        inputStruct.deviceAttributes.append(attr['name'])
        inputStruct.attributeDataTypes.append(attr['data_type'])
        inputStruct.attributePerms.append('0664')
        inputStruct.attributeWriteIsNormal.append(True)
        inputStruct.attributeReadIsNormal.append(True)
        inputStruct.attributeWriteOffsets.append([str(attr['reg_num'])])
    return inputStruct
