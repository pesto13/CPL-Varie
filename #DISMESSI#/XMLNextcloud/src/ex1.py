"""script used for change xml tag value according to CasisticaDate.xls

Vanessa asked for it(ex1)"""

from FileExplorerManager import FileExplorerManager
from ExcelManager import ExcelManager

STARTING_FOLDER = "NEXTCLOUD"
POOL_FOLDER = "POOL"

OLD_LINE='<FlussoMisure cod_flusso="TML">'
NEW_LINE='<FlussoMisure xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" cod_flusso="TML">'


ExcelManager.initialize()
fem = FileExplorerManager('_1_M', STARTING_FOLDER)
fem.decompress_folder()
fem.remove_old_zip()
fem.rename_all()
fem.modify_all_ex1()
fem.replace_line_all_file(OLD_LINE, NEW_LINE)
fem.compress_folder()
fem.move_zip_into_pool(POOL_FOLDER)
