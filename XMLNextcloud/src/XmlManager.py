import xml.etree.ElementTree as ET
import ExcelManager

class XmlManager:
    def __init__(self, filename):
        self.filename = filename
        self.tree = ET.parse(filename)
        self.root = self.tree.getroot()
        # non mi fa impazzire

    def check_and_update_data(self, parent_tag_name='DatiPdr', first_tag_name='pros_fin_inizio', second_tag_name='pros_fin_fine'):
        for parent_tag in self.root.findall(parent_tag_name):
            tag1 = parent_tag.find('.//' + first_tag_name)
            tag2 = parent_tag.find('.//' + second_tag_name)
            
            # chiedi a vanessa (se non trova corr nelle date excel non restituisce nulla)
            if tag1 is not None and tag2 is not None:
                tag1.text, tag2.text = ExcelManager.ExcelManager.validate_dates(tag1.text, tag2.text)
            
        self.tree.write(self.filename)
