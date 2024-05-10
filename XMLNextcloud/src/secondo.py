import myutils

starting_folder = "SECONDO"
pool_folder = "SECONDO_POOL"



myutils.decompress_folder(starting_folder)
# myutils.remove_old_zip(starting_folder)
myutils.rename_all(starting_folder)

myutils.modify_all_secondo(starting_folder)
myutils.replace_flusso(starting_folder)

myutils.compress_folder(starting_folder)
myutils.move_zip_into_pool(starting_folder, pool_folder)