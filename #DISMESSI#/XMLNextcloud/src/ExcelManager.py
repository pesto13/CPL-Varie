"""Module for interact with xls(excel) file"""

import pandas

EXCELFILE = 'CasisticaDate.xls'

COL1='pros_fin_inizio_OLD'
COL2='pros_fin_fine_OLD'
COL3='pros_fin_inizio_NEW'
COL4='pros_fin_fine_NEW'

class ExcelManager:
    """Class for interact with xls(excel) file"""

    _data = None

    @staticmethod
    def initialize(filename=EXCELFILE):
        """Reads the excel file and set is a class variable"""
        if ExcelManager._data is None:
            ExcelManager._data = ExcelManager.__read_excel(filename)

    @staticmethod
    def __read_excel(filename):
        """Open and return the excel file as dict"""
        xls = pandas.ExcelFile(filename)
        sheet = xls.parse(0)
        return sheet.to_dict(orient='records')

    @staticmethod
    def validate_dates(data1, data2):
        """Returns dates according to excel file

        If dates in the excel file are find returns the new one
        Else returns the old one (no modify)
        """
        if ExcelManager._data is not None:
            for row in ExcelManager._data:
                d1 = row[COL1].date().strftime('%d/%m/%Y')
                d2 = row[COL2].date().strftime('%d/%m/%Y')
                d3 = row[COL3].date().strftime('%d/%m/%Y')
                d4 = row[COL4].date().strftime('%d/%m/%Y')

                if(data1 == d1 and data2 == d2):
                    return d3, d4

            return data1, data2
        return None
