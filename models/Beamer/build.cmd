python ../../../simulink_codegen/autogen_quartus.py -c model.json -w hdlsrc/Beamer/quartus/ -l 

python ../../../simulink_codegen/device_tree_overlays/generate.py -s hdlsrc/Beamer/quartus/reflex_system.sopcinfo -d aes_reflex -o hdlsrc/Beamer

wsl.exe dtc -@ -O dtb -o hdlsrc/Beamer/aes_reflex.dtbo hdlsrc/Beamer/aes_reflex.dts