<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.Locale"%>
<%@page import="java.util.Collections"%>
<%@page import="java.util.List"%>
<%@page import="cadastroee.util.HtmlUtil"%>
<%@page import="cadastroee.model.Produto"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    List<Produto> produtos = (List<Produto>) request.getAttribute("produtos");
    if (produtos == null) {
        produtos = Collections.emptyList();
    }
    NumberFormat moeda = NumberFormat.getCurrencyInstance(new Locale("pt", "BR"));
%>
<!doctype html>
<html lang="pt-BR">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Cadastro de produtos</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous" defer></script>
    </head>
    <body class="container py-4">
        <header class="mb-4">
            <h1 class="h2">Produtos cadastrados</h1>
            <p class="text-body-secondary mb-0">Consulte e mantenha os itens da loja.</p>
        </header>

        <% if (request.getAttribute("mensagem") != null) { %>
            <div class="alert alert-success" role="alert"><%= HtmlUtil.escape((String) request.getAttribute("mensagem")) %></div>
        <% } %>
        <% if (request.getAttribute("erro") != null) { %>
            <div class="alert alert-danger" role="alert"><%= HtmlUtil.escape((String) request.getAttribute("erro")) %></div>
        <% } %>

        <a class="btn btn-primary m-2 ms-0" href="ServletProdutoFC?acao=formIncluir">Incluir produto</a>

        <div class="table-responsive">
            <table class="table table-striped align-middle">
                <thead class="table-dark">
                    <tr>
                        <th scope="col">ID</th>
                        <th scope="col">Nome</th>
                        <th scope="col" class="text-end">Quantidade</th>
                        <th scope="col" class="text-end">Preço de venda</th>
                        <th scope="col" class="text-center">Ações</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Produto produto : produtos) { %>
                    <tr>
                        <td><%= produto.getIdProduto() %></td>
                        <td><%= HtmlUtil.escape(produto.getNome()) %></td>
                        <td class="text-end"><%= produto.getQuantidade() %></td>
                        <td class="text-end"><%= moeda.format(produto.getPrecoVenda()) %></td>
                        <td class="text-center text-nowrap">
                            <a class="btn btn-primary btn-sm" href="ServletProdutoFC?acao=formAlterar&amp;id=<%= produto.getIdProduto() %>">Alterar</a>
                            <a class="btn btn-danger btn-sm" href="ServletProdutoFC?acao=excluir&amp;id=<%= produto.getIdProduto() %>" onclick="return confirm('Excluir este produto?');">Excluir</a>
                        </td>
                    </tr>
                    <% } %>
                    <% if (produtos.isEmpty()) { %>
                    <tr><td colspan="5" class="text-center text-body-secondary py-4">Nenhum produto cadastrado.</td></tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </body>
</html>
