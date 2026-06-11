-- ═══════════════════════════════════════════════════
--  NEXA PRO · SQL COMPLETO v2
--  Cole no SQL Editor do Supabase e execute
-- ═══════════════════════════════════════════════════

DROP TABLE IF EXISTS agendamentos CASCADE;
DROP TABLE IF EXISTS slots CASCADE;
DROP TABLE IF EXISTS servicos CASCADE;
DROP TABLE IF EXISTS disponibilidade CASCADE;
DROP TABLE IF EXISTS bloqueios CASCADE;
DROP TABLE IF EXISTS links CASCADE;
DROP TABLE IF EXISTS clientes CASCADE;

-- ── CLIENTES (profissionais) ──────────────────────
CREATE TABLE clientes (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  slug            text UNIQUE NOT NULL,
  nome            text NOT NULL,
  especialidade   text,
  bio             text,
  foto_url        text,
  foto_capa_url   text,

  -- Mini site
  minisite_ativo  boolean DEFAULT false,
  cor_bg          text DEFAULT '#0d0d0d',
  cor_primary     text DEFAULT '#c9a84c',
  cor_texto       text DEFAULT '#f0f0f0',
  cor_botao_txt   text DEFAULT '#0d0d0d',

  -- Agendamento
  agenda_ativo    boolean DEFAULT false,

  -- Info profissional (uso interno)
  whatsapp        text,
  instagram       text,
  status_interno  text DEFAULT 'ativo', -- ativo | teste | inativo

  criado_em       timestamptz DEFAULT now(),
  atualizado_em   timestamptz DEFAULT now()
);

-- ── LINKS do mini site ────────────────────────────
CREATE TABLE links (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  cliente_id  uuid REFERENCES clientes(id) ON DELETE CASCADE,
  ordem       int DEFAULT 0,
  label       text NOT NULL,
  url         text NOT NULL,
  icone       text DEFAULT 'link',
  destaque    boolean DEFAULT false,
  ativo       boolean DEFAULT true
);

-- ── SERVIÇOS ──────────────────────────────────────
CREATE TABLE servicos (
  id           uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  cliente_id   uuid REFERENCES clientes(id) ON DELETE CASCADE,
  titulo       text NOT NULL,
  descricao    text,
  foto_url     text,
  duracao_min  int DEFAULT 60,
  valor        numeric(10,2),
  ativo        boolean DEFAULT true,
  ordem        int DEFAULT 0
);

-- ── DISPONIBILIDADE SEMANAL ───────────────────────
CREATE TABLE disponibilidade (
  id           uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  cliente_id   uuid REFERENCES clientes(id) ON DELETE CASCADE,
  dia_semana   int NOT NULL, -- 0=dom, 1=seg ... 6=sab
  ativo        boolean DEFAULT true,
  hora_ini     time NOT NULL DEFAULT '08:00',
  hora_fim     time NOT NULL DEFAULT '18:00',
  UNIQUE(cliente_id, dia_semana)
);

-- ── BLOQUEIOS ─────────────────────────────────────
CREATE TABLE bloqueios (
  id           uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  cliente_id   uuid REFERENCES clientes(id) ON DELETE CASCADE,
  tipo         text NOT NULL, -- dia | horario | recorrente
  data         date,          -- para tipo dia e horario
  hora_ini     time,          -- para tipo horario e recorrente
  hora_fim     time,
  dia_semana   int,           -- para tipo recorrente
  motivo       text,
  criado_em    timestamptz DEFAULT now()
);

-- ── AGENDAMENTOS ──────────────────────────────────
CREATE TABLE agendamentos (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  cliente_id    uuid REFERENCES clientes(id) ON DELETE CASCADE,
  servico_id    uuid REFERENCES servicos(id) ON DELETE SET NULL,
  data_hora_ini timestamptz NOT NULL,
  data_hora_fim timestamptz NOT NULL,
  nome_cliente  text NOT NULL,
  telefone      text NOT NULL,
  status        text DEFAULT 'pendente', -- pendente | confirmado | remarcado | cancelado | concluido
  criado_em     timestamptz DEFAULT now(),
  atualizado_em timestamptz DEFAULT now()
);

-- ── CONFIG AGENDA (intervalo, antecedência) ───────
CREATE TABLE config_agenda (
  id               uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  cliente_id       uuid REFERENCES clientes(id) ON DELETE CASCADE UNIQUE,
  intervalo_min    int DEFAULT 0,
  antecedencia_min int DEFAULT 0
);

-- ── RLS ───────────────────────────────────────────
ALTER TABLE clientes       ENABLE ROW LEVEL SECURITY;
ALTER TABLE links          ENABLE ROW LEVEL SECURITY;
ALTER TABLE servicos       ENABLE ROW LEVEL SECURITY;
ALTER TABLE disponibilidade ENABLE ROW LEVEL SECURITY;
ALTER TABLE bloqueios      ENABLE ROW LEVEL SECURITY;
ALTER TABLE agendamentos   ENABLE ROW LEVEL SECURITY;
ALTER TABLE config_agenda  ENABLE ROW LEVEL SECURITY;

CREATE POLICY "pub clientes"        ON clientes        FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "pub links"           ON links           FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "pub servicos"        ON servicos        FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "pub disponibilidade" ON disponibilidade FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "pub bloqueios"       ON bloqueios       FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "pub agendamentos"    ON agendamentos    FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "pub config_agenda"   ON config_agenda   FOR ALL USING (true) WITH CHECK (true);

-- ── COLUNAS VISUAL SEPARADO DA AGENDA ───────────
-- Execute este bloco se o banco já existe (migração)
ALTER TABLE clientes ADD COLUMN IF NOT EXISTS agf_bg         text DEFAULT '#0d0d0d';
ALTER TABLE clientes ADD COLUMN IF NOT EXISTS agf_primary    text DEFAULT '#c9a84c';
ALTER TABLE clientes ADD COLUMN IF NOT EXISTS agf_texto      text DEFAULT '#f0f0f0';
ALTER TABLE clientes ADD COLUMN IF NOT EXISTS agf_botao_txt  text DEFAULT '#0d0d0d';
ALTER TABLE clientes ADD COLUMN IF NOT EXISTS foto_capa_url  text;
