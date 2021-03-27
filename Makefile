TARGET := iphone:clang:latest:13.0
INSTALL_TARGET_PROCESSES = Music

DEBUG=0
FINALPACKAGE=1

include $(THEOS)/makefiles/common.mk

PREFIX=$(THEOS)/toolchain/Xcode.xctoolchain/usr/bin/

TWEAK_NAME = MusicLyricsShare

MusicLyricsShare_FILES = Tweak.xm
MusicLyricsShare_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
