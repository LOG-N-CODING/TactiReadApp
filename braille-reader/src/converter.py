class Converter:
    def __init__(self, image_processor):
        self.image_processor = image_processor

    def image_to_matrix(self):
        bw_image = self.image_processor.image
        if bw_image is None:
            raise ValueError("No image has been processed. Please load and convert an image first.")

        width, height = bw_image.size
        matrix = []
        
        for y in range(height):
            row = []
            for x in range(width):
                pixel = bw_image.getpixel((x, y))
                row.append(pixel == 0)  # True for black, False for white
            matrix.append(row)
        
        return matrix

    def document_to_text(self, document_path):
        import os
        from PyPDF2 import PdfReader
        
        if not os.path.exists(document_path):
            raise FileNotFoundError(f"The document {document_path} does not exist.")
        
        text = ""
        if document_path.endswith('.pdf'):
            with open(document_path, 'rb') as file:
                reader = PdfReader(file)
                for page in reader.pages:
                    text += page.extract_text() + "\n"
        elif document_path.endswith('.txt'):
            with open(document_path, 'r', encoding='utf-8') as file:
                text = file.read()
        else:
            raise ValueError("Unsupported document format. Please provide a PDF or TXT file.")
        
        return text

    def display_text(self, text):
        print(text)  # Simple console output for demonstration purposes.