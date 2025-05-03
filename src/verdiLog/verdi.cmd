verdiSetActWin -win $_OneSearch
simSetSimulator "-vcssv" -exec "/home/aseel/haraka-s-hdl/src/simv" -args
debImport "-dbdir" "/home/aseel/haraka-s-hdl/src/simv.daidir"
debLoadSimResult /home/aseel/haraka-s-hdl/src/simv.fsdb
wvCreateWindow
verdiSetActWin -dock widgetDock_MTB_SOURCE_TAB_1
wvGetSignalOpen -win $_nWave2
wvGetSignalSetScope -win $_nWave2 "/top"
verdiSetActWin -win $_nWave2
wvGetSignalSetScope -win $_nWave2 "/top/harka_s/deserializer"
wvSetPosition -win $_nWave2 {("G1" 11)}
wvSetPosition -win $_nWave2 {("G1" 11)}
wvAddSignal -win $_nWave2 -clear
wvAddSignal -win $_nWave2 -group {"G1" \
{/top/harka_s/deserializer/clear} \
{/top/harka_s/deserializer/clk} \
{/top/harka_s/deserializer/counter\[4:0\]} \
{/top/harka_s/deserializer/out\[255:0\]} \
{/top/harka_s/deserializer/outclk} \
{/top/harka_s/deserializer/output_ready} \
{/top/harka_s/deserializer/pad_counter\[1:0\]} \
{/top/harka_s/deserializer/process_input} \
{/top/harka_s/deserializer/serial_in\[7:0\]} \
{/top/harka_s/deserializer/start_squeeze} \
{/top/harka_s/deserializer/temp\[255:0\]} \
}
wvAddSignal -win $_nWave2 -group {"G2" \
}
wvSelectSignal -win $_nWave2 {( "G1" 1 2 3 4 5 6 7 8 9 10 11 )} 
wvSetPosition -win $_nWave2 {("G1" 11)}
wvSetPosition -win $_nWave2 {("G1" 11)}
wvSetPosition -win $_nWave2 {("G1" 11)}
wvAddSignal -win $_nWave2 -clear
wvAddSignal -win $_nWave2 -group {"G1" \
{/top/harka_s/deserializer/clear} \
{/top/harka_s/deserializer/clk} \
{/top/harka_s/deserializer/counter\[4:0\]} \
{/top/harka_s/deserializer/out\[255:0\]} \
{/top/harka_s/deserializer/outclk} \
{/top/harka_s/deserializer/output_ready} \
{/top/harka_s/deserializer/pad_counter\[1:0\]} \
{/top/harka_s/deserializer/process_input} \
{/top/harka_s/deserializer/serial_in\[7:0\]} \
{/top/harka_s/deserializer/start_squeeze} \
{/top/harka_s/deserializer/temp\[255:0\]} \
}
wvAddSignal -win $_nWave2 -group {"G2" \
}
wvSelectSignal -win $_nWave2 {( "G1" 1 2 3 4 5 6 7 8 9 10 11 )} 
wvSetPosition -win $_nWave2 {("G1" 11)}
wvGetSignalClose -win $_nWave2
verdiWindowBeWindow -win $_nWave2
wvResizeWindow -win $_nWave2 -10 20 1920 977
wvZoomAll -win $_nWave2
wvResizeWindow -win $_nWave2 -10 20 1920 977
verdiSetActWin -dock widgetDock_MTB_SOURCE_TAB_1
verdiSetActWin -win $_nWave2
wvCut -win $_nWave2
wvSetPosition -win $_nWave2 {("G1" 0)}
wvGetSignalOpen -win $_nWave2
wvGetSignalSetScope -win $_nWave2 "/top"
wvGetSignalSetScope -win $_nWave2 "/top/harka_s"
wvGetSignalSetScope -win $_nWave2 "/top/harka_s/deserializer"
wvGetSignalSetScope -win $_nWave2 "/top/harka_s"
wvGetSignalSetScope -win $_nWave2 "/top"
wvSetPosition -win $_nWave2 {("G1" 7)}
wvSetPosition -win $_nWave2 {("G1" 7)}
wvAddSignal -win $_nWave2 -clear
wvAddSignal -win $_nWave2 -group {"G1" \
{/top/clk} \
{/top/digest_length\[63:0\]} \
{/top/enable} \
{/top/out\[7:0\]} \
{/top/process_input} \
{/top/reset} \
{/top/serial_in\[7:0\]} \
}
wvAddSignal -win $_nWave2 -group {"G2" \
}
wvSelectSignal -win $_nWave2 {( "G1" 1 2 3 4 5 6 7 )} 
wvSetPosition -win $_nWave2 {("G1" 7)}
wvSetPosition -win $_nWave2 {("G1" 7)}
wvSetPosition -win $_nWave2 {("G1" 7)}
wvAddSignal -win $_nWave2 -clear
wvAddSignal -win $_nWave2 -group {"G1" \
{/top/clk} \
{/top/digest_length\[63:0\]} \
{/top/enable} \
{/top/out\[7:0\]} \
{/top/process_input} \
{/top/reset} \
{/top/serial_in\[7:0\]} \
}
wvAddSignal -win $_nWave2 -group {"G2" \
}
wvSelectSignal -win $_nWave2 {( "G1" 1 2 3 4 5 6 7 )} 
wvSetPosition -win $_nWave2 {("G1" 7)}
wvGetSignalClose -win $_nWave2
wvSelectSignal -win $_nWave2 {( "G1" 4 )} 
wvGetSignalOpen -win $_nWave2
wvGetSignalSetScope -win $_nWave2 "/top"
wvGetSignalSetScope -win $_nWave2 "/top/harka_s"
wvGetSignalSetScope -win $_nWave2 "/top/harka_s/deserializer"
wvGetSignalSetScope -win $_nWave2 "/top"
wvZoomAll -win $_nWave2
wvZoomAll -win $_nWave2
wvSetCursor -win $_nWave2 462.695030 -snap {("G1" 4)}
wvSetCursor -win $_nWave2 358.154378 -snap {("G1" 4)}
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvTpfCloseForm -win $_nWave2
wvGetSignalClose -win $_nWave2
wvCloseWindow -win $_nWave2
verdiSetActWin -dock widgetDock_MTB_SOURCE_TAB_1
