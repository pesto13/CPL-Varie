"""script used for add tag value

Vanessa asked for it(ex2)"""

from myutils import FileExplorerManager

STARTING_FOLDER = "SECONDO"
POOL_FOLDER = "SECONDO_POOL"

OLD_LINE='<FlussoMisure cod_flusso="TML">'
NEW_LINE='<FlussoMisure xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" cod_flusso="TML">'

fem = FileExplorerManager('', STARTING_FOLDER, POOL_FOLDER)

fem.decompress_folder()
# fem.remove_old_zip()
fem.rename_all()

fem.modify_all_secondo()
fem.replace_line_all_file(OLD_LINE, NEW_LINE)

fem.compress_folder()
fem.move_zip_into_pool(POOL_FOLDER)
