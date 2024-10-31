

select *
from [CLIENTE$NDMGas Vendor$80210a5a-2b85-4c29-95f9-64117945258f]
where tipo = 1

select *
from [CLIENTE$NDMInsurance Data$da897d7a-9bd9-4b9b-bc17-408c6a527edf]

-- Valori che non matchano vediamo quali sono per poi metterli a posto con la query sotto
select *
from [CLIENTE$NDMInsurance Data$da897d7a-9bd9-4b9b-bc17-408c6a527edf] as id
where id.[Seller Description] not in (
	select id.[Seller Description]
	from 
		[CLIENTE$NDMGas Vendor$80210a5a-2b85-4c29-95f9-64117945258f] as gv,
		[CLIENTE$NDMInsurance Data$da897d7a-9bd9-4b9b-bc17-408c6a527edf] as id
	where
		gv.Descrizione = id.[Seller Description]
		and gv.Tipo = 1
	)

-- sistemazione valori che non combaciano
update [CLIENTE$NDMInsurance Data$da897d7a-9bd9-4b9b-bc17-408c6a527edf]
set [Seller Description] = '[codice_new]'
where [Seller Description] = '[codice_old]'


-- bonifica
update id
	set id.[Seller Code] = gv.Codice
from 
	[CLIENTE$NDMInsurance Data$da897d7a-9bd9-4b9b-bc17-408c6a527edf] as id,
	[CLIENTE$NDMGas Vendor$80210a5a-2b85-4c29-95f9-64117945258f] as gv
where id.[Seller Description] = gv.Descrizione

