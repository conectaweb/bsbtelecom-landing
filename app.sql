
-- Tabela de planos de internet
CREATE TABLE plans (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    speed VARCHAR(50) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    description TEXT,
    features TEXT[],
    is_active BOOLEAN DEFAULT true,
    display_order INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Tabela de solicitações de contato/leads
CREATE TABLE contact_requests (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT,
    full_name VARCHAR(200) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    email VARCHAR(255),
    address TEXT NOT NULL,
    plan_id BIGINT,
    plan_name VARCHAR(100),
    message TEXT,
    status VARCHAR(50) DEFAULT 'pending' CHECK (status IN ('pending', 'contacted', 'converted', 'cancelled')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Tabela de informações da empresa
CREATE TABLE company_info (
    id BIGSERIAL PRIMARY KEY,
    company_name VARCHAR(200) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    whatsapp VARCHAR(20),
    email VARCHAR(255),
    address TEXT NOT NULL,
    city VARCHAR(100),
    state VARCHAR(2),
    zip_code VARCHAR(10),
    anatel_license VARCHAR(100),
    about_text TEXT,
    logo_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Tabela de perfis de usuários
CREATE TABLE user_profiles (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    full_name VARCHAR(200) NOT NULL,
    phone VARCHAR(20),
    address TEXT,
    city VARCHAR(100),
    state VARCHAR(2),
    zip_code VARCHAR(10),
    plan_id BIGINT,
    customer_since DATE,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Habilitar RLS para tabelas que precisam de isolamento de usuário
ALTER TABLE user_profiles ENABLE ROW LEVEL SECURITY;

-- Políticas RLS para user_profiles
CREATE POLICY user_profiles_select_policy ON user_profiles
    FOR SELECT USING (user_id = uid());

CREATE POLICY user_profiles_insert_policy ON user_profiles
    FOR INSERT WITH CHECK (user_id = uid());

CREATE POLICY user_profiles_update_policy ON user_profiles
    FOR UPDATE USING (user_id = uid()) WITH CHECK (user_id = uid());

CREATE POLICY user_profiles_delete_policy ON user_profiles
    FOR DELETE USING (user_id = uid());

-- Criar índices para melhorar performance
CREATE INDEX idx_contact_requests_status ON contact_requests(status);
CREATE INDEX idx_contact_requests_plan_id ON contact_requests(plan_id);
CREATE INDEX idx_contact_requests_created_at ON contact_requests(created_at);
CREATE INDEX idx_user_profiles_user_id ON user_profiles(user_id);
CREATE INDEX idx_user_profiles_plan_id ON user_profiles(plan_id);

-- Inserir dados iniciais dos planos
INSERT INTO plans (name, speed, price, description, features, display_order) VALUES
('ConectawebHome400', '400 Mbps', 119.90, 'Plano ideal para residências com uso moderado de internet', 
 ARRAY['400 Mbps de velocidade', 'Wi-Fi incluso', 'Suporte técnico local', 'Instalação grátis'], 1),
('ConectawebOffice60', '600 Mbps', 159.90, 'Perfeito para home office e pequenos negócios', 
 ARRAY['600 Mbps de velocidade', 'Wi-Fi de alta performance', 'Suporte prioritário', 'IP fixo opcional', 'Instalação grátis'], 2),
('ConectawebGiga', '1 Gbps', 199.90, 'Máxima velocidade para empresas e usuários exigentes', 
 ARRAY['1 Gbps de velocidade', 'Wi-Fi 6 incluso', 'Suporte VIP 24/7', 'IP fixo incluso', 'Instalação e configuração grátis'], 3);

-- Inserir informações da empresa
INSERT INTO company_info (company_name, phone, address, city, state, anatel_license, about_text) VALUES
('BSBTelecom - Internet Banda Larga', 
 '(12) 3000-0000', 
 'Sertão da Barra do Una', 
 'São Sebastião', 
 'SP',
 'Outorgado pela ANATEL',
 'Provedor de internet banda larga especializado em atendimento rural, levando conectividade de qualidade para o Sertão da Barra do Una e região. Com tecnologia de ponta e suporte local, garantimos internet estável mesmo em áreas remotas.');

-- Criar perfil padrão para o usuário admin (user_id = 1)
INSERT INTO user_profiles (user_id, full_name, is_active) VALUES (1, 'Administrador BSBTelecom', true);

-- Atualizar informações da empresa BSBTelecom
UPDATE company_info SET
    company_name = 'bsbtelecom - internet banda larga',
    phone = '(19) 4040-4715',
    whatsapp = '(19) 4040-4715',
    email = 'contato@bsbtelecom.com.br',
    address = 'Rua Arnaldo Mamprin, 20 - Parque Santa Candida',
    city = 'Vinhedo',
    state = 'SP',
    zip_code = '13248-408',
    updated_at = CURRENT_TIMESTAMP
WHERE id = 1;
