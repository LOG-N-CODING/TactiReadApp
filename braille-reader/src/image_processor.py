from PIL import Image

class ImageProcessor:
    def __init__(self):
        self.image = None

    def load_image(self, file_path):
        self.image = Image.open(file_path)

    def convert_to_bw(self, threshold=128):
        if self.image is None:
            raise ValueError("No image loaded. Please load an image first.")
        bw_image = self.image.convert("L")  # Convert to grayscale
        bw_image = bw_image.point(lambda x: 255 if x > threshold else 0, '1')  # Apply threshold
        self.image = bw_image

    def resize_image(self, new_width=100, new_height=100):
        if self.image is None:
            raise ValueError("No image loaded. Please load an image first.")
        
        # Calculate aspect ratios
        original_width, original_height = self.image.size
        original_ratio = original_width / original_height
        target_ratio = new_width / new_height
        
        # Determine scaling factor to fit within bounds while maintaining aspect ratio
        if original_ratio > target_ratio:
            # Image is wider, scale based on width
            scale_width = new_width
            scale_height = int(new_width / original_ratio)
        else:
            # Image is taller, scale based on height
            scale_height = new_height
            scale_width = int(new_height * original_ratio)
        
        # Resize the image maintaining aspect ratio
        scaled_image = self.image.resize((scale_width, scale_height), Image.Resampling.LANCZOS)
        
        # Create new image with target dimensions and white background
        final_image = Image.new('1' if self.image.mode == '1' else 'RGB', (new_width, new_height), 'white')
        
        # Calculate position to center the scaled image
        x_offset = (new_width - scale_width) // 2
        y_offset = (new_height - scale_height) // 2
        
        # Paste the scaled image onto the white background
        final_image.paste(scaled_image, (x_offset, y_offset))
        
        self.image = final_image

    def get_image(self):
        return self.image