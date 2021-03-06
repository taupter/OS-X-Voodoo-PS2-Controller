# really just some handy scripts...

.PHONY: all
all:
	xcodebuild -scheme All -configuration Debug
	xcodebuild -scheme All -configuration Release

.PHONY: clean
clean:
	xcodebuild -scheme All -configuration Debug clean
	xcodebuild -scheme All -configuration Release clean

.PHONY: update_kernelcache
update_kernelcache:
	sudo touch /System/Library/Extensions
	sudo kextcache --system-prelinked-kernel -arch x86_64

.PHONY: install_debug
install_debug:
	sudo cp -R ./Build/Products/Debug/VoodooPS2Controller.kext /System/Library/Extensions
	sudo cp ./VoodooPS2Keyboard/VoodooPS2Keyboard-RemapFN-Info.plist /System/Library/Extensions/VoodooPS2Controller.kext/Contents/PlugIns/VoodooPS2Keyboard.kext/Contents/Info.plist
	sudo /usr/libexec/PlistBuddy -c "Set ':IOKitPersonalities:Synaptics TouchPad:Configuration:DragLockTempMask' 262148" /System/Library/Extensions/VoodooPS2Controller.kext/Contents/PlugIns/VoodooPS2Trackpad.kext/Contents/Info.plist
	sudo /usr/libexec/PlistBuddy -c "Set ':IOKitPersonalities:Synaptics TouchPad:Configuration:FingerZ' 47" /System/Library/Extensions/VoodooPS2Controller.kext/Contents/PlugIns/VoodooPS2Trackpad.kext/Contents/Info.plist
	sudo cp ./VoodooPS2Daemon/org.rehabman.voodoo.driver.Daemon.plist /Library/LaunchDaemons
	sudo cp ./Build/Products/Debug/VoodooPS2Daemon /usr/bin
	make update_kernelcache

.PHONY: install
install: install_kext install_daemon

.PHONY: install_kext
install_kext:
	sudo cp -R ./Build/Products/Release/VoodooPS2Controller.kext /System/Library/Extensions
	sudo cp ./VoodooPS2Keyboard/VoodooPS2Keyboard-RemapFN-Info.plist /System/Library/Extensions/VoodooPS2Controller.kext/Contents/PlugIns/VoodooPS2Keyboard.kext/Contents/Info.plist
	sudo /usr/libexec/PlistBuddy -c "Set ':IOKitPersonalities:Synaptics TouchPad:Configuration:DragLockTempMask' 262148" /System/Library/Extensions/VoodooPS2Controller.kext/Contents/PlugIns/VoodooPS2Trackpad.kext/Contents/Info.plist
	sudo /usr/libexec/PlistBuddy -c "Set ':IOKitPersonalities:Synaptics TouchPad:Configuration:FingerZ' 47" /System/Library/Extensions/VoodooPS2Controller.kext/Contents/PlugIns/VoodooPS2Trackpad.kext/Contents/Info.plist
	sudo /usr/libexec/PlistBuddy -c "Set ':IOKitPersonalities:Sentelic FSP:DisableDevice' Yes" /System/Library/Extensions/VoodooPS2Controller.kext/Contents/PlugIns/VoodooPS2TrackPad.kext/Contents/Info.plist
	sudo /usr/libexec/PlistBuddy -c "Set ':IOKitPersonalities:ALPS GlidePoint:DisableDevice' Yes" /System/Library/Extensions/VoodooPS2Controller.kext/Contents/PlugIns/VoodooPS2TrackPad.kext/Contents/Info.plist
	sudo /usr/libexec/PlistBuddy -c "Set ':IOKitPersonalities:ApplePS2Mouse:DisableDevice' Yes" /System/Library/Extensions/VoodooPS2Controller.kext/Contents/PlugIns/VoodooPS2Mouse.kext/Contents/Info.plist
	make update_kernelcache

.PHONY: install_mouse
install_mouse:
	sudo cp -R ./Build/Products/Release/VoodooPS2Controller.kext /System/Library/Extensions
	sudo cp ./VoodooPS2Keyboard/VoodooPS2Keyboard-RemapFN-Info.plist /System/Library/Extensions/VoodooPS2Controller.kext/Contents/PlugIns/VoodooPS2Keyboard.kext/Contents/Info.plist
	sudo rm -r /System/Library/Extensions/VoodooPS2Controller.kext/Contents/PlugIns/VoodooPS2Trackpad.kext
	sudo /usr/libexec/PlistBuddy -c "Set ':IOKitPersonalities:ApplePS2Mouse:ActLikeTrackpad' Yes" /System/Library/Extensions/VoodooPS2Controller.kext/Contents/PlugIns/VoodooPS2Mouse.kext/Contents/Info.plist
	sudo /usr/libexec/PlistBuddy -c "Set ':IOKitPersonalities:ApplePS2Mouse:DisableDevice' No" /System/Library/Extensions/VoodooPS2Controller.kext/Contents/PlugIns/VoodooPS2Mouse.kext/Contents/Info.plist
	make update_kernelcache

