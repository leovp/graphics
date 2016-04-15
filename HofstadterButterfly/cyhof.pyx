import cython
from libc.math cimport cos, sin, M_PI

cdef extern from "math.h":
    double M_PI

@cython.cdivision(True)
cdef int gcd(int a, int b):
    while b:
        a, b = b, a % b
    return a

@cython.cdivision(True)
cdef butterfly_iteration(object pixels, int max_x, int max_y, int p, int q, double sigma):
    cdef:
        int n, nold
        int ie, m
        int x, y
        double e

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
            x, y = int(max_y - ie), int(max_x * p / q)
            pixels[x, y] = 255
            pixels[y, x] = 255
        nold = n


def butterfly(object pixels, int max_x, int max_y, int qmax):
    cdef:
        int q, p
        double sigma

    for q in range(4, qmax, 2):
        for p in range(1, q, 2):
            if gcd(p, q) <= 1:
                sigma = 2 * M_PI * p / q
                butterfly_iteration(pixels, max_x, max_y, p, q, sigma)