from colorsys import hsv_to_rgb
import cython
from cpython cimport array
import array

@cython.cdivision(True)
@cython.boundscheck(False)
cdef int make_palette(unsigned char [:] ra, unsigned char [:] ga, unsigned char [:] ba):
    cdef:
        unsigned int i
        double f, r, g, b

    for i in range(200):
        f = 1 - abs((<double>i / 200 - 1) ** 15)
        r, g, b = hsv_to_rgb(0.66 + f / 3.0, 1 - f / 2.0, f)
        ra[i] = int(r * 255)
        ga[i] = int(g * 255)
        ba[i] = int(b * 255)

    return 0

@cython.cdivision(True)
cdef double iterate_mandelbrot(double cr, double ci, double zr, double zi):
    cdef unsigned int n
    for n in range(175 + 1):
        zr, zi = (zr * zr - zi * zi + cr, 2 * zr * zi + ci)

        if zr * zr + zi * zi > 4.0:
            return n / 150.0

@cython.boundscheck(False)
def draw_mandelbrot(double scale, unsigned int size):
    cdef array.array output = array.array('B')
    array.resize(output, size * size * 3)
    cdef unsigned char[:] out = output

    cdef array.array ra = array.array('B')
    array.resize(ra, 200)
    cdef unsigned char[:] r = ra

    cdef array.array ga = array.array('B')
    array.resize(ga, 200)
    cdef unsigned char[:] g = ga

    cdef array.array ba = array.array('B')
    array.resize(ba, 200)
    cdef unsigned char[:] b = ba

    make_palette(r, g, b)

    cdef:
        unsigned int colors_max
        unsigned int pos, x, y
        double zr, zi, v
        unsigned int color_id

    colors_max = 200
    pos = 0

    # Draw our image
    for y in range(size):
        for x in range(size):
            zr = x * scale - 1.5
            zi = y * scale - 1.5
            v = iterate_mandelbrot(0.3, 0.6, zr, zi)

            color_id = int(v * (colors_max - 1))
            if color_id > colors_max - 1:
                color_id = colors_max - 1

            out[pos] = r[color_id]
            out[pos+1] = g[color_id]
            out[pos+2] = b[color_id]
            pos += 3

    return output
