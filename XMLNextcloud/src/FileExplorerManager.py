"""Module for interact with the OS"""

import os
import shutil
import XmlManager


class FileExplorerManager:
    """Class for interact with the OS"""

    def __init__(self, ends_with, starting_folder):
        # ends_with prende tipo _1M oppure 1_M. Dipende
        self.ends_with = ends_with
        #TODO potrebbe essere meglio
        self.new_ends_with = self.ends_with.replace('1', '2')
        self.starting_folder = starting_folder


    def decompress_folder(self):
        """Decompress all zip archieves.

        When they come they are all in zip files, we have to decompress em all.
        """
        for root, _, files in os.walk(self.starting_folder):
            for file in files:
                if file.endswith('.zip'):
                    zip_path = os.path.join(root, file)
                    folder_name = os.path.splitext(file)[0]
                    destination_folder = os.path.join(root, folder_name)

                    if not os.path.exists(destination_folder):
                        os.makedirs(destination_folder)

                    shutil.unpack_archive(zip_path, destination_folder)


    def remove_old_zip(self):
        """Removes all older zip archieves.

        When extracted they are duplicated, so we make rid of em.
        """
        for root, _, files in os.walk(self.starting_folder):
            for file in files:
                if file.endswith(self.ends_with+'.zip'):
                    file_path = os.path.join(root, file)
                    os.remove(file_path)


    def rename_all(self):
        """Rename all XML files.

        When uploaded to Nextcloud they whant a different name, incremental value suggested
        """
        for root, _, files in os.walk(self.starting_folder):
            for file in files:
                if file.endswith(self.ends_with+'.xml'):
                    old_file_path = os.path.join(root, file)
                    new_file_path = os.path.join(root, file.replace(self.ends_with+'.xml',
                                                                    self.new_ends_with+'.xml'))
                    os.rename(old_file_path, new_file_path)


    def compress_folder(self):
        """Compress all XML file.

        Since they come all zipped, we re-zip all the renamed xml files
        """
        for root, dirs, _ in os.walk(self.starting_folder):
            for dir_name in dirs:
                if dir_name.endswith(self.ends_with):
                    folder_path = os.path.join(root, dir_name)
                    zip_path = os.path.join(root, dir_name.replace(self.ends_with,
                                                                   self.new_ends_with))
                    shutil.make_archive(zip_path, 'zip', folder_path)
                    shutil.rmtree(folder_path)


    def modify_all(self):
        """Updates dates according to Excel file.

        That's the core of the Activity.
        """
        for root, _, files in os.walk(self.starting_folder):
            for file in files:
                if file.endswith(self.new_ends_with+'.xml'):
                    file_path = os.path.join(root, file)
                    e=XmlManager.XmlManager(file_path)
                    e.check_and_update_data()


    def modify_all_secondo(self):
        """TODO
        """
        for root, _, files in os.walk(self.starting_folder):
            for file in files:
                if file.endswith(self.new_ends_with+'.xml'):
                    file_path = os.path.join(root, file)
                    e=XmlManager.XmlManager(file_path)
                    data = e.add_value_to_tag_data_misura()

                    with open(file_path, 'r', encoding='utf-8') as f:
                        lines = f.readlines()

                    with open(file_path, 'w', encoding='utf-8') as f:
                        for line in lines:
                            if '<data_misura />' in line:
                                line = line.replace('<data_misura />',
                                                    f'<data_misura>{data}</data_misura>')
                            f.write(line)


    def move_zip_into_pool(self, pool_folder):
        """Takes all zip files and moves em in a new Folder.

        Vanessa prefers all the zipped file in a giant pool,
        it's easier insted of having zipped file in a tree.
        """
        if not os.path.exists(pool_folder):
            os.makedirs(pool_folder)

        for root, _, files in os.walk(self.starting_folder):
            for file in files:
                if file.endswith(self.new_ends_with+'.zip'):
                    shutil.copyfile(os.path.join(root, file), os.path.join(pool_folder, file))


    def replace_line_all_file(self, old_line, new_line):
        """Modify the header of the XML file.

        When ovverriding the xml file it delets the header,
        we make sure it's in his correct form.
        """
        for root, _, files in os.walk(self.starting_folder):
            for file in files:
                if file.endswith(self.new_ends_with+'.xml'):
                    filename = os.path.join(root, file)
                    self._replace_line_in_file(filename, old_line, new_line)


    @staticmethod
    def _replace_line_in_file(filename, old_line, new_line):
        """replace a line in the file header

        Args:
            filename (_type_): _description_
        """
        with open(filename, 'r', encoding='utf-8') as f:
            lines = f.readlines()

        with open(filename, 'w', encoding='utf-8') as f:
            for line in lines:
                # Trova la riga che contiene <FlussoMisure cod_flusso="TML">
                if '<FlussoMisure cod_flusso="TML">' in line:
                    # line = line.replace(, )
                    line = line.replace(old_line, new_line)
                f.write(line)
