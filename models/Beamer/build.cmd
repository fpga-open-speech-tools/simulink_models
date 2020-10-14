python ../../../simulink_codegen/autogen_quartus.py -c model.json -w Nest/ing/quartus/ -l 

python ../../../simulink_codegen/device_tree_overlays/generate.py -s Nest/ing/quartus/reflex_system.sopcinfo -d aes_reflex -o Nest/ing

wsl.exe dtc -@ -O dtb -o Nest/ing/aes_reflex.dtbo Nest/ing/aes_reflex.dts