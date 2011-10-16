import datetime
import operator
import os
import re
import sys
import traceback
import math, time
import subprocess
from threading import Thread, Timer

import pygmi
import weather
from pygmi import *
from pygmi import event

identity = lambda k: k

# Theme
background = '#333333'
floatbackground='#222222'

FOCUS_COLOR_NORM ='#ffffff', '#285577', '#4c7899'
FOCUS_COLOR_FLOAT='#ffffff', '#852E38', '#E04E5E'
wmii['font'] = 'drift,-*-fixed-*-*-*-*-12-*-*-*-*-*-*-*'
wmii['normcolors'] = '#888888', '#222222', '#333333'
wmii['focuscolors'] = FOCUS_COLOR_NORM
wmii['grabmod'] = keys.defs['mod']
wmii['border'] = 2

terminal = 'wmiir', 'setsid', 'urxvt'
pygmi.shell = os.environ.get('SHELL', 'sh')

@defmonitor
def load(self):
    return wmii.cache['normcolors'], re.sub(r'^.*: ', '', call('uptime')).replace(', ', ' ')
@defmonitor
def time(self):
    return wmii.cache['focuscolors'], datetime.datetime.now().strftime('%c')

"""
@defmonitor(side='left')
def cmus(self):
    try:
        result = unicode(subprocess.check_output(['cmus-remote', '-Q']),'utf-8')
    except:
        return u"CMUS: N/A"
    status = u'#'
    artist = u''
    title = u''
    file = u''
    for line in iter(result.splitlines()):
        if line.startswith('status playing'):
            status = u'>'
        elif line.startswith('status stopped'):
            status = u'#'
        elif line.startswith('status paused'):
            status = u'|'
        elif line.startswith('tag artist'):
            artist = u' '.join(line.split()[2:])
        elif line.startswith('tag title'):
            title = u' '.join(line.split()[2:])
        elif line.startswith('file'):
            file = (u' '.join(line.split()[1:])).split('/')[-1]
    if len(artist) > 0 and len(title) > 0:
        return u"CMUS:%s %s - %s" % (status, artist, title)
    elif len(file) > 0:
        return u"CMUS:%s %s" % (status, file)
    else:
        return u"CMUS:%s" %(status)
"""

@defmonitor(interval=600)
def aweather(self):
    try:
        res = weather.get_weather('daxx0002')
        return 'Temp: %sC, Today: %s [%s:%s] Tommorow: %s [%s:%s]' % (
        res['current_temp'], 
        res['forecasts'][0]['condition'], res['forecasts'][0]['high'], 
        res['forecasts'][0]['low'], res['forecasts'][1]['condition'],
        res['forecasts'][1]['high'], res['forecasts'][1]['low'])
    except:
        pass

    

####### Network monitor
def fs_format(bytes):
    s = [' B','kB','MB','GB','TB','PB','EB','ZB','YB']
    if bytes <= 0:
        return '%5.1f B' % 0
    log = math.floor(math.log(bytes, 1000))
    return "%5.1f%s" % (bytes/math.pow(1000,log),s[int(log)])

netinterval=1
netdev = open('/proc/net/dev')
@defmonitor(interval=netinterval)
def netmon(self):
    netdev.seek(0)
    for line in netdev:
        l = line.split()
        if l[0].startswith('eth0'):
            down = long(l[1])
            up = long(l[9])
            try:
                netstr = 'DOWN:%s UP:%s' % (fs_format((down-self.lastd)/netinterval), fs_format((up-self.lastu)/netinterval))
            except:
                netstr = 'NA'
            self.lastd = down
            self.lastu = up
    return netstr

tags = Tags()
def focuscolors(colors):
    wmii['focuscolors']=colors

events.bind({
    'AreaFocus':    lambda args: (args == '~' and
                                  (focuscolors(FOCUS_COLOR_FLOAT), True) or
                                  focuscolors(FOCUS_COLOR_NORM) )
})

@apply
class Actions(event.Actions):
    def shutdown(self, args=''):
        os.system('sudo shutdown -h now')
    def suspend(self, args=''):
        os.system('sudo pm-suspend')
    def reboot(self, args=''):
        os.system('sudo reboot')


action_menu = Menu(histfile='%s/history.actions' % confpath[0], nhist=500,
                   choices=lambda: Actions._choices,
                   action=Actions._call)

keys.bind('main', (
    "Resize",
    ('%(mod)s-Control-%(left)s',  "Shrink right",
        lambda k: Tag('sel').ctl('grow', 'sel sel', 'right',-5)),
    ('%(mod)s-Control-%(right)s',  "Grow right",
        lambda k: Tag('sel').ctl('grow', 'sel sel', 'right',5)),
    ('%(mod)s-Control-%(down)s',  "Grow down",
        lambda k: Tag('sel').ctl('grow', 'sel sel', 'down',5)),
    ('%(mod)s-Control-%(up)s',  "Shrink down",
        lambda k: Tag('sel').ctl('grow', 'sel sel', 'down',-5)),

    "Running programs",
    ('%(mod)s-a',      "Open wmii actions menu",
        lambda k: action_menu()),
    ('%(mod)s-Return', "Launch a terminal",
        lambda k: call(*terminal, background=True)),

    "Client actions",
    ('%(mod)s-g',       "Toggle selected client's fullsceen state",
        lambda k: Client('sel').set('Fullscreen', 'toggle')),
))

#Call startup script
try:
    subprocess.Popen(['bash','/home/peter/.wmii-hg/startup.sh'])
except:
    pass

# vim:se sts=4 sw=4 et:
