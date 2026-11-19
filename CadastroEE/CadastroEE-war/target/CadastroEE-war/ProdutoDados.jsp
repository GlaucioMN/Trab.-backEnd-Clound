<%@page import="cadastroee.util.HtmlUtil"%>
<%@page import="cadastroee.model.Produto"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Produto produto = (Produto) request.getAttribute("produto");
    boolean alteracao = produto != null && produto.getIdProduto() != null;
    String acao = alteracao ? "alterar" : "incluir";
    String titulo = alteracao ? "Alterar produto" : "Incluir produto";
%>
<!doctype html>
<html lang="pt-BR">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title><%= titulo %></title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous" defer></script>
    </head>
    <body class="container py-4">
        <header class="mb-4">
            <h1 class="h2"><%= titulo %></h1>
            <p class="text-body-secondary mb-0">Preencha os dados e confirme a operação.</p>
        </header>

        <% if (request.getAttribute("erro") != null) { %>
            <div class="alert alert-danger" role="alert"><%= HtmlUtil.escape((String) request.getAttribute("erro")) %></div>
        <% } %>

        <form class="form" action="ServletProdutoFC" method="post">
            <input type="hidden" name="acao" value="<%= acao %>">
            <% if (alteracao) { %>
                <input type="hidden" name="id" value="<%= produto.getIdProduto() %>">
            <% } %>

            <div class="mb-3">
                <label class="form-label" for="nome">Nome</label>
                <input class="form-control" id="nome" name="nome" type="text" maxlength="120" required value="<%= produto == null ? "" : HtmlUtil.escape(produto.getNome()) %>">
            </div>

            <div class="mb-3">
                <label class="form-label" for="quantidade">Quantidade</label>
                <input class="form-control" id="quantidade" name="quantidade" type="number" min="0" required value="<%= produto == null || produto.getQuantidade() == null ? "" : produto.getQuantidade() %>">
            </div>

            <div class="mb-3">
                <label class="form-label" for="precoVenda">Preço de venda</label>
                <input class="form-control" id="precoVenda" name="precoVenda" type="number" min="0" step="0.01" required value="<%= produto == null || produto.getPrecoVenda() == null ? "" : produto.getPrecoVenda() %>">
            </div>

            <button class="btn btn-primary" type="submit"><%= alteracao ? "Salvar alterações" : "Incluir produto" %></button>
            <a class="btn btn-outline-secondary" href="ServletProdutoFC?acao=listar">Cancelar</a>
        </form>
    </body>
</html>
