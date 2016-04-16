import cython

from cpython cimport array
import array

from libc.stdlib cimport rand, srand
cdef extern from "limits.h":
    int INT_MAX

from libc.math cimport cos, sin
cdef extern from "math.h":
    double M_PI

@cython.cdivision(True)
@cython.boundscheck(False)
cdef double random():
    return rand() / <double>INT_MAX

@cython.cdivision(True)
@cython.boundscheck(False)
cdef int randint(int min, int max):
    return rand() % (max - min) + min

@cython.cdivision(True)
@cython.boundscheck(False)
@cython.wraparound(False)
def generate_spirals(int imgx, int imgy, int seed):
    srand(seed)

    cdef array.array output = array.array('B')
    array.resize(output, imgx * imgy)
    cdef unsigned char[:] out = output

    cdef:
        int iterations, idx, k, kx, ky
        double a, t, tc, ts, r0, r1, p0, x, y

    arms = randint(2, 9)
    iterations = imgx * imgy

    a = 2.0 * M_PI / arms
    t = 2.0 * M_PI * random()  # Rotation angle of central copy

    ts = sin(t)
    tc = cos(t)

    r1 = 0.2 * random() + 0.1                           # Scale factor of outmost copies on the spiral arms
    r0 = 1.0 - r1                                       # Scale factor of central copy
    p0 = r0 ** 2.0 / (arms * r1 ** 2.0 + r0 ** 2.0)     # Probability of central copy

    x = 0.0
    y = 0.0
    for i in range(iterations):
        if random() < p0:               # Central copy
            x *= r0                     # Scaling
            y *= r0

            h = x * tc - y * ts         # Rotation
            y = x * ts + y * tc
            x = h
        else:                           # Outmost copies on the spiral arms
            k = randint(0, arms - 1)    # Select an arm
            c = k * a                   # Angle

            x = x * r1 + cos(c)         # Scaling and translation
            y = y * r1 + sin(c)

        kx = <int>((x + 2.0) / 4.0 * (imgx - 1))
        ky = <int>((y + 2.0) / 4.0 * (imgy - 1))

        idx = ky * imgx + kx
        out[idx] = 255

    return output
