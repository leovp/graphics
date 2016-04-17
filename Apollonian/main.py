# Circle Inversion Fractals (Apollonian Gasket) (Escape-time Algorithm)
# FB36 - 20131031
import math
from collections import deque
from PIL import Image

imgx = 512 * 2
imgy = 512 * 2
image = Image.new("RGB", (imgx, imgy))
pixels = image.load()

circles = 3
a = math.pi * 2.0 / circles
r = math.sin(a) / math.sin((math.pi - a) / 2.0) / 2.0 # r of main circles
h = math.sqrt(1.0 - r * r)
xa = -h; xb = h; ya = -h; yb = h # viewing area
cx = [0.0]; cy = [0.0]; cr = [1.0 - r] # center circle
for i in range(circles): # add main circles
    cx.append(math.cos(a * i))
    cy.append(math.sin(a * i))
    cr.append(r)
maxIt = 128 # of iterations
for ky in range(imgy):
    for kx in range(imgx):
        x = float(kx) / (imgx - 1) * (xb - xa) + xa
        y = float(ky) / (imgy - 1) * (yb - ya) + ya
        queue = deque([])
        queue.append((x, y, 0))
        while len(queue) > 0: # iterate points until none left
            (x, y, i) = queue.popleft()
            for k in range(circles + 1):
                dx = x - cx[k]; dy = y - cy[k]
                d = math.hypot(dx, dy)
                if d <= cr[k]:
                    dx = dx / d; dy = dy / d
                    dnew = cr[k] ** 2.0 / d
                    xnew = dnew * dx + cx[k]
                    ynew = dnew * dy + cy[k]
                    if xnew >= xa and xnew <= xb and ynew >= ya and ynew <= yb:
                        if i + 1 == maxIt: break
                        queue.append((xnew, ynew, i + 1))
        pixels[kx, ky] = (i % 16 * 16 , i % 8 * 32, i % 4 * 64)
image.save('result.png')
