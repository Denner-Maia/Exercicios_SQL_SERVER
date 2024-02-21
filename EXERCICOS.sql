
/*
EXERCÍCIO 1
Restaurar o arquivo  treino.bak no banco de dados criado.
*/

-- Restore criando uma nova database

RESTORE DATABASE TREINO_RESTORE
FROM DISK = 'C:\SQL\TREINO.BAK'
WITH RECOVERY,STATS = 5,
MOVE 'TREINO' TO 'C:\SQL\Bases\Dados\TREINO_RESTORE.mdf',
MOVE 'TREINO_log' TO 'C:\SQL\Bases\Logs\TREINO_RESTORE_Log.ldf'
GO

/*
EXERCÍCIO 2 
Liste todos os clientes com seus nomes e com suas respectivas cidade e estados
*/

SELECT 
	 CLIENTE.NOME_CLIENTE AS CLIENTE
	,CIDADE.NOME_CIDADE AS CIDADE
	,CIDADE.UF AS ESTADO
FROM CLIENTE 
INNER JOIN CIDADE
	ON (CLIENTE.ID_CIDADE = CIDADE.ID_CIDADE)
GO
  
/*
EXERCÍCIO 3 
Liste o código do produto, descrição do produto e descrição das categorias dos produtos que tenham o valor unitário na 
faixa de R$ 10,00 a R$ 1500
*/

SELECT 
	 PRODUTOS.ID_PROD
	,PRODUTOS.NOME_PRODUTO AS 'DESCRIÇÃO DO PRODUTO'
	,CATEGORIA.NOME_CATEGORIA AS 'DESCRIÇÃO DA CATEGORIA'
	,PRODUTOS.PRECO
FROM PRODUTOS 
INNER JOIN CATEGORIA 
	ON (PRODUTOS.ID_CATEGORIA = CATEGORIA.ID_CATEGORIA)
WHERE 
	PRODUTOS.PRECO BETWEEN 10 AND 1500
GO

/*
EXERCÍCIO 4 
Liste o código do produto, descrição do produto e descrição da categorias dos produtos, e também apresente uma coluna condicional  com o  nome de "faixa de preço" 
Com os seguintes critérios
•	preço< 500 : valor da coluna será  igual  "preço abaixo de 500"
•	preço  >= 500 e <=1000 valor da coluna será igual  "preço entre 500 e 1000"
•	preço  > 1000 : valor da coluna será igual  "preço acima de 1000".
*/

SELECT 
	 PRODUTOS.ID_PROD
	,PRODUTOS.NOME_PRODUTO AS 'DESCRIÇÃO DO PRODUTO'
	,CATEGORIA.NOME_CATEGORIA AS 'DESCRIÇÃO DA CATEGORIA'
	,PRODUTOS.PRECO
	,CASE WHEN PRODUTOS.PRECO < 500
			THEN 'PREÇO ABAIXO DE 500'
		  WHEN PRODUTOS.PRECO >= 500 AND PRODUTOS.PRECO <= 1000
			THEN 'PREÇO ENTRE 500 E 1000'
		  ELSE  
				 'PREÇO ACIMA DE 1000'
	 END AS 'FAIXA DE PREÇO'
FROM PRODUTOS 
INNER JOIN CATEGORIA 
	ON (PRODUTOS.ID_CATEGORIA = CATEGORIA.ID_CATEGORIA)
GO


/*
EXERCÍCIO  5
Adicione a coluna faixa_salario na tabela vendedor tipo char(1)
*/
	select * from vendedores 
	BEGIN TRAN 
		ALTER TABLE VENDEDORES ADD faixa_salario CHAR(1)
		GO
	--COMMIT
	--ROLLBACK

/*
EXERCÍCIO 6 
Atualize o valor do campo faixa_salario da tabela vendedor com um update condicional .
Com os seguintes critérios
•	salario <1000 ,atualizar faixa = c
•	salario >=1000  and <2000 , atualizar faixa = b
•	salario >=2000  , atualizar faixa = a

**VERIFIQUE SE OS VALORES FORAM ATUALIZADOS CORRETAMENTE
*/

BEGIN TRAN 

UPDATE VENDEDORES 
SET FAIXA_SALARIO = 
	CASE WHEN VENDEDORES.SALARIO < 1000
			THEN 'C'
		 WHEN VENDEDORES.SALARIO >= 1000 AND VENDEDORES.SALARIO < 2000
			THEN 'B'
	ELSE 
		'A'
	END
