from PIL import Image, ImageDraw, ImageFont

class DocumentProcessor:
    def __init__(self):
        self.text = ""
        self.image = None  # Store the graphical representation

    def load_document(self, file_path):
        if file_path.endswith('.pdf'):
            self.extract_text_from_pdf(file_path)
        elif file_path.endswith('.txt'):
            self.extract_text_from_txt(file_path)
        else:
            raise ValueError("Unsupported file format. Please provide a PDF or TXT file.")

    def extract_text_from_pdf(self, file_path):
        from PyPDF2 import PdfReader
        reader = PdfReader(file_path)
        self.text = ""
        for page in reader.pages:
            page_text = page.extract_text()
            if page_text:
                self.text += page_text + "\n"

    def extract_text_from_txt(self, file_path):
        with open(file_path, 'r', encoding='utf-8') as file:
            self.text = file.read()

    def display_text(self):
        print(self.text)

    def text_to_image(self, width=800, height=1000, font_size=20):
        """
        Converts the extracted text to a graphical image representation with natural line wrapping.
        Stores the image in self.image and returns it.
        """
        if not self.text:
            raise ValueError("No text loaded. Please load a document first.")

        image = Image.new('RGB', (width, height), color='white')
        draw = ImageDraw.Draw(image)

        try:
            font = ImageFont.truetype("arial.ttf", font_size)
        except IOError:
            font = ImageFont.load_default()

        margin = 10
        offset = margin
        max_width = width - 2 * margin

        # Wrap each paragraph by pixel width
        for paragraph in self.text.split('\n'):
            line = ""
            for word in paragraph.split(' '):
                test_line = line + (' ' if line else '') + word
                if draw.textlength(test_line, font=font) <= max_width:
                    line = test_line
                else:
                    draw.text((margin, offset), line, font=font, fill='black')
                    offset += font_size + 5
                    line = word
                    if offset > height - margin:
                        break
            if line:
                draw.text((margin, offset), line, font=font, fill='black')
                offset += font_size + 5
                if offset > height - margin:
                    break
            # Add extra space between paragraphs
            offset += 5

        self.image = image
        return image

    def resize_image(self, new_width=100, new_height=100):
        """
        Resizes the text image to lower pixel dimensions, similar to ImageProcessor.
        Stores the resized image in self.image and returns it.
        """
        if self.image is None:
            raise ValueError("No image to resize. Please convert text to image first.")

        # Maintain aspect ratio
        original_width, original_height = self.image.size
        original_ratio = original_width / original_height
        target_ratio = new_width / new_height

        if original_ratio > target_ratio:
            scale_width = new_width
            scale_height = int(new_width / original_ratio)
        else:
            scale_height = new_height
            scale_width = int(new_height * original_ratio)

        scaled_image = self.image.resize((scale_width, scale_height), Image.Resampling.LANCZOS)
        final_image = Image.new('RGB', (new_width, new_height), 'white')
        x_offset = (new_width - scale_width) // 2
        y_offset = (new_height - scale_height) // 2
        final_image.paste(scaled_image, (x_offset, y_offset))

        self.image = final_image
        return final_image

    def get_image(self):
        return self.image