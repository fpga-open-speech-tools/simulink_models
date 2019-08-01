from FileOutput import WriteDriver
from AvalonJsonParser import AvalonJsonParse


def JsonToDriver(inFileName, outFileName):
  inputStructure = AvalonJsonParse(inFileName)
  WriteDriver(outFileName, inputStructure, True)
