from math import cos, sin, sqrt, hypot, pi
from collections import deque


def appolonian(pixels, img_size, max_it):
    circles = 3
    a = pi * 2.0 / circles
    r = sin(a) / sin((pi - a) / 2.0) / 2.0  # r of main circles
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

    for ky in range(imgy):
            for kx in range(img_size):
                x = float(kx) / (img_size - 1) * (xb - xa) + xa
                y = float(ky) / (img_size - 1) * (yb - ya) + ya
                queue = deque([])
                queue.append((x, y, 0))
                while len(queue) > 0:  # iterate points until none left
                    (x, y, i) = queue.popleft()
                    for k in range(circles + 1):
                        dx = x - cx[k]
                        dy = y - cy[k]
                        d = hypot(dx, dy)
                        if d <= cr[k]:
                            dx /= d
                            dy /= d
                            dnew = cr[k] ** 2.0 / d
                            xnew = dnew * dx + cx[k]
                            ynew = dnew * dy + cy[k]
                            if xa <= xnew <= xb and ya <= ynew <= yb:
                                if i + 1 == max_it:
                                    break

                                queue.append((xnew, ynew, i + 1))
                pixels[kx, ky] = (i % 16 * 16, i % 8 * 32, i % 4 * 64)