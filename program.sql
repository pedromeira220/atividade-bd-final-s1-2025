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

-- 1) listar os postos e o preço mais recente de cada combustível

select 
    p.nome_fantasia as posto, 
    c.nome as combustivel, 
    pr.valor as preco, 
    pr.momento
from posto p
join posto_combustivel pc on p.id = pc.posto_id
join combustivel c on c.id = pc.combustivel_id
join preco pr on pr.posto_combustivel_id = pc.id
where pr.momento = (
    select max(pr2.momento)
    from preco pr2
    where pr2.posto_combustivel_id = pc.id
)
order by p.nome_fantasia, c.nome;

-- 2) listar os comentários dos usuários por posto, mais recentes primeiro

select 
    p.nome_fantasia as posto,
    pes.nome as usuario,
    c.momento,
    c.id as id_comentario
from comentario c
join pessoa pes on pes.id = c.pessoa_id
join posto p on p.id = c.posto_id
order by c.momento desc;

-- 3) listar quais veículos cada usuário possui e quais combustíveis são suportados (via tabela abastecimento)

select 
    pes.nome as usuario,
    v.placa,
    v.marca,
    v.modelo,
    distinct c.nome as combustivel
from pessoa pes
join veiculo v on v.pessoa_id = pes.id
join abastecimento a on a.veiculo_id = v.id
join combustivel c on c.id = a.combustivel_id
order by pes.nome, v.placa;

-- 4) filtrar postos por bandeira e bairro (como sugerido no artigo)

select 
    p.nome_fantasia,
    b.nome as bandeira,
    ba.nome as bairro
from posto p
join bandeira b on b.id = p.bandeira_id
join bairro ba on ba.id = (
    select pe.bairro_id
    from pessoa pe
    join comentario c on c.pessoa_id = pe.id
    where c.posto_id = p.id
    limit 1
)
order by b.nome, ba.nome, p.nome_fantasia;

-- 5) consulta de melhor custo-benefício (simulando cálculo rendimento com fator — ex: gasolina = 1.0, etanol = 0.7)

select 
    p.nome_fantasia as posto,
    c.nome as combustivel,
    pr.valor as preco,
    case 
        when c.nome = 'gasolina' then pr.valor / 1.0
        when c.nome = 'etanol' then pr.valor / 0.7
        when c.nome = 'gnv' then pr.valor / 1.25
        else pr.valor 
    end as custo_proporcional
from posto p
join posto_combustivel pc on p.id = pc.posto_id
join combustivel c on c.id = pc.combustivel_id
join preco pr on pr.posto_combustivel_id = pc.id
where pr.momento = (
    select max(pr2.momento)
    from preco pr2
    where pr2.posto_combustivel_id = pc.id
)
order by custo_proporcional asc;

-- 6) quantidade de comentários por posto (classificação por "popularidade")

select 
    p.nome_fantasia,
    count(c.id) as total_comentarios
from posto p
left join comentario c on c.posto_id = p.id
group by p.id
order by total_comentarios desc;

-- 7) usuários sem veículos cadastrados (detecção de usuários "incompletos")

select 
    pes.nome,
    pes.login
from pessoa pes
left join veiculo v on v.pessoa_id = pes.id
where v.id is null;

-- 8) veículos que já foram abastecidos com mais de um tipo de combustível (usuários com carro flex)

select 
    v.placa,
    count(distinct a.combustivel_id) as qtd_tipos_combustivel
from veiculo v
join abastecimento a on a.veiculo_id = v.id
group by v.id
having qtd_tipos_combustivel > 1
order by qtd_tipos_combustivel desc;
