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
    foreign key (tipo_usuario) references tipo_usuario(id)
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
