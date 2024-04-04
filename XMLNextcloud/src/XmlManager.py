import xml.etree.ElementTree as ET

XMLFILE = 'CasisticaDate.xls'

class ExcelManager:

    @staticmethod
    def _read_XML(filename=XMLFILE):
        pass

    def __init__(self) -> None:
        # possibile passaggio valore del file
        self.data = ExcelManager._read_XML()

    

        