from PIL import Image
import os

def split_image(input_path, output_path1, output_path2, height1, height2):
    original_image = Image.open(input_path).convert("RGBA")

    width, total_height = original_image.size

    transparent_first_half = Image.new("RGBA", (width, total_height), (0, 0, 0, 0))
    transparent_second_half = Image.new("RGBA", (width, total_height), (0, 0, 0, 0))

    transparent_first_half.paste(original_image.crop((0, 0, width, height1)), (0, 0))
    transparent_second_half.paste(original_image.crop((0, total_height - height2, width, total_height)), (0, height1))

    transparent_first_half.save(output_path1)
    transparent_second_half.save(output_path2)


if __name__ == "__main__":
    input_image_name = "back.png"
    output_image_name1 = "back1.png"
    output_image_name2 = "back.png"
    height_first_half = 418
    height_second_half = 302

    main_directory = input("Qual diretorio? ")

    for folder in os.listdir(main_directory):
        folder_path = os.path.join(main_directory, folder)

        if os.path.isdir(folder_path):
            input_image_path = os.path.join(folder_path, input_image_name)
            output_image_path1 = os.path.join(folder_path, output_image_name1)
            output_image_path2 = os.path.join(folder_path, output_image_name2)

            split_image(input_image_path, output_image_path1, output_image_path2, height_first_half, height_second_half)





