import os
from PIL import Image

def convert_to_a4_300dpi(src_path, out_path):
    # Load the PlantUML output
    src = Image.open(src_path).convert('RGB')
    print(f'Original size of {src_path}: {src.size}')

    # Create A4 300 DPI Canvas (2480x3508)
    page = Image.new('RGB', (2480, 3508), 'white')

    # Scale the diagram down to leave safe margins (max 2320 width, 3308 height)
    src.thumbnail((2320, 3308), Image.Resampling.LANCZOS)
    print(f'Resized size: {src.size}')

    # Center the diagram
    x = (2480 - src.width) // 2
    y = (3508 - src.height) // 2
    page.paste(src, (x, y))

    # Save with 300 DPI metadata
    page.save(out_path, dpi=(300, 300))
    print(f'Saved A4 Diagram to: {out_path}')

if __name__ == '__main__':
    convert_to_a4_300dpi('docs/uml/activity_kelola_akun.png', 'docs/uml/activity_kelola_akun_A4.png')
    convert_to_a4_300dpi('docs/uml/activity_kelola_alamat.png', 'docs/uml/activity_kelola_alamat_A4.png')
