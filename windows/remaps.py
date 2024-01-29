from pynput import keyboard, mouse
from pynput.mouse import Button, Controller as MouseController
from pynput.keyboard import Key, Controller as KeyboardController
import threading

# TODO: have installed pyinstaller, python3-pip, python3-venv
# Do I really need all this? Should I try Node or Rust?

# Constants
INTERVAL = 40
SPEED = 20
MODIFIER = 0.2

# Global variables
slow_mode = 1
running = True

# Initialize mouse and keyboard controllers
mouse_controller = MouseController()
keyboard_controller = KeyboardController()


def move_mouse(x, y):
  global slow_mode
  while True:
    # Adjust speed and interval based on slow_mode
    adjusted_speed = SPEED * slow_mode
    adjusted_interval = INTERVAL * slow_mode

    # Update mouse position
    current_pos = mouse_controller.position

    new_pos = (
        current_pos[0] + x * adjusted_interval,
        current_pos[1] + y * adjusted_interval,
    )
    mouse_controller.position = new_pos

    # Sleep for the adjusted speed
    time.sleep(adjusted_speed)


def move_up():
  move_mouse(0, -1)


def move_down():
  move_mouse(0, 1)


def move_left():
  move_mouse(-1, 0)


def move_right():
  move_mouse(1, 0)


def apply_slow():
  global slow_mode
  slow_mode = MODIFIER


def reset_speed():
  global slow_mode
  slow_mode = 1


def on_press(key):
  try:
    if key.char == "k":  # Replace 'k' with your key choice
      threading.Thread(target=move_up).start()
    elif key.char == "j":  # Replace 'j' with your key choice
      threading.Thread(target=move_down).start()
    # Add other key bindings here
  except AttributeError:
    pass


def on_release(key):
  if key == keyboard.Key.esc:
    # Stop listener
    return False


# Collect events until released
with keyboard.Listener(on_press=on_press, on_release=on_release) as listener:
  listener.join()
