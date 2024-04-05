import os
import shutil
import ExcelManager
import XmlManager


def remove_old_zip(starting_folder):
    for root, dirs, files in os.walk(starting_folder):
        for file in files:
            if file.endswith('_1_M.zip'):
                file_path = os.path.join(root, file)
                os.remove(file_path)


def compress_folder(starting_folder):
    for root, dirs, files in os.walk(starting_folder):
        for dir_name in dirs:
            if dir_name.endswith('_1_M'):
                folder_path = os.path.join(root, dir_name)
                zip_path = os.path.join(root, dir_name.replace('_1_M', '_2_M'))
                shutil.make_archive(zip_path, 'zip', folder_path)
                shutil.rmtree(folder_path)


def decompress_folder(starting_folder):
    for root, dirs, files in os.walk(starting_folder):
        for file in files:
            if file.endswith('.zip'):
                zip_path = os.path.join(root, file)
                folder_name = os.path.splitext(file)[0]
                destination_folder = os.path.join(root, folder_name)

                if not os.path.exists(destination_folder):
                    os.makedirs(destination_folder)

                shutil.unpack_archive(zip_path, destination_folder)


def rename_all(starting_folder):
    for root, dirs, files in os.walk(starting_folder):
        for file in files:
            if file.endswith('_1_M.xml'):
                old_file_path = os.path.join(root, file)
                new_file_path = os.path.join(root, file.replace('_1_M.xml', '_2_M.xml'))
                os.rename(old_file_path, new_file_path)


def modify_all(starting_folder):
    for root, dirs, files in os.walk(starting_folder):
        for file in files:
            if file.endswith('_2_M.xml'):
                file_path = os.path.join(root, file)
                e=XmlManager.XmlManager(file_path)
                e.check_and_update_data()


def move_zip_into_pool(starting_folder, pool_folder):
    if not os.path.exists(pool_folder):
        os.makedirs(pool_folder)

    for root, dirs, files in os.walk(starting_folder):
        for file in files:
            if file.endswith('_2_M.zip'):
                shutil.copyfile(os.path.join(root, file), os.path.join(pool_folder, file))


# def replace_flusso(starting_folder):



starting_folder = "NEXTCLOUD"
pool_folder = "POOL"

ExcelManager.ExcelManager.initialize()
XmlManager.XmlManager.clear_logging_file()
decompress_folder(starting_folder)
rename_all(starting_folder)
modify_all(starting_folder)
# replace_flusso(starting_folder)
compress_folder(starting_folder)
remove_old_zip(starting_folder)
move_zip_into_pool(starting_folder, pool_folder)