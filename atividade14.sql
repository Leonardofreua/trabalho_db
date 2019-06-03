1. Considere o banco de dados  de uma rede de hospitais. A partir dos requisitos a seguir construa o modelo relacional (DER):
--
-- - Considere Médicos, Pacientes e Enfermeiros como entidades separadas e independentes.
--
-- - A rede possui vários Hospitais.
--
-- - Cada Hospital possui um Nome e CNPJ único.
--
-- - Cada hospital possui várias alas.
--
-- - As Alas possuem identificação e descrição referente aos tipos de tratamentos e doenças.
--
-- - São mantidos os registros de todos os enfermeiros (as) e possuem nome, RG único, COREN único e Salário.
--
-- - Cada Ala possui somente um enfermeiro e atende todos os pacientes dessa ala.
--
-- - Médicos tem nome, CRM único, Salário, especialidade, data e Pais de formação.
--
-- - Um médico pode ter apenas uma especialidade registrada no hospital.
--
-- - Os tipos de especialidades de médicos devem ser mantidos com seu nome e descrição.
--
-- - Os médicos são credenciados em diversos planos de saúde que mantem a data de credenciamento.
--
-- - Os hospitais são credenciados em diversos planos de saúde que mantem a data de credenciamento.
--
-- - Plano de saúde têm um Nome e Telefone.
--
-- - Pacientes são associados em plano de saúde e possuem categoria e valor. O valor pode variar de acordo com cada paciente em função de descontos e convênios com empresas.
--
-- - Deve ser mantido um registro de histórico de valores e categorias que um determinado paciente passou em seu tempo de associação em um plano de saúde.
--
-- - Um paciente pode ser associado somente a um plano de saúde.
--
-- - Para cada plano de saúde é necessário saber os médicos credenciados no mesmo.
--
-- - Todo atendimento de um médico a um paciente deve ser registrado com a data e hora em que o mesmo ocorreu.
--
-- - O Hospital deve manter os registros de pacientes.
--
-- -  Pacientes possuem Nome, CPF único.
--
-- - Um mesmo paciente pode ser atendido por mais de um médico.
--
-- - Todos os pacientes devem ser internados para receber atendimentos.
--
-- -  A internação deve registrar a data e hora, assim como a alta, hora.
--
-- - Na internação também deve ser registrada a ala que o paciente foi internado.

--  2. A partir do modelo relacional, crie o modelo físico do banco de dados (SQL).
--  Atribua as chaves primarias e estrangeiras necessárias para garantir a integridade relacional entre as entidades.
--  Defina como chave única os atributos (colunas) que achar necessário.

CREATE TABLE HOSPITAL(
	ID INTEGER,
	NAME VARCHAR(100),
	CNPJ INTEGER,
	CONSTRAINT PK_HOSPITAL PRIMARY KEY(ID)
);
GRANT CREATE ANY TABLE TO HOSPITAL;
GRANT CREATE ANY TABLE TO ESPECIALIDADE;
GRANT CREATE ANY TABLE TO PLANO_SAUDE;
GRANT CREATE ANY TABLE TO CATEGORIA;
GRANT CREATE ANY TABLE TO PACIENTE;
GRANT CREATE ANY TABLE TO MEDICOS;
GRANT CREATE ANY TABLE TO ENFERMEIRO;
GRANT CREATE ANY TABLE TO ATENDIMENTO;
GRANT CREATE ANY TABLE TO CREDENCIAMENTO_HOSPITAL;
GRANT CREATE ANY TABLE TO CREDENCIAMENTO_MEDICO;
GRANT CREATE ANY TABLE TO ALAS;
GRANT CREATE ANY TABLE TO INTERNACAO;
GRANT CREATE ANY TABLE TO HISTORICO;

CREATE TABLE ESPECIALIDADE(
	ID INTEGER,
	NOME VARCHAR(100),
	DESCRICAO VARCHAR(300),
	CONSTRAINT PK_ESPECIALIDADE PRIMARY KEY(ID)
);

