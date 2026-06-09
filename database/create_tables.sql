CREATE DATABASE IF NOT EXISTS smart_city;
USE smart_city;

CREATE TABLE IF NOT EXISTS area_urbana (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS evento_urbano (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    data DATETIME NOT NULL,
    nome VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS infraestrutura (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    tipo VARCHAR(45) NOT NULL,
    area_urbana_id INT NOT NULL,
    CONSTRAINT fk_infraestrutura_area_urbana FOREIGN KEY (area_urbana_id) REFERENCES area_urbana (id)
);

CREATE TABLE IF NOT EXISTS servico_publico (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(45) NOT NULL,
    infraestrutura_id INT NOT NULL,
    CONSTRAINT fk_servico_publico_infraestrutura FOREIGN KEY (infraestrutura_id) REFERENCES infraestrutura (id)
);

CREATE TABLE IF NOT EXISTS sensor (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    tipo VARCHAR(45) NOT NULL,
    latitude VARCHAR(45) NOT NULL,
    logitude VARCHAR(45) NOT NULL,
    infraestrutura_id INT NOT NULL,
    CONSTRAINT fk_sensor_infraestrutura FOREIGN KEY (infraestrutura_id) REFERENCES infraestrutura (id)
);

CREATE TABLE IF NOT EXISTS leitura (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    data DATETIME NOT NULL,
    valor VARCHAR(45) NOT NULL,
    sensor_id INT NOT NULL,
    CONSTRAINT fk_leitura_sensor FOREIGN KEY (sensor_id) REFERENCES sensor (id)
);

CREATE TABLE IF NOT EXISTS manutencao (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    responsavel VARCHAR(255) NOT NULL,
    inicio DATE NOT NULL,
    fim DATE NOT NULL,
    descrição VARCHAR(45),
    infraestrutura_id INT NOT NULL,
    CONSTRAINT fk_manutencao_infraestrutura FOREIGN KEY (infraestrutura_id) REFERENCES infraestrutura (id)
);

CREATE TABLE IF NOT EXISTS itens (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(45) NOT NULL,
    infraestrutura_id INT NOT NULL,
    CONSTRAINT fk_itens_infraestrutura FOREIGN KEY (infraestrutura_id) REFERENCES infraestrutura (id)
);

CREATE TABLE IF NOT EXISTS status (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    data DATE NOT NULL,
    status_item VARCHAR(45) NOT NULL,
    itens_id INT NOT NULL,
    CONSTRAINT fk_status_itens FOREIGN KEY (itens_id) REFERENCES itens (id)
);

CREATE TABLE IF NOT EXISTS cidadao (
    cpf VARCHAR(11) NOT NULL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    data_nascimento DATE NOT NULL,
    estado_civil VARCHAR(20) NOT NULL,
    cargo VARCHAR(45) NOT NULL
);

CREATE TABLE IF NOT EXISTS propriedade (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    latitude VARCHAR(45) NOT NULL,
    longitude VARCHAR(45) NOT NULL,
    area_urbana_id INT NOT NULL,
    cidadao_cpf VARCHAR(11) NOT NULL,
    CONSTRAINT fk_propriedade_area_urbana FOREIGN KEY (area_urbana_id) REFERENCES area_urbana (id),
    CONSTRAINT fk_propriedade_cidadao FOREIGN KEY (cidadao_cpf) REFERENCES cidadao (cpf)
);

CREATE TABLE IF NOT EXISTS reclamacao (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    motivo VARCHAR(255) NOT NULL,
    data DATE NOT NULL,
    cidadao_cpf VARCHAR(11) NOT NULL,
    area_urbana_id INT NOT NULL,
    servico_publico_id INT NOT NULL,
    CONSTRAINT fk_reclamacao_cidadao FOREIGN KEY (cidadao_cpf) REFERENCES cidadao (cpf),
    CONSTRAINT fk_reclamacao_area_urbana FOREIGN KEY (area_urbana_id) REFERENCES area_urbana (id),
    CONSTRAINT fk_reclamacao_servico_publico FOREIGN KEY (servico_publico_id) REFERENCES servico_publico (id)
);

CREATE TABLE IF NOT EXISTS area_urbana_has_evento_urbano (
    area_urbana_id INT NOT NULL,
    evento_urbano_id INT NOT NULL,
    PRIMARY KEY (area_urbana_id, evento_urbano_id),
    CONSTRAINT fk_au_eu_area_urbana FOREIGN KEY (area_urbana_id) REFERENCES area_urbana (id),
    CONSTRAINT fk_au_eu_evento_urbano FOREIGN KEY (evento_urbano_id) REFERENCES evento_urbano (id)
);

CREATE TABLE IF NOT EXISTS infraestrutura_has_evento_urbano (
    infraestrutura_id INT NOT NULL,
    evento_urbano_id INT NOT NULL,
    PRIMARY KEY (infraestrutura_id, evento_urbano_id),
    CONSTRAINT fk_infra_eu_infraestrutura FOREIGN KEY (infraestrutura_id) REFERENCES infraestrutura (id),
    CONSTRAINT fk_infra_eu_evento_urbano FOREIGN KEY (evento_urbano_id) REFERENCES evento_urbano (id)
);