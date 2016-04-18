import cython

from libc.math cimport cos, sin, sqrt, hypot
cdef extern from "math.h":
    double M_PI

from collections import deque

@cython.boundscheck(False)
@cython.wraparound(False)
@cython.cdivision(True)
def appolonian(object pixels, int img_size, int max_it):
    cdef:
        int circles
        double a, r, h
        double xa, xb, ya, yb
        list cx, cy, cr

        double x, y, dx, dy, d
        double xnew, ynew, dnew
        int i
        double cxk, cyk, crk

    circles = 3
    a = M_PI * 2.0 / circles
    r = sin(a) / sin((M_PI - a) / 2.0) / 2.0  # r of main circles
    h = sqrt(1.0 - r * r)

    # center circle
    cx = [0.0]
    cy = [0.0]
    cr = [1.0 - r]

    for i in range(circles):  # add main circles
        cx.append(cos(a * i))
        cy.append(sin(a * i))
        cr.append(r)

    # viewing area
    xa = -h
    xb = h
    ya = -h
    yb = h

    for ky in range(img_size):
            for kx in range(img_size):
                x = float(kx) / (img_size - 1) * (xb - xa) + xa
                y = float(ky) / (img_size - 1) * (yb - ya) + ya
                queue = deque()
                queue.append((x, y, 0))
                while len(queue) > 0:  # iterate points until none left
                    (x, y, i) = queue.popleft()
                    for k in range(circles + 1):
                        cxk = cx[k]
                        cyk = cy[k]
                        crk = cr[k]

                        dx = x - cxk
                        dy = y - cyk
                        d = hypot(dx, dy)
                        if d <= crk:
                            dx /= d
                            dy /= d
                            dnew = crk ** 2.0 / d
                            xnew = dnew * dx + cxk
                            ynew = dnew * dy + cyk
                            if xa <= xnew <= xb and ya <= ynew <= yb:
                                if i + 1 == max_it:
                                    break

                                queue.append((xnew, ynew, i + 1))
                pixels[kx, ky] = (i % 16 * 16, i % 8 * 32, i % 4 * 64)