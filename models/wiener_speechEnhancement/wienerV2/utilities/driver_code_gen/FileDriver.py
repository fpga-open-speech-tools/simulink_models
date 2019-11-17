from FileOutput import WriteDriver
from InputStructureFile import InputStructure
from ExampleInputStructs import AD1939inputStruct
from ExampleInputStructs import TPAinputStruct
from ExampleInputStructs import HAinputStruct
from CreateCustomFunctions import CreateCustomFunctions


WriteDriver("ADfile.c", AD1939inputStruct, overwrite=True)
WriteDriver("TPAfile.c", TPAinputStruct, overwrite=True)
WriteDriver("HAfile.c", HAinputStruct, overwrite=True)