CREATE TABLE PLANO_SAUDE(
	ID INTEGER,
	NOME VARCHAR(100),
	TELEFONE INT,
	ID_CATEGORIA INTEGER,
	CONSTRAINT FK_CATEGORIA FOREIGN KEY(ID_CATEGORIA)REFERENCES CATEGORIA(ID),
	CONSTRAINT PK_SAUDE PRIMARY KEY(ID)
);

CREATE TABLE CATEGORIA(
	ID INTEGER,
	NOME VARCHAR(100),
	VALOR INT,
	CONSTRAINT PK_CATEGORIA PRIMARY KEY(ID)
);

CREATE TABLE PACIENTE(
	ID INTEGER,
	NAME VARCHAR(100),
	CPF INTEGER,
	ID_HOSPITAL INTEGER,
	ID_PLANO INTEGER,
	CONSTRAINT FK_HOSPITAL_PACIENTE FOREIGN KEY(ID_HOSPITAL)REFERENCES HOSPITAL(ID),
	CONSTRAINT FK_PLANO_PACIENTE FOREIGN KEY(ID_PLANO)REFERENCES PLANO_SAUDE(ID),
	CONSTRAINT PK_PACIENTE PRIMARY KEY(ID)
);

CREATE TABLE MEDICOS(
	ID INTEGER ,
	NOME VARCHAR(100),
	RG INTEGER,
	CRE VARCHAR(50),
	SALARIO FLOAT,
	FORMACAO VARCHAR(100),
	ID_HOSPITAL INTEGER,
	ID_ESPECIALIDADE INTEGER,
	CONSTRAINT FK_ESPECIALIDADE_MEDICOS FOREIGN KEY(ID_ESPECIALIDADE) REFERENCES ESPECIALIDADE(ID),
	CONSTRAINT FK_HOSPITAL_MEDICOS FOREIGN KEY(ID_HOSPITAL)REFERENCES HOSPITAL(ID),
	CONSTRAINT PK_MEDICOS PRIMARY KEY(ID)
);

CREATE TABLE ENFERMEIRO(
	ID INTEGER,
	NOME VARCHAR(100),
	RG INTEGER,
	CRE VARCHAR(50),
	ID_HOSPITAL INTEGER,
	CONSTRAINT FK_HOSPITAL_ENFERMEIRO FOREIGN KEY(ID_HOSPITAL)REFERENCES HOSPITAL(ID),
    CONSTRAINT PK_ENFERMEIRO PRIMARY KEY(ID)
);
CREATE TABLE ATENDIMENTO(
	ID INTEGER,
	DATA_HORA DATE,
	ID_MEDICO INTEGER,
	ID_PACIENTE INTEGER,
	CONSTRAINT FK_MEDICO_ATENDIMENTO   FOREIGN KEY(ID_MEDICO)REFERENCES MEDICOS(ID),
	CONSTRAINT FK_PACIENTE_ATENDIMENTO  FOREIGN KEY(ID_PACIENTE) REFERENCES PACIENTE(ID) ,
    CONSTRAINT PK_ATENDIMENTO PRIMARY KEY(ID)
);

CREATE TABLE CREDENCIAMENTO_HOSPITAL(
	ID INTEGER,
	DATA DATE,
	ID_HOSPITAL INTEGER,
	ID_PLANO INTEGER,
	CONSTRAINT FK_HOSPITAL_CREDENCIAMENTOH FOREIGN KEY(ID_HOSPITAL) REFERENCES HOSPITAL(ID),
	CONSTRAINT FK_PLANO_SAUDE_CREDENCIAMENTOH  FOREIGN KEY(ID_PLANO)REFERENCES PLANO_SAUDE(ID),
    CONSTRAINT PK_CREDENCIAMENTO_HOSPITAL PRIMARY KEY(ID)
);
CREATE TABLE CREDENCIAMENTO_MEDICO(
	ID INTEGER,
	DATA DATE,
	ID_MEDICO INTEGER,
	ID_PLANO INTEGER,
	CONSTRAINT FK_MEDICO_CREDENCIAMENTOM FOREIGN KEY(ID_MEDICO) REFERENCES MEDICOS(ID),
	CONSTRAINT FK_PLANO_SAUDE_CREDENCIAMENTOM  FOREIGN KEY(ID_PLANO)REFERENCES PLANO_SAUDE(ID),
    CONSTRAINT PK_CREDENCIAMENTO_MEDICO PRIMARY KEY(ID)
);

