#!/bin/python3

import curses as c
import ueberzug.lib.v0 as uz
import time

from os import path, getcwd, listdir, makedirs, rename

from sys import argv

keys = {
            "a": "Order A",
            "b": "Ordner B"
       }

settings = {
            "q": "quit",
            "s": "skip",
            "u": "undo",
        }

# Size settings
FOOTER_LEFT = 0
FOOTER_HEIGHT = 2

SIDEBAR_WIDTH = 40

CURSOR_X = 0
CURSOR_Y = 2

KEYS_BEGIN = 5

class Sorter:
    def __init__(self, wdir, canvas):
        self.wd = wdir
        
        self.images = [] # old paths
        self.images_new = [] # new paths
        self.image_iter = 0
        self.image = ""

        self.keys = keys

        self.settings = settings

        self.validate_dirs()

        # info about last action
        self.last_dir = ""

        # curses
        self.window = c.initscr()
        self.win_y, self.win_x = self.window.getmaxyx()

        self.message = "" # displayed in footer

        c.echo()

        # ueberzug
        self.canvas = canvas

        self.placement = self.canvas.create_placement("p1", x=0, y=0, path="")
        self.placement.visibility = uz.Visibility.VISIBLE
        self.placement.scaler = uz.ScalerOption.FIT_CONTAIN.value
        self.placement.x = SIDEBAR_WIDTH + 1
        self.placement.y = 1
        self.placement.width = self.win_x - SIDEBAR_WIDTH - 1
        self.placement.height = self.win_y - FOOTER_HEIGHT - 1

        # version
        self.version = "Glowzwiebel Image Sorter 1.0"

    def validate_dirs(self):
        for d in self.keys.values():
            if not path.isdir(d):
                print(f"Directory '{d}' does not exist.")
                decision = input(f"Create directory '{path.abspath(d)}'? y/n: ")
                if (decision == "y"):
                    makedirs(d)
                else:
                    print("Exiting - can not use non-existing directory.")
                    exit(1)


    def get_images(self):
        """
        Put all image-paths from wd in images dictionary.
        """
        self.images.clear()
        self.images_new.clear()

        for name in listdir(self.wd):
            name = path.normpath(self.wd + "/" + name)
            if (path.isfile(name)):
                self.images.append(name)

        self.images_new = self.images.copy()
        print(self.images)
            
    def display_image(self):
        with self.canvas.lazy_drawing: # issue ueberzug command AFTER with-statement
            self.placement.path = self.image
            self.window.addnstr(0, SIDEBAR_WIDTH + 1, self.placement.path, self.win_x - SIDEBAR_WIDTH - 1)

    def sort(self):
        while (self.image_iter < len(self.images)):
            self.image = self.images[self.image_iter]

            self.print_window()
            self.display_image()

            key = self.window.getkey() # wait until user presses something

            if key in self.settings:
                if self.settings[key] == "quit":
                    self.quit(f"Key '{key}' pressed. Canceling image sorting")
                elif self.settings[key] == "skip":
                    self.image_iter += 1
                    self.message = "Skipped image"
                    continue
                elif settings[key] == "undo":
                    if self.image_iter > 0:
                        self.image_iter -= 1 # using last image
                        rename(self.images_new[self.image_iter], self.images[self.image_iter])
                        self.images_new[self.image_iter] = self.images[self.image_iter]
                        self.message = "Undone last action"
                        continue
                    else:
                        self.message = "Nothing to undo!"
                        continue

            # move to folder
            elif key in self.keys:
                new_filepath =  self.move_file(self.image, self.keys[key])
                if new_filepath: # is string when successful
                    self.images_new[self.image_iter] = new_filepath
                    self.message = f"Moved image to {self.keys[key]}"
                else:
                    self.message = f"ERROR: Failed to move '{self.image}' to '{keys[key]}'."


            self.image_iter += 1
        self.quit("All done!")
        
    def print_window(self):
        self.window.erase()
        
        # lines
        self.window.hline(self.win_y - FOOTER_HEIGHT, FOOTER_LEFT, '=', self.win_x)
        self.window.vline(0, SIDEBAR_WIDTH, '|', self.win_y - FOOTER_HEIGHT + 1)

        # version
        x = self.win_x - len(self.version) - 1
        self.window.addstr(self.win_y - 1, x, self.version)

        # wd
        wdstring = f"Sorting {self.wd} - {len(self.images)} files - {len(self.images) - self.image_iter} remaining."
        self.window.addnstr(self.win_y - 1, FOOTER_LEFT, wdstring, self.win_x)

        # message
        self.window.addstr(self.win_y - FOOTER_HEIGHT, SIDEBAR_WIDTH + 2, self.message)
        self.message = ""

        # progress
        progstring = f"File {self.image_iter + 1}/{len(self.images)}"
        x = self.win_x - len(progstring) - 1
        self.window.addstr(self.win_y - FOOTER_HEIGHT, x, progstring)


        # print all key : action pairs
        i = 0
        self.window.hline(KEYS_BEGIN + i, 0, '-', SIDEBAR_WIDTH)
        i += 1
        self.window.addnstr(KEYS_BEGIN + i, 0, "Key: Action", SIDEBAR_WIDTH)
        i += 1
        self.window.hline(KEYS_BEGIN + i, 0, '-', SIDEBAR_WIDTH)
        i += 1
        for k, v in self.settings.items():
            if i >= self.win_y - KEYS_BEGIN - FOOTER_HEIGHT: # dont write into footer
                break
            self.window.addnstr(KEYS_BEGIN + i, 0, f"  {k}: {v}", SIDEBAR_WIDTH)
            i += 1
        self.window.hline(KEYS_BEGIN + i, 0, '-', SIDEBAR_WIDTH)
        i += 1

        # print all key : directory pairs
        self.window.addnstr(KEYS_BEGIN + i, 0, "Key: Directory", SIDEBAR_WIDTH)
        i += 1
        self.window.hline(KEYS_BEGIN + i, 0, '-', SIDEBAR_WIDTH)
        i += 1
        for k, v in self.keys.items():
            if i >= self.win_y - KEYS_BEGIN - FOOTER_HEIGHT: # dont write into footer
                break
            self.window.addnstr(KEYS_BEGIN + i, 0, f"  {k}: {v}", SIDEBAR_WIDTH)
            i += 1


        self.window.move(CURSOR_Y, CURSOR_X)
    
    def move_file(self, file, dest):
        # if not path.isdir(dest):
        #     makedirs(dest)
        if not path.isfile(file): return False
        if not path.isdir(dest): return False

        
        new_path = path.normpath(dest + '/' + path.split(file)[1])

        rename(file, new_path)
        return new_path

    def quit(self, message = ""): 
        self.window.clear()
        self.window.refresh()
        print(message)
        print("Quitting " + self.version)
        exit(0)
    

def main():
    # set working directory
    if len(argv) > 1:
        wd = path.abspath(argv[1])
    else:
        wd = getcwd();
    print(wd)

    with uz.Canvas() as canvas:
        sorter = Sorter(wd, canvas)
        sorter.get_images()
        # sorter.move_file("/home/matth/Bilder/Clara/bank.jpg", "/home")
        # sorter.print_window()
        sorter.sort()
        

if __name__ == "__main__":
    main()
