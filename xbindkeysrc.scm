;; Misc
(xbindkey '(Mod4 Print) "bash -c 'import -window root /tmp/screenshot.bmp && gthumb /tmp/screenshot.bmp'")
(xbindkey '(XF86AudioMute) "amixer -c 0 set Master playback toggle" )
(xbindkey '(XF86AudioLowerVolume) "amixer -c 0 set Master playback 2-" )
(xbindkey '(XF86AudioRaiseVolume) "amixer -c 0 set Master playback 2+" )
(xbindkey '(Control Alt Delete) "bash -c 'xflock4 -mode blank'")
(xbindkey '(Control Alt Escape) "bash -c 'xkill'")
(xbindkey '(Mod4 F4) "xfce4-session-logout")

;; Top row
(xbindkey '(Mod4 q) "wmctrl -r :ACTIVE: -b add,above")
(xbindkey '(Alt Mod4 q) "wmctrl -r :ACTIVE: -b add,below")
(xbindkey '(Mod4 w) "wmctrl -r :ACTIVE: -b remove,above,below")
(xbindkey '(Alt Mod4 w) "wmctrl -r :ACTIVE: -b toggle,shaded")
(xbindkey '(Mod4 e) "bash -c 'wmctrl -xa evince'")
(xbindkey '(Mod4 t) "bash -c 'wmctrl -xa thunar || thunar'")
(xbindkey '(Mod4 m) "bash -c 'wmctrl -xa maplesoft; wmctrl -xa matlab; wmctrl -xa mathcad.exe'")
(xbindkey '(Mod4 p) "bash -c 'wmctrl -xa pidgin'")
(xbindkey '(Mod4 y) "bash -c 'wmctrl -xa wine'")

;; Middle row
(xbindkey '(Mod4 a) "wmctrl -r :ACTIVE: -b toggle,maximized_vert,maximized_horz")
(xbindkey '(Mod4 d) "wmctrl -k on")
(xbindkey '(Mod4 f) "bash -c 'wmctrl -xa Navigator || firefox'")

;; Bottom row
(xbindkey '(Mod4 v) "bash -c 'wmctrl -xa vim || gvim'")
(xbindkey '(Mod4 b) "bash -c 'cmus-remote --next")
(xbindkey '(Mod4 z) "bash -c 'cmus-remote --prev")
(xbindkey '(Mod4 x) "bash -c 'cmus-remote --stop")
(xbindkey '(Mod4 c) "bash -c 'cmus-remote --pause'")

;; Move/resize windows
(xbindkey '(Shift Mod4 i) "wmctrl -r ':ACTIVE:' -e '0,0,0,668,840'")
(xbindkey '(Shift Mod4 o) "wmctrl -r ':ACTIVE:' -e '0,670,0,930,840'")
(xbindkey '(Shift Mod4 h) "wmctrl -r ':ACTIVE:' -e '0,0,507,668,489'")
(xbindkey '(Shift Mod4 j) "wmctrl -r ':ACTIVE:' -e '0,0,0,668,481'")
(xbindkey '(Shift Mod4 k) "wmctrl -r ':ACTIVE:' -e '0,670,0,930,481'")
(xbindkey '(Shift Mod4 l) "wmctrl -r ':ACTIVE:' -e '0,670,507,930,489'")


;; Funny sounds
(xbindkey '(Mod4 Escape) "sh -c 'mpg123 /home/peter/.scripts/instantrimshot.mp3'")
;(xbindkey '(Mod4 Escape) "sh -c 'amixer set Master 100% unmute; mpg123 /home/peter/.scripts/instantrimshot.mp3'")
