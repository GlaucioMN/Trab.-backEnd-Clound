package cadastroee.servlets;

import cadastroee.controller.ProdutoFacadeLocal;
import cadastroee.model.Produto;
import cadastroee.util.HtmlUtil;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.nio.charset.StandardCharsets;
import java.text.NumberFormat;
import java.util.List;
import java.util.Locale;

@WebServlet(name = "ServletProduto", urlPatterns = {"/ServletProduto"})
public class ServletProduto extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @EJB
    private ProdutoFacadeLocal facade;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setCharacterEncoding(StandardCharsets.UTF_8.name());
        response.setContentType("text/html;charset=UTF-8");

        List<Produto> produtos = facade.findAll();
        NumberFormat moeda = NumberFormat.getCurrencyInstance(new Locale("pt", "BR"));

        try (PrintWriter out = response.getWriter()) {
            out.println("<!doctype html><html lang=\"pt-BR\"><head><meta charset=\"UTF-8\">");
            out.println("<meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">");
            out.println("<title>Produtos</title></head><body>");
            out.println("<h1>Lista de produtos</h1><ul>");
            for (Produto produto : produtos) {
                out.printf("<li>%d - %s - %d unidade(s) - %s</li>%n",
                        produto.getIdProduto(), HtmlUtil.escape(produto.getNome()),
                        produto.getQuantidade(), moeda.format(produto.getPrecoVenda()));
            }
            out.println("</ul><p><a href=\"ServletProdutoFC?acao=listar\">Abrir cadastro completo</a></p>");
            out.println("</body></html>");
        }
    }
}