CREATE TABLE ALAS(
	ID INTEGER,
	IDENTIFICACAO VARCHAR(100),
	DESCRICAO VARCHAR(100),
	DOENCA VARCHAR(100),
	ID_HOSPITAL INTEGER,
	ID_ENFERMEIRO INTEGER,
	CONSTRAINT FK_HOSPITAL_ALAS FOREIGN KEY(ID_HOSPITAL) REFERENCES HOSPITAL(ID),
	CONSTRAINT FK_ENFERMEIRO_ALAS FOREIGN KEY(ID_ENFERMEIRO) REFERENCES ENFERMEIRO(ID),
    CONSTRAINT PK_ALAS PRIMARY KEY(ID)
);

CREATE TABLE INTERNACAO(
	ID INTEGER,
	DATA_HORA_ENTRADA DATE,
	DATA_HORA_SAIDA DATE,
	ID_PACIENTE INTEGER,
	ID_ALA INTEGER,
	CONSTRAINT FK_PACIENTE_INTERNACAO FOREIGN KEY(ID_PACIENTE) REFERENCES PACIENTE(ID),
	CONSTRAINT FK_ALAS_INTERNACAO FOREIGN KEY(ID_ALA )REFERENCES ALAS(ID),
    CONSTRAINT PK_INTERNACAO PRIMARY KEY(ID)
);

CREATE TABLE HISTORICO(
	ID NUMBER NOT NULL,
	ID_PLANO_SAUDE INTEGER,
	ID_CATEGORIA INTEGER,
	CONSTRAINT FK_PLANO_SAUDE_HISTORICO FOREIGN KEY(ID_PLANO_SAUDE)REFERENCES PLANO_SAUDE(ID),
	CONSTRAINT FK_CATEGORIA_HISTORICO FOREIGN KEY(ID_CATEGORIA)REFERENCES CATEGORIA(ID),
	CONSTRAINT HISTORICO_PK PRIMARY KEY (ID)
);
-- -2. Crie uma função que recebe 2 números e retorna o valor da multiplicação entre eles.
-- - Não é permitido utilizar o operador de multiplicação e nem qualquer outra função.
-- - Faça o código SQL utilizando a função.

CREATE FUNCTION MULTIPLICARR(VALOR1 IN NUMBER, VALOR2 IN NUMBER)
RETURN NUMBER
AS
BEGIN
RETURN VALOR1 *VALOR2;
END MULTIPLICARR;

SELECT MULTIPLICARR(COUNT(MEDICOS.ID),COUNT(PACIENTE.ID)) FROM MEDICOS, PACIENTE;

-- 2. Crie uma função que recebe 2 números inteiros (base e expoente) e retorna o valor da potência.
--
-- - Não é permitido utilizar o operador de multiplicação e nem qualquer outra função.
--
-- - Caso um dos parâmetros seja negativo retorne uma exceção relatando.
--
-- - Caso o expoente seja 0 retorne 1.
--
-- - Faça o código SQL utilizando a função.
CREATE FUNCTION RETORNAVALORDAPOTENCIAE(BASE IN NUMBER, EXPOENTE IN NUMBER)
RETURN NUMBER  IS
    RESULTADO NUMBER:= 1;
    CONT NUMBER := 0;
BEGIN
WHILE CONT <=EXPOENTE  LOOP
     RESULTADO  := RESULTADO   * BASE ;
    CONT := CONT +1;
