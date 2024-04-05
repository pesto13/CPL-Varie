import xml.etree.ElementTree as ET
import ExcelManager

class XmlManager:
    def __init__(self, filename):
        self.filename = filename
        self.tree = ET.parse(filename)
        self.root = self.tree.getroot()

    def check_and_update_data(self, parent_tag_name='DatiPdr', first_tag_name='pros_fin_inizio', second_tag_name='pros_fin_fine'):
        for parent_tag in self.root.findall(parent_tag_name):
            tag1 = parent_tag.find('.//' + first_tag_name)
            tag2 = parent_tag.find('.//' + second_tag_name)
            
            if tag1 is not None and tag2 is not None:
                # before = [tag1.text, tag2.text]
                tag1.text, tag2.text = ExcelManager.ExcelManager.validate_dates(tag1.text, tag2.text)
                # after = [tag1.text, tag2.text]
                # XmlManager._logging(before, after)
            
        self.tree.write(self.filename)
        self._add_xml_header()


    def _add_xml_header(self):
        with open(self.filename, 'r+') as f:
            content = f.read()
            f.seek(0, 0)
            f.write('<?xml version="1.0" encoding="UTF-8" standalone="no"?>\n' + content)

    @staticmethod
    def clear_logging_file():
        open('loggingFile.txt', 'w').close()

    @staticmethod
    def _logging(before, after):
        with open('loggingFile.txt', 'a') as f:
            f.write(f'{before[0]}  {before[1]}\n')
            f.write(f'{after[0]}  {after[1]}\n')
            f.write('==================')
            f.write('\n')