from setuptools import setup, find_packages

setup(
    name='braille-reader',
    version='0.1.0',
    author='Your Name',
    author_email='your.email@example.com',
    description='A software for converting images and documents to a format suitable for Braille e-readers.',
    packages=find_packages(where='src'),
    package_dir={'': 'src'},
    install_requires=[
        'Pillow',
        'matplotlib',
        'numpy',
        'PyPDF2',  # For PDF handling
        'python-docx',  # For DOCX handling if needed
        'braille',  # Hypothetical library for Braille translation
    ],
    classifiers=[
        'Programming Language :: Python :: 3',
        'License :: OSI Approved :: MIT License',
        'Operating System :: OS Independent',
    ],
    python_requires='>=3.6',
)