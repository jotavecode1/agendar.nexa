-- ═══════════════════════════════════════════════════════
--  NEXA · Script SQL para o Supabase
--  Cole no SQL Editor do seu projeto Supabase e execute
-- ═══════════════════════════════════════════════════════

-- Tabela de clientes
CREATE TABLE IF NOT EXISTS clientes (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  slug        text UNIQUE NOT NULL,        -- ex: "karol-ferreira" → URL /cliente/karol-ferreira
  nome        text NOT NULL,               -- ex: "Karol Ferreira"
  especialidade text,                      -- ex: "Extensão de Cílios"
  foto_url    text,                        -- URL da foto de perfil
  cor_primaria  text DEFAULT '#b89a7a',    -- cor dos botões e destaque
  cor_fundo     text DEFAULT '#ffffff',    -- cor de fundo do mini site
  cor_texto     text DEFAULT '#5a3e2b',    -- cor do texto/nome
  tema          text DEFAULT 'claro',      -- "claro" ou "escuro"
  ativo       boolean DEFAULT true,
  criado_em   timestamptz DEFAULT now(),
  atualizado_em timestamptz DEFAULT now()
);

-- Tabela de links de cada cliente
CREATE TABLE IF NOT EXISTS links (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  cliente_id  uuid REFERENCES clientes(id) ON DELETE CASCADE,
  ordem       int DEFAULT 0,
  label       text NOT NULL,               -- ex: "Agendar Horário"
  url         text NOT NULL,               -- ex: "https://wa.me/..."
  icone       text DEFAULT 'link',         -- "calendar", "instagram", "whatsapp", "maps", "link"
  destaque    boolean DEFAULT false,       -- true = botão sólido (CTA principal)
  ativo       boolean DEFAULT true
);

-- Permissões de leitura pública (para os mini sites)
ALTER TABLE clientes ENABLE ROW LEVEL SECURITY;
ALTER TABLE links ENABLE ROW LEVEL SECURITY;

CREATE POLICY "leitura publica clientes"
  ON clientes FOR SELECT USING (ativo = true);

CREATE POLICY "leitura publica links"
  ON links FOR SELECT USING (ativo = true);

-- ─── DADOS DE EXEMPLO (remova se não precisar) ────────────────────

INSERT INTO clientes (slug, nome, especialidade, cor_primaria, cor_fundo, cor_texto, tema)
VALUES
  ('karol-ferreira',  'Karol Ferreira',    'Extensão de Cílios',   '#c9a84c', '#0f0f0f', '#c9a84c', 'escuro'),
  ('evelin-vitoria',  'Evelin Vitória',    'Sobrancelhas',         '#b89a7a', '#ffffff', '#8a6a4a', 'claro'),
  ('graciele-santiago','Graciele Santiago', 'Manicure & Pedicure',  '#d4829a', '#ffffff', '#c06a84', 'claro');

-- Links da Karol
INSERT INTO links (cliente_id, ordem, label, url, icone, destaque)
SELECT id, 1, 'Agendar Horário', 'https://wa.me/5500000000000', 'calendar', true  FROM clientes WHERE slug='karol-ferreira';
INSERT INTO links (cliente_id, ordem, label, url, icone, destaque)
SELECT id, 2, 'Instagram', 'https://instagram.com/karol.cilios', 'instagram', false FROM clientes WHERE slug='karol-ferreira';
INSERT INTO links (cliente_id, ordem, label, url, icone, destaque)
SELECT id, 3, 'WhatsApp', 'https://wa.me/5500000000000', 'whatsapp', false FROM clientes WHERE slug='karol-ferreira';
INSERT INTO links (cliente_id, ordem, label, url, icone, destaque)
SELECT id, 4, 'Localização', 'https://maps.google.com', 'maps', false FROM clientes WHERE slug='karol-ferreira';

-- Links da Evelin
INSERT INTO links (cliente_id, ordem, label, url, icone, destaque)
SELECT id, 1, 'Agendar Horário', 'https://wa.me/5500000000000', 'calendar', true  FROM clientes WHERE slug='evelin-vitoria';
INSERT INTO links (cliente_id, ordem, label, url, icone, destaque)
SELECT id, 2, 'Instagram', 'https://instagram.com/evelinvsobrancelhas', 'instagram', false FROM clientes WHERE slug='evelin-vitoria';
INSERT INTO links (cliente_id, ordem, label, url, icone, destaque)
SELECT id, 3, 'WhatsApp', 'https://wa.me/5500000000000', 'whatsapp', false FROM clientes WHERE slug='evelin-vitoria';
INSERT INTO links (cliente_id, ordem, label, url, icone, destaque)
SELECT id, 4, 'Localização', 'https://maps.google.com', 'maps', false FROM clientes WHERE slug='evelin-vitoria';

-- Links da Graciele
INSERT INTO links (cliente_id, ordem, label, url, icone, destaque)
SELECT id, 1, 'Agendar Horário', 'https://wa.me/5500000000000', 'calendar', true  FROM clientes WHERE slug='graciele-santiago';
INSERT INTO links (cliente_id, ordem, label, url, icone, destaque)
SELECT id, 2, 'Instagram', 'https://instagram.com/graciele', 'instagram', false FROM clientes WHERE slug='graciele-santiago';
INSERT INTO links (cliente_id, ordem, label, url, icone, destaque)
SELECT id, 3, 'WhatsApp', 'https://wa.me/5500000000000', 'whatsapp', false FROM clientes WHERE slug='graciele-santiago';
INSERT INTO links (cliente_id, ordem, label, url, icone, destaque)
SELECT id, 4, 'Localização', 'https://maps.google.com', 'maps', false FROM clientes WHERE slug='graciele-santiago';
