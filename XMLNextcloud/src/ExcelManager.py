import pandas as pd

EXCELFILE = 'CasisticaDate.xls'


class ExcelManager:
    @staticmethod
    def _read_excel(filename=EXCELFILE):
        xls = pd.ExcelFile(filename) 
        sheet = xls.parse(0)
        return sheet.to_dict(orient='records')

    def __init__(self) -> None:
        # possibile passaggio valore del file
        self.data = ExcelManager._read_excel()



        