GO

SELECT
	 [ID_VENDEDOR]
	,[NOME_VENDEDOR]
	,[SALARIO]
	,[faixa_salario]
FROM VENDEDORES
GO

--SELECT @@TRANCOUNT
--COMMIT
--ROLLBACK

/*
EXERCÍCIO 7
Listar em ordem alfabética os vendedores e seus respectivos salários, mais uma coluna, simulando aumento de 12% em seus salários.
*/

SELECT 
	VENDEDORES.NOME_VENDEDOR AS VENDEDOR
	,VENDEDORES.SALARIO
	,VENDEDORES.SALARIO * 1.12 AS 'SIMULAÇÃO DE AUMENTO DE 12%'
FROM VENDEDORES 
GO

/*EXERCÍCIO 8
Listar os nome dos vendedores, salário atual , coluna calculada com salario novo + reajuste de 18% sobre o salário atual, calcular  a coluna acréscimo e calcula uma coluna salario novo+ acresc.
Critérios
Se o vendedor for  da faixa “C”, aplicar  R$ 120 de acréscimo , outras faixas de salario acréscimo igual a 0(Zero )
*/

SELECT 
	VENDEDORES.NOME_VENDEDOR AS VENDEDOR
	,VENDEDORES.SALARIO AS 'SALÁRIO ATUAL'
	,VENDEDORES.SALARIO * 1.18 AS 'SALARIO NOVO COM REAJUSTE DE 18%'
	,VENDEDORES.FAIXA_SALARIO
	,CASE WHEN VENDEDORES.FAIXA_SALARIO = 'C'
			THEN '+ R$ 120'
	 ELSE 
		  '+ R$ 0.00'
	 END AS 'ACRÉSCIMO' 
	,CASE WHEN VENDEDORES.FAIXA_SALARIO = 'C'
			THEN (VENDEDORES.SALARIO * 1.18) + 120
	 ELSE 
		(VENDEDORES.SALARIO * 1.18)
	 END 'SALARIO NOVO + ACRESC'
FROM VENDEDORES 
GO

/*
EXERCÍCIO 9
Listar o nome e salários do vendedor com menor salario.
*/

SELECT
	VENDEDORES.NOME_VENDEDOR AS VENDEDOR
	,VENDEDORES.SALARIO
FROM VENDEDORES
	WHERE VENDEDORES.SALARIO = (SELECT MIN(SALARIO) FROM VENDEDORES)
GO

/*
EXERCÍCIO 10
Quantos vendedores ganham acima de R$ 2.000,00 de salário fixo?
*/

--select * from vendedores

SELECT 
	COUNT(VENDEDORES.NOME_VENDEDOR) AS QTD
FROM VENDEDORES
WHERE VENDEDORES.SALARIO > 2000
GO
/*
EXERCÍCIO 11
Adicione o campo valor_total tipo decimal(10,2) na tabela venda.
*/
BEGIN TRAN 
ALTER TABLE VENDAs ADD VALOR_TOTAL DECIMAL(10,2)
GO

--commit 
--rollback

/*
EXERCÍCIO 12
Atualize o campo valor_tota da tabela venda, com a soma dos produtos das respectivas vendas.
*/
begin tran
update vendas 
set valor_total = 
(
select 
	sum(val_total) 
from venda_itens
where (venda_itens.num_venda = vendas.num_venda) 
group by num_venda
)
go
--commit
--rollback


select 
	sum(val_total) 
from venda_itens
group by num_venda
go


/*
EXERCÍCIO 13
Realize a conferencia do exercício anterior, certifique-se que o valor  total de cada venda e igual ao valor total da soma dos  produtos da venda, listar as vendas em que ocorrer diferença.
*/

select
	num_venda,
	sum(val_total) 
from venda_itens
where not exists
	(select 
		num_venda
		,valor_total 
	from vendas)
group by num_venda
go

/*
EXERCÍCIO 14
Listar o número de produtos existentes, valor total , média do valor unitário referente ao mês 07/2018 agrupado por venda.
*/

