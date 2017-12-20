install:
	kpackagetool5 -t Plasma/Applet --install package

remove:
	kpackagetool5 -t Plasma/Applet --remove com.github.putrasattvika.ssidstat-kde

reinstall:
	kpackagetool5 -t Plasma/Applet -u package; killall plasmashell; kstart5 plasmashell

view:
	plasmoidviewer --applet package