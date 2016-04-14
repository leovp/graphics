# Hofstadter Butterfly Fractal
# http://en.wikipedia.org/wiki/Hofstadter%27s_butterfly
# Wolfgang Kinzel/Georg Reents,"Physics by Computer" Springer Press (1998)
# FB36 - 20130922
from math import pi, cos
from fractions import gcd
from PIL import Image
from cyhof import butterfly_iteration


def main():
    img_size = 200
    image = Image.new("L", (img_size, img_size))
    pixels = image.load()

    pi2 = pi * 2.0
    max_x = img_size + 1
    max_y = img_size + 1
    qmax = img_size
    for q in range(4, qmax, 2):
        for p in range(1, q, 2):
            if gcd(p, q) <= 1:
                sigma = pi2 * p / q
                butterfly_iteration(pixels, max_x, max_y, p, q, sigma)

    image.save("HofstadterButterflyFractal.png", "PNG")


if __name__ == '__main__':
    main()