SELECT
	 VENDA_ITENS.NUM_VENDA AS 'NUMERO DA VENDA'
	,COUNT(VENDA_ITENS.ID_PROD) AS 'QTD PRODUTOS'
	,CAST(AVG(VENDA_ITENS.VAL_UNIT) AS DECIMAL(10,2)) AS 'MEDIA VALOR UNITARIO'
	,SUM(VENDA_ITENS.VAL_TOTAL) AS 'VALOR TOTAL'
 FROM VENDA_ITENS
 INNER JOIN VENDAS 
	ON VENDA_ITENS.NUM_VENDA = VENDAS.NUM_VENDA
where datepart(yy,vendas.DATA_VENDA) = 2017
	  and 
	  datepart(mm,vendas.DATA_VENDA) = 7
 GROUP BY VENDA_ITENS.NUM_VENDA
 go 
/*
EXERCÍCIO 15
Listar o número de vendas, Valor do ticket médio, menor ticket e maior ticket referente ao mês 07/2017.
*/

SELECT 
	 VENDA_ITENS.NUM_VENDA AS 'NUMERO DA VENDA'
	,COUNT(VENDA_ITENS.NUM_VENDA) AS  'QUANTIDADE DE VENDAS REALIZADAS'
	,cast(AVG(VENDA_ITENS.VAL_TOTAL)as decimal(10,2)) AS 'MEDIA DO VALOR TOTAL DE VENDAS'
	,MIN(VENDA_ITENS.VAL_TOTAL) AS 'MINIMO DO VALOR TOTAL DE VENDAS'
	,MAX(VENDA_ITENS.VAL_TOTAL) AS 'MAXIMO DO VALOR TOTAL DE VENDAS'
FROM VENDA_ITENS
INNER JOIN VENDAS 
	ON VENDA_ITENS.NUM_VENDA = VENDAS.NUM_VENDA
WHERE DATEPART(YY,VENDAS.DATA_VENDA) = 2017
	  AND 
	  DATEPART(MM,VENDAS.DATA_VENDA) = 7
 GROUP BY VENDA_ITENS.NUM_VENDA
 GO 


/*
EXERCÍCIO 16
Atualize o status das notas abaixo de normal(N) para cancelada (C)
--15,34,80,104,130,159,180,240,350,420,422,450,480,510,530,560,600,640,670,714

*/
SELECT * FROM VENDAS

BEGIN TRAN
UPDATE VENDAS
SET STATUS = 'C'
WHERE VENDAS.NUM_VENDA IN (15,34,80,104,130,159,180,240,350,420,422,450,480,510,530,560,600,640,670,714)
GO

--COMMIT
--ROLLBACK


/*
EXERCÍCIO 17
Quais clientes realizaram mais de 70 compras?
*/

SELECT
	 VENDAS.ID_CLIENTE AS 'ID CLIENTE'
	,CLIENTE.NOME_CLIENTE AS 'CLIENTE'
	,COUNT(VENDAS.NUM_VENDA) 'QTD DE VENDAS'
FROM VENDAS
INNER JOIN CLIENTE
	ON VENDAS.ID_CLIENTE = CLIENTE.ID_CLIENTE
GROUP BY VENDAS.ID_CLIENTE, CLIENTE.NOME_CLIENTE
HAVING COUNT(NUM_VENDA) > 70

/*
EXERCÍCIO 18
Listar os produtos que estão incluídos em vendas que a quantidade total de produtos seja superior a 100 unidades.
*/

WITH CTE_RELATORIO AS
(
SELECT 
	 VENDA_ITENS.NUM_VENDA
	,PRODUTOS.NOME_PRODUTO
	,VENDA_ITENS.QTDE
FROM VENDA_ITENS
INNER JOIN PRODUTOS 
	ON VENDA_ITENS.ID_PROD = PRODUTOS.ID_PROD
),
CTE_RELATORIO2 AS (
SELECT
	 NUM_VENDA
	,NOME_PRODUTO
	,QTDE
	,SUM(QTDE) OVER(PARTITION BY NUM_VENDA) AS SUM_QTD
FROM CTE_RELATORIO
)

SELECT  
	 ISNULL(CAST(NUM_VENDA AS VARCHAR(50)),'TOTAL GERAL') AS 'NUMERO DA VENDA'
	,ISNULL(NOME_PRODUTO, 'TOTAL') AS PRODUTOS
	,SUM(QTDE) AS 'SOMATORIO DE PRODUTOS' 
	--,SUM_QTD
