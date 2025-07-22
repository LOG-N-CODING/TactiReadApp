class Visualizer:
    def display_images(self, images, titles=None):
        import matplotlib.pyplot as plt
        
        num_images = len(images)
        
        # Set default titles if none provided
        if titles is None:
            titles = [f'Image {i+1}' for i in range(num_images)]
        
        # Create subplots based on number of images
        if num_images <= 4:
            cols = num_images
            rows = 1
        else:
            cols = 4
            rows = (num_images + 3) // 4  # Ceiling division
        
        fig, axes = plt.subplots(rows, cols, figsize=(4*cols, 4*rows))
        
        # Handle single image case
        if num_images == 1:
            axes = [axes]
        elif rows == 1:
            axes = axes if hasattr(axes, '__iter__') else [axes]
        else:
            axes = axes.flatten()
        
        # Display each image
        for i, (image, title) in enumerate(zip(images, titles)):
            axes[i].imshow(image, cmap='gray')
            axes[i].set_title(title)
            axes[i].axis('off')
        
        # Hide unused subplots
        for i in range(num_images, len(axes)):
            axes[i].axis('off')
        
        plt.tight_layout()
        plt.show()