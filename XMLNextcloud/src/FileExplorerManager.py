import os
import shutil
import XmlManager


def remove_old_zip(starting_folder):
    # Traversa ogni dir
    for root, dirs, files in os.walk(starting_folder):
        for file in files:
            # Controlla se il nome della cartella termina con '_1_M'
            if file.endswith('_1_M.zip'):
                file_path = os.path.join(root, file)
                os.remove(file_path)


def compress_folder(starting_folder):
    # Traversa ogni dir
    for root, dirs, files in os.walk(starting_folder):
        for dir_name in dirs:
            # Controlla se il nome della cartella termina con '_1_M'
            if dir_name.endswith('_1_M'):
                # Crea il percorso completo della cartella da comprimere
                folder_path = os.path.join(root, dir_name)
                # Crea il percorso completo per l'archivio zip di destinazione
                zip_path = os.path.join(root, dir_name.replace('_1_M', '_2_M'))
                # Comprimi la cartella in un archivio zip
                shutil.make_archive(zip_path, 'zip', folder_path)
                # Rimuovi la cartella dopo la compressione
                shutil.rmtree(folder_path)


def decompress_folder(starting_folder):
    # traversa ogni dir
    for root, dirs, files in os.walk(starting_folder):
        for file in files:
            if file.endswith('.zip'):
                zip_path = os.path.join(root, file)
                # prende solo il nome, senza estensione
                folder_name = os.path.splitext(file)[0]
                # folder_name = folder_name.replace('_1_M', '_2_M')
                destination_folder = os.path.join(root, folder_name)
                # Crea la cartella di destinazione se non esiste già
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
                print(file_path)
                e=XmlManager.XmlManager(file_path)
                e.check_and_update_data()


starting_folder = "NEXTCLOUD"

decompress_folder(starting_folder)
rename_all(starting_folder)
modify_all(starting_folder)
compress_folder(starting_folder)
remove_old_zip(starting_folder)
