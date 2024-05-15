"""Module for interact with xml Files"""

import xml.etree.ElementTree as ET
import ExcelManager

class XmlManager:
    """Class for interact with xml Files"""

    def __init__(self, filename):
        self.filename = filename
        self.tree = ET.parse(filename)
        self.root = self.tree.getroot()


    def check_and_update_data(self, parent_tag_name='DatiPdr',
                              first_tag_name='pros_fin_inizio',
                              second_tag_name='pros_fin_fine'):
        """Modify data tag according to Excel file
        
        Main function used for the XMLNEXTCLOUD (ex1)
        """
        for parent_tag in self.root.findall(parent_tag_name):
            tag1 = parent_tag.find('.//' + first_tag_name)
            tag2 = parent_tag.find('.//' + second_tag_name)

            if tag1 is not None and tag2 is not None:
                # before = [tag1.text, tag2.text]
                tag1.text, tag2.text = ExcelManager.ExcelManager.validate_dates(tag1.text,
                                                                                tag2.text)
                # after = [tag1.text, tag2.text]
                # XmlManager._log(before, after)

        self.tree.write(self.filename)
        self._add_xml_header()


    def add_value_to_tag_data_misura(self, parent_tag_name='DatiPdR', find_tag='data_inst_mis'):
        """Add a tag and his value
        
        Main function used for the XMLNEXTCLOUD (ex2)
        """
        for parent_tag in self.root.findall(parent_tag_name):
            tag_data_misura = parent_tag.find('.//' + find_tag)
            # print(tag_data_misura.text)

        return tag_data_misura.text

    def _add_xml_header(self):
        with open(self.filename, 'r+', encoding='utf-8') as f:
            content = f.read()
            f.seek(0, 0)
            # questa stringa viene usata per ex1 e pure tutti direi
            f.write('<?xml version="1.0" encoding="UTF-8" standalone="no"?>\n' + content)


    @staticmethod
    def clear_log_file():
        """Clear log file"""
        open('loggingFile.txt', 'w', encoding='utf-8').close()

    @staticmethod
    def _log(before, after):
        with open('logFile.txt', 'a', encoding='utf-8') as f:
            f.write(f'{before[0]}  {before[1]}\n')
            f.write(f'{after[0]}  {after[1]}\n')
            f.write('==================')
            f.write('\n')
