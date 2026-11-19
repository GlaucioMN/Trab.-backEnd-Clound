# Guia completo para executar e entender o CadastroEE

Este guia permite que outra pessoa configure, execute, teste e entregue o trabalho sem depender do computador em que ele foi desenvolvido.

## 1. O que é este trabalho

O **CadastroEE** é uma aplicação Web corporativa de cadastro de produtos para a disciplina **DGT2811 — Desenvolvimento Back-End Corporativo com Java e Cloud**.

Ela implementa as três etapas solicitadas no roteiro:

1. **Persistência e controle:** entidade JPA `Produto`, EJB Session Bean, interface local e banco SQL Server.
2. **Interface cadastral:** Servlets, JSPs e padrão Front Controller para listar, incluir, alterar e excluir produtos.
3. **Design:** interface responsiva construída com Bootstrap.

## 2. Estrutura da entrega

```text
CadastroEE_Entrega_2026-11-10/
├── CadastroEE-ejb/          # entidade JPA, facade e regras de negócio EJB
├── CadastroEE-war/          # Servlets, JSPs, Front Controller e Bootstrap
├── CadastroEE-ear/          # módulo que reúne EJB e WAR para implantação
├── artefatos/CadastroEE.ear # EAR já compilado para implantar
├── database/loja.sql        # script do banco SQL Server
├── glassfish/               # comandos de criação do pool JDBC e JNDI
├── documentacao/            # relatório PDF e este guia
├── evidencias/              # prévias visuais da interface
├── README.md                # resumo técnico
├── LEIA-ME-PRIMEIRO.md      # orientação rápida
└── pom.xml                  # projeto Maven principal
```

## 3. Arquitetura da aplicação

```text
Navegador
   ↓
ServletProdutoFC (Front Controller)
   ↓
ProdutoFacadeLocal (interface EJB)
   ↓
ProdutoFacade (Session Bean) → EntityManager / JPA
   ↓
Recurso JNDI jdbc/loja → SQL Server / banco loja
```

- `Produto.java`: representa a tabela `produto`.
- `ProdutoFacade.java`: centraliza acesso e operações sobre produtos.
- `ServletProdutoFC.java`: recebe a ação solicitada e envia à JSP correta.
- `ProdutoLista.jsp`: exibe a tabela de produtos.
- `ProdutoDados.jsp`: exibe o formulário de inclusão ou alteração.
- `ServletProduto.java`: página simples para demonstrar a comunicação Servlet–EJB.

## 4. Programas necessários

Instale ou tenha acesso a:

- **JDK 8** (o código foi compilado para Java 8).
- **Maven 3.9 ou superior**.
- **Microsoft SQL Server** e **SQL Server Management Studio (SSMS)**.
- **GlassFish 6.2.1** ou compatível com Jakarta EE 9.1.
- **Visual Studio Code** ou NetBeans (opcional para editar; não é necessário para executar).
- Driver Microsoft JDBC para SQL Server terminado em **`jre8.jar`**.

No PowerShell, confirme Java e Maven:

```powershell
java -version
mvn -version
```

## 5. Configuração do SQL Server

### 5.1 Habilitar a porta esperada

O projeto considera SQL Server local na porta **1433**.

1. Abra o **SQL Server Configuration Manager**.
2. Vá em **SQL Server Network Configuration → Protocols for ...**.
3. Habilite **TCP/IP**.
4. Em **TCP/IP → Properties → IP Addresses**, informe `1433` em **TCP Port** na seção `IPAll`.
5. Reinicie o serviço do SQL Server.

> Se a instalação usa uma porta diferente, altere `portNumber=1433` para a porta correta em `glassfish/configurar-glassfish.asadmin` antes de criar o pool.

### 5.2 Criar o banco

1. Abra o **SSMS** usando uma conta com permissão administrativa.
2. Abra `database/loja.sql`.
3. Clique em **Execute**.
4. Confirme que foram criados:
   - banco: `loja`;
   - login e usuário: `loja`;
   - senha de laboratório: `loja`;
   - tabela: `dbo.produto`;
   - quatro produtos de exemplo.

Consulta de conferência:

```sql
USE loja;
SELECT idProduto, nome, quantidade, precoVenda FROM dbo.produto;
```

> A senha `loja` foi mantida porque ela aparece no roteiro acadêmico. Nunca use essa senha em um sistema real.

## 6. Instalar o driver JDBC no GlassFish

1. Baixe o JDBC Driver oficial da Microsoft para SQL Server.
2. Para Java 8, use o arquivo com final `jre8.jar`, como `mssql-jdbc-12.2.0.jre8.jar`.
3. Copie **somente um** driver JDBC para:

```text
<PASTA_DO_GLASSFISH>\glassfish\domains\domain1\lib
```

4. Reinicie o domínio GlassFish depois da cópia:

```powershell
Set-Location '<PASTA_DO_GLASSFISH>\glassfish\bin'
.\asadmin.bat stop-domain domain1
.\asadmin.bat start-domain domain1
```