END LOOP;
RETURN RESULTADO;
END RETORNAVALORDAPOTENCIAE;

SELECT RETORNAVALORDAPOTENCIAE(COUNT(MEDICOS.ID),COUNT(PACIENTE.ID)) FROM MEDICOS, PACIENTE;

-- -2. Crie uma função que recebe o salário e calcula e retorna qual o valor que será descontado no total durante o ano inteiro de trabalho.
--
-- - Inclua o 13º salário e 1/3 de férias.
--
-- - Faça uma consulta SQL que retorna o nome, salário e total descontado cada um de todos os enfermeiros e médicos registrados.
--
-- - Crie um rotulo para o total descontado
--
-- - Utilize a tabela de 2019 como referência:
--
-- Base de cálculo                             Alíquota (%)
--
-- Até R$1.903,98                              Isento
--
-- De R$1.903,99 até R$2.826,65    7,5%
--
-- De R$2.826,66 até R$3.751,05    15%
--
-- De R$3.751,06 até R$4.664,68    22,5%
--
-- Acima de R$4.664,68             27,5%

create function calcularSalario(salalario in number)
return number is
    isento  NUMBER := 0;
    soma NUMBER := 0;
    cont NUMBER :=1;
begin
    if(salario <= 1.903,98) then
        isento := 0;
    else if (salario <=2.826,65)then
        isento := 7.5;
    else if(salario <=3.751,05) then
        isento := 15;
    else if (salario <= 4.664,68) then
        isento := 22.5;
    else
        isento :=  27.5;
    end if;
while cont <=13 loop
    soma := soma +salario;
    cont := cont +1;
end loop;
return  salario-((soma*isento)/100);
end calcularSalario;
-- 3. Crie um procedimento utilizando CURSOR que busca o nome e salário dos médicos formados em 2015 com salários maiores de R$ 10.000,00 que atenderam pacientes que são associados em plano de saúde que esses médicos são credenciados.
--
-- - No mesmo procedimento o CURSOR deve ser percorrido cada registro e armazenar em outra tabela o nome e salário desses médicos sem serem repetições.
--
-- - No final de execução do DML aplique um COMMIT.
--
-- - Coloque na exceção um aviso para caso de erro e um ROLLBACK.
--
-- - Imprima no console a lista de médicos e salários.
--
-- - Imprima a média dos salários.
DECLARE
    NOME MEDICOS.NOME%TYPE;
    SALARIO MEDICOS.SALARIO%TYPE;

    CURSOR CURSOR_MEDICOS IS
        SELECT MEDICOS.NOME, MEDICOS.SALARIO FROM
        MEDICOS JOIN ATENDIMENTO ON MEDICOS.ID =  ATENDIMENTO.ID_MEDICO JOIN
        PACIENTE ON PACIENTE.ID = ATENDIMENTO.ID_PACIENTE JOIN CREDENCIAMENTO_MEDICO
        ON MEDICOS.ID = CREDENCIAMENTO_MEDICO.ID_MEDICO JOIN PLANO_SAUDE ON
        PLANO_SAUDE.ID = CREDENCIAMENTO_MEDICO.ID_PLANO WHERE MEDICOS.FORMACAO = 2015 AND
        MEDICOS.SALARIO  > 10.000;
BEGIN
    OPEN CURSOR_MEDICOS;

    LOOP
        FETCH CURSOR_MEDICOS
        INTO NOME, SALARIO;
        EXIT WHEN CURSOR_MEDICOS%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(' Salario ' || SALARIO);
        DBMS_OUTPUT.PUT_LINE(' Medicos ' || NOME);
    END LOOP;
    CLOSE CURSOR_MEDICOS;
EXCEPTION
	DBMS_OUTPUT.PUT_LINE('Erro');
	ROLLBACK;
END;
COMMIT;

