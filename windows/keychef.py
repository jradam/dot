from pynput.keyboard import Listener, Controller
import sys

keyboard = Controller()
hyper = False


def on_press(key):
    global hyper
    if key.char == ';' and not hyper:
        hyper = True
    elif hyper:
        if key.char == 'f':
            # TODO: these don't send anything
            print("Pressing...")
            keyboard.press('{')
            keyboard.release('{')


def on_release(key):
    global hyper
    if key.char == ';':
        hyper = False
    if key.char == 'q':
        sys.exit()


with Listener(
        suppress=True,
        on_press=on_press,
        on_release=on_release) as listener:
    listener.join()
