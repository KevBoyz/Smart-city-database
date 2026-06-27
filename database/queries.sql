
# sensores por infraestrutura
SELECT sensor.id, sensor.tipo, infraestrutura .tipo AS infraestrutura
FROM sensor INNER JOIN infraestrutura
ON sensor.infraestrutura_id = infraestrutura .id;

# Cidadões que fizeram reclamações e o local problemático
SELECT cidadao.nome AS Cidadao, motivo, area_urbana.nome AS Local
FROM cidadao INNER JOIN reclamacao INNER JOIN area_urbana
ON cpf = cidadao_cpf AND area_urbana.id = area_urbana_id;

# Manutenções feitas em infraestruturas, por conta do Right Join infraestruturas que não fizeram manutenção ainda aparecem
SELECT infraestrutura.tipo, manutencao.responsavel, manutencao.inicio
FROM manutencao RIGHT JOIN infraestrutura
ON manutencao.infraestrutura_id = infraestrutura.id;

# Locais com e sem eventos
SELECT  area_urbana.nome as Local, evento_urbano.nome AS Evento
FROM area_urbana 
LEFT JOIN area_urbana_has_evento_urbano ON area_urbana.id = area_urbana_has_evento_urbano.area_urbana_id
LEFT JOIN evento_urbano ON area_urbana_has_evento_urbano.evento_urbano_id = evento_urbano.id;

# Local de propriedades de cidadãos
SELECT cidadao.nome, area_urbana.nome AS area, propriedade.latitude, propriedade.longitude
FROM propriedade INNER JOIN cidadao ON propriedade.cidadao_cpf = cidadao.cpf 
INNER JOIN area_urbana ON propriedade.area_urbana_id = area_urbana.id;

# Item, seus status, a infraestrutura que pertence e a área urbana que se localiza
SELECT itens.nome AS Item, status.status_item AS Status, infraestrutura.tipo AS Infraestrutura, area_urbana.nome AS Local
FROM itens
INNER JOIN status ON itens.id = status.itens_id
INNER JOIN infraestrutura ON itens.infraestrutura_id = infraestrutura.id
INNER JOIN area_urbana ON infraestrutura.area_urbana_id = area_urbana.id;

# Infrestrutura com sensores de qualidade de ar
SELECT tipo FROM infraestrutura
WHERE id IN (
    SELECT infraestrutura_id
    FROM sensor
    WHERE tipo = 'qualidade do ar'
);

# Cidadãos com propriedades
SELECT nome FROM cidadao
WHERE cpf IN (
    SELECT cidadao_cpf
    FROM propriedade
);

# Quantidade de reclamações por área urbana
SELECT area_urbana.nome AS Local, (
    SELECT COUNT(*) FROM reclamacao
    WHERE reclamacao.area_urbana_id = area_urbana.id
) AS total_de_reclamações
FROM area_urbana;

# Quantidade de sensores por infrestrutura
SELECT infraestrutura.tipo, (
    SELECT COUNT(*) FROM sensor
    WHERE sensor.infraestrutura_id = infraestrutura.id
) AS sensores
FROM infraestrutura;

# Total de cidadãos
SELECT COUNT(*) AS total_de_cidadaos FROM cidadao;

# Quantidade de sensor por infraestrutura e quantidade média de senroes por infraestrutura 
SELECT infraestrutura.tipo AS Infraestrutura, COUNT(sensor.id) AS Quantidade_de_Sensores 
FROM infraestrutura
LEFT JOIN sensor ON infraestrutura.id = sensor.infraestrutura_id
GROUP BY infraestrutura.id;
SELECT AVG(quantidade)
FROM (
    SELECT COUNT(sensor.id) AS quantidade
    FROM infraestrutura
    LEFT JOIN sensor ON infraestrutura.id = sensor.infraestrutura_id
    GROUP BY infraestrutura.id
) quantidade_por_infraestrutura;

# Menor e maior salario, folha salarial, média salarial e cidadãos que possuem salário maior que a média
SELECT MIN(salario) AS Menor_salario, MAX(salario) AS Maior_salario
FROM cidadao;
SELECT SUM(salario) AS folha_salarial
FROM cidadao;
SELECT AVG(salario) AS media_salario
FROM cidadao;
SELECT nome, cargo, salario FROM cidadao
WHERE salario > (
	SELECT AVG(salario) AS media_salario
	FROM cidadao
)ORDER BY salario DESC;

# Infrestrutura com mais de 2 sensores
SELECT infraestrutura.tipo, COUNT(sensor.id) AS sensores
FROM infraestrutura
JOIN sensor ON infraestrutura.id = sensor.infraestrutura_id
GROUP BY infraestrutura.id
HAVING COUNT(sensor.id) > 2;

# Cidadãos com mais de 1 propriedade
SELECT cidadao.nome, COUNT(propriedade.id) AS propriedades
FROM cidadao
JOIN propriedade ON cidadao.cpf = propriedade.cidadao_cpf
GROUP BY cidadao.cpf
HAVING COUNT(propriedade.id)>1;

# Área urbana com mais de 2 reclamações
SELECT area_urbana.nome, COUNT(reclamacao.id) AS total
FROM reclamacao
JOIN area_urbana ON reclamacao.area_urbana_id = area_urbana.id
GROUP BY area_urbana.id
HAVING COUNT(reclamacao.id) > 2;

# VIEW de todas as áreas com quantidade de reclamações, sensores, propriedades e infraestruturas
CREATE VIEW monitoramento_areas AS
SELECT area_urbana.nome AS area, COUNT(DISTINCT reclamacao.id) AS reclamacoes,
COUNT(DISTINCT sensor.id) AS sensores, COUNT(DISTINCT infraestrutura.id) AS infraestruturas,
COUNT(DISTINCT propriedade.id) AS propriedades
FROM area_urbana
LEFT JOIN infraestrutura ON area_urbana.id = infraestrutura.area_urbana_id
LEFT JOIN sensor ON infraestrutura.id = sensor.infraestrutura_id
LEFT JOIN reclamacao ON area_urbana.id = reclamacao.area_urbana_id
LEFT JOIN propriedade ON area_urbana.id = propriedade.area_urbana_id
GROUP BY area_urbana.id;

SELECT * FROM monitoramento_areas order by area;

# VIEW de todas as infraestruturas com número de itens, sensores e manutenções além de suas respectivas áreas
CREATE VIEW infraestrutura_resumo AS
SELECT infraestrutura.id, infraestrutura.tipo, area_urbana.nome AS area, COUNT(DISTINCT itens.id) AS itens,
COUNT(DISTINCT sensor.id) AS sensores, COUNT(DISTINCT manutencao.id) AS manutencoes
FROM infraestrutura
JOIN area_urbana ON infraestrutura.area_urbana_id = area_urbana.id
LEFT JOIN itens ON itens.infraestrutura_id = infraestrutura.id
LEFT JOIN sensor ON sensor.infraestrutura_id = infraestrutura.id
LEFT JOIN manutencao ON manutencao.infraestrutura_id = infraestrutura.id
GROUP BY infraestrutura.id;

SELECT * FROM infraestrutura_resumo;

SELECT REGEXP_SUBSTR(valor, '[0-9]+$') AS '' from leitura where sensor_id in(select id from sensor where tipo = 'qualidade do ar');
