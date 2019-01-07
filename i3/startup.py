#!/usr/bin/python
import i3ipc
import logging
import signal
import os
from time import sleep
from shutil import which


class starter:
    def __init__(self):
        self.i3 = i3ipc.Connection()

        for sig in [signal.SIGINT, signal.SIGTERM]:
            signal.signal(sig, lambda signal, frame: self.i3.main_quit())

    def launch_app_gui(self, space_id, display, command, args=None):
        logging.info('provided the following params:\n'
                     'space_id={}\n'
                     'display={}\n'
                     'command={}\n'
                     'args={}'.format(space_id, display, command, args))

        # command = which(command)
        if args is not None:
            command += " " + args

        #if display is not None:
            #self.i3.command('move workspace to output {}'.format(display))

        self.i3.command('move workspace to output {}, workspace {}, exec --no-startup-id {}'.format(display ,space_id, command))
        # self.i3.command('exec --no-startup-id {}'.format(command))
        # self.i3.command('for_window [class="{}"] move container to workspace {}'.format(command, space_id))

        sleep(2)


    def launch_app_tray(self, command, args=None):
        logging.info('provided the following params:\n'
                     'command={}\n'
                     'args={}'.format(command, args))

        # command = which(command)

        if args is not None:
            command += " " + args

        self.i3.command('exec --no-startup-id {}'.format(command))
        sleep(0.25)

    #def sort_windows(self):
        #for_window [class="^evil-app$"]

    def start(self):
        self.launch_app_tray('nm-applet')

        self.launch_app_gui(1, 'eDP1', 'terminator', '-e \'tmux -2 attach || tmux -2\'')
        self.launch_app_gui(2, 'eDP1', 'firefox')
        self.launch_app_gui(3, 'eDP1', 'emacs')
        self.launch_app_gui(9, 'eDP1', 'skypeforlinux')
        self.launch_app_gui(9, 'eDP1', 'telegram-desktop')

        # go to first window
        self.i3.command('workspace 1')
        self.launch_app_tray('python /home/dartmoor/.config/i3/autoRenameWindows.py')



if __name__ == "__main__":
    logging.basicConfig(level=logging.INFO)
    sleep(3)
    starter().start()
