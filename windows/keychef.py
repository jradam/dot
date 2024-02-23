# This program replaces semicolon with F13, and enables the "cooking" keyboard layer here.
# In Windows, this means that semicolon does nothing, as F13 is not bound there, and it can now act as our new keyboard layer.
# In Windows Terminal's settings.json, I have bound F13 to send semicolon again so I can use it as a leader key in neovim, and I have blocked it from typing anything with <Nop>

# TODO: figure out how to type semicolon in Neovim while still having functionality
# TODO: figure out how to make semi+e type "=" but also work well for opening tree
# TODO: mouse movement


from winput import (
    VK_2, VK_C, VK_E, VK_ESCAPE, VK_H, VK_N, VK_OEM_1, VK_OEM_MINUS, VK_OEM_PLUS, VK_Q, VK_RETURN, VK_U, WP_DONT_PASS_INPUT_ON, WM_KEYDOWN, WM_KEYUP, VK_F, VK_OEM_4, VK_SHIFT, VK_J, press_key, release_key, WP_UNHOOK, WP_STOP, hook_keyboard, wait_messages, KeyboardEvent, VK_OEM_6, VK_D, VK_9, VK_K, VK_S, VK_0, VK_L, VK_F13, VK_LSHIFT
)

cooking = False
shifted = False
semicolon = False
halt = WP_DONT_PASS_INPUT_ON


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


def handle_ingredients(event: KeyboardEvent):
    global semicolon
    if event.vkCode == VK_F and event.action == WM_KEYDOWN:  # F > {
        shift_hit(VK_OEM_4)
        return halt
    if event.vkCode == VK_J and event.action == WM_KEYDOWN:  # J > }
        shift_hit(VK_OEM_6)
        return halt
    if event.vkCode == VK_D and event.action == WM_KEYDOWN:  # D > (
        shift_hit(VK_9)
        return halt
    if event.vkCode == VK_K and event.action == WM_KEYDOWN:  # K > )
        shift_hit(VK_0)
        return halt
    if event.vkCode == VK_S and event.action == WM_KEYDOWN:  # S > [
        hit(VK_OEM_4)
        return halt
    if event.vkCode == VK_L and event.action == WM_KEYDOWN:  # L > ]
        hit(VK_OEM_6)
        return halt
    if event.vkCode == VK_U and event.action == WM_KEYDOWN:  # U > _
        shift_hit(VK_OEM_MINUS)
        return halt
    if event.vkCode == VK_H and event.action == WM_KEYDOWN:  # H > -
        hit(VK_OEM_MINUS)
        return halt
    if event.vkCode == VK_Q and event.action == WM_KEYDOWN:  # Q > "
        shift_hit(VK_2)
        return halt
    if event.vkCode == VK_E and event.action == WM_KEYDOWN:  # E > =
        hit(VK_OEM_PLUS)
        return halt
    if event.vkCode == VK_C and event.action == WM_KEYDOWN:  # C > ;
        semicolon = True
        hit(VK_OEM_1)
        semicolon = False
        return halt
    if event.vkCode == VK_N and event.action == WM_KEYDOWN:  # N > Return
        hit(VK_RETURN)
        return halt
    if event.vkCode == VK_ESCAPE and event.action == WM_KEYDOWN:  # Exit
        return WP_UNHOOK | WP_STOP


def keyboard_callback(event: KeyboardEvent):
    if event.vkCode == VK_LSHIFT:
        return toggle_shifted(event)
    if event.vkCode == VK_OEM_1 and not shifted and not semicolon:
        return toggle_cooking(event)
    elif cooking:
        return handle_ingredients(event)


hook_keyboard(keyboard_callback)
wait_messages()