FROM CTE_RELATORIO2
WHERE SUM_QTD > 100
GROUP BY ROLLUP (NUM_VENDA,NOME_PRODUTO)
GO

/*
EXERCÍCIO 19
Trazer total de vendas do ano 2017 por categoria e apresentar total geral
*/

SELECT
	ISNULL(CATEGORIA.NOME_CATEGORIA, 'TOTAL GERAL') AS CATEGORIA
	,SUM(VAL_TOTAL) AS TOTAL
FROM VENDA_ITENS
INNER JOIN VENDAS 
	ON (VENDA_ITENS.NUM_VENDA = VENDAS.NUM_VENDA)
INNER JOIN PRODUTOS
	ON (VENDA_ITENS.ID_PROD = PRODUTOS.ID_PROD)
INNER JOIN CATEGORIA 
	ON(PRODUTOS.ID_CATEGORIA = CATEGORIA.ID_CATEGORIA)
WHERE DATEPART(YY,VENDAS.DATA_VENDA) = 2017
GROUP BY ROLLUP(CATEGORIA.NOME_CATEGORIA)
GO

/*
EXERCÍCIO 20
Listar total de vendas do ano 2017 por categoria e mês a mês apresentar subtotal dos meses e total geral ano.
*/

SELECT
	 ISNULL(CATEGORIA.NOME_CATEGORIA, 'TOTAL GERAL ANUAL') AS CATEGORIA 
	,isnull(ISNULL(CAST(DATEPART(MM,VENDAS.DATA_VENDA) AS VARCHAR(50)), 'Total mensal ' + CATEGORIA.NOME_CATEGORIA),'TOTAL-ANO') AS 'MÊS'
	,SUM(VAL_TOTAL) AS TOTAL
FROM VENDA_ITENS
INNER JOIN VENDAS 
	ON (VENDA_ITENS.NUM_VENDA = VENDAS.NUM_VENDA)
INNER JOIN PRODUTOS
	ON (VENDA_ITENS.ID_PROD = PRODUTOS.ID_PROD)
INNER JOIN CATEGORIA 
	ON(PRODUTOS.ID_CATEGORIA = CATEGORIA.ID_CATEGORIA)
WHERE DATEPART(YY,VENDAS.DATA_VENDA) = 2017
GROUP BY ROLLUP(CATEGORIA.NOME_CATEGORIA, DATEPART(MM,VENDAS.DATA_VENDA))
GO

/*
EXERCÍCIO 21
Listar total de vendas por vendedores referente ao ano 2017, mês a mês apresentar subtotal do mês e total geral.
*/

SELECT
	 ISNULL(VENDEDORES.NOME_VENDEDOR, 'TOTAL GERAL ANUAL') AS VENDEDORES 
	,isnull(ISNULL(CAST(DATEPART(MM,VENDAS.DATA_VENDA) AS VARCHAR(50)), 'Total mensal ' + VENDEDORES.NOME_VENDEDOR), 'TOTAL-ANO') AS 'MÊS'
	,SUM(VENDAS.VALOR_TOTAL) AS TOTAL
FROM VENDAS
INNER JOIN VENDEDORES
	ON (VENDAS.ID_VENDEDOR = VENDEDORES.ID_VENDEDOR)
GROUP BY ROLLUP(VENDEDORES.NOME_VENDEDOR, DATEPART(MM,VENDAS.DATA_VENDA))

go

/*
EXERCÍCIO 22
Listar os top 10 produtos mais vendidos por valor total de venda com suas respectivas categorias
*/
WITH CTE_RELATORIO AS 
(
SELECT 
	 VENDA_ITENS.ID_PROD
	,SUM(VENDA_ITENS.VAL_TOTAL) AS 'VALOR TOTAL POR PRODUTO'
	,ROW_NUMBER() OVER(ORDER BY SUM(VENDA_ITENS.VAL_TOTAL) DESC) RANK
FROM VENDA_ITENS
GROUP BY VENDA_ITENS.ID_PROD
)
SELECT 
	 PRODUTOS.NOME_PRODUTO
	,CATEGORIA.NOME_CATEGORIA
	,CTE_RELATORIO.[VALOR TOTAL POR PRODUTO]
	,RANK
FROM CTE_RELATORIO
INNER JOIN PRODUTOS 
	ON(CTE_RELATORIO.ID_PROD = PRODUTOS.ID_PROD)
