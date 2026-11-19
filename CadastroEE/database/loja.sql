/*
  Banco de dados do trabalho CadastroEE.
  Execute este script no SQL Server Management Studio com uma conta administrativa.
  Em ambientes acadêmicos, a senha simples "loja" segue o roteiro da disciplina.
*/

USE master;
GO

IF DB_ID(N'loja') IS NULL
BEGIN
    CREATE DATABASE loja;
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = N'loja')
BEGIN
    CREATE LOGIN loja WITH PASSWORD = 'loja', CHECK_POLICY = OFF;
END;
GO

USE loja;
GO

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = N'loja')
BEGIN
    CREATE USER loja FOR LOGIN loja;
END;
GO

ALTER ROLE db_datareader ADD MEMBER loja;
ALTER ROLE db_datawriter ADD MEMBER loja;
GO

IF OBJECT_ID(N'dbo.produto', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.produto (
        idProduto INT IDENTITY(1,1) NOT NULL,
        nome VARCHAR(120) NOT NULL,
        quantidade INT NOT NULL CONSTRAINT CK_produto_quantidade CHECK (quantidade >= 0),
        precoVenda REAL NOT NULL CONSTRAINT CK_produto_precoVenda CHECK (precoVenda >= 0),
        CONSTRAINT PK_produto PRIMARY KEY (idProduto)
    );
END;
GO

IF NOT EXISTS (SELECT 1 FROM dbo.produto)
BEGIN
    INSERT INTO dbo.produto (nome, quantidade, precoVenda) VALUES
        ('Café 500 g', 25, 18.90),
        ('Leite integral 1 L', 40, 6.75),
        ('Arroz 5 kg', 18, 31.50),
        ('Feijão 1 kg', 30, 9.80);
END;
GO

SELECT idProduto, nome, quantidade, precoVenda
FROM dbo.produto
ORDER BY idProduto;
GO
