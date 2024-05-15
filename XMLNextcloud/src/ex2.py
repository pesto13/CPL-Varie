"""script used for add tag value

Vanessa asked for it(ex2)"""

from FileExplorerManager import FileExplorerManager

STARTING_FOLDER = "SECONDO"
POOL_FOLDER = "SECONDO_POOL"

# OLD_LINE='<FlussoMisure cod_flusso="IGMG">'
# NEW_LINE='<FlussoIGMG xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" CodFlusso="IGMG">'

fem = FileExplorerManager('_1', STARTING_FOLDER)
fem.decompress_folder()
# fem.remove_old_zip()
fem.rename_all()
fem.modify_all_secondo()
# fem.replace_line_all_file(OLD_LINE, NEW_LINE)
fem.compress_folder()
fem.move_zip_into_pool(POOL_FOLDER)
