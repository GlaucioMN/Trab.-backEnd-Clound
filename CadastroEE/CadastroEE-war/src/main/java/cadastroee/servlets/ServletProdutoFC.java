package cadastroee.servlets;

import cadastroee.controller.ProdutoFacadeLocal;
import cadastroee.model.Produto;
import jakarta.ejb.EJB;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "ServletProdutoFC", urlPatterns = {"/ServletProdutoFC"})
public class ServletProdutoFC extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @EJB
    private ProdutoFacadeLocal facade;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String acao = normalizarAcao(request.getParameter("acao"));
        String destino;

        try {
            switch (acao) {
                case "formIncluir":
                    destino = "/ProdutoDados.jsp";
                    break;
                case "formAlterar":
                    request.setAttribute("produto", buscarProduto(request));
                    destino = "/ProdutoDados.jsp";
                    break;
                case "incluir":
                    Produto novoProduto = new Produto();
                    preencherProduto(novoProduto, request);
                    facade.create(novoProduto);
                    request.setAttribute("mensagem", "Produto incluído com sucesso.");
                    destino = prepararListagem(request);
                    break;
                case "alterar":
                    Produto produtoExistente = buscarProduto(request);
                    preencherProduto(produtoExistente, request);
                    facade.edit(produtoExistente);
                    request.setAttribute("mensagem", "Produto alterado com sucesso.");
                    destino = prepararListagem(request);
                    break;
                case "excluir":
                    facade.remove(buscarProduto(request));
                    request.setAttribute("mensagem", "Produto excluído com sucesso.");
                    destino = prepararListagem(request);
                    break;
                case "listar":
                default:
                    destino = prepararListagem(request);
                    break;
            }
        } catch (IllegalArgumentException ex) {
            request.setAttribute("erro", ex.getMessage());
            destino = acao.startsWith("form") ? "/ProdutoDados.jsp" : prepararListagem(request);
        } catch (RuntimeException ex) {
            getServletContext().log("Falha ao processar a ação " + acao, ex);
            request.setAttribute("erro", "Não foi possível concluir a operação. Verifique os dados e tente novamente.");
            destino = prepararListagem(request);
        }

        RequestDispatcher dispatcher = request.getRequestDispatcher(destino);
        dispatcher.forward(request, response);
    }

    private String prepararListagem(HttpServletRequest request) {
        request.setAttribute("produtos", facade.findAll());
        return "/ProdutoLista.jsp";
    }

    private Produto buscarProduto(HttpServletRequest request) {
        Integer id = parseInteiro(request.getParameter("id"), "Identificador inválido.");
        Produto produto = facade.find(id);
        if (produto == null) {
            throw new IllegalArgumentException("Produto não encontrado.");
        }
        return produto;
    }

    private void preencherProduto(Produto produto, HttpServletRequest request) {
        String nome = request.getParameter("nome");
        if (nome == null || nome.trim().isEmpty()) {
            throw new IllegalArgumentException("Informe o nome do produto.");
        }
        if (nome.trim().length() > 120) {
            throw new IllegalArgumentException("O nome deve ter no máximo 120 caracteres.");
        }

        Integer quantidade = parseInteiro(request.getParameter("quantidade"), "Quantidade inválida.");
        Float preco = parseFloat(request.getParameter("precoVenda"), "Preço de venda inválido.");
        if (quantidade < 0 || preco < 0) {
            throw new IllegalArgumentException("Quantidade e preço não podem ser negativos.");
        }

        produto.setNome(nome.trim());
        produto.setQuantidade(quantidade);
        produto.setPrecoVenda(preco);
        request.setAttribute("produto", produto);
    }

    private Integer parseInteiro(String valor, String mensagem) {
        try {
            return Integer.valueOf(valor);
        } catch (NumberFormatException | NullPointerException ex) {
            throw new IllegalArgumentException(mensagem);
        }
    }

    private Float parseFloat(String valor, String mensagem) {
        try {
            return Float.valueOf(valor == null ? null : valor.replace(',', '.'));
        } catch (NumberFormatException | NullPointerException ex) {
            throw new IllegalArgumentException(mensagem);
        }
    }

    private String normalizarAcao(String acao) {
        return acao == null || acao.trim().isEmpty() ? "listar" : acao.trim();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}
