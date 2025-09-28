% --- MODELAGEM DA BASE DE RECONHECIMENTO - Leticia ---

% Fatos das trilhas
trilha(inteligencia_artificial, 'Aplicação e estudo de algoritmos inteligentes, machine learning e visão computacional').
trilha(desenvolvimento_web, 'Criação de sistemas e aplicações web, front-end e back-end').
trilha(seguranca_da_informacao, 'Proteção de dados, criptografia e análise de vulnerabilidade de sistemas').
trilha(ciencia_de_dados, 'Análise e interpretação de grande volume de dados, machine learning').
trilha(redes_e_infraestrutura, 'Manutenção e configuração de redes, servidores de infraestrutura de sistemas').

% Perfis das trilhas com pesos
perfil(inteligencia_artificial, logica_de_programacao, 4).
perfil(inteligencia_artificial, matematica_estatistica, 5).
perfil(inteligencia_artificial, pensamento_abstrato, 5).

perfil(desenvolvimento_web, design_visual, 3).
perfil(desenvolvimento_web, programacao_frontend, 5).
perfil(desenvolvimento_web, programacao_backend, 5).

perfil(seguranca_da_informacao, criptografia_basica, 3).
perfil(seguranca_da_informacao, resolucao_problemas, 4).
perfil(seguranca_da_informacao, conhecimento_redes, 5).

perfil(ciencia_de_dados, resolucao_problemas, 3).
perfil(ciencia_de_dados, matematica_estatistica, 5).
perfil(ciencia_de_dados, programacao_python, 4).

perfil(redes_e_infraestrutura, conhecimento_redes, 5).
perfil(redes_e_infraestrutura, configuracao_servidores, 5).
perfil(redes_e_infraestrutura, resolucao_problemas, 4).

% Perguntas
pergunta(1, 'Você tem afinidade com matemática e estatística?', matematica_estatistica).
pergunta(2, 'Você gosta de programar algoritmos complexos e resolver problemas abstratos?', pensamento_abstrato).
pergunta(3, 'Você gosta de resolver problemas usando lógica de programação?', logica_de_programacao).
pergunta(4, 'Você tem interesse em desenvolvimento visual e design de interfaces?', design_visual).
pergunta(5, 'Você tem interesse em criar aplicações que outras pessoas utilizam diretamente?', programacao_frontend).
pergunta(6, 'Você gosta de programar para web (front-end ou back-end)?', programacao_backend).
pergunta(7, 'Você se vê trabalhando com inovações e soluções criativas?', resolucao_problemas).
pergunta(8, 'Você tem facilidade com redes de computadores e protocolos?', conhecimento_redes).
pergunta(9, 'Você gosta de configurar servidores e entender como sistemas funcionam por trás?', configuracao_servidores).
pergunta(10, 'Você tem interesse em ciência de dados e programação em Python?', programacao_python).

% --- Motor de inferência - Brenda ---

% Predicado que calcula a pontuação para uma trilha baseada nas respostas
calcula_pontuacao(Trilha, Respostas, Pontuacao) :-
    findall(Peso, (
        perfil(Trilha, Habilidade, Peso),
        pergunta(Id, _, Habilidade),
        member(resposta(Id, s), Respostas)
    ), Pesos),
    sum_list(Pesos, Pontuacao).

% Predicado que calcula as pontuações para todas as trilhas e ordena
calcular_pontuacoes(Respostas, PontuacoesOrdenada) :-
    findall(Pontuacao-Trilha, (
        trilha(Trilha, _),
        calcula_pontuacao(Trilha, Respostas, Pontuacao)
    ), Pontuacoes),
    sort(1, @>=, Pontuacoes, PontuacoesOrdenada).

% Predicado principal de recomendação
recomenda(Respostas, Recomendacoes) :-
    calcular_pontuacoes(Respostas, Recomendacoes).

% --- Interface e Fluxo de Execução - Alana ---

:- dynamic resposta/2.

% Predicado principal interativo
iniciar :-
    retractall(resposta(_, _)),
    writeln('--- Sistema Especialista de Trilha Acadêmica ---'),
    writeln('Responda as perguntas com "s" ou "n".'), nl,
    faz_perguntas,
    findall(resposta(Id, Valor), resposta(Id, Valor), Respostas),
    recomenda(Respostas, RecomendacoesOrdenadas),
    exibe_resultado(RecomendacoesOrdenadas).

% Faz todas as perguntas
faz_perguntas :-
    forall(pergunta(Id, Texto, _), fazer_pergunta(Id, Texto)).

% Faz uma pergunta individual
fazer_pergunta(Id, Texto) :-
    format('P~w: ~w (s/n): ', [Id, Texto]),
    flush_output(current_output),
    read_line_to_string(user_input, RespostaString),
    string_lower(RespostaString, RespostaMin),
    atom_string(Resposta, RespostaMin),
    (   (Resposta = s ; Resposta = n)
    ->  assertz(resposta(Id, Resposta))
    ;   writeln('Resposta inválida. Digite apenas s ou n.'),
        fazer_pergunta(Id, Texto)
    ).

% Exibe o resultado (interativo)
exibe_resultado(RecomendacoesOrdenadas) :-
    nl, writeln('Recomendações'),
    writeln('As suas trilhas em ordem de compatibilidade são:'),
    exibe_ranking(1, RecomendacoesOrdenadas).