.PHONY: install_mouse_debug
install_mouse_debug:
	sudo cp -R ./Build/Products/Debug/VoodooPS2Controller.kext /System/Library/Extensions
	sudo cp ./VoodooPS2Keyboard/VoodooPS2Keyboard-RemapFN-Info.plist /System/Library/Extensions/VoodooPS2Controller.kext/Contents/PlugIns/VoodooPS2Keyboard.kext/Contents/Info.plist
	sudo rm -r /System/Library/Extensions/VoodooPS2Controller.kext/Contents/PlugIns/VoodooPS2Trackpad.kext
	sudo /usr/libexec/PlistBuddy -c "Set ':IOKitPersonalities:ApplePS2Mouse:ActLikeTrackpad' Yes" /System/Library/Extensions/VoodooPS2Controller.kext/Contents/PlugIns/VoodooPS2Mouse.kext/Contents/Info.plist
	sudo /usr/libexec/PlistBuddy -c "Set ':IOKitPersonalities:ApplePS2Mouse:DisableDevice' No" /System/Library/Extensions/VoodooPS2Controller.kext/Contents/PlugIns/VoodooPS2Mouse.kext/Contents/Info.plist
	make update_kernelcache

.PHONY: install_daemon
install_daemon:
	sudo cp ./VoodooPS2Daemon/org.rehabman.voodoo.driver.Daemon.plist /Library/LaunchDaemons
	sudo cp ./Build/Products/Release/VoodooPS2Daemon /usr/bin

install.sh: makefile
	make -n install >install.sh
	chmod +x install.sh

.PHONY: distribute
distribute:
	if [ -e ./Distribute ]; then rm -r ./Distribute; fi
	mkdir ./Distribute
	mkdir ./Distribute/ProBook
	cp -R ./Build/Products/ ./Distribute
	cp -R ./Build/Products/ ./Distribute/ProBook
	cp ./VoodooPS2Keyboard/VoodooPS2Keyboard-RemapFN-Info.plist ./Distribute/ProBook/Debug/VoodooPS2Controller.kext/Contents/PlugIns/VoodooPS2Keyboard.kext/Contents/Info.plist
	cp ./VoodooPS2Keyboard/VoodooPS2Keyboard-RemapFN-Info.plist ./Distribute/ProBook/Release/VoodooPS2Controller.kext/Contents/PlugIns/VoodooPS2Keyboard.kext/Contents/Info.plist
	/usr/libexec/PlistBuddy -c "Set ':IOKitPersonalities:Synaptics TouchPad:Configuration:FingerZ' 40" ./Distribute/ProBook/Debug/VoodooPS2Controller.kext/Contents/PlugIns/VoodooPS2Trackpad.kext/Contents/Info.plist
	/usr/libexec/PlistBuddy -c "Set ':IOKitPersonalities:Synaptics TouchPad:Configuration:FingerZ' 40" ./Distribute/ProBook/Release/VoodooPS2Controller.kext/Contents/PlugIns/VoodooPS2Trackpad.kext/Contents/Info.plist
	/usr/libexec/PlistBuddy -c "Set ':IOKitPersonalities:Sentelic FSP:DisableDevice' Yes" ./Distribute/ProBook/Debug/VoodooPS2Controller.kext/Contents/PlugIns/VoodooPS2TrackPad.kext/Contents/Info.plist
	/usr/libexec/PlistBuddy -c "Set ':IOKitPersonalities:ALPS GlidePoint:DisableDevice' Yes" ./Distribute/ProBook/Debug/VoodooPS2Controller.kext/Contents/PlugIns/VoodooPS2TrackPad.kext/Contents/Info.plist
	/usr/libexec/PlistBuddy -c "Set ':IOKitPersonalities:ApplePS2Mouse:DisableDevice' Yes" ./Distribute/ProBook/Debug/VoodooPS2Controller.kext/Contents/PlugIns/VoodooPS2Mouse.kext/Contents/Info.plist
	/usr/libexec/PlistBuddy -c "Set ':IOKitPersonalities:Sentelic FSP:DisableDevice' Yes" ./Distribute/ProBook/Release/VoodooPS2Controller.kext/Contents/PlugIns/VoodooPS2TrackPad.kext/Contents/Info.plist
	/usr/libexec/PlistBuddy -c "Set ':IOKitPersonalities:ALPS GlidePoint:DisableDevice' Yes" ./Distribute/ProBook/Release/VoodooPS2Controller.kext/Contents/PlugIns/VoodooPS2TrackPad.kext/Contents/Info.plist
	/usr/libexec/PlistBuddy -c "Set ':IOKitPersonalities:ApplePS2Mouse:DisableDevice' Yes" ./Distribute/ProBook/Release/VoodooPS2Controller.kext/Contents/PlugIns/VoodooPS2Mouse.kext/Contents/Info.plist
	find ./Distribute -path *.DS_Store -delete
	find ./Distribute -path *.dSYM -exec echo rm -r {} \; >/tmp/org.voodoo.rm.dsym.sh
	chmod +x /tmp/org.voodoo.rm.dsym.sh
	/tmp/org.voodoo.rm.dsym.sh
	rm /tmp/org.voodoo.rm.dsym.sh
	cp ./VoodooPS2Daemon/org.rehabman.voodoo.driver.Daemon.plist ./Distribute/
	cp ./VoodooPS2Daemon/org.rehabman.voodoo.driver.Daemon.plist ./Distribute/ProBook/
	rm -r ./Distribute/Debug/VoodooPS2synapticsPane.prefPane
	rm -r ./Distribute/ProBook/Debug/VoodooPS2synapticsPane.prefPane
	rm -r ./Distribute/Release/VoodooPS2synapticsPane.prefPane
	rm -r ./Distribute/ProBook/Release/VoodooPS2synapticsPane.prefPane
	rm ./Distribute/Debug/synapticsconfigload
	rm ./Distribute/ProBook/Debug/synapticsconfigload
	rm ./Distribute/Release/synapticsconfigload
	rm ./Distribute/ProBook/Release/synapticsconfigload