## 7. Criar pool JDBC e recurso JNDI

O projeto espera os seguintes nomes; não os altere sem também alterar o código:

| Item | Valor |
|---|---|
| Pool | `SQLServerPool` |
| Recurso JNDI | `jdbc/loja` |
| Servidor | `localhost` |
| Porta | `1433` |
| Banco | `loja` |
| Usuário | `loja` |

No PowerShell, execute:

```powershell
Set-Location '<PASTA_DO_GLASSFISH>\glassfish\bin'
Get-Content 'C:\caminho\da\entrega\glassfish\configurar-glassfish.asadmin' | .\asadmin.bat multimode
.\asadmin.bat ping-connection-pool SQLServerPool
.\asadmin.bat list-jdbc-resources
```

O teste deve retornar sucesso. Se o pool já existir, não execute o arquivo de criação novamente; apenas use o comando `ping-connection-pool`.

## 8. Compilar o projeto

Abra um terminal na pasta principal da entrega (a mesma que contém `pom.xml`) e execute:

```powershell
mvn clean package
```

O resultado esperado é `BUILD SUCCESS`. O EAR gerado ficará em:

```text
CadastroEE-ear\target\CadastroEE.ear
```

Também há uma cópia já compilada em `artefatos\CadastroEE.ear`.

## 9. Implantar no GlassFish

Com o GlassFish ligado:

```powershell
Set-Location '<PASTA_DO_GLASSFISH>\glassfish\bin'
.\asadmin.bat deploy --force=true 'C:\caminho\da\entrega\CadastroEE-ear\target\CadastroEE.ear'
```

Alternativamente, abra o Admin Console do GlassFish e use **Applications → Deploy**, selecionando o arquivo EAR.

## 10. Testar a aplicação

Abra no navegador:

```text
http://localhost:8080/CadastroEE-war/ServletProdutoFC?acao=listar
```

Teste e registre, se necessário, estas operações:

1. **Listar:** devem aparecer os quatro produtos do script SQL.
2. **Incluir:** clique em “Incluir produto”, preencha nome, quantidade e preço.
3. **Alterar:** clique em “Alterar”, modifique um campo e salve.
4. **Excluir:** clique em “Excluir” e confirme a remoção.
5. **Teste de EJB:** abra `http://localhost:8080/CadastroEE-war/ServletProduto`.

Para uma entrega acadêmica mais forte, faça capturas da tela de listagem e de cada operação concluída.

## 11. Problemas frequentes

| Mensagem ou sintoma | Causa provável | Como resolver |
|---|---|---|
| `ClassNotFoundException` com `SQLServerDataSource` | Driver JDBC ausente ou no local errado | Copie o JAR `jre8` para `domain1/lib` e reinicie o domínio. |
| `Connection refused` | SQL Server parado, TCP/IP desabilitado ou porta incorreta | Inicie o serviço, habilite TCP/IP e confira a porta. |
| `Login failed for user loja` | Script SQL não foi executado ou senha diferente | Execute `database/loja.sql` com conta administrativa. |
| Erro ao criar pool porque ele existe | Configuração foi executada mais de uma vez | Use apenas `ping-connection-pool SQLServerPool`. |
| Erro de recurso `jdbc/loja` não encontrado | Recurso JNDI não foi criado | Execute a configuração do GlassFish uma vez. |
| Aplicação abre mas não lista produtos | Conexão ou banco incorreto | Rode o `ping-connection-pool` e consulte a tabela no SSMS. |
| Erro 404 na URL | EAR não foi implantado ou contexto diferente | Confirme o deploy com `asadmin list-applications`. |

## 12. O que entregar ao professor

Antes do envio final:

1. Preencha no relatório: instituição, campus, curso, turma, semestre, nome, matrícula e link do Git.
2. Troque a indicação “LOGOMARCA DA INSTITUIÇÃO” pela logo correta, se solicitada.
3. Execute os testes e, caso o professor exija, substitua as prévias de interface por capturas reais do computador.
4. Faça um repositório Git apenas desta pasta de entrega.
5. Envie o repositório e o PDF conforme a orientação do professor.

Comandos Git sugeridos:

```powershell
git init
git add .
git commit -m 'Entrega CadastroEE'
```

## 13. O que já está pronto e o que depende do computador do colega

| Situação | Item |
|---|---|
| Pronto | Código-fonte, estrutura Maven, módulos EJB/WAR/EAR e Bootstrap. |
| Pronto | Script SQL, comandos GlassFish, EAR compilado, relatório e prévias visuais. |
| Pronto | Compilação Maven validada durante a preparação da entrega. |
| Precisa configurar localmente | SQL Server, driver JDBC e GlassFish. |
| Precisa testar localmente | A conexão real, implantação e CRUD no navegador. |
| Precisa personalizar | Dados acadêmicos, logo e link do repositório no relatório. |
