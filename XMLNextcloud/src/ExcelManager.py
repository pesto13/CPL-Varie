import pandas as pd

EXCELFILE = 'CasisticaDate.xls'

COL1='pros_fin_inizio_OLD'
COL2='pros_fin_fine_OLD'
COL3='pros_fin_inizio_NEW'
COL4='pros_fin_fine_NEW'

class ExcelManager:

    _data = None

    def initialize(filename=EXCELFILE):
        if ExcelManager._data is None:
            ExcelManager._data = ExcelManager._read_excel(filename)

    @staticmethod
    def _read_excel(filename):
        xls = pd.ExcelFile(filename) 
        sheet = xls.parse(0)
        return sheet.to_dict(orient='records')

    @staticmethod
    def validate_dates(data1, data2):
        if ExcelManager._data is not None:
            for row in ExcelManager._data:
                d1 = row[COL1].date().strftime('%d/%m/%Y')
                d2 = row[COL2].date().strftime('%d/%m/%Y')
                d3 = row[COL3].date().strftime('%d/%m/%Y')
                d4 = row[COL4].date().strftime('%d/%m/%Y')

                if(data1 == d1 and data2 == d2):
                    return d3, d4
                
            return data1, data2