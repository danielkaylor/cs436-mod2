import RPi.GPIO as GPIO
import time

# Pin 27 = Toggle
# Pin 23 = X
# Pin 22 = Y
# Pin 17 = Button

GPIO.setmode(GPIO.BCM)
pins = [17, 22, 23, 27]
names = ['Button', 'Y', 'X', 'Toggle']

for pin in pins:
    GPIO.setup(pin, GPIO.IN, pull_up_down=GPIO.PUD_DOWN)

GPIO.add_event_detect(17, GPIO.RISING)
GPIO.add_event_detect(22, GPIO.RISING)
GPIO.add_event_detect(23, GPIO.RISING)

X = False
Y = False
Button = False

while(True):
    Y = GPIO.event_detected(22)
    X = GPIO.event_detected(23)
    Button = GPIO.event_detected(17)
    str = ''
    if (Y):
        str += 'Y is Pressed! | '
    if (X):
        str += 'X is Pressed! | '
    if (Button):
        str += 'Button is Pressed! | '
    if (toggle != GPIO.input(27)):
        toggle = GPIO.input(27)
        str += 'Toggle changed state!'
    if (not str == ''):
        print(str)
    time.sleep(1)