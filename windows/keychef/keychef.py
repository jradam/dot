from winput import (
    VK_OEM_1, VK_Q, WP_DONT_PASS_INPUT_ON, WM_KEYDOWN, WM_KEYUP,
    VK_F, VK_OEM_4, VK_SHIFT, VK_J, press_key, release_key, WP_UNHOOK, WP_STOP,
    hook_keyboard, wait_messages, KeyboardEvent, vk_code_dict, VK_OEM_6
)

cooking = False


def toggle_cooking(event: KeyboardEvent):
    global cooking
    if event.action == WM_KEYDOWN:
        cooking = True
    elif event.action == WM_KEYUP:
        cooking = False
    return WP_DONT_PASS_INPUT_ON


def handle_ingredients(event: KeyboardEvent):
    if event.vkCode == VK_F and event.action == WM_KEYDOWN:
        press_key(VK_SHIFT)
        press_key(VK_OEM_4)
        release_key(VK_OEM_4)
        release_key(VK_SHIFT)
        return WP_DONT_PASS_INPUT_ON
    if event.vkCode == VK_J and event.action == WM_KEYDOWN:
        press_key(VK_SHIFT)
        press_key(VK_OEM_6)
        release_key(VK_OEM_6)
        release_key(VK_SHIFT)
        return WP_DONT_PASS_INPUT_ON


def leave_kitchen():
    return WP_UNHOOK | WP_STOP


def keyboard_callback(event: KeyboardEvent):
    if event.vkCode == VK_OEM_1:
        return toggle_cooking(event)
    elif cooking:
        return handle_ingredients(event)
    elif event.vkCode == VK_Q:
        return leave_kitchen()
    print(vk_code_dict.get(event.vkCode, "VK_UNKNOWN"), cooking)


hook_keyboard(keyboard_callback)
wait_messages()