-- 3. Crie um procedimento utilizando CURSOR que busca o nome e salário dos médicos formados em 2015 com salários maiores de R$ 10.000,00 que atenderam pacientes que são associados em plano de saúde que esses médicos são credenciados.
--
-- - No mesmo procedimento o CURSOR deve ser percorrido cada registro e armazenar em outra tabela o nome e salário desses médicos sem serem repetições.
--
-- - Imprima no console a lista de médicos e salários.
--
-- - Imprima a média dos salários.
DECLARE
    NOME MEDICOS.NOME%TYPE;
    SALARIO MEDICOS.SALARIO%TYPE;

    CURSOR CURSOR_MEDICOS IS
        SELECT MEDICOS.NOME, MEDICOS.SALARIO FROM
        MEDICOS JOIN ATENDIMENTO ON MEDICOS.ID =  ATENDIMENTO.ID_MEDICO JOIN
        PACIENTE ON PACIENTE.ID = ATENDIMENTO.ID_PACIENTE JOIN CREDENCIAMENTO_MEDICO
        ON MEDICOS.ID = CREDENCIAMENTO_MEDICO.ID_MEDICO JOIN PLANO_SAUDE ON
        PLANO_SAUDE.ID = CREDENCIAMENTO_MEDICO.ID_PLANO WHERE MEDICOS.FORMACAO = 2015 AND
        MEDICOS.SALARIO  > 10.000;

BEGIN
    OPEN CURSOR_MEDICOS;
    LOOP
        FETCH CURSOR_MEDICOS
        INTO NOME, SALARIO;
        EXIT WHEN CURSOR_MEDICOS%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(' Salario ' || SALARIO);
        DBMS_OUTPUT.PUT_LINE(' Medicos ' || NOME);
    END LOOP;
    CLOSE CURSOR_MEDICOS;
END;

-- 3.Crie sequencias e gatilhos para todas as entidades, garantindo que o identificador único das entidades auto

CREATE SEQUENCE especialidade_seq
INCREMENT BY 1
START WITH 1
NOMAXVALUE
NOCACHE
NOCYCLE
ORDER;

CREATE SEQUENCE hospital_seq
INCREMENT BY 1
START WITH 1
NOMAXVALUE
NOCACHE
NOCYCLE
ORDER;

CREATE SEQUENCE paciente_seq
INCREMENT BY 1
START WITH 1
NOMAXVALUE
NOCACHE
NOCYCLE
ORDER;

CREATE SEQUENCE enfermeiro_seq
INCREMENT BY 1
START WITH 1
NOMAXVALUE
NOCACHE
NOCYCLE
ORDER;

CREATE SEQUENCE medicos_seq
INCREMENT BY 1
START WITH 1
NOMAXVALUE
NOCACHE
NOCYCLE
ORDER;

CREATE SEQUENCE atendimento_seq
INCREMENT BY 1
START WITH 1
NOMAXVALUE
NOCACHE
NOCYCLE
ORDER;

CREATE SEQUENCE credenciamento_hospital_seq
INCREMENT BY 1
START WITH 1
NOMAXVALUE
NOCACHE
NOCYCLE
ORDER;

CREATE SEQUENCE credenciamento_medico_seq
INCREMENT BY 1
START WITH 1
NOMAXVALUE
NOCACHE
NOCYCLE
ORDER;

CREATE SEQUENCE alas_seq
INCREMENT BY 1
START WITH 1
NOMAXVALUE
NOCACHE
NOCYCLE
ORDER;

CREATE SEQUENCE internacao_seq
INCREMENT BY 1
START WITH 1
NOMAXVALUE
NOCACHE
NOCYCLE
ORDER;

CREATE SEQUENCE plano_saude_seq
INCREMENT BY 1
START WITH 1
NOMAXVALUE
NOCACHE
NOCYCLE
ORDER;
					    
CREATE SEQUENCE internacao_seq
INCREMENT BY 1
START WITH 1
NOMAXVALUE
NOCACHE
NOCYCLE
ORDER;

