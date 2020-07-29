function createModelJson(modelName)
%CREATEMODELJSON Summary of this function goes here
%   Detailed explanation goes here
    autogenDir = erase(mfilename('fullpath'), mfilename); 
    configPath = autogenDir + "defaultModel.json";
    config =  jsondecode(fileread(configPath));
    config.devices(1).name = char(modelName);
    writejson(config, "model.json")
end

