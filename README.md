# Sistema Especialista de Recomendação de Trilhas Acadêmicas

Trabalho Discente Efetivo da matéria de Programação Lógica e Funcional, ministrada pelo professor Frank de Alcântara para o curso Bacharelado em Ciência da Computação na PUCPR.

---

## Autoras:
Alana da Conceição Queiroz
Brenda Gabrielli Barbosa
Leticia Maria Maia de Andrade Vieira

## Visão Geral
Este projeto implementa um **sistema especialista** em **Prolog**, projetado para recomendar trilhas acadêmicas com base nas respostas do usuário a um questionário interativo.
O sistema utiliza conceitos de **IA simbólica** e **engenharia de conhecimento**, onde o raciocínio se baseia em **fatos, regras e pesos atribuídos a habilidades**. Diferente de técnicas modernas de *machine learning*, aqui não há treinamento em dados: todas as inferências são feitas por **regras explícitas**.

---

## Objetivo
Ajudar estudantes a identificar a trilha acadêmica mais compatível com seus interesses e habilidades, entre as opções:

- **Inteligência Artificial**
- **Desenvolvimento Web**
- **Segurança da Informação**
- **Ciência de Dados**
- **Redes e Infraestrutura**

---

## Estrutura do Sistema
O sistema está dividido em módulos principais:

### 1. **Base de Conhecimento**
- Define as **trilhas** disponíveis (`trilha/2`).  
- Define os **perfis de habilidades** para cada trilha com pesos (`perfil/3`).  
- Define as **perguntas** que serão feitas ao usuário (`pergunta/3`).  

Exemplo:
trilha(inteligencia_artificial, 'Aplicação e estudo de algoritmos inteligentes, machine learning e visão computacional').
perfil(inteligencia_artificial, matematica_estatistica, 5).
pergunta(1, 'Você tem afinidade com matemática e estatística?', matematica_estatistica).

### 2. **Motor de Inferência** 
- Calcula a pontuação de cada trilha com base nas respostas (calcula_pontuacao/3).
- Ordena as trilhas em ordem de compatibilidade (calcular_pontuacoes/2).
- Recomenda a trilha mais adequada (recomenda/2).

Exemplo: 
calcula_pontuacao(Trilha, Respostas, Pontuacao) :-
    findall(Peso, (
        perfil(Trilha, Habilidade, Peso),
        pergunta(Id, _, Habilidade),
        member(resposta(Id, s), Respostas)
    ), Pesos),
    sum_list(Pesos, Pontuacao).

### 3. **Interface Interativa**
- Exibe o questionário.
- Lê respostas do usuário (s ou n).
- Mostra o ranking final de trilhas com justificativas.

Exemplo: 
iniciar :-
    retractall(resposta(_, _)),
    writeln('--- Sistema Especialista de Trilha Acadêmica ---'),
    writeln('Responda as perguntas com "s" ou "n".'), nl,
    faz_perguntas,
    findall(resposta(Id, Valor), resposta(Id, Valor), Respostas),
    recomenda(Respostas, RecomendacoesOrdenadas),
    exibe_resultado(RecomendacoesOrdenadas).

### 4. **Testes Automatizados** 
- Permite carregar arquivos de teste (perfil_1.pl, perfil_2.pl, perfil_3.pl).
- Executa cenários simulados sem interação humana.

### 5. **Menu Principal**
- Opção 1 → Rodar o questionário.
- Opção 2 → Executar testes automáticos.
- Opção 3 → Sair.

Exemplo:
menu_principal :-
    writeln('1. Questionário'),
    writeln('2. Executar testes automáticos'),
    writeln('3. Sair'),
    write('Opção: '),
    ...

---

## Como Executar

### Pré-requisitos:
Instalar SWI-Prolog (ou outro interpretador Prolog).

### Passos
1. Abra o terminal.
2. Carregue o arquivo principal usando: swipl -s base_conhecimento.pl -g main -t halt
3. Escolha no menu:
  1 → Responder o questionário.
  2 → Executar testes automáticos.
  3 → Encerrar.
