function verpdf --description 'Mostra PDFs no kitty: ←/→ (ou ↑/↓) navegam, Home/End vão ao início/fim, q sai'
    set -l n (count $argv)
    set -l i 1
    while test $i -le $n
        set -l arq $argv[$i]
        set -l total (pdfinfo $arq 2>/dev/null | string match -r '^Pages:\s+(\d+)' | tail -1)
        if test -z "$total"
            echo "Não consegui ler: $arq"
            set i (math $i + 1)
            continue
        end
        set -l pag 1
        while true
            clear
            kitten icat --clear
            echo "[$i/$n] $arq — página $pag de $total"
            # ajusta a página à janela: linha 1 é o título, a última é a ajuda
            pdftoppm -png -r 150 -f $pag -l $pag -singlefile $arq \
                | kitten icat --stdin=yes --scale-up --place {$COLUMNS}x(math $LINES - 2)@0x1
            tput cup (math $LINES - 1) 0
            if test $pag -eq $total -a $i -eq $n
                echo -n '(fim) ←/→ página · Home/End início/fim · q sair'
            else
                echo -n '←/→ página · Home/End início/fim · q sair'
            end
            # o read do fish não entrega as setas; o bash lê a tecla crua
            set -l tecla (bash -c 'IFS= read -rsn1 k; if [[ $k == $'"'"'\e'"'"' ]]; then read -rsn2 -t 0.1 r; k=$r; [[ $r == \[[0-9] ]] && read -rsn1 -t 0.1 x; fi; printf %s "$k"')
            switch $tecla
                case q Q
                    clear
                    return
                case '[D' '[A' '[5'  # ←, ↑, PgUp
                    if test $pag -gt 1
                        set pag (math $pag - 1)
                    else if test $i -gt 1
                        set i (math $i - 2)  # volta para o arquivo anterior
                        break
                    end
                case '[H' '[1'  # Home
                    set pag 1
                case '[F' '[4'  # End
                    set pag $total
                case '*'  # →, ↓, PgDn, Enter, espaço
                    if test $pag -lt $total
                        set pag (math $pag + 1)
                    else if test $i -lt $n
                        break  # vai para o próximo arquivo
                    end  # na última página do último arquivo, fica parado
            end
        end
        set i (math $i + 1)
    end
    clear
end
