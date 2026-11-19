## CadastroEE

## Sistema cadastral Web desenvolvido para a disciplina DGT2811 Desenvolvimento Back-End Corporativo com Java e Cloud. O projeto implementa persistência JPA, regras de negócio com EJB, Servlets, JSPs, padrão Front Controller e Bootstrap.



## Estrutura

## - `CadastroEE-ejb`: entidade JPA, facade abstrata, Session Bean e interface local.
## - `CadastroEE-war`: Servlets, Front Controller, páginas JSP e recursos Web.
## - `CadastroEE-ear`: empacotamento corporativo dos módulos EJB e WAR.
## - `database/loja.sql`: criação do banco, login, tabela e dados iniciais.
## - `glassfish/configurar-glassfish.asadmin`: criação do pool e do recurso JNDI.
## - `documentacao`: relatório em PDF para entrega.

## Requisitos

## - JDK 8 ou versão compatível com o GlassFish adotado.
## - Maven 3.9 ou superior.
## - GlassFish Server 6.2.1 ou posterior.
## - SQL Server com TCP/IP habilitado na porta 1433.
## - Driver JDBC Microsoft `mssql-jdbc-12.2.0.jre8.jar`.

## Configuração do banco

## 1. Abra o SQL Server Management Studio com uma conta administrativa.
## 2. Execute `database/loja.sql`.
## 3. Confirme que o login `loja`, o banco `loja` e a tabela `dbo.produto` foram criados.
## 4. Se a instância não usar a porta 1433, ajuste a porta no pool do GlassFish.

## A URL JDBC prevista pelo roteiro é:

## jdbc:sqlserver://localhost:1433;databaseName=loja;encrypt=true;trustServerCertificate=true;


## Configuração do GlassFish

## 1. Copie o driver JDBC para `glassfish/domains/domain1/lib`.
## 2. Reinicie o domínio do GlassFish.
## 3. No diretório `glassfish/bin`, execute os comandos do arquivo `glassfish/configurar-glassfish.asadmin`.
## 4. Confirme que `ping-connection-pool SQLServerPool` retorna sucesso.
## 5. Confirme a existência do recurso JNDI `jdbc/loja`.

## Compilação

## No terminal aberto nesta pasta de entrega, execute:

## bash
## mvn clean package


## O pacote para implantação será criado em:

## CadastroEE-ear/target/CadastroEE.ear


## Implantação e teste

## Implante `CadastroEE-ear/target/CadastroEE.ear` pelo Admin Console do GlassFish ou execute:
 
## bash
## asadmin deploy --force=true CadastroEE-ear/target/CadastroEE.ear


## Após a implantação, teste:

## - Lista simples: `http://localhost:8080/CadastroEE-war/ServletProduto`
## - Cadastro completo: `http://localhost:8080/CadastroEE-war/ServletProdutoFC?acao=listar`

## Valide as quatro operações do CRUD: listar, incluir, alterar e excluir.

## Uso no VS Code

## 1. Abra somente esta pasta de entrega em uma nova janela do VS Code.
## 2. Instale as extensões recomendadas quando solicitado.
## 3. Aguarde a importação dos projetos Maven.
## 4. Use `Ctrl+Shift+B` para executar a tarefa de compilação configurada.

## Uso no NetBeans

## O NetBeans reconhece projetos Maven. Use `File > Open Project`, selecione esta pasta de entrega e aguarde a carga dos três módulos. Configure o ## ## ## GlassFish no painel `Services` e implante o arquivo EAR produzido.

## Arquitetura e fluxo

## 
## Navegador

## ServletProdutoFC (Front Controller)
   ## -- ProdutoLista.jsp
   ## -- ProdutoDados.jsp
   
   
## ProdutoFacadeLocal -> ProdutoFacade (EJB)
   
## EntityManager / JPA -> jdbc/loja -> SQL Server

## O Front Controller interpreta a ação recebida, chama o EJB por meio da interface local e encaminha a requisição ao JSP adequado. A camada Web não #
## acessa o banco diretamente.

## Publicação no Git
