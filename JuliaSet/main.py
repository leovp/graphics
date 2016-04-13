#!/usr/bin/env python
from PIL import Image
from cyfrac import draw_mandelbrot

size = 4096
scale = 1.0 / (size / 3.0)

def main():
    raw_data = draw_mandelbrot(scale, size)
    data = raw_data.tostring()
    img = Image.frombytes('RGB', (size, size), data, decoder_name='raw')
    img.save("result.png")

if __name__ == '__main__':
    main()