INNER JOIN CATEGORIA
	ON(PRODUTOS.ID_CATEGORIA = CATEGORIA.ID_CATEGORIA)
WHERE RANK <= 10
ORDER BY CTE_RELATORIO.[VALOR TOTAL POR PRODUTO] DESC 
go
/*
EXERCÍCIO 23
Listar os top 10 produtos mais vendidos por valor total de venda com suas respectivas categorias, calcular seu percentual de participação com relação ao total geral.
*/

WITH CTE_RELATORIO AS 
(
SELECT 
	 VENDA_ITENS.ID_PROD
	,SUM(VENDA_ITENS.VAL_TOTAL) AS 'VALOR TOTAL POR PRODUTO'
	,ROW_NUMBER() OVER(ORDER BY SUM(VENDA_ITENS.VAL_TOTAL) DESC) RANK
FROM VENDA_ITENS
GROUP BY VENDA_ITENS.ID_PROD
)
SELECT 
	 PRODUTOS.NOME_PRODUTO
	,CATEGORIA.NOME_CATEGORIA
	,CTE_RELATORIO.[VALOR TOTAL POR PRODUTO]
	,RANK
	,concat(cast((CTE_RELATORIO.[VALOR TOTAL POR PRODUTO] / (select sum(CTE_RELATORIO.[VALOR TOTAL POR PRODUTO]) from CTE_RELATORIO)) * 100 as decimal(10,2)), '%') as 'Porcentagem em relaçao ao valor total'
FROM CTE_RELATORIO
INNER JOIN PRODUTOS 
	ON(CTE_RELATORIO.ID_PROD = PRODUTOS.ID_PROD)
INNER JOIN CATEGORIA
	ON(PRODUTOS.ID_CATEGORIA = CATEGORIA.ID_CATEGORIA)
WHERE RANK <= 10
ORDER BY CTE_RELATORIO.[VALOR TOTAL POR PRODUTO] DESC
go

/*
EXERCÍCIO 24
Listar apenas o produto mais vendido de cada Mês com seu  valor total referente ao ano de 2017.
*/
select 
	RankItensVendidos2017.ID_PROD,
	RankItensVendidos2017.produto,
	RankItensVendidos2017.mes,
	RankItensVendidos2017.total
from 
(
select 
	 produtos.ID_PROD
	,produtos.NOME_PRODUTO as produto
	,datepart(mm,vendas.DATA_VENDA) as mes
	,sum(VALOR_TOTAL) as total
	,row_number()over(partition by datepart(mm,vendas.DATA_VENDA) order by sum(VALOR_TOTAL) desc) as rank
from produtos 
inner join VENDA_ITENS
	on(produtos.ID_PROD = VENDA_ITENS.ID_PROD)
inner join vendas 
	on(VENDA_ITENS.NUM_VENDA = vendas.NUM_VENDA)
where 
	datepart(yy,vendas.data_venda) = 2017
group by 
	produtos.ID_PROD,produtos.NOME_PRODUTO,
	datepart(mm,vendas.DATA_VENDA)
) as RankItensVendidos2017 
where 
	RankItensVendidos2017.rank = 1 
order by 
	RankItensVendidos2017.mes
go
/*
EXERCÍCIO 25
Lista o cliente e a data da última compra de cada cliente.
*/

select
cliente.NOME_CLIENTE
,vendas.DATA_VENDA
from cliente
inner join VENDAS
	on(cliente.ID_CLIENTE = vendas.ID_CLIENTE)
where vendas.DATA_VENDA = (select max(vendas.DATA_VENDA) from vendas where vendas.ID_CLIENTE = CLIENTE.ID_CLIENTE)
go

/*
EXERCÍCIO 26
Lista e a data da última venda de cada produto.
*/

select
	 PRODUTOS.NOME_PRODUTO
	,vendas.DATA_VENDA
from PRODUTOS
inner join VENDA_ITENS
	on(produtos.ID_PROD = VENDA_ITENS.ID_PROD)
inner join VENDAs
	on(VENDA_ITENS.NUM_VENDA = vendas.NUM_VENDA)
where vendas.DATA_VENDA = 
(
select 
	max(a.DATA_VENDA) 
from vendas as a 
inner join VENDA_ITENS as b
	on(a.NUM_VENDA = b.NUM_VENDA)
where b.ID_PROD = produtos.ID_PROD
)
go
