import svgwrite
import subprocess

def find_row_numbers(text_file, words):
    row_numbers = []
    with open(text_file, 'r') as f:
        lines = f.readlines()
        for word in words:
            found = False
            for i, line in enumerate(lines):
                if word in line.split():
                    row_numbers.append(i)
                    found = True
                    break
            if not found:
                row_numbers.append(-1)  # If word is not found, use -1 as placeholder
    return row_numbers

def convert_to_11_bit_binary(row_numbers):
    binary_numbers = []
    for row in row_numbers:
        if row == -1:
            binary_numbers.append('0' * 11)  # For words not found, append 11 zeros
        else:
            binary = bin(row)[2:]  # Remove '0b' prefix
            binary = binary.zfill(11)  # Ensure it's 11 bits long
            binary_numbers.append(binary)
    return binary_numbers

def generate_svg(binary_matrix, filename):
    # Determine size of the SVG based on number of words and bits per word
    word_count = len(binary_matrix)
    bit_count = len(binary_matrix[0])
    
    # Create an SVG drawing object
    dwg = svgwrite.Drawing(filename, size=(bit_count * 20, word_count * 20))
    
    # Draw the matrix of squares
    for i, row in enumerate(binary_matrix):
        for j, bit in enumerate(row):
            color = "black" if bit == '1' else "white"
            dwg.add(dwg.rect(insert=(j * 20, i * 20), size=(20, 20), fill=color, stroke="black", stroke_width=1))
    
    # Save the SVG file
    dwg.save()

# List of words to search for in the text file
#words = ['ability', 'able', 'above', 'absurd', 'acoustic', 'advice', 'amount', 'avoid', 'cactus', 'divorce', 'length']
with open('secret', 'r') as file:
    for line in file:
        words = line.split(':')[1].strip().split()

# Path to your text file
text_file = 'bip-0039-wordlist-english.txt'

# Step 1: Find row numbers where words are located
row_numbers = find_row_numbers(text_file, words)

# Step 2: Convert row numbers to 11-bit binary
binary_matrix = convert_to_11_bit_binary(row_numbers)

# Step 3: Generate and save the SVG
generate_svg(binary_matrix, 'matrix.svg')

command = "rsvg-convert -f pdf -o matrix.pdf matrix.svg"
result = subprocess.run(command, shell=True, capture_output=True, text=True)

if result.returncode == 0:
    print("Command executed successfully.")  
    print(result.stdout)
else:
    print("Command failed.")
    print(result.stderr)   
