import xml.etree.ElementTree as ET

class XmlManager:
    def __init__(self, filename):
        self.tree = ET.parse(filename)
        self.root = self.tree.getroot()

    def check_and_update_data(self, parent_tag_name, first_tag_name, second_tag_name):
        for parent_tag in self.root.findall(parent_tag_name):
            tag1 = parent_tag.find('.//' + first_tag_name)
            tag2 = parent_tag.find('.//' + second_tag_name)
            print(tag1.text)
            tag1.text = 'lol'
            tag2.text = 'ciao'
            print(tag1.text)
        
        self.tree.write('questo2.xml')

# Utilizzo della classe XmlManager
xml_manager = XmlManager('questo.xml')
xml_manager.check_and_update_data('DatiPdr', 'pros_fin_inizio', 'pros_fin_fine')
