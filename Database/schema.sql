-- 建立 users 表
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role ENUM('requester', 'approver') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 預設使用者帳號（密碼尚未加密）
INSERT INTO users (username, password, role) VALUES
('Aaron1', '19970627', 'requester'),
('Aaron2', '19970627', 'requester'),
('Leader1', 'leader1', 'approver'),
('Leader2', 'leader2', 'approver');

-- 建立 workflows 表（請款申請主資料）
CREATE TABLE workflows (
    id INT PRIMARY KEY AUTO_INCREMENT,
    applicant_id INT NOT NULL,
    status ENUM('pending', 'approved', 'rejected') DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (applicant_id) REFERENCES users(id)
);

-- 建立 workflow_items 表（請款內容）
CREATE TABLE workflow_items (
    id INT PRIMARY KEY AUTO_INCREMENT,
    workflow_id INT NOT NULL,
    item_name VARCHAR(255) NOT NULL,
    invoice_number VARCHAR(100) NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (workflow_id) REFERENCES workflows(id) ON DELETE CASCADE
);

-- 建立 workflow_steps 表（簽核步驟）
CREATE TABLE workflow_steps (
    id INT PRIMARY KEY AUTO_INCREMENT,
    workflow_id INT NOT NULL,
    step_order INT NOT NULL,
    signer_id INT NOT NULL,
    status ENUM('pending', 'approved', 'rejected') DEFAULT 'pending',
    signed_at TIMESTAMP NULL,
    FOREIGN KEY (workflow_id) REFERENCES workflows(id) ON DELETE CASCADE,
    FOREIGN KEY (signer_id) REFERENCES users(id)
);

-- 建立 workflow_logs 表（簽核歷程）
CREATE TABLE workflow_logs (
    id INT PRIMARY KEY AUTO_INCREMENT,
    workflow_id INT NOT NULL,
    step_id INT NOT NULL,
    signer_id INT NOT NULL,
    action ENUM('approved', 'rejected', 'returned') NOT NULL,
    comment TEXT,
    action_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (workflow_id) REFERENCES workflows(id),
    FOREIGN KEY (step_id) REFERENCES workflow_steps(id),
    FOREIGN KEY (signer_id) REFERENCES users(id)
);
