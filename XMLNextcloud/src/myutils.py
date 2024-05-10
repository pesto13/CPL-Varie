import os
import shutil
import XmlManager


def remove_old_zip(starting_folder):
    for root, dirs, files in os.walk(starting_folder):
        for file in files:
            if file.endswith('_1_M.zip') or file.endswith('_1.zip'):
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
            elif dir_name.endswith('_1'):
                folder_path = os.path.join(root, dir_name)
                zip_path = os.path.join(root, dir_name.replace('_1', '_2'))
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
            if file.endswith('_1.xml'):
                old_file_path = os.path.join(root, file)
                new_file_path = os.path.join(root, file.replace('_1.xml', '_2.xml'))
                os.rename(old_file_path, new_file_path)

def modify_all(starting_folder):
    for root, dirs, files in os.walk(starting_folder):
        for file in files:
            if file.endswith('_2_M.xml'):
                file_path = os.path.join(root, file)
                e=XmlManager.XmlManager(file_path)
                e.check_and_update_data()

def modify_all_secondo(starting_folder):
    for root, dirs, files in os.walk(starting_folder):
        for file in files:
            if file.endswith('_2.xml'):
                file_path = os.path.join(root, file)
                e=XmlManager.XmlManager(file_path)
                data = e.add_value_to_tag_data_misura()

                with open(file_path, 'r') as f:
                    lines = f.readlines()

                with open(file_path, 'w') as f:
                    for line in lines:
                        if '<data_misura />' in line:
                            line = line.replace('<data_misura />', f'<data_misura>{data}<data_misura />')
                        f.write(line)
                

def move_zip_into_pool(starting_folder, pool_folder):
    if not os.path.exists(pool_folder):
        os.makedirs(pool_folder)

    for root, dirs, files in os.walk(starting_folder):
        for file in files:
            if file.endswith('_2_M.zip') or file.endswith('_2.zip'):
                shutil.copyfile(os.path.join(root, file), os.path.join(pool_folder, file))

def replace_flusso(starting_folder):
    for root, dirs, files in os.walk(starting_folder):
        for file in files:
            if file.endswith('_2_M.xml') or file.endswith('_2.xml'):
                filename = os.path.join(root, file)
                replace_flusso_in_file(filename)

def replace_flusso_in_file(filename):
    with open(filename, 'r') as f:
        lines = f.readlines()

    with open(filename, 'w') as f:
        for line in lines:
            # Trova la riga che contiene <FlussoMisure cod_flusso="TML">
            if '<FlussoMisure cod_flusso="TML">' in line:
                # Sostituisci con <FlussoMisure xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" cod_flusso="TML">
                line = line.replace('<FlussoMisure cod_flusso="TML">', '<FlussoMisure xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" cod_flusso="TML">')
            f.write(line)