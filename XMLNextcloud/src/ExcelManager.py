import pandas as pd

EXCELFILE = 'CasisticaDate.xls'


class ExcelManager:

    _data = None

    @staticmethod
    def _read_excel(filename=EXCELFILE):
        print('lo faccio')
        xls = pd.ExcelFile(filename) 
        sheet = xls.parse(0)
        return sheet.to_dict(orient='records')

    def __init__(self) -> None:
        if ExcelManager._data is None:
            ExcelManager._data = ExcelManager._read_excel()
        self.data = ExcelManager._data

    @staticmethod
    def validate_dates(data1, data2):
        ExcelManager()._validate_dates(data1, data2)
    

    def _validate_dates(self, date1, date2):
        pass



ExcelManager.validate_dates('1','2')
ExcelManager.validate_dates('1','2')
ExcelManager.validate_dates('1','2')