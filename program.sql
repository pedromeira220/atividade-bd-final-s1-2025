-- Criação das tabelas do banco de dados com UUID como chave primária

create table bandeira (
    id varchar(36) primary key,
    nome varchar(64) unique,
    url varchar(64)
);

create table posto (
    id varchar(36) primary key,
    cnpj varchar(20) unique,
    razao_social varchar(128),
    nome_fantasia varchar(128),
    latitude decimal(9,6),
    longitude decimal(9,6),
    endereco varchar(128),
    telefone varchar(20),
    bandeira_id varchar(36),
    foreign key (bandeira_id) references bandeira(id)
);

create table bairro (
    id varchar(36) primary key,
    nome varchar(64) unique,
    cidade_id varchar(36) not null,
    foreign key (cidade_id) references cidade(id)
);

create table cidade (
    id varchar(36) primary key,
    nome varchar(64),
    estado varchar(64),
    latitude decimal(9,6),
    longitude decimal(9,6),
    unique (nome, estado)
);

create table preco (
    id varchar(36) primary key,
    valor decimal(10,2),
    momento datetime,
    posto_combustivel_id varchar(36) not null,
    foreign key (posto_combustivel_id) references posto_combustivel(id)
);

create table posto_combustivel (
    id varchar(36) primary key,
    posto_id varchar(36),
    combustivel_id varchar(36),
    unique (posto_id, combustivel_id),
    foreign key (posto_id) references posto(id),
    foreign key (combustivel_id) references combustivel(id)
);

create table combustivel (
    id varchar(36) primary key,
    nome varchar(64) unique
);

create table veiculo (
    id varchar(36) primary key,
    placa varchar(20) unique,
    marca varchar(64),
    modelo varchar(64),
    pessoa_id varchar(36) not null,
    foreign key (pessoa_id) references pessoa(id)
);

create table abastecimento (
    id varchar(36) primary key,
    veiculo_id varchar(36),
    combustivel_id varchar(36),
    foreign key (veiculo_id) references veiculo(id),
    foreign key (combustivel_id) references combustivel(id)
);

create table pessoa (
    id varchar(36) primary key,
    login varchar(64) unique,
    nome varchar(128),
    endereco varchar(128),
    bairro_id varchar(36) not null,
    foreign key (bairro_id) references bairro(id)
);

create table usuario (
    id varchar(36) primary key,
    login varchar(64) unique,
    senha varchar(128),
    pessoa_id varchar(36),
    tipo_usuario_id varchar(36),
    foreign key (pessoa_id) references pessoa(id),
    foreign key (tipo_usuario_id) references tipo_usuario(id)
);

create table tipo_usuario (
    id varchar(36) primary key,
    nome varchar(64) unique
);

create table comentario (
    id varchar(36) primary key,
    pessoa_id varchar(36),
    posto_id varchar(36),
    momento datetime,
    foreign key (pessoa_id) references pessoa(id),
    foreign key (posto_id) references posto(id)
);

-- Inserção de registros no banco de dados

INSERT INTO tipo_usuario (id, nome) VALUES 
('tipo-1', 'Administrador'),
('tipo-2', 'Usuário Comum');

INSERT INTO cidade (id, nome, estado, latitude, longitude) VALUES
('cidade-1', 'Campinas', 'SP', -22.9099, -47.0626),
('cidade-2', 'Sumaré', 'SP', -22.8212, -47.2666);

INSERT INTO bairro (id, nome, cidade_id) VALUES
('bairro-1', 'Centro', 'cidade-1'),
('bairro-2', 'Centro Sumaré', 'cidade-2');

INSERT INTO pessoa (id, login, nome, endereco, bairro_id) VALUES
('pessoa-1', 'pedro-meira', 'Pedro Meira', 'Rua XPTO, 123', 'bairro-1'),
('pessoa-2', 'joao-pedro', 'João Pedro', 'Avenida Brasil, 456', 'bairro-2');

INSERT INTO usuario (id, login, senha, pessoa_id, tipo_usuario_id) VALUES
('usuario-1', 'pedro-meira', 'senha123', 'pessoa-1', 'tipo-1'),
('usuario-2', 'joao-pedro', 'senha456', 'pessoa-2', 'tipo-2');

INSERT INTO bandeira (id, nome, url) VALUES
('bandeira-1', 'Shell', 'http://shell.com'),
('bandeira-2', 'Ipiranga', 'http://ipiranga.com');

