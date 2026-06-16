select count(cpf) from cidadao;

CREATE VIEW reclamacoes AS
SELECT cidadao.nome AS 'Cidadão', motivo, area_urbana.nome AS 'Local'
FROM cidadao INNER JOIN reclamacao INNER JOIN area_urbana
WHERE cpf = cidadao_cpf AND area_urbana.id = area_urbana_id;

select * from reclamacoes;

SELECT REGEXP_SUBSTR(valor, '[0-9]+$') AS resultado from leitura where sensor_id in(select id from sensor where tipo = 'qualidade do ar');
