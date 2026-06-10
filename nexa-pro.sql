-- ═══════════════════════════════════════════════════════
--  NEXA PRO · SQL COMPLETO
--  Execute no SQL Editor do Supabase
-- ═══════════════════════════════════════════════════════

-- Clientes (profissionais)
CREATE TABLE IF NOT EXISTS clientes (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  slug          text UNIQUE NOT NULL,
  nome          text NOT NULL,
  especialidade text,
  foto_url      text,
  cor_primaria  text DEFAULT '#b89a7a',
  cor_fundo     text DEFAULT '#ffffff',
  cor_texto     text DEFAULT '#5a3e2b',
  tema          text DEFAULT 'claro',
  tem_agendamento boolean DEFAULT false,
  ativo         boolean DEFAULT true,
  criado_em     timestamptz DEFAULT now(),
  atualizado_em timestamptz DEFAULT now()
);

-- Links do mini site
CREATE TABLE IF NOT EXISTS links (
  id         uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  cliente_id uuid REFERENCES clientes(id) ON DELETE CASCADE,
  ordem      int DEFAULT 0,
  label      text NOT NULL,
  url        text NOT NULL,
  icone      text DEFAULT 'link',
  destaque   boolean DEFAULT false,
  ativo      boolean DEFAULT true
);

-- Serviços
CREATE TABLE IF NOT EXISTS servicos (
  id           uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  cliente_id   uuid REFERENCES clientes(id) ON DELETE CASCADE,
  titulo       text NOT NULL,
  descricao    text,
  duracao_min  int DEFAULT 60,
  valor        numeric(10,2),
  ativo        boolean DEFAULT true,
  ordem        int DEFAULT 0,
  criado_em    timestamptz DEFAULT now()
);

-- Slots de horário
CREATE TABLE IF NOT EXISTS slots (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  cliente_id  uuid REFERENCES clientes(id) ON DELETE CASCADE,
  data_hora   timestamptz NOT NULL,
  bloqueado   boolean DEFAULT false,
  criado_em   timestamptz DEFAULT now(),
  UNIQUE(cliente_id, data_hora)
);

-- Agendamentos
CREATE TABLE IF NOT EXISTS agendamentos (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  cliente_id    uuid REFERENCES clientes(id) ON DELETE CASCADE,
  servico_id    uuid REFERENCES servicos(id) ON DELETE SET NULL,
  slot_id       uuid REFERENCES slots(id) ON DELETE SET NULL,
  data_hora     timestamptz NOT NULL,
  nome_cliente  text NOT NULL,
  telefone      text NOT NULL,
  status        text DEFAULT 'pendente',
  criado_em     timestamptz DEFAULT now(),
  atualizado_em timestamptz DEFAULT now()
);

-- RLS
ALTER TABLE clientes    ENABLE ROW LEVEL SECURITY;
ALTER TABLE links       ENABLE ROW LEVEL SECURITY;
ALTER TABLE servicos    ENABLE ROW LEVEL SECURITY;
ALTER TABLE slots       ENABLE ROW LEVEL SECURITY;
ALTER TABLE agendamentos ENABLE ROW LEVEL SECURITY;

CREATE POLICY "acesso total clientes"     ON clientes     FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "acesso total links"        ON links        FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "acesso total servicos"     ON servicos     FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "acesso total slots"        ON slots        FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "acesso total agendamentos" ON agendamentos FOR ALL USING (true) WITH CHECK (true);
