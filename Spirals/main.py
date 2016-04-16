# Random Spiral IFS Fractals
import time
from PIL import Image
from cyspirals import generate_spirals

if __name__ == '__main__':
    size = 4096

    raw_data = generate_spirals(size, size, seed=time.time())
    data = raw_data.tostring()

    img = Image.frombytes('L', (size, size), data, decoder_name='raw')
    img.save('result.png')
