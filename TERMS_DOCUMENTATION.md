# Documentação de Termos Técnicos do Projeto

Este documento lista os principais termos técnicos em inglês utilizados no código do projeto, com explicações em português para facilitar o entendimento e manutenção.

---

**appointment**
Agendamento, compromisso, consulta marcada. Refere-se a um evento específico já marcado, como uma consulta entre paciente e médico em um horário definido.

**schedule**
Agenda, cronograma, lista de horários disponíveis. Refere-se à estrutura de horários disponíveis ou planejados, normalmente de um médico ou serviço.

**consultation**
Consulta médica, atendimento entre paciente e médico.

**doctor**
Médico.

**patient**
Paciente.

**slot**
Horário disponível, intervalo de tempo para agendamento.

**duration**
Duração, tempo total de uma consulta ou agendamento.

**startTime / endTime**
Horário de início / horário de término.

**available**
Disponível, indica se o horário pode ser agendado.

**confirmed**
Confirmado, indica se o agendamento foi aceito.

**cancelled**
Cancelado, indica que o agendamento foi desmarcado.

**completed**
Concluído, indica que a consulta já aconteceu.

**pending**
Pendente, aguardando confirmação.

**status**
Situação do agendamento (pendente, confirmado, cancelado, etc).

**notes**
Observações, informações adicionais sobre a consulta.

**symptoms**
Sintomas, informações sobre o estado do paciente.

**fee / consultationFee**
Valor da consulta, preço cobrado pelo médico.

**createdAt / updatedAt**
Data de criação / data de atualização do registro.

**dayOfWeek / dayName**
Dia da semana (número ou nome, ex: 1=Segunda, 'Saturday'=Sábado).

**specialty**
Especialidade médica (ex: cardiologia, pediatria).

**bio**
Biografia, descrição do médico.

**hourlyRate**
Valor cobrado por hora.

**id**
Identificador único do registro.

**userId / doctorId / patientId**
Identificador do usuário, médico ou paciente.

**token / refreshToken**
Chave de autenticação, usada para login seguro.

**requestStatus**
Status da requisição (carregando, sucesso, erro).

**errorMessage**
Mensagem de erro.

**fromJson / toJson**
Métodos para converter dados entre objetos e formato JSON.

**store**
Classe que gerencia o estado e as ações (MobX).

**service**
Classe responsável por chamadas à API/backend.

**controller**
Classe que gerencia a lógica de rotas e requisições no backend.

**repository**
Classe que faz acesso ao banco de dados.

**middleware**
Função intermediária que executa validações ou autenticação.

**route**
Rota, caminho de navegação na aplicação.

**observer**
Componente que observa mudanças de estado (MobX).

**provider / getIt**
Gerenciador de dependências, usado para acessar stores e services.

---

Se precisar de explicação de outros termos ou de exemplos práticos, basta pedir!
