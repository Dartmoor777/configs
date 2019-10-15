#!/usr/bin/python
import i3ipc
import logging
import signal
import os
import subprocess
import notify2
from time import sleep
from Xlib import display
from Xlib.ext import randr


class starter:
    def __init__(self):
        notify2.init("i3 startup")
        self.i3 = i3ipc.Connection()
        self.ntf = notify2.Notification('Startup')
        self.displays = []
        self._init_display_info()
        self.displaysCount = len(self.displays)
        self.postCmds = []

        for sig in [signal.SIGINT, signal.SIGTERM]:
            signal.signal(sig, lambda signal, frame: self.i3.main_quit())

    def _init_display_info(self):
        d = display.Display()
        window = d.create_resource_object("window", d.screen().root.id)
        res = randr.get_screen_resources(window)

        # set up primary display
        self.displays.append(randr.get_output_info(
            window, randr.get_output_primary(window).output,
            res.config_timestamp).name)

        # set up primary display
        for output in res.outputs:
            info = randr.get_output_info(d, output, res.config_timestamp)
            logging.info("checked display: {}, state {}".format(info.name, info.num_preferred))
            if info.name not in self.displays and info.num_preferred:
                self.displays.append(info.name)

        logging.info("configured displays: ")
        logging.info(self.displays)

    def launch_app_gui(self, space_id, display, command, args=None):
        logging.info('provided the following params:\n'
                     'space_id={}\n'
                     'display={}\n'
                     'command={}\n'
                     'args={}'.format(space_id, display, command, args))

        if args is not None:
            command += " " + args

        self.i3.command('workspace {}, move workspace to output {}, exec --no-startup-id {}'.
                        format(space_id, display, command))

        sleep(2)

    def get_caps_status(self):
        for line in subprocess.check_output(['xset', '-q']).splitlines():
            if 'Caps' in str(line):
                if 'on' == str(line).split()[4]:
                    return True
                else:
                    return False
        return False

    def notify(self, msg):
        self.ntf.update("Startup i3", msg)
        self.ntf.show()

    def launch_app_tray(self, command, args=None):
        logging.info('provided the following params:\n'
                     'command={}\n'
                     'args={}'.format(command, args))

        if args is not None:
            command += " " + args

        self.i3.command('exec --no-startup-id {}'.format(command))
        sleep(0.25)

    def start(self):
        # configure display(s)
        if self.displaysCount is 2:
            cmd = os.environ['HOME'] + "/.screenlayout/dual.sh"
            logging.info("Going to run " + cmd)
            subprocess.run(cmd)
            sleep(0.5)

        # launch apps which should be started at any case
        self.launch_app_tray('nm-applet')
        self.launch_app_tray('flameshot')
        self.launch_app_tray('feh', '--bg-scale ~/Pictures/wallpapers/wall.jpg')

        # launch apps according to caps lock state
        if self.get_caps_status():
            self.launch_app_tray('telegram-desktop', '-startintray')
            self.notify('Skip starting apps due to caps lock!')
        else:
            if self.displaysCount is not 2:
                self.launch_app_gui(1, self.displays[0], 'terminator', '-e \'tmux -2 attach || tmux -2\'')
                self.launch_app_gui(2, self.displays[0], 'firefox')
                self.launch_app_gui(3, self.displays[0], 'emacs')
                # self.launch_app_gui(9, self.displays[0], 'skypeforlinux')
                self.launch_app_gui(9, self.displays[0], 'telegram-desktop')
            else:
                self.launch_app_gui(1, self.displays[0], 'terminator', '-e \'tmux -2 attach || tmux -2\'')
                self.launch_app_gui(2, self.displays[0], 'firefox')
                self.launch_app_gui(3, self.displays[0], 'emacs')
                # self.launch_app_gui(9, self.displays[1], 'skypeforlinux')
                self.launch_app_gui(9, self.displays[1], 'telegram-desktop')

            self.i3.command('workspace 1')
            self.notify('The apps started successfully!')

        # go to first window
        self.launch_app_tray('python /home/dartmoor/.config/i3/autoRenameWindows.py')


if __name__ == "__main__":
    logging.basicConfig(level=logging.INFO, filename="/tmp/startup.log")
    sleep(3)
    starter().start()
