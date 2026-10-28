# verpdf

Função do [fish](https://fishshell.com/) para ler PDFs direto no terminal [kitty](https://sw.kovidgoyal.net/kitty/), página por página, ajustando cada página ao tamanho da janela.

```fish
verpdf entrega1.pdf entrega2.pdf
verpdf *.pdf
```

| Tecla | Ação |
|---|---|
| → ↓ PgDn Enter espaço | próxima página (no fim do arquivo, vai ao próximo) |
| ← ↑ PgUp | página anterior (no início, volta ao arquivo anterior) |
| Home / End | primeira / última página do arquivo |
| q | sair |

## Requisitos

- fish
- kitty (usa `kitten icat`)
- poppler (`pdfinfo` e `pdftoppm`)
- bash (para ler as setas)

## Instalação

```fish
cp functions/verpdf.fish ~/.config/fish/functions/
```
