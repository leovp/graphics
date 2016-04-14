# Hofstadter Butterfly Fractal
# http://en.wikipedia.org/wiki/Hofstadter%27s_butterfly
# Wolfgang Kinzel/Georg Reents,"Physics by Computer" Springer Press (1998)
# FB36 - 20130922
from math import pi, cos
from fractions import gcd
from PIL import Image


def butterfly_iteration(pixels, max_x, max_y, p, q, sigma):
    nold = 0
    for ie in range(0, max_y + 2):
        e = 8.0 * ie / max_y - 4.0 - 4.0 / max_y
        n = 0
        polyold = 1.0
        poly = 2.0 * cos(sigma) - e
        if polyold * poly < 0.0:
            n += 1

        for m in range(2, q // 2):
            polynew = (2.0 * cos(sigma * m) - e) * poly - polyold
            if poly * polynew < 0.0:
                n += 1
            polyold = poly
            poly = polynew

        polyold = 1.0
        poly = 2.0 - e
        if polyold * poly < 0.0:
            n += 1
        polynew = (2.0 * cos(sigma) - e) * poly - 2.0 * polyold
        if poly * polynew < 0.0:
            n += 1
        polyold = poly
        poly = polynew

        for m in range(2, q // 2):
            polynew = (2.0 * cos(sigma * m) - e) * poly - polyold
            if poly * polynew < 0.0:
                n += 1
            polyold = poly
            poly = polynew

        polynew = (2.0 * cos(sigma * q / 2.0) - e) * poly - 2.0 * polyold
        if poly * polynew < 0.0:
            n += 1

        polyold = 1.0
        poly = 2.0 - e
        if polyold * poly < 0.0:
            n += 1
        polynew = (2.0 * cos(sigma) - e) * poly - 2.0 * polyold
        if poly * polynew < 0.0:
            n += 1
        polyold = poly
        poly = polynew

        for m in range(2, q // 2):
            polynew = (2.0 * cos(sigma * m) - e) * poly - polyold
            if poly * polynew < 0.0:
                n += 1
            polyold = poly
            poly = polynew

        polynew = (2.0 * cos(sigma * q / 2.0) - e) * poly - 2.0 * polyold
        if poly * polynew < 0.0:
            n += 1
        if n > nold:
            pixels[int(max_y - ie), int(max_x * p / q)] = 255
            pixels[int(max_x * p / q), int(max_y - ie)] = 255
        nold = n


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
