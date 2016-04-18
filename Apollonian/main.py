# Circle Inversion Fractals (Apollonian Gasket) (Escape-time Algorithm)
# FB36 - 20131031
from PIL import Image
from cygasket import appolonian


def main():
    img_size = 512 * 2
    image = Image.new("RGB", (img_size, img_size))
    pixels = image.load()

    max_it = 128  # of iterations
    appolonian(pixels, img_size, max_it)
    image.save('result.png')

if __name__ == '__main__':
    main()
