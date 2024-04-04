import xml.etree.ElementTree as ET
import ExcelManager

class XmlManager:
    def __init__(self, filename):
        self.filename = filename
        self.tree = ET.parse(filename)
        self.root = self.tree.getroot()
        ExcelManager.ExcelManager()

    def check_and_update_data(self, parent_tag_name, first_tag_name, second_tag_name):
        for parent_tag in self.root.findall(parent_tag_name):
            tag1 = parent_tag.find('.//' + first_tag_name)
            tag2 = parent_tag.find('.//' + second_tag_name)
            
            if tag1 is not None and tag2 is not None:
                tag1.text, tag2.text = ExcelManager.ExcelManager.validate_dates(tag1.text, tag2.text)
            
            # per test
            # print(tag1.text, tag2.text)
            # d3, d4 = ExcelManager.ExcelManager.validate_dates(tag1.text, tag2.text)
            # print(d3, d4)
            # print('=========================')
            # fine test
            
        self.tree.write(self.filename)
