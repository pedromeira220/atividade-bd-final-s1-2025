-- Criação das tabelas do banco de dados

create table bandeira (
    nome varchar(64) primary key,
    url varchar(64)
);

create table posto (
    cnpj varchar(20) primary key,
    razao_social varchar(128),
    nome_fantasia varchar(128),
    latitude decimal(9,6),
    longitude decimal(9,6),
    endereco varchar(128),
    telefone varchar(20),
    bandeira_nome varchar(64),
    foreign key (bandeira_nome) references bandeira(nome)
);

create table bairro (
    nome varchar(64) primary key,
    cidade_nome varchar(64),
    foreign key (cidade_nome) references cidade(nome)
);

create table cidade (
    nome varchar(64),
    estado varchar(64),
    latitude decimal(9,6),
    longitude decimal(9,6),
    primary key (nome, estado)
);

create table preco (
    valor decimal(10,2),
    momento datetime,
    posto_cnpj varchar(20),
    combustivel_nome varchar(64),
    primary key (valor, momento, posto_cnpj, combustivel_nome),
    foreign key (posto_cnpj, combustivel_nome) references posto_combustivel(posto_cnpj, combustivel_nome)
);

create table posto_combustivel (
    posto_cnpj varchar(20),
    combustivel_nome varchar(64),
    primary key (posto_cnpj, combustivel_nome),
    foreign key (posto_cnpj) references posto(cnpj),
    foreign key (combustivel_nome) references combustivel(nome)
);

create table combustivel (
    nome varchar(64) primary key
);

create table pessoa (
    login varchar(64) primary key,
    nome varchar(128),
    endereco varchar(128),
    bairro_nome varchar(64),
    foreign key (bairro_nome) references bairro(nome)
);

create table veiculo (
    placa varchar(20) primary key,
    marca varchar(64),
    modelo varchar(64),
    pessoa_login varchar(64),
    foreign key (pessoa_login) references pessoa(login)
);

create table usuario (
    login varchar(64) primary key,
    senha varchar(128),
    foreign key (login) references pessoa(login)
);

create table tipo_usuario (
    nome varchar(64) primary key
);

create table usuario_tipo (
    usuario_login varchar(64),
    tipo_usuario_nome varchar(64),
    primary key (usuario_login, tipo_usuario_nome),
    foreign key (usuario_login) references usuario(login),
    foreign key (tipo_usuario_nome) references tipo_usuario(nome)
);

create table comentario (
    pessoa_login varchar(64),
    posto_cnpj varchar(20),
    momento datetime,
    primary key ( momento),
    foreign key (pessoa_login) references pessoa(login),
    foreign key (posto_cnpj) references posto(cnpj)
);

create table abastecimento (
    veiculo_placa varchar(20),
    posto_cnpj varchar(20),
    combustivel_nome varchar(64),
    momento datetime,
    primary key (veiculo_placa, posto_cnpj, combustivel_nome, momento),
    foreign key (veiculo_placa) references veiculo(placa),
    foreign key (posto_cnpj) references posto(cnpj),
    foreign key (combustivel_nome) references combustivel(nome)
);
