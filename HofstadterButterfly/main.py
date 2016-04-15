# Hofstadter Butterfly Fractal
# http://en.wikipedia.org/wiki/Hofstadter%27s_butterfly
# Wolfgang Kinzel/Georg Reents,"Physics by Computer" Springer Press (1998)
# FB36 - 20130922
from math import pi, cos
from PIL import Image
from cyhof import butterfly


def main():
    img_size = 256
    image = Image.new("L", (img_size, img_size))
    pixels = image.load()

    max_x = img_size + 1
    max_y = img_size + 1
    qmax = img_size
    butterfly(pixels, img_size)

    image.save("HofstadterButterflyFractal.png", "PNG")


if __name__ == '__main__':
    main()