CREATE SEQUENCE historico_seq
INCREMENT BY 1
START WITH 1
NOMAXVALUE
NOCACHE
NOCYCLE
ORDER;					    


--4. Crie os seguintes Pacotes:-
--Crie um pacote com as 3 funções criadas no exercicio 2.-
-- Declare os elementos no Paconte e crie um corpo de pacote para as funções.

--Teste a execução das Funçoes.
create or replace package body  pacote-funcoes is
	FUNCTION MULTIPLICARR(VALOR1 IN NUMBER, VALOR2 IN NUMBER)
	RETURN VARCHAR IS 
	BEG IN RETURN ( Função multiplicar )
	END MULTIPLICARR;
	
	FUNCTION RETORNAVALORDAPOTENCIAE(BASE IN NUMBER, EXPOENTE IN NUMBER)
	RETURN VARCHAR IS
	BEG IN RETURN (‘ Função retorna valor da potencia’ )
	END RETORNAVALORDAPOTENCIAE;
	
	fuction calcularSalario(salalario in number)
	return varchar is
	begin in return (Funcao calcular salario)
	end calcularSalario;
	
EXEC pacote-funcoes.MULTIPLICARR;
EXEC pacote-funcoes.calcularSalario;

--4.Crie um pacote com as 2 procedimento criadas no exercício 3.

--Declare os elementos no Pacote e crie um corpo de pacote para os procedimento.

-- Teste a execução das Procedimento.
create or replace package body pacote-procedimentos is
	procedure buscaNomeESalairioMedicos1()(
	is 
	Begin
		DBMS_OUTPUT.PUT_LINE('Esta eh a mensagem da Procedimento1’)
	end buscaNomeESalairioMedicos1;
				     
	procedure buscaNomeESalairioMedicos2()(
	is 
	begin
		DBMS_OUTPUT.PUT_LINE('Esta eh a mensagem da Procedimento 2’)
	end buscaNomeESalairioMedicos2;

EXEC pacote-procedimentos.buscaNomeESalairioMedicos1;
EXEC pacote-procedimentos.buscaNomeESalairioMedicos2;

--4.Crie um pacote com todas as funções e procedimentos criadas no exercício 2 e 3.

--Declare os elementos no Pacote e crie um corpo de pacote.

-- Baseado no modelo de Hospital implemente uma operação (Função, Procedimento, ...) e insira no pacote. 

-- Teste todas as operações.
create or replace package body pacote-procedimentos-funcoes
	procedure buscaNomeESalairioMedicos1()(
	is 
	Begin
		DBMS_OUTPUT.PUT_LINE('Esta eh a mensagem da Procedimento1’)
	end buscaNomeESalairioMedicos1;
				     
	procedure buscaNomeESalairioMedicos2()(
	is 
	begin
		DBMS_OUTPUT.PUT_LINE('Esta eh a mensagem da Procedimento 2’)
	end buscaNomeESalairioMedicos2;	
					    
	FUNCTION MULTIPLICARR(VALOR1 IN NUMBER, VALOR2 IN NUMBER)
	RETURN VARCHAR IS 
	BEG IN RETURN ( 'Função multiplicar' )
	END MULTIPLICARR;
	
	FUNCTION RETORNAVALORDAPOTENCIAE(BASE IN NUMBER, EXPOENTE IN NUMBER)
	RETURN VARCHAR IS
	BEG IN RETURN (‘ Função retorna valor da potencia’ )
	END RETORNAVALORDAPOTENCIAE;
	
	fuction calcularSalario(salalario in number)
	return varchar is
	begin in return ('Funcao calcular salario')
	end calcularSalario;
					    
EXEC pacote-procedimentos-funcoes.buscaNomeESalairioMedicos1;
EXEC pacote-procedimentos-funcoes.buscaNomeESalairioMedicos2;
EXEC pacote-procedimentos-funcoes.MULTIPLICARR;
EXEC pacote-procedimentos-funcoes.calcularSalario;


