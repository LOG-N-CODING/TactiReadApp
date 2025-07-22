# Braille Reader

## Overview
The Braille Reader project is designed to convert standard image files (such as JPG, PNG, and PDF) into a format suitable for Braille e-readers. The software processes images by converting them to black and white, resizing them to a specified resolution, and representing them as a matrix of boolean values. This project aims to enhance accessibility for visually impaired users by providing a means to read visual content in a tactile format.

## Features
- Load images from various formats (JPG, PNG, PDF).
- Convert images to black and white using a customizable threshold.
- Resize images while maintaining the aspect ratio.
- Output images as a matrix of boolean values, where `True` represents a black pixel and `False` represents a white pixel.
- Visualize original and converted images side by side for comparison.

## Installation
To install the required dependencies, run the following command:

```
pip install -r requirements.txt
```

## Usage
1. **Load an Image**: Use the `ImageProcessor` class to load an image from a specified file path.
2. **Convert to Black and White**: Apply the `convert_to_bw` method with a desired threshold to convert the image.
3. **Resize the Image**: Use the `resize_image` method to adjust the image to the desired resolution.
4. **Convert to Matrix**: Utilize the `Converter` class to convert the processed image into a boolean matrix.
5. **Visualize**: Use the `Visualizer` class to display the original and converted images side by side.

## Example
Refer to the Jupyter notebook located in the `notebooks` directory for practical examples of how to use the classes and methods provided in this project.

## Contributing
Contributions are welcome! Please feel free to submit a pull request or open an issue for any enhancements or bug fixes.

## License
This project is licensed under the MIT License. See the LICENSE file for more details.