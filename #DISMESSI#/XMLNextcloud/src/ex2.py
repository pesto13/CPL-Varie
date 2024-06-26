"""script used for add tag value

Vanessa asked for it(ex2)"""

from FileExplorerManager import FileExplorerManager

STARTING_FOLDER = 'IGMG'
POOL_OK = 'SECONDO_POOL'
POOL_ERROR = 'ERROR_POOL'

# OLD_LINE='<FlussoMisure cod_flusso="IGMG">'
# NEW_LINE='<FlussoIGMG xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" CodFlusso="IGMG">'

fem = FileExplorerManager('_1', STARTING_FOLDER)
fem._pulizia()
fem.decompress_folder()
# fem.remove_old_zip()
fem.rename_all()
fem.modify_all_ex2()
fem.move_into_pool(POOL_OK, POOL_ERROR)
# la cartella cambia nome qua
fem.compress_folder(POOL_OK)
fem.compress_folder(POOL_ERROR)
