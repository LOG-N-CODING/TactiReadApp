class BrailleTranslator:
    def __init__(self):
        self.braille_dict = {
            'a': '⠁', 'b': '⠃', 'c': '⠉', 'd': '⠙', 'e': '⠑',
            'f': '⠋', 'g': '⠛', 'h': '⠓', 'i': '⠊', 'j': '⠚',
            'k': '⠅', 'l': '⠇', 'm': '⠍', 'n': '⠝', 'o': '⠕',
            'p': '⠏', 'q': '⠟', 'r': '⠗', 's': '⠎', 't': '⠞',
            'u': '⠥', 'v': '⠧', 'w': '⠺', 'x': '⠭', 'y': '⠽',
            'z': '⠵', ' ': '⠶'
        }

    def text_to_braille(self, text):
        braille_output = ''
        for char in text.lower():
            if char in self.braille_dict:
                braille_output += self.braille_dict[char]
            else:
                braille_output += '?'  # Placeholder for unsupported characters
        return braille_output

    def display_braille(self, text):
        braille_representation = self.text_to_braille(text)
        print(braille_representation)  # This could be replaced with a more sophisticated display method if needed.