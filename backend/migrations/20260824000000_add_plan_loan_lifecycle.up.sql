-- Issue #1035: persist freeze / recall / liquidation progress for
-- yield-bearing vaults so the loan-lifecycle endpoints and trigger-info
-- dashboard have a source of truth besides the chain.

CREATE TABLE IF NOT EXISTS plan_loan_lifecycle (
    plan_id UUID PRIMARY KEY REFERENCES plans (id) ON DELETE CASCADE,
    freeze_status TEXT NOT NULL DEFAULT 'PENDING'
        CHECK (freeze_status IN ('PENDING', 'PROCESSING', 'FROZEN')),
    recall_progress INTEGER NOT NULL DEFAULT 0
        CHECK (recall_progress >= 0 AND recall_progress <= 100),
    settlement_status TEXT NOT NULL DEFAULT 'PENDING'
        CHECK (settlement_status IN ('PENDING', 'PROCESSING', 'LIQUIDATED', 'SETTLED')),
    outstanding_loaned BIGINT NOT NULL DEFAULT 0
        CHECK (outstanding_loaned >= 0),
    last_tx_hash TEXT,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
