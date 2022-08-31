CREATE INDEX IX_accounts_num
ON accounts (num ASC)

sp_Helpindex accounts

DROP INDEX accounts.IX_accounts_num