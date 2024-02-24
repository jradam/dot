# This program replaces semicolon with F13, and enables a new keyboard layer here.
# In Windows, this means that semicolon does nothing, as F13 is not bound there, and it can now act as our new keyboard layer.
# In Windows Terminal's settings.json, I have bound F13 to send ¦ to use as a leader key in neovim (the only key I could think of that I never need to use) and I have blocked it from typing anything with <Nop> in init.lua

# TODO: figure out how to make <leader>e type "=" but also work well for opening tree. Maybe just rebind all the leader things that clash to the new bindings (i.e. menu open on "=")?
# TODO: package as an exe and run at startup
# TODO: mouse movement
# TODO: move to public repo

from winput import (
    VK_2, VK_7, VK_A, VK_B, VK_BACK, VK_C, VK_DELETE, VK_E, VK_ESCAPE, VK_G, VK_H, VK_N, VK_OEM_1, VK_OEM_MINUS, VK_OEM_PLUS, VK_Q, VK_RETURN, VK_U, VK_X, WP_DONT_PASS_INPUT_ON, WM_KEYDOWN, WM_KEYUP, VK_F, VK_OEM_4, VK_SHIFT, VK_J, press_key, release_key, WP_UNHOOK, WP_STOP, hook_keyboard, wait_messages, KeyboardEvent, VK_OEM_6, VK_D, VK_9, VK_K, VK_S, VK_0, VK_L, VK_F13, VK_LSHIFT
)
import time

cooking = False
shifted = False
semicolon = False

last_key_time = 0
last_key = None


def toggle_cooking(event: KeyboardEvent):
    global cooking
    if event.action == WM_KEYDOWN:
        cooking = True
        press_key(VK_F13)
    elif event.action == WM_KEYUP:
        cooking = False
        release_key(VK_F13)
    return WP_DONT_PASS_INPUT_ON


def toggle_shifted(event: KeyboardEvent):
    global shifted
    if event.action == WM_KEYDOWN:
        shifted = True
    elif event.action == WM_KEYUP:
        shifted = False


def hit(key):
    press_key(key)
    release_key(key)


def shift_hit(key):
    press_key(VK_SHIFT)
    hit(key)
    release_key(VK_SHIFT)


def press(key, shift=False):
    if shift == True:
        shift_hit(key)
    else:
        hit(key)


def double(key1, key2):
    global last_key_time, last_key
    current_time = time.time()
    if last_key == key1[0] and (current_time - last_key_time) < 0.2:
        hit(VK_BACK)
        press(*key2)
    else:
        press(*key1)
    last_key_time = current_time
    last_key = key1[0]


def handle_semicolon():
    global semicolon
    semicolon = True
    hit(VK_OEM_1)
    semicolon = False


def handle_ingredients(event: KeyboardEvent):
    global semicolon
    key_map = {
        VK_F: lambda: double((VK_OEM_4, True), (VK_OEM_6, True)),
        VK_D: lambda: double((VK_9, True), (VK_0, True)),
        VK_S: lambda: double((VK_OEM_4, False), (VK_OEM_6, False)),
        VK_G: lambda: double((VK_OEM_MINUS, False), (VK_OEM_MINUS, True)),
        VK_Q: lambda: press(VK_2, True),
        VK_E: lambda: press(VK_OEM_PLUS),
        VK_N: lambda: press(VK_RETURN),
        VK_B: lambda: press(VK_BACK),
        VK_X: lambda: press(VK_DELETE),
        VK_A: lambda: press(VK_7, True),
        VK_C: lambda: handle_semicolon(),
    }
    if event.action == WM_KEYDOWN:
        if event.vkCode == VK_ESCAPE:
            return WP_UNHOOK | WP_STOP
        action = key_map.get(event.vkCode)
        if action:
            action()
            return WP_DONT_PASS_INPUT_ON


def keyboard_callback(event: KeyboardEvent):
    if event.vkCode == VK_LSHIFT:
        return toggle_shifted(event)
    if event.vkCode == VK_OEM_1 and not shifted and not semicolon:
        return toggle_cooking(event)
    elif cooking:
        return handle_ingredients(event)


hook_keyboard(keyboard_callback)
wait_messages()
