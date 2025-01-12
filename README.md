# Processador RISC-V32i (Projeto Parcialmente Desenvolvido)

Este projeto visa o desenvolvimento de um **processador RISC-V32i** parcial, implementado em **VHDL**, com foco nos blocos fundamentais necessários para a execução de operações de controle e manipulação de dados em sistemas digitais.

### Funcionalidades  
1. **JAL (Jump and Link):**  
   - Atualiza o contador de programa (PC) somando o valor atual do PC a um deslocamento imediato.  
   - Implementa saltos incondicionais, essenciais para sub-rotinas e funções.  

2. **JALR (Jump and Link Register):**  
   - Atualiza o PC com base no valor do registrador RS1 somado a um deslocamento imediato.  
   - Inclui uma máscara (`x"FFFFFFFE"`) para garantir alinhamento a múltiplos de 4.  

3. **BRANCH:**  
   - Realiza desvios condicionais, atualizando o PC com base no deslocamento imediato e um sinal de controle.  
   - Implementa saltos condicionais usados em estruturas como `if` e `while`.  

4. **Branch Control:**  
   - Interpreta sinais de controle (2 bits) para determinar a condição de desvio, como igualdade ou diferença.  
   - Essencial para a execução de instruções de controle de fluxo.  

5. **Mux 4x1:**  
   - Seleciona uma entre quatro entradas com base em um sinal de controle (2 bits).  
   - Facilita a escolha dinâmica de dados, permitindo maior flexibilidade no processamento.  

---

### Tecnologias Utilizadas  
- **VHDL (VHSIC Hardware Description Language):**  
  Linguagem de descrição de hardware utilizada para implementar os blocos do processador.  
- **Simuladores de Circuitos Digitais:**  
  Ferramentas para simular, depurar e validar o comportamento dos módulos implementados.  
- **Plataforma FPGA (opcional):**  
  Possibilidade de síntese do código VHDL para validação prática.  

---

### Objetivo  
O objetivo principal deste projeto é explorar os fundamentos de design de arquiteturas de processadores com foco no conjunto de instruções RISC-V32i.  
- **Educar:** Oferecer uma base sólida em **VHDL** e conceitos de arquitetura de computadores.  
- **Desenvolver:** Criar blocos modulares que constituem elementos básicos de controle de fluxo e manipulação de dados em processadores.  
- **Aplicar:** Integrar os conhecimentos de **sistemas digitais** em uma implementação prática, mesmo que parcial.  

Este projeto é ideal para demonstrar como componentes de processadores modernos operam de forma integrada, reforçando habilidades práticas e teóricas essenciais para o design de hardware.
