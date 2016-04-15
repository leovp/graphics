# Hofstadter Butterfly Fractal
# http://en.wikipedia.org/wiki/Hofstadter%27s_butterfly
# Wolfgang Kinzel/Georg Reents,"Physics by Computer" Springer Press (1998)
# FB36 - 20130922
from math import pi, cos
from PIL import Image
from cyhof import butterfly


def main():
    img_size = 256
    raw_data = butterfly(img_size)
    data = raw_data.tostring()

    img = Image.frombytes('L', (img_size, img_size), data, decoder_name='raw')
    img.save('result.png')


if __name__ == '__main__':
    main()
