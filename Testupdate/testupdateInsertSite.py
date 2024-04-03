from selenium import webdriver
from selenium.common.exceptions import WebDriverException
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import Select
import json
import os

CONFIG_FILE = 'config.json'

def login(driver, username, password):
    input_username = driver.find_element(By.ID, 'okta-signin-username')
    input_username.clear()
    input_username.send_keys(username)

    input_pw = driver.find_element(By.ID, 'okta-signin-password')
    input_pw.clear()
    input_pw.send_keys(password)

def read_credentials_from_config():
    username = ''
    password = ''
    if os.path.isfile(CONFIG_FILE):
        with open(CONFIG_FILE) as f:
            config = json.load(f)
            username = config.get('username')
            password = config.get('password')
    print(username, password)
    return username, password

def core(driver):

    nome_cliente = input("Inserisci il nome del cliente (se presente inserisci lo spazio)")
    nome_cliente = nome_cliente.strip()

    btn_nuovo_slot = driver.find_element(By.CSS_SELECTOR, "button.btn.btn-default.btn-sm.float-right")
    btn_nuovo_slot.click()

    # Inizio con inserimento

    # Lo slot lo lascio vuoto

    # INPUT SECTION

    text = driver.find_element(By.ID, 'txbNomeDb')
    text.clear()
    text.send_keys(f'TEST{nome_cliente.upper().replace(' ','')}')

    text = driver.find_element(By.ID, 'txbNomeCliente')
    text.clear()
    text.send_keys(f'{nome_cliente.upper()}')

    text = driver.find_element(By.ID, 'txbBilling')
    text.clear()
    text.send_keys('distribuzioneict@cpl.it')

    # SELECT SECTION

    select_element = driver.find_element(By.ID, 'ddlRef1')
    select = Select(select_element)
    select.select_by_visible_text('Jacopo Mozzarelli')

    select_element = driver.find_element(By.ID, 'ddlRef2')
    select = Select(select_element)
    select.select_by_visible_text('Matteo Tartari')

    select_element = driver.find_element(By.ID, 'ddlAmbito')
    select = Select(select_element)
    select.select_by_visible_text('Distribuzione')

    select_element = driver.find_element(By.ID, 'ddlAmbiente')
    select = Select(select_element)
    select.select_by_visible_text('BC21')

    text = driver.find_element(By.ID, 'txbBilling')
    text.clear()
    text.send_keys('distribuzioneict@cpl.it')

    # INPUT SECTION

    text = driver.find_element(By.ID, 'txbUtenteNAS')
    text.clear()
    text.send_keys(fr'cpgnet\nas{nome_cliente.lower().replace(' ','')}')

    text = driver.find_element(By.ID, 'txbSourceDbHost')
    text.clear()
    text.send_keys('sv-db-dinet1.cpgnet.local')

    text = driver.find_element(By.ID, 'txbSourceDbName')
    text.clear()
    text.send_keys(f'{nome_cliente.upper().replace(' ','')}')

    text = driver.find_element(By.ID, 'txbSourceDbInstance')
    text.clear()
    text.send_keys('MSSQLSERVER')

    text = driver.find_element(By.ID, 'txbServiceServer')
    text.clear()
    text.send_keys('sv-srv-testdnt')

    text = driver.find_element(By.ID, 'txbServiceName')
    text.clear()
    text.send_keys(fr'MicrosoftDynamicsNavServer$TEST{nome_cliente.upper().replace(' ','')}')

def main():
    driver = webdriver.Chrome()

    try:
        driver.get("https://testupdate.cpl.it/GestisciDb")
    except WebDriverException:
        print('Non sei connesso alla rete?')
        return
    
    username, password = read_credentials_from_config()
    login(driver, username, password)

    input("Premi per continuare dopo aver inserito OKTA...")

    while(True):
        driver.get("https://testupdate.cpl.it/GestisciDb")
        core(driver)
        risp = input("Vuoi inserire un altro cliente (S/N)")
        if(risp == 'N' or risp == 'n'):
            break
    
    input("Premi INVIO per chiudere il browser...")
    driver.quit()

main()