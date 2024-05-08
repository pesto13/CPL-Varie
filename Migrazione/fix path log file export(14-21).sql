-- REPLACE_CLIENTE va cambiato con il nome del cliente sul DB ad esempio SGDISTRIBUZIONE
-- RPL va cambiato con le 3 lettere del cliente, ad esempio [soc, ver]
-- File migrazione da 14 a 21

Use [REPLACE_CLIENTE]

select * from [REPLACE_CLIENTE$NDMGas Vendor$80210a5a-2b85-4c29-95f9-64117945258f] where Tipo = '1'

update [REPLACE_CLIENTE$NDMGas Vendor$80210a5a-2b85-4c29-95f9-64117945258f] set Path_Cart_Doc = '\\nascpg.cpgnet.local\fatture$\REPLACE_CLIENTE\DATI\venditori\' where Tipo = '1'

select * from [REPLACE_CLIENTE$NDMLog File Export$e895c92b-9469-4077-90be-6e4be122c7a0] where FileName <> '' and LEFT(FileName, 4) = '\\sv'

update [REPLACE_CLIENTE$NDMLog File Export$e895c92b-9469-4077-90be-6e4be122c7a0]
set [File Path] = REPLACE([File Path], '\\sv-srvbc-RPL.cpgnet.local\socogasbc$\', '\\nascpg.cpgnet.local\fatture$\REPLACE_CLIENTE\DATI\')
where [File Path] <> '' and LEFT([File Path], 39) = '\\sv-srvbc-RPL.cpgnet.local\socogasbc$\' -- check

update [REPLACE_CLIENTE$NDMLog File Export$e895c92b-9469-4077-90be-6e4be122c7a0]
set [File Path] = REPLACE([File Path], '\\nascpg.cpgnet.local\fatture$\REPLACE_CLIENTE\DATI\distr\portale\', '\\nascpg.cpgnet.local\fatture$\REPLACE_CLIENTE\DATI\distr\FileEstratti\')
where [File Path] <> '' and LEFT([File Path], 66) = '\\nascpg.cpgnet.local\fatture$\REPLACE_CLIENTE\DATI\distr\portale\'

update [REPLACE_CLIENTE$NDMLog File Export$e895c92b-9469-4077-90be-6e4be122c7a0]
set FileName = REPLACE(FileName, '\\sv-srvbc-RPL.cpgnet.local\socogasbc$\', '\\nascpg.cpgnet.local\fatture$\REPLACE_CLIENTE\DATI\')
where FileName <> '' and LEFT(FileName, 39) = '\\sv-srvbc-RPL.cpgnet.local\socogasbc$\'

update [REPLACE_CLIENTE$NDMLog File Export$e895c92b-9469-4077-90be-6e4be122c7a0]
set FileName = REPLACE(FileName, '\\nascpg.cpgnet.local\fatture$\REPLACE_CLIENTE\DATI\distr\portale\', '\\nascpg.cpgnet.local\fatture$\REPLACE_CLIENTE\DATI\distr\FileEstratti\')
where FileName <> '' and LEFT(FileName, 66) = '\\nascpg.cpgnet.local\fatture$\REPLACE_CLIENTE\DATI\distr\portale\'

select distinct left([File Path], 59) from [REPLACE_CLIENTE$NDMLog File Export$e895c92b-9469-4077-90be-6e4be122c7a0] where [File Path] <> '' order by 1
select distinct left(FileName, 59) from [REPLACE_CLIENTE$NDMLog File Export$e895c92b-9469-4077-90be-6e4be122c7a0] where FileName <> '' order by 1

delete from [REPLACE_CLIENTE$NDMLog File Export$e895c92b-9469-4077-90be-6e4be122c7a0] where left([File Path], 50) = '\\nascpg.cpgnet.local\fatture$\REPLACE_CLIENTE\DATI\distr\mod\'

select * from [User]

update [User] set State = '0' where [User Name] = 'CPGNET\LASAGNAS'
update [User] set State = '1' where [User Name] = 'CPGNET\MOZZARELLIJ'

update [REPLACE_CLIENTE$Item$437dbf0e-84ff-417a-965d-ed2bb9650972]
set [Type] = 2, [Stockout Warning] = 1, [Inventory Posting Group] = 'DIGAS'
where No_ in (
    'BOLLO', 'ASSICURAZIONE CF', 'CARRO', 'STORNO', 'CMOR-AI2', 'CMOR-SI2', 'CMOR-SI7', 'C03>G6', 'C03-G4', 'C03-G6', 'VT - ST', 'VT - VR', 'ST.INTERR.', 'RIPR101', 'RIPR151A', 'REIN107', 'DEM102A', 'COST308A', 'CONTR.CONCESSIONARIO', 'MML_1',
    'MML_1E',
    'MML_2E',
    'MML_2',
    'MML_3',
    'MML_4',
    'ACVA101',
    'ART00003',
    'ART00004',
    'ART00005',
    'CONTR.CONCESSIONARIO',
    'COST308A',
    'DEM102A',
    'INGA531',
    '5.29',
    '5.28',
    '5.25',
    '5.20',
    '5.2',
    '5.19',
    '5.17',
    '5.16',
    '5.15',
    '5.14',
    '5.14 MTL',
    '5.13 C 70',
    '5.13 B 60',
    '5.13 A 47',
    '5.1 SCONT',
    '5.1',
    '11',
    '12',
    '14',
    '10',
    '09',
    '08',
    '01',
    '02')
and Type <> '2'

select * from [REPLACE_CLIENTE$Item$437dbf0e-84ff-417a-965d-ed2bb9650972] order by Type, No_

update [REPLACE_CLIENTE$Item$437dbf0e-84ff-417a-965d-ed2bb9650972] set [Search Description] = upper(Description) where left(No_, 9) = 'SP-IND-OM'