INSERT INTO posto (id, cnpj, razao_social, nome_fantasia, latitude, longitude, endereco, telefone, bandeira_id) VALUES
('posto-1', '12345678000199', 'Posto Shell', 'Posto Shell Centro', -22.9099, -47.0626, 'Rua XPO, 789', '(19) 99999-9999', 'bandeira-1'),
('posto-2', '98765432000188', 'Posto Ipiranga', 'Ipiranga Sumaré', -22.8212, -47.2666, 'Avenida XPTO, 321', '(19) 98888-8888', 'bandeira-2');

INSERT INTO combustivel (id, nome) VALUES
('combustivel-1', 'Gasolina'),
('combustivel-2', 'Etanol');

INSERT INTO posto_combustivel (id, posto_id, combustivel_id) VALUES
('pc-1', 'posto-1', 'combustivel-1'),
('pc-2', 'posto-1', 'combustivel-2'),
('pc-3', 'posto-2', 'combustivel-1');

INSERT INTO preco (id, valor, momento, posto_combustivel_id) VALUES
('preco-1', 5.79, '2025-06-01 08:00:00', 'pc-1'),
('preco-2', 3.99, '2025-06-03 08:30:00', 'pc-2'),
('preco-3', 5.89, '2025-06-02 09:00:00', 'pc-3');

INSERT INTO veiculo (id, placa, marca, modelo, pessoa_id) VALUES
('veiculo-1', 'ABC1234', 'Toyota', 'Corolla', 'pessoa-1'),
('veiculo-2', 'XYZ5678', 'Honda', 'Civic', 'pessoa-2');

INSERT INTO abastecimento (id, veiculo_id, combustivel_id) VALUES
('abastecimento-1', 'veiculo-1', 'combustivel-1'),
('abastecimento-2', 'veiculo-1', 'combustivel-2'),
('abastecimento-3', 'veiculo-2', 'combustivel-1');

INSERT INTO comentario (id, pessoa_id, posto_id, momento) VALUES
('comentario-1', 'pessoa-1', 'posto-1', '2025-06-02 10:00:00'),
('comentario-2', 'pessoa-2', 'posto-2', '2025-06-02 11:00:00');

-- listar os preços mais recentes de cada combustível por posto

select 
    p.nome_fantasia as posto, 
    c.nome as combustivel, 
    pr.valor as preco, 
    pr.momento
from preco pr
join posto_combustivel pc on pr.posto_combustivel_id = pc.id
join posto p on pc.posto_id = p.id
join combustivel c on pc.combustivel_id = c.id
where pr.momento = (
    select max(pr2.momento)
    from preco pr2
    where pr2.posto_combustivel_id = pc.id
)
order by p.nome_fantasia, c.nome;

-- listar os veículos de cada pessoa

select 
    pes.nome as usuario, 
    v.placa, 
    v.marca, 
    v.modelo
from veiculo v
join pessoa pes on v.pessoa_id = pes.id
order by pes.nome, v.placa;

-- filtrar postos de uma determinada bandeira

select 
    p.nome_fantasia, 
    b.nome as bandeira
from posto p
join bandeira b on p.bandeira_id = b.id
where b.nome = 'shell'
order by p.nome_fantasia;

-- filtrar postos de uma determinada cidade

select 
    p.nome_fantasia, 
    c.nome as cidade
from posto p
join bandeira b on p.bandeira_id = b.id
join comentario cm on cm.posto_id = p.id
join pessoa pes on pes.id = cm.pessoa_id
join bairro ba on pes.bairro_id = ba.id
join cidade c on ba.cidade_id = c.id
where c.nome = 'Campinas'
order by p.nome_fantasia;

-- listar os tipos de combustíveis abastecidos por um veículo específico

select 
    c.nome as combustivel
from combustivel c
where c.id in (
    select a.combustivel_id 
    from abastecimento a
    where a.veiculo_id = 'uuid-veiculo-1'
);

-- 9) listar as bandeiras cadastradas no sistema

select nome, url 
from bandeira 
order by nome;

-- 10) listar a quantidade de veículos cadastrados por pessoa

select 
    pes.nome, 
    (select count(*) from veiculo v where v.pessoa_id = pes.id) as qtd_veiculos
from pessoa pes
order by qtd_veiculos desc, pes.nome;

