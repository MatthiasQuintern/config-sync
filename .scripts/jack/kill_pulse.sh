# make sure it doesnt restart
systemctl --user stop pulseaudio.socket

# kill process
pulseaudio --kill