exibe_ranking(_, []).
exibe_ranking(Posicao, [Pontuacao-Trilha | Resto]) :-
    trilha(Trilha, Descricao),
    writeln('----------------------------------------------------'),
    format('Posição ~w: ~w (Pontuação: ~w)~n', [Posicao, Trilha, Pontuacao]),
    format('   - Descrição: ~w~n', [Descricao]),
    justificar_recomendacao(Trilha, Pontuacao),
    NovaPosicao is Posicao + 1,
    exibe_ranking(NovaPosicao, Resto).

% Justifica a recomendação
justificar_recomendacao(Trilha, Pontuacao) :-
    findall(Habilidade, (
        perfil(Trilha, Habilidade, _),
        pergunta(Id, _, Habilidade),
        resposta(Id, s)
    ), HabilidadesPontuadas),
    format('   - Justificativa (~w pontos):~n', [Pontuacao]),
    (   HabilidadesPontuadas = []
    ->  writeln('     Nenhuma afinidade foi encontrada com base nas suas respostas.')
    ;   writeln('     Você pontuou nessa trilha com afinidade em algumas habilidades.')
    ).

% --- Arquivos de Teste ---

executar_teste_arquivo(NomeArquivo) :-
    format('~nRodando teste: ~w~n', [NomeArquivo]),
    retractall(resposta(_, _)), % limpa respostas anteriores
    carregar_arquivo_teste(NomeArquivo),
    findall(resposta(Id, Valor), resposta(Id, Valor), Respostas),
    recomenda(Respostas, Recomendacoes),
    exibir_resultado_teste(NomeArquivo, Recomendacoes).

carregar_arquivo_teste(NomeArquivo) :-
    atom_concat(NomeArquivo, '.pl', Arquivo),
    (   exists_file(Arquivo)
    ->  consult(Arquivo),
        format('Arquivo ~w carregado.~n', [Arquivo])
    ;   format('Arquivo ~w não encontrado.~n', [Arquivo]),
        fail
    ).

exibir_resultado_teste(NomeArquivo, []) :-
    format('~n ~w: Nenhuma recomendação gerada~n', [NomeArquivo]).

exibir_resultado_teste(NomeArquivo, [Pontuacao-Trilha|Resto]) :-
    format('~n ~w: Recomendação - ~w (Pontuação: ~w)~n', 
           [NomeArquivo, Trilha, Pontuacao]),
    exibir_todas_recomendacoes([Pontuacao-Trilha|Resto]).

exibir_todas_recomendacoes([]).
exibir_todas_recomendacoes([Pontuacao-Trilha|Resto]) :-
    format('- ~w: ~w pontos~n', [Trilha, Pontuacao]),
    exibir_todas_recomendacoes(Resto).

% Executa todos os testes
executar_todos_testes :-
    writeln('Executando testes automáticos '),
    (   executar_teste_arquivo('perfil_1'),
        executar_teste_arquivo('perfil_2'),
        executar_teste_arquivo('perfil_3')
    ->  writeln('Testes finalizados')
    ;   writeln('Algum teste falhou')
    ).
% --- Arquivos de Teste ---

executar_teste_arquivo(NomeArquivo) :-
    format('~nRodando teste: ~w~n', [NomeArquivo]),
    retractall(resposta(_, _)), % limpa respostas anteriores
    carregar_arquivo_teste(NomeArquivo),
    findall(resposta(Id, Valor), resposta(Id, Valor), Respostas),
    recomenda(Respostas, Recomendacoes),
    exibir_resultado_teste(NomeArquivo, Recomendacoes).

carregar_arquivo_teste(NomeArquivo) :-
    atom_concat(NomeArquivo, '.pl', Arquivo),
    (   exists_file(Arquivo)
    ->  consult(Arquivo),
        format('Arquivo ~w carregado.~n', [Arquivo])
    ;   format('Arquivo ~w não encontrado.~n', [Arquivo]),
        fail
    ).

exibir_resultado_teste(NomeArquivo, []) :-
    format('~n ~w: Nenhuma recomendação gerada~n', [NomeArquivo]).

exibir_resultado_teste(NomeArquivo, [Pontuacao-Trilha|Resto]) :-
    format('~n ~w: Recomendação - ~w (Pontuação: ~w)~n', 
           [NomeArquivo, Trilha, Pontuacao]),
    exibir_todas_recomendacoes([Pontuacao-Trilha|Resto]).

exibir_todas_recomendacoes([]).
exibir_todas_recomendacoes([Pontuacao-Trilha|Resto]) :-
    format('- ~w: ~w pontos~n', [Trilha, Pontuacao]),
    exibir_todas_recomendacoes(Resto).

% Executa todos os testes
executar_todos_testes :-
    writeln('Executando testes automáticos '),
    (   executar_teste_arquivo('perfil_1'),
        executar_teste_arquivo('perfil_2'),
        executar_teste_arquivo('perfil_3')
    ->  writeln('Testes finalizados')
    ;   writeln('Algum teste falhou')
    ).

% --- Menu Principal ---

main :-
    menu_principal.

menu_principal :-
    nl,
    writeln('Sistema Especialista para Recomendação de Trilha Acadêmica'),
    writeln('Escolha uma opção:'),
    writeln('1. Questionário'),
    writeln('2. Executar testes automaticos'),
    writeln('3. Sair'),
    write('Opção: '),
    flush_output(current_output),
    read_line_to_string(user_input, Str),
    (   number_string(Opcao, Str)
    ->  executar_opcao(Opcao)
    ;   writeln('Opção inválida!'),
        menu_principal
    ).

executar_opcao(1) :-
    iniciar, menu_principal.

executar_opcao(2) :-
    executar_todos_testes,
    menu_principal.

executar_opcao(3) :-
    writeln('Encerrando').

executar_opcao(_) :-
    writeln('Opção inválida!'),
    menu_principal.
