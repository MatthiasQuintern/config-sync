
pactl load-module module-null-sink sink_name=VirtualOut
pacmd update-sink-proplist VirtualOut device.description=VirtualOut
pacmd update-source-proplist VirtualOut.monitor device.description="VirtualOut-Monitor"

pactl load-module module-null-sink sink_name=VirtualIn
pacmd update-sink-proplist VirtualIn device.description=VirtualIn
pacmd update-source-proplist VirtualIn.monitor device.description="VirtualIn-Monitor"

pactl load-module module-loopback source=VirtualIn.monitor sink=VirtualOut
pactl load-module module-loopback source=VirtualIn.monitor sink=alsa_output.pci-0000_2d_00.4.analog-stereo
pactl load-module module-loopback source=alsa_input.pci-0000_2d_00.4.analog-stereo sink=VirtualOut

# echo "pactl list modules short"
# pactl list modules short
echo "pactl unload-module <nummer> zum unloaden benutzen"
echo "in pavucontrol:"
echo "   Wiedergabe - VLC -> VirtualIn"
echo "   Aufnahme"